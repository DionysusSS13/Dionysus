from copy import deepcopy

from PIL import Image, PngImagePlugin
import tomllib
import math

from . import cutter_shapes

from .dirs import *

BITMASK_SLICE = "BitmaskSlice"
SMOOTH_DIAGONALLY = "smooth_diagonally"

# This is kinda fugly but
def process_templates(toml: dict, templates):
    if toml.get("template") is not None:
        template = deepcopy(templates[toml["template"]])
        toml.pop("template")
        for key, value in toml.items():
            if isinstance(value, dict) and isinstance(template.get(key), dict):
                for key1, _ in toml[key].items():
                    template[key][key1] = value[key1]
            else:
                template[key] = value
        return process_templates(template, templates)
    return toml

def cut(toml_path: str, templates: dict):
    img_path = toml_path[:-5]

    with open(toml_path, "rb") as file:
        toml = tomllib.load(file)

    toml = process_templates(toml, templates)

    if toml["mode"] != BITMASK_SLICE:
        print("Unsupported mode: " + toml["mode"])
        return

    if toml[SMOOTH_DIAGONALLY]:
        icon_states_to_iter = cutter_shapes.OUTPUT_DIAGONALS
    else:
        icon_states_to_iter = cutter_shapes.OUTPUT_CARDINALS

    png_image: Image.Image = Image.open(img_path, "r")

    output_name = toml["output_name"] + "-"
    center = (toml["cut_pos"]["x"], toml["cut_pos"]["y"])
    size = (toml["icon_size"]["x"], toml["icon_size"]["y"])
    output_size = (toml["output_icon_size"]["x"], toml["output_icon_size"]["y"])
    columns = int(png_image.width / size[0]) # Should always be round
    positions: dict = toml["positions"]
    position_index_to_name = {str(v): k for k, v in positions.items()}
    rows = math.ceil(positions[max(positions, key=positions.get)] / columns)

    # North > clockwise
    slices = {  # why tf does this work
        NORTHEAST: (center[0], 0, size[0], center[1]),
        SOUTHEAST: (center[0], center[1], size[0], size[1]),
        SOUTHWEST: (0, center[1], center[0], size[1]),
        NORTHWEST: (0, 0, center[0], center[1])
    }

    stray_icons = {}
    corners = {str(name): {} for name in slices.keys()}
    color = 255

    for y in range(rows):
        for x in range(columns):
            index = ((y * columns) + x)
            pos_name = position_index_to_name.get(str(index))
            if not pos_name:
                continue
            if cutter_shapes.SHAPES.get(pos_name) is None:
                cut_pos = (x * size[0], y * size[1], (x * size[0]) + size[0], (y * size[1]) + size[1])
                stray_icons[pos_name] = png_image.crop(cut_pos)
                continue
            offset = (x * size[0], y * size[1], x * size[0], y * size[1])
            for current_slice in slices:
                connections = fingerprint_corner(current_slice, cutter_shapes.SHAPES[pos_name])
                cut_pos = tuple(sum(x) for x in zip(slices[current_slice], offset)) # lazy way to add two tuples together
                corners[str(current_slice)][connections] = png_image.crop(cut_pos)
                color = round(color / 0.95)

    dmi_icons = {output_name + str(k): do_icon(Image.new("RGBA", output_size), k, corners, slices) for k in icon_states_to_iter}

    dmi_icons = dmi_icons | stray_icons

    make_dmi(img_path[:-4] + ".dmi", dmi_icons, output_size)

def do_icon(image: Image.Image, connections: int, corners: dict, slices: dict):
    for corner_name, connection_to_corner in corners.items():
        for corner_connection, corner_image in reversed(list(connection_to_corner.items())):
            corner_connection_i = int(corner_connection)
            if (corner_connection_i & connections) == corner_connection_i:
                image.paste(corner_image, slices[int(corner_name)])
                break

    return image

def fingerprint_corner(current_slice: int, relevant_connections: int):
    if current_slice == NORTHEAST:
        return (NORTH | EAST | NORTHEAST) & relevant_connections
    if current_slice == SOUTHEAST:
        return (SOUTH | EAST | SOUTHEAST) & relevant_connections
    if current_slice == SOUTHWEST:
        return (SOUTH | WEST | SOUTHWEST) & relevant_connections
    if current_slice == NORTHWEST:
        return (NORTH | WEST | NORTHWEST) & relevant_connections
    raise "Oh shit oh fuck"

def make_dmi(file, dmi_icons: dict, icon_size):
    columns = 7 # Most efficient in most cases + can't be fucked
    rows = math.ceil(len(dmi_icons) / columns)
    dmi_icons = list(dmi_icons.items()) # Not the best but idgaf
    # Never fucking trust the parser to handle multiline strings sensibly. Yes, indenting this "properly" breaks it. Don't do it.
    dmi_str = f"""# BEGIN DMI
version = 4.0
	width = {str(icon_size[0])}
	height = {str(icon_size[1])}"""

    image = Image.new("RGBA", (columns * icon_size[0], rows * icon_size[1]))
    for y in range(rows):
        for x in range(columns):
            index = ((y * columns) + x)
            if index >= len(dmi_icons):
                break
            entry = dmi_icons[index]
            image.paste(entry[1], (x * icon_size[0], y * icon_size[1]))
            dmi_str += "\nstate = \"" + entry[0] + "\""
            dmi_str += "\n	dirs = 1"
            dmi_str += "\n	frames = 1"
    dmi_str += "\n# END DMI"

    png_info = PngImagePlugin.PngInfo()
    png_info.add_text("Description", dmi_str, zip=True)
    image.save(file, "png", pnginfo=png_info)

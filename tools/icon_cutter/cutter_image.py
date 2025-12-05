from copy import deepcopy

from PIL import Image
import pathlib
import tomllib
import math

import cutter_shapes

from dirs import *

BITMASK_SLICE = "BitmaskSlice"
SMOOTH_DIAGONALLY = "smooth_diagonally"

def cut(toml_path: str, templates: {}):
    img_path = toml_path[:-5]

    with open(toml_path, "rb") as file:
        toml = tomllib.load(file)

    if toml["template"] is not None:
        template = deepcopy(templates[toml["template"]])
        for key, value in toml:
            if isinstance(value, dict):
                for key1, value1 in toml[key]:
                    template[key][key1] = value[key1]
        toml = template

    if toml["mode"] != BITMASK_SLICE:
        print("Unsupported mode: " + toml["mode"])
        return

    if toml[SMOOTH_DIAGONALLY]:
        icon_states_to_iter = cutter_shapes.ALL_DIRS
    else:
        icon_states_to_iter = cutter_shapes.CARDINALS

    output_name = toml["output_name"] + "_"
    center = (toml["cut_pos"]["x"], toml["cut_pos"]["y"])
    size = (toml["icon_size"]["x"], toml["icon_size"]["y"])
    columns = toml["icon_size"]["x"] / size[1]
    positions: dict = toml["positions"]
    position_index_to_name = {str(v): k for k, v in positions}
    rows = math.floor(max(positions, key=positions.get) / columns)

    # North > clockwise
    slices = {
        NORTHEAST: (center[0], 0, size[0], center[1]),
        SOUTHEAST: (center[0], center[1], size[0], size[1]),
        SOUTHWEST: (0, center[1], center[0], size[1]),
        NORTHWEST: (0, 0, center[0], center[1])
    }

    png_image: Image.Image = Image.open(img_path, "r")
    stray_icons = {}
    corners = {}

    for y in range(rows):
        for x in range(columns):
            pos_name = position_index_to_name[str(x * y)]
            if not pos_name:
                continue
            if not pos_name in cutter_shapes.SHAPES:
                cut_pos = (x * size[0], y * size[1], (x * size[0]) + size[0], (y * size[1]) + size[1])
                stray_icons[pos_name] = png_image.crop(cut_pos)
                continue
            offset = (x * size[0], y * size[1], x * size[0], y * size[1])
            for current_slice in slices:
                connections = cutter_shapes.SHAPES[]
                cut_pos = tuple(sum(x) for x in zip(slices[current_slice], offset)) # lazy way to add two tuples together
                corners[str(current_slice)] = png_image.crop(cut_pos)

    dmi_icons = {output_name + k: do_icon(Image.new("rgba", size), k, corners) for k in icon_states_to_iter}

    for k, v in dmi_icons:
        v.save("testdir/" + k + ".png")

def do_icon(image: Image.Image, connections: int, corners: {}):
    for corner in CORNERS:


    return image

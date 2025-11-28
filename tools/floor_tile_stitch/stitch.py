import PIL.Image
import sys
import pathlib
import PIL.PngImagePlugin

# Some lazy code inbound - RimiNosha

dmiData = """# BEGIN DMI
version = 4.0
	width = 32
	height = 32
state = "tile_center"
	dirs = 1
	frames = 1
state = "tile_corner"
	dirs = 4
	frames = 1
state = "tile_edge"
	dirs = 4
	frames = 1
state = "tile_center_inverted"
	dirs = 1
	frames = 1
state = "tile_corner_inverted"
	dirs = 4
	frames = 1
# END DMI"""

if len(sys.argv) < 2:
    print("You need to supple an image via argument (or drop it on the script)")
    sys.exit(0)

tiles = PIL.Image.open(sys.argv[1])
tileA = PIL.Image.new("RGBA", (16, 16), (0, 0, 0, 0))
tileA.paste(tiles)
tileB = PIL.Image.new("RGBA", (16, 16), (0, 0, 0, 0))
tileB.paste(tiles, (-16, 0))
newImage = PIL.Image.new("RGBA", (96, 160), (0, 0, 0, 0))

pngInfo = PIL.PngImagePlugin.PngInfo()
pngInfo.add_text("Description", dmiData, zip=True)

tiles = {"a": tileA, "b": tileB}

locToLayout = {
    (0, 0): ["a", "a", "a", "a"],
    (1, 0): ["a", "a", "a", "b"],
    (2, 0): ["b", "a", "a", "a"],
    (0, 1): ["a", "b", "a", "a"],
    (1, 1): ["a", "a", "b", "a"],
    (2, 1): ["a", "a", "b", "b"],
    (0, 2): ["b", "b", "a", "a"],
    (1, 2): ["a", "b", "a", "b"],
    (2, 2): ["b", "a", "b", "a"],
    (0, 3): ["b", "b", "b", "b"],
    (1, 3): ["b", "b", "b", "a"],
    (2, 3): ["a", "b", "b", "b"],
    (0, 4): ["b", "a", "b", "b"],
    (1, 4): ["b", "b", "a", "b"],
}

for yLoc in range(5):
    for xLoc in range(3):
        floor = PIL.Image.new("RGBA", (96, 96), (0, 0, 0, 0))

        if not (xLoc, yLoc) in locToLayout:
            continue

        tileStrs = locToLayout[(xLoc, yLoc)]

        floor.paste(tiles[tileStrs[0]])
        floor.paste(tiles[tileStrs[1]], (16, 0))
        floor.paste(tiles[tileStrs[2]], (0, 16))
        floor.paste(tiles[tileStrs[3]], (16, 16))

        newImage.paste(floor, (xLoc * 32, yLoc * 32))

newImage.save(pathlib.Path(sys.argv[1]).stem + ".dmi", "png", pnginfo=pngInfo)

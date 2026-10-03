import re

import PIL.Image
import sys
import pathlib
import PIL.PngImagePlugin

# Some lazy code inbound - RimiNosha
# This converts old hairstyle icon names to be in line with the new system.

if len(sys.argv) < 2:
    print("You need to supply an DMI via argument (or drop it on the script)")
    sys.exit(0)

dmiImage = PIL.Image.open(sys.argv[1])
finalsplit = list()
desc = str(dmiImage.info.get("Description"))

data = re.sub(r"state = \"(.*)\"", "state = \"m_\\1_ADJ\"", desc)

print(data)

pngInfo = PIL.PngImagePlugin.PngInfo()
pngInfo.add_text("Description", data, zip=True)

dmiImage.save(sys.argv[1] + ".dmi", "png", pnginfo=pngInfo)

import os
import os.path
import sys
import tomllib
from datetime import datetime

from . import cutter_image

time = datetime.now()

if len(sys.argv) < 3:
    print("cutter.py <templates> <image root>")
    sys.exit(1)

if not os.path.exists(sys.argv[1]):
    print("Template path doesn't exist!")
    sys.exit(2)

if not os.path.exists(sys.argv[2]):
    print("Icons path doesn't exist!")
    sys.exit(3)

bad_tomls = []

def find_toml_files(path: str, is_templates = False, tomls: list | dict = None):
    if tomls is None:
        if is_templates:
            tomls = {}
        else:
            tomls = []
    global bad_tomls
    for file in os.listdir(path):
        rel_file = path + "/" + file
        if os.path.isdir(rel_file):
            find_toml_files(rel_file, is_templates, tomls)
        if not rel_file.endswith(".toml"):
            continue
        if not is_templates and not os.path.exists(rel_file[:-5]):
            bad_tomls.append(rel_file)
            continue
        if is_templates:
            with open(rel_file, "rb") as r_file:
                tomls[rel_file[17 + (3 if rel_file[:3] == "../" else 0):]] = tomllib.load(r_file)
        else:
            tomls.append(rel_file)
    return tomls

templates = find_toml_files(sys.argv[1], True)
icon_tomls = find_toml_files(sys.argv[2])

for toml in icon_tomls:
    cutter_image.cut(toml, templates)

print("Took approx " + str(datetime.now() - time))
print("Found " + str(len(templates)) + " templates.")
print("Found " + str(len(icon_tomls)) + " icon tomls.")
if len(bad_tomls):
    print("Found " + str(len(bad_tomls)) + " bad toml" + ("" if len(bad_tomls) == 1 else "s") + ". Is the toml named right?")
    for toml in bad_tomls:
        print("- " + (toml[3:] if toml.startswith("../") else toml))

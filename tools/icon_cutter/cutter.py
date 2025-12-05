import os
import os.path
import sys
import cutter_image

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

def find_toml_files(path: str, is_templates = False, tomls: [] = None):
    if tomls is None:
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
        else:
            tomls.append(rel_file)
    return tomls

templates = find_toml_files(sys.argv[1], True)
icon_tomls = find_toml_files(sys.argv[2])

cutter_image.cut("", {})

print(templates.__len__())
print(icon_tomls.__len__())
print(bad_tomls.__len__())

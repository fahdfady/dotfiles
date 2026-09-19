#!/usr/bin/env -S\_/bin/sh\_-c\_"source\_\$(eval\_echo\_\$FAHD_VIRTUAL_ENV)/bin/activate&&exec\_python\_-E\_"\$0"\_"\$@""
import argparse
import re
import os
from typing import Dict, List

# Parses the Hyprland LUA keybinds file (was: hyprland .conf).
# Section markers: `-- #!` (grouper) and `-- ##! <Column>`.
# Hidden binds are skipped when the line ends with `-- hidden`.
# Produces the same JSON tree the cheatsheet consumes:
#   { children: [ { name, children: [ { name, keybinds: [{mods,key,dispatcher,params,comment}] } ] } ] }

parser = argparse.ArgumentParser(description='Hyprland keybind reader (lua)')
parser.add_argument('--path', type=str, default="$HOME/.config/hypr/keybinds.lua", help='path to keybind lua file')
args = parser.parse_args()


class KeyBinding(dict):
    def __init__(self, mods, key, dispatcher, params, comment) -> None:
        self["mods"] = mods
        self["key"] = key
        self["dispatcher"] = dispatcher
        self["params"] = params
        self["comment"] = comment


class Section(dict):
    def __init__(self, children, keybinds, name) -> None:
        self["children"] = children
        self["keybinds"] = keybinds
        self["name"] = name


def parse_bind(line):
    m = re.search(r'hl\.bind\(\s*"([^"]+)"', line)
    if not m:
        return None
    keystr = m.group(1)
    parts = [p.strip() for p in keystr.split('+')]
    key = parts[-1]
    mods = parts[:-1]

    desc_m = re.search(r'description\s*=\s*"([^"]*)"', line)
    comment = desc_m.group(1) if desc_m else ""

    return KeyBinding(mods, key, "", "", comment)


def get_binds_recursive(lines, i, scope):
    current = Section([], [], "")
    while i < len(lines):
        line = lines[i]
        m = re.match(r'^--\s*(#+!)(.*)$', line)
        if m:
            heading_scope = m.group(1).find('!')
            if heading_scope <= scope:
                i -= 1
                return current, i
            name = m.group(2).strip()
            i += 1
            child, i = get_binds_recursive(lines, i, heading_scope)
            child["name"] = name
            current["children"].append(child)
        else:
            if '-- hidden' not in line and re.match(r'^\s*hl\.bind\(', line):
                kb = parse_bind(line)
                if kb is not None:
                    current["keybinds"].append(kb)
            i += 1
    return current, i


def parse_keys(path: str) -> Dict[str, List[KeyBinding]]:
    real = os.path.expanduser(os.path.expandvars(path))
    if not os.access(real, os.R_OK):
        return {"children": []}
    with open(real, "r") as f:
        lines = f.read().splitlines()
    tree, _ = get_binds_recursive(lines, 0, 0)
    return tree


if __name__ == "__main__":
    import json
    print(json.dumps(parse_keys(args.path)))
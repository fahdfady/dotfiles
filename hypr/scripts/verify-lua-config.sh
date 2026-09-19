#!/usr/bin/env bash
# Strict parse+execute gate for the staged Hyprland Lua config.
# Runs the real Lua config manager headlessly and only passes when it
# reports "config ok" (exit code alone is unreliable here).
#
# Usage: verify-lua-config.sh <path-to-hyprland.lua>
set -uo pipefail

CFG="${1:?usage: $0 <path-to-hyprland.lua>}"
out=$(timeout 90 Hyprland --verify-config -c "$CFG" 2>&1)

if grep -q "config ok" <<<"$out"; then
    echo "OK: $CFG"
else
    echo "FAIL: $CFG"
    echo "$out"
    exit 1
fi
# Hyprland Lua config — staging area

This directory holds the in-progress Lua migration of the Hyprland config.
It is **not** used by the live session until the cutover (Stage 9): the
live session keeps using `hyprland.conf` because `~/.config/hypr/hyprland.lua`
does not exist yet.

## Test harness

- Parse + execute gate (headless, real Lua manager):
  `../scripts/verify-lua-config.sh hyprland.lua`
- Behavioral test happens only at the cutover restart, with the `.conf`
  fallback still on disk and `--safe-mode` available.

Note: Hyprland 0.56 has no nested/headless instance mode (no wayland
backend in aquamarine; the only second-instance flag is `--socket`, which
performs a session handover, not nesting). So the per-stage gate is the
verify-config execution above, and the behavioral gate is the restart.
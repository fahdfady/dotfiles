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

## Plugins (stage 8 findings)

- `blurls` is **not a real feature** in current Hyprland: the legacy parser
  silently ignores unknown keywords (verified: a bogus keyword also parses
  "config ok"). No plugin in hyprland-plugins provides it. It has been
  dropped from the transparent modules.
- `hyprpm` is available in `extra` (0.56.2). `hyprland-plugins` provides
  `hyprbars` (title bars) and `hyprexpo`. hyprbars has full Lua support:
  `hl.config({ plugin = { hyprbars = { ... } } })` and
  `hl.plugin.hyprbars.add_button({ ... })`.
- The config's `plugin { hyprbars { ... } }` block (in matugen's colors
  output) is **inert** because hyprpm/plugins are not installed. It was
  therefore **omitted** from `colors.lua`; including it without the plugin
  loaded would produce "unknown config key" errors and break the config.
- To enable hyprbars later: `sudo pacman -S hyprpm`, `hyprpm add
  https://github.com/hyprwm/hyprland-plugins`, `hyprpm enable hyprbars`,
  then add the Lua block back to the matugen template.
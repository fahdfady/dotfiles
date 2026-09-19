-- Antigravity transparency (was ~/.config/hypr/antigravity-transparent.conf) -- Stage 4
-- mic-mute.conf keybind (Super+Shift+Alt+M) is migrated with the other
-- keybinds in stage 5.

hl.window_rule({
    name    = "antigravity-transparent",
    match   = { class = "^(antigravity)$" },
    opacity = "0.95 0.95 override",
})

-- Global decoration/blur override (matches the sourced .conf behavior)
hl.config({
    decoration = {
        blur = {
            enabled           = true,
            size              = 2,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
        },
    },
})
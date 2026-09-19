-- VS Code transparency (was vscode-transparent.conf) -- Stage 4
-- The legacy `blurls = code` keyword has no Lua equivalent yet; see stage 8
-- (plugins / hyprpm investigation).

hl.window_rule({
    name    = "vscode-transparent",
    match   = { class = "^(code|Code)$" },
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
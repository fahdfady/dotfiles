-- Kitty transparency (was kitty-transparent.conf) -- Stage 4

hl.window_rule({
    name    = "kitty-transparent",
    match   = { class = "^(kitty)$" },
    opacity = "0.99 0.99 override",
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
-- Trackpad gestures (was hyprland/general.conf gestures) -- Stage 3

hl.gesture({ fingers = 3, direction = "swipe", action = "move" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "pinch", action = "float" })
hl.gesture({
    fingers  = 4,
    direction = "up",
    action = function()
        hl.dispatch(hl.dsp.global("quickshell:overviewToggle"))
    end,
})
hl.gesture({
    fingers  = 4,
    direction = "down",
    action = function()
        hl.dispatch(hl.dsp.global("quickshell:overviewClose"))
    end,
})

hl.config({
    gestures = {
        workspace_swipe_distance             = 700,
        workspace_swipe_cancel_ratio         = 0.2,
        workspace_swipe_min_speed_to_force   = 5,
        workspace_swipe_direction_lock       = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new           = true,
    },
})
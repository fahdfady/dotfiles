-- General options (was hyprland/general.conf) -- Stage 1
-- Monitors, gestures, and animations are handled in later stages.

hl.config({
    general = {
        gaps_in           = 1,
        gaps_out          = 0,
        gaps_workspaces   = 50,
        border_size       = 0,
        col = {
            active_border   = "rgba(0DB7D4FF)",
            inactive_border = "rgba(31313600)",
        },
        resize_on_border  = true,
        no_focus_fallback = true,
        allow_tearing     = true,
        snap = {
            enabled      = true,
            window_gap   = 4,
            monitor_gap  = 5,
            respect_gaps = true,
        },
    },

    dwindle = {
        preserve_split = true,
        smart_split    = false,
        smart_resizing = false,
    },

    decoration = {
        rounding = 4,
        blur = {
            enabled                  = true,
            xray                     = true,
            special                  = false,
            new_optimizations        = true,
            size                     = 14,
            passes                   = 3,
            brightness               = 1,
            noise                    = 0.04,
            contrast                 = 1,
            popups                   = true,
            popups_ignorealpha       = 0.6,
            input_methods            = true,
            input_methods_ignorealpha = 0.8,
        },
        shadow = {
            enabled      = true,
            range        = 30,
            offset       = "0 2",
            render_power = 4,
            color        = "rgba(00000010)",
        },
        dim_inactive = true,
        dim_strength = 0.025,
        dim_special  = 0.07,
    },

    input = {
        kb_layout             = "us,ara",
        numlock_by_default    = true,
        repeat_delay          = 250,
        repeat_rate           = 35,
        follow_mouse          = 1,
        off_window_axis_events = 2,
        kb_options            = "caps:escape",
        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor        = 0.8,
        },
    },

    misc = {
        disable_hyprland_logo        = true,
        disable_splash_rendering     = true,
        vrr                          = 1,
        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,
        animate_manual_resizes       = false,
        animate_mouse_windowdragging = false,
        enable_swallow               = false,
        swallow_regex                = "(foot|kitty|allacritty|Alacritty)",
        allow_session_lock_restore   = true,
        session_lock_xray            = true,
        initial_workspace_tracking   = false,
        focus_on_activate            = true,
    },

    binds = {
        scroll_event_delay               = 0,
        hide_special_on_workspace_change = true,
    },

    cursor = {
        zoom_factor     = 1,
        zoom_rigid      = false,
        hotspot_padding = 1,
    },
})
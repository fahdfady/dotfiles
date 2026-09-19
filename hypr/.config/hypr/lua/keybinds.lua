-- Keybinds (was hyprland/keybinds.conf + custom/keybinds.conf + mic-mute.conf) -- Stage 5
-- All binds live in the `global` submap (legacy `submap = global`), entered at startup.

local qsConfig = "ii"

hl.on("hyprland.start", function()
    hl.dispatch(hl.dsp.submap("global"))
end)

hl.define_submap("global", function()

    ---------------------------------
-- #!
-- ##! Shell
    -- Shell
    ---------------------------------
    hl.bind("SUPER + SUPER_L", hl.dsp.global("quickshell:overviewToggleRelease"), { ignore_mods = true, description = "Toggle overview" })
    hl.bind("SUPER + SUPER_R", hl.dsp.global("quickshell:overviewToggleRelease"), { ignore_mods = true, description = "Toggle overview" }) -- hidden
    hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call TEST_ALIVE || fuzzel")) -- hidden
    hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call TEST_ALIVE || fuzzel")) -- hidden
    hl.bind("catchall", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { ignore_mods = true, transparent = true, non_consuming = true }) -- hidden
    hl.bind("CTRL + SUPER_L", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt")) -- hidden
    hl.bind("CTRL + SUPER_R", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt")) -- hidden
    hl.bind("SUPER + mouse:272", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { mouse = true }) -- hidden
    hl.bind("SUPER + mouse:273", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { mouse = true }) -- hidden
    hl.bind("SUPER + mouse:274", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { mouse = true }) -- hidden
    hl.bind("SUPER + mouse:275", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { mouse = true }) -- hidden
    hl.bind("SUPER + mouse:276", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { mouse = true }) -- hidden
    hl.bind("SUPER + mouse:277", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { mouse = true }) -- hidden
    hl.bind("SUPER + mouse_up", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { mouse = true }) -- hidden
    hl.bind("SUPER + mouse_down", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { mouse = true }) -- hidden

    hl.bind("SUPER_L", hl.dsp.global("quickshell:workspaceNumber"), { ignore_mods = true, transparent = true }) -- hidden
    hl.bind("SUPER_R", hl.dsp.global("quickshell:workspaceNumber"), { ignore_mods = true, transparent = true }) -- hidden
    hl.bind("SUPER + V", hl.dsp.global("quickshell:overviewClipboardToggle"), { description = "Clipboard history >> clipboard" })
    hl.bind("SUPER + TAB", hl.dsp.global("quickshell:overviewToggle"), { description = "Toggle overview" }) -- hidden
    hl.bind("SUPER + A", hl.dsp.global("quickshell:sidebarLeftToggle"), { description = "Toggle left sidebar" })
    hl.bind("SUPER + ALT + A", hl.dsp.global("quickshell:sidebarLeftToggleDetach")) -- hidden
    hl.bind("SUPER + B", hl.dsp.global("quickshell:sidebarLeftToggle")) -- hidden
    hl.bind("SUPER + N", hl.dsp.global("quickshell:sidebarRightToggle"), { description = "Toggle right sidebar" })
    hl.bind("SUPER + SLASH", hl.dsp.global("quickshell:cheatsheetToggle"), { description = "Toggle cheatsheet" })
    hl.bind("SUPER + K", hl.dsp.global("quickshell:oskToggle"), { description = "Toggle on-screen keyboard" })
    hl.bind("SUPER + M", hl.dsp.global("quickshell:mediaControlsToggle"), { description = "Toggle media controls" })
    hl.bind("SUPER + G", hl.dsp.global("quickshell:crosshairToggle"))
    hl.bind("CTRL + ALT + DELETE", hl.dsp.global("quickshell:sessionToggle"), { description = "Toggle session menu" })
    hl.bind("SUPER + J", hl.dsp.global("quickshell:barToggle"), { description = "Toggle bar" })
    hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call TEST_ALIVE || pkill wlogout || wlogout -p layer-shell")) -- hidden
    hl.bind("SHIFT + SUPER + ALT + SLASH", hl.dsp.exec_cmd("qs -p ~/.config/quickshell/" .. qsConfig .. "/welcome.qml")) -- hidden

    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call brightness increment || brightnessctl s 5%+"), { locked = true, repeating = true }) -- hidden
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call brightness decrement || brightnessctl s 5%-"), { locked = true, repeating = true }) -- hidden
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"), { locked = true, repeating = true }) -- hidden
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { locked = true, repeating = true }) -- hidden

    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true }) -- hidden
    hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true, description = "Toggle mute" }) -- hidden
    hl.bind("ALT + XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true }) -- hidden
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true }) -- hidden
    hl.bind("SUPER + ALT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true, description = "Toggle mic" }) -- hidden
    hl.bind("CTRL + SUPER + T", hl.dsp.global("quickshell:wallpaperSelectorToggle"), { description = "Toggle wallpaper selector" })
    hl.bind("CTRL + SUPER + ALT + T", hl.dsp.global("quickshell:wallpaperSelectorRandom"), { description = "Select random wallpaper" })
    hl.bind("CTRL + SUPER + T", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call TEST_ALIVE || ~/.config/quickshell/" .. qsConfig .. "/scripts/colors/switchwall.sh"), { description = "Change wallpaper" }) -- hidden
    hl.bind("CTRL + SUPER + R", hl.dsp.exec_cmd("killall ags agsv1 gjs ydotool qs quickshell; qs -c " .. qsConfig .. " &"), { description = "Restart widgets" })

    ---------------------------------
-- #!
-- ##! Utilities
    -- Utilities
    ---------------------------------
    hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/fuzzel-emoji.sh copy"), { description = "Copy an emoji" })
    hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/screenshot-instant.sh"), { description = "Instant screenshot" })
    hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/screenshot-instant.sh"), { description = "Instant screenshot" })
    hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("mkdir -p ~/Pictures/Screenshots && hyprshot --freeze --mode region --output-folder ~/Pictures/Screenshots --silent"), { description = "Screen snip" })
    hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd('grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract "tmp.png" - | wl-copy && rm "tmp.png"'), { description = "Character recognition" }) -- hidden
    hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"), { description = "Color picker" })
    hl.bind("PRINT", hl.dsp.exec_cmd("grim - | wl-copy"), { locked = true, description = "Screenshot >> clipboard" })
    hl.bind("CTRL + PRINT", hl.dsp.exec_cmd('mkdir -p $(xdg-user-dir PICTURES)/Screenshots && grim $(xdg-user-dir PICTURES)/Screenshots/Screenshot_"$(date \'%Y-%m-%d_%H.%M.%S\')".png'), { locked = true, description = "Screenshot >> clipboard & save" })
    hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/record.sh"), { description = "Record region (no sound)" })
    hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/record.sh --fullscreen"), { description = "Record screen (no sound)" }) -- hidden
    hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/record.sh --fullscreen-sound"), { description = "Record screen (with sound)" })
    hl.bind("SUPER + SHIFT + ALT + mouse:273", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/ai/primary-buffer-query.sh"), { mouse = true, description = "Generate AI summary for selected text" })

    ---------------------------------
-- #!
-- ##! Window
    -- Window
    ---------------------------------
    hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true }) -- hidden
    hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
    hl.bind("SUPER + LEFT", hl.dsp.focus({ direction = "left" })) -- hidden
    hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "right" })) -- hidden
    hl.bind("SUPER + UP", hl.dsp.focus({ direction = "up" })) -- hidden
    hl.bind("SUPER + DOWN", hl.dsp.focus({ direction = "down" })) -- hidden
    hl.bind("SUPER + BRACKETLEFT", hl.dsp.focus({ direction = "left" })) -- hidden
    hl.bind("SUPER + BRACKETRIGHT", hl.dsp.focus({ direction = "right" })) -- hidden
    hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.move({ direction = "left" })) -- hidden
    hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.move({ direction = "right" })) -- hidden
    hl.bind("SUPER + SHIFT + UP", hl.dsp.window.move({ direction = "up" })) -- hidden
    hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.move({ direction = "down" })) -- hidden
    hl.bind("ALT + F4", hl.dsp.window.close()) -- hidden
    hl.bind("SUPER + Q", hl.dsp.window.close())
    hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"))

    hl.bind("SUPER + ALT + SPACE", hl.dsp.window.float({ action = "toggle" }))
    hl.bind("SUPER + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "set" }), { description = "Maximize" })
    hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "set" }), { description = "Fullscreen" })
    hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3 }))
    hl.bind("SUPER + P", hl.dsp.window.pin({ action = "toggle" }))

    hl.bind("SUPER + ALT + 1", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 1")) -- hidden
    hl.bind("SUPER + ALT + 2", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 2")) -- hidden
    hl.bind("SUPER + ALT + 3", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 3")) -- hidden
    hl.bind("SUPER + ALT + 4", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 4")) -- hidden
    hl.bind("SUPER + ALT + 5", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 5")) -- hidden
    hl.bind("SUPER + ALT + 6", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 6")) -- hidden
    hl.bind("SUPER + ALT + 7", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 7")) -- hidden
    hl.bind("SUPER + ALT + 8", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 8")) -- hidden
    hl.bind("SUPER + ALT + 9", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 9")) -- hidden
    hl.bind("SUPER + ALT + 0", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 10")) -- hidden

    hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "r-1" }), { mouse = true }) -- hidden
    hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "r+1" }), { mouse = true }) -- hidden
    hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }), { mouse = true }) -- hidden
    hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }), { mouse = true }) -- hidden

    hl.bind("SUPER + ALT + PAGE_DOWN", hl.dsp.window.move({ workspace = "+1" })) -- hidden
    hl.bind("SUPER + ALT + PAGE_UP", hl.dsp.window.move({ workspace = "-1" })) -- hidden
    hl.bind("SUPER + SHIFT + PAGE_DOWN", hl.dsp.window.move({ workspace = "r+1" })) -- hidden
    hl.bind("SUPER + SHIFT + PAGE_UP", hl.dsp.window.move({ workspace = "r-1" })) -- hidden
    hl.bind("CTRL + SUPER + SHIFT + RIGHT", hl.dsp.window.move({ workspace = "r+1" })) -- hidden
    hl.bind("CTRL + SUPER + SHIFT + LEFT", hl.dsp.window.move({ workspace = "r-1" })) -- hidden

    hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:special", follow = false }))

    hl.bind("CTRL + SUPER + S", hl.dsp.workspace.toggle_special("")) -- hidden
    hl.bind("ALT + TAB", hl.dsp.window.cycle_next({ next = true })) -- hidden
    hl.bind("ALT + TAB", hl.dsp.window.bring_to_top()) -- hidden

    ---------------------------------
-- ##! Workspace
    -- Workspace
    ---------------------------------
    hl.bind("SUPER + 1", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 1")) -- hidden
    hl.bind("SUPER + 2", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 2")) -- hidden
    hl.bind("SUPER + 3", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 3")) -- hidden
    hl.bind("SUPER + 4", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 4")) -- hidden
    hl.bind("SUPER + 5", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 5")) -- hidden
    hl.bind("SUPER + 6", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 6")) -- hidden
    hl.bind("SUPER + 7", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 7")) -- hidden
    hl.bind("SUPER + 8", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 8")) -- hidden
    hl.bind("SUPER + 9", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 9")) -- hidden
    hl.bind("SUPER + 0", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 10")) -- hidden

    hl.bind("CTRL + SUPER + RIGHT", hl.dsp.focus({ workspace = "r+1" })) -- hidden
    hl.bind("CTRL + SUPER + LEFT", hl.dsp.focus({ workspace = "r-1" })) -- hidden
    hl.bind("CTRL + SUPER + ALT + RIGHT", hl.dsp.focus({ workspace = "m+1" })) -- hidden
    hl.bind("CTRL + SUPER + ALT + LEFT", hl.dsp.focus({ workspace = "m-1" })) -- hidden
    hl.bind("SUPER + PAGE_DOWN", hl.dsp.focus({ workspace = "+1" })) -- hidden
    hl.bind("SUPER + PAGE_UP", hl.dsp.focus({ workspace = "-1" })) -- hidden
    hl.bind("CTRL + SUPER + PAGE_DOWN", hl.dsp.focus({ workspace = "r+1" })) -- hidden
    hl.bind("CTRL + SUPER + PAGE_UP", hl.dsp.focus({ workspace = "r-1" })) -- hidden
    hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "+1" }), { mouse = true }) -- hidden
    hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "-1" }), { mouse = true }) -- hidden
    hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "r+1" }), { mouse = true }) -- hidden
    hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "r-1" }), { mouse = true }) -- hidden

    hl.bind("SUPER + S", hl.dsp.workspace.toggle_special(""), { description = "Toggle scratchpad" })
    hl.bind("SUPER + mouse:275", hl.dsp.workspace.toggle_special(""), { mouse = true }) -- hidden
    hl.bind("CTRL + SUPER + BRACKETLEFT", hl.dsp.focus({ workspace = "-1" })) -- hidden
    hl.bind("CTRL + SUPER + BRACKETRIGHT", hl.dsp.focus({ workspace = "+1" })) -- hidden
    hl.bind("CTRL + SUPER + UP", hl.dsp.focus({ workspace = "r-5" })) -- hidden
    hl.bind("CTRL + SUPER + DOWN", hl.dsp.focus({ workspace = "r+5" })) -- hidden

    ---------------------------------
-- #!
-- # Testing
    -- Testing
    ---------------------------------
    hl.bind("SUPER + ALT + F11", hl.dsp.exec_cmd([=[bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i "nipple" | grep -v -i "pussy" | shuf -n 1); ACTION=$(notify-send "Test notification with body image" "This notification should contain your user account <b>image</b> and <a href=\"https://discord.com/app\">Discord</a> <b>icon</b>. Oh and here is a random image in your Pictures folder: <img src=\"$RANDOM_IMAGE\" alt=\"Testing image\"/>" -a "Hyprland keybind" -p -h "string:image-path:/var/lib/AccountsService/icons/$USER" -t 6000 -i "discord" -A "openImage=Open profile image" -A "action2=Open the random image" -A "action3=Useless button"); [[ $ACTION == *openImage ]] && xdg-open "/var/lib/AccountsService/icons/$USER"; [[ $ACTION == *action2 ]] && xdg-open \"$RANDOM_IMAGE\"']=])) -- hidden
    hl.bind("SUPER + ALT + F12", hl.dsp.exec_cmd([=[bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i "nipple" | grep -v -i "pussy" | shuf -n 1); ACTION=$(notify-send "Test notification" "This notification should contain a random image in your <b>Pictures</b> folder and <a href=\"https://discord.com/app\">Discord</a> <b>icon</b>.\n<i>Flick right to dismiss!</i>" -a "Discord (fake)" -p -h "string:image-path:$RANDOM_IMAGE" -t 6000 -i "discord" -A "openImage=Open profile image" -A "action2=Useless button" -A "action3=Cry more"); [[ $ACTION == *openImage ]] && xdg-open "/var/lib/AccountsService/icons/$USER"']=])) -- hidden
    hl.bind("SUPER + ALT + EQUAL", hl.dsp.exec_cmd("notify-send \"Urgent notification\" \"Ah hell no\" -u critical -a 'Hyprland keybind'")) -- hidden

    ---------------------------------
-- ##! Session
    -- Session
    ---------------------------------
    hl.bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"), { description = "Lock" })
    hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend || loginctl suspend"), { locked = true, description = "Suspend system" })
    hl.bind("CTRL + SHIFT + ALT + SUPER + DELETE", hl.dsp.exec_cmd("systemctl poweroff || loginctl poweroff"), { description = "Shutdown" }) -- hidden

    ---------------------------------
-- ##! Screen
    -- Screen
    ---------------------------------
    hl.bind("SUPER + MINUS", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call zoom zoomOut"), { repeating = true, description = "Zoom out" })
    hl.bind("SUPER + EQUAL", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call zoom zoomIn"), { repeating = true, description = "Zoom in" })
    hl.bind("SUPER + MINUS", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call TEST_ALIVE || ~/.config/hypr/hyprland/scripts/zoom.sh decrease 0.1"), { repeating = true }) -- hidden
    hl.bind("SUPER + EQUAL", hl.dsp.exec_cmd("qs -c " .. qsConfig .. " ipc call TEST_ALIVE || ~/.config/hypr/hyprland/scripts/zoom.sh increase 0.1"), { repeating = true }) -- hidden

    ---------------------------------
-- ##! Media
    -- Media
    ---------------------------------
    hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd('playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`'), { locked = true, description = "Next track" })
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd('playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`'), { locked = true }) -- hidden
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true }) -- hidden
    hl.bind("SUPER + SHIFT + ALT + mouse:275", hl.dsp.exec_cmd("playerctl previous"), { mouse = true }) -- hidden
    hl.bind("SUPER + SHIFT + ALT + mouse:276", hl.dsp.exec_cmd('playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`'), { mouse = true }) -- hidden
    hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Previous track" })
    hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play/pause media" })
    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- hidden
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- hidden

    ---------------------------------
-- ##! Apps
    -- Apps
    ---------------------------------
    hl.bind("SUPER + RETURN", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "${TERMINAL}" "kitty -1" "foot" "alacritty" "wezterm" "konsole" "kgx" "uxterm" "xterm"'), { description = "Terminal" })
    hl.bind("SUPER + T", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "${TERMINAL}" "kitty -1" "foot" "alacritty" "wezterm" "konsole" "kgx" "uxterm" "xterm"')) -- hidden
    hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "${TERMINAL}" "kitty -1" "foot" "alacritty" "wezterm" "konsole" "kgx" "uxterm" "xterm"')) -- hidden
    hl.bind("SUPER + E", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "dolphin" "nautilus" "nemo" "thunar" "${TERMINAL}" "kitty -1 fish -c yazi"'), { description = "File manager" })
    hl.bind("SUPER + W", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "google-chrome-stable" "zen-browser" "firefox" "brave" "chromium" "microsoft-edge-stable" "opera" "librewolf"'), { description = "Browser" })
    hl.bind("SUPER + C", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "chromium"'))
    hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "wps" "onlyoffice-desktopeditors"'), { description = "Office software" })
    hl.bind("SUPER + X", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "kate" "gnome-text-editor" "emacs"'), { description = "Text editor" })
    hl.bind("CTRL + SUPER + V", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "pavucontrol-qt" "pavucontrol"'), { description = "Volume mixer" })
    hl.bind("SUPER + I", hl.dsp.exec_cmd('XDG_CURRENT_DESKTOP=gnome ~/.config/hypr/hyprland/scripts/launch_first_available.sh "qs -p ~/.config/quickshell/' .. qsConfig .. '/settings.qml" "systemsettings" "gnome-control-center" "better-control"'), { description = "Settings app" })
    hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd('~/.config/hypr/hyprland/scripts/launch_first_available.sh "gnome-system-monitor" "plasma-systemmonitor --page-name Processes" "command -v btop && kitty -1 fish -c btop"'), { description = "Task manager" })
    hl.bind("SUPER + D", hl.dsp.exec_cmd("discord"))
    hl.bind("SUPER + O", hl.dsp.exec_cmd("obsidian"))
    hl.bind("SUPER + P", hl.dsp.exec_cmd("zathura"))

    ---------------------------------
    -- Cursed stuff
    ---------------------------------
    hl.bind("CTRL + SUPER + BACKSLASH", hl.dsp.window.resize({ x = 640, y = 480 })) -- hidden

    ---------------------------------
-- #!
-- ##! User
    -- User (custom/keybinds.conf)
    ---------------------------------
    hl.bind("CTRL + SUPER + SLASH", hl.dsp.exec_cmd("xdg-open ~/.config/fahd/config.json"), { description = "Edit shell config" })
    hl.bind("CTRL + SUPER + ALT + SLASH", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.conf"), { description = "Edit extra keybinds" })

    ---------------------------------
    -- mic-mute.conf
    ---------------------------------
    hl.bind("SUPER + SHIFT + ALT + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-all-mics.sh"), { locked = true, description = "Toggle all microphones" })
end)

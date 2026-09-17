-- Environment variables (was hyprland/env.conf) -- Stage 1
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")
hl.env("INPUT_METHOD", "fcitx")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XDG_MENU_PREFIX", "plasma-")

hl.env("FAHD_VIRTUAL_ENV", "~/.local/state/quickshell/.venv")

hl.env("TERMINAL", "kitty -1")

hl.env("WLR_NO_HARDWARE_CURSORS", "1")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
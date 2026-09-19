#!/usr/bin/env bash
# Keep quickshell alive.
#
# quickshell (the "ii" shell providing the bar, overview, wallpaper and the
# global shortcuts used by many Hyprland binds) segfaults periodically, often
# after GPU context loss (QRhiGles2: Context is lost). Without a supervisor the
# shell just stays dead. This restarts it with a small backoff.
#
# Restarting on demand: kill the process (the "Restart widgets" keybind does
# `killall qs quickshell`); the loop below brings it back.

cfg="${1:-ii}"
export QS_DISABLE_DMABUF=1

log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell"
mkdir -p "$log_dir"
log="$log_dir/watchdog.log"

while true; do
    qs -c "$cfg" >>"$log" 2>&1
    code=$?
    printf '[%s] quickshell exited (code %s), restarting in 2s\n' \
        "$(date '+%F %T')" "$code" >>"$log"
    sleep 2
done

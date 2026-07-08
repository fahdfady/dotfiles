#!/bin/sh
OUTDIR="$HOME/Pictures/Screenshots"
mkdir -p "$OUTDIR"
FILE="$OUTDIR/Screenshot_$(date '+%Y-%m-%d_%H.%M.%S').png"
/usr/bin/grim "$FILE" && /usr/bin/wl-copy < "$FILE"

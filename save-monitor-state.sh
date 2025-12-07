#!/usr/bin/env bash
# save-monitors.sh
# Usage: save-monitors.sh profile-name

set -euo pipefail

if ! command -v xrandr >/dev/null 2>&1; then
    echo "xrandr not found. This script requires X11 with xrandr." >&2
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Usage: $0 profile-name" >&2
    exit 1
fi

PROFILE="$1"
OUTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/xrandr-monitor-layouts"
mkdir -p "$OUTDIR"
FILE="$OUTDIR/$PROFILE"

xrandr --query | awk '
/ connected/ && $2 == "connected" {
    name = $1
    primary = 0
    on = 0
    mode = "off"
    x = 0
    y = 0
    rotation = "normal"
    w = 0
    h = 0

    # walk tokens to find primary, geometry, and rotation
    for (i = 2; i <= NF; i++) {
        if ($i == "primary") {
            primary = 1
        }

        # geometry token: 1080x1920+3840+514
        if ($i ~ /^[0-9]+x[0-9]+\+[0-9]+\+[0-9]+$/) {
            split($i, a, /[x+]/)
            w = a[1]
            h = a[2]
            x = a[3]
            y = a[4]
            on = 1
            continue
        }
    }

    # Determine rotation by looking for the word before an open parenthesis
    if ($0 ~ /\(/) {
        # Split the line at the opening parenthesis
        split($0, parts, "(")
        # Get the last word before the parenthesis
        split(parts[1], words, " ")
        rotation = words[length(words)]
        # Validate its a valid rotation
        if (rotation != "normal" && rotation != "left" && rotation != "right" && rotation != "inverted") {
            rotation = "normal"
        }
    } else {
        rotation = "normal"
    }

    if (on) {
        pw = w
        ph = h
        if (rotation == "left" || rotation == "right") {
            pw = h
            ph = w
        }
        mode = pw "x" ph
    } else {
        mode = "off"
        x = 0
        y = 0
        rotation = "normal"
    }

    # format: output state mode x y primary_flag rotation
    print name, (on ? "on" : "off"), mode, x, y, primary, rotation
}
' > "$FILE"

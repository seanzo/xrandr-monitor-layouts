#!/usr/bin/env bash
# restore-monitor-state.sh
# Usage: restore-monitor-state.sh profile-name

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
FILE="$OUTDIR/$PROFILE"

if [ ! -f "$FILE" ]; then
    echo "Profile not found: $FILE" >&2
    exit 1
fi

while read -r name state mode x y primary rotation; do
    [ -z "$name" ] && continue

    if [ "$state" = "off" ]; then
        xrandr --output "$name" --off || true
    else
        args=(--output "$name" --mode "$mode" --pos "${x}x${y}")
        if [ "$primary" = "1" ]; then
            args+=(--primary)
        fi
        if [ -n "${rotation:-}" ]; then
            args+=(--rotate "$rotation")
        fi
        xrandr "${args[@]}"
    fi
done < "$FILE"

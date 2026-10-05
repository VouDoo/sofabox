#!/usr/bin/env bash
# Volume keys (the keyboard's media keys, bound in labwc's rc.xml): change the volume and show it on screen.
# Usage: sofabox-volume up|down|mute
set -euo pipefail

sink=@DEFAULT_AUDIO_SINK@
case "${1:-}" in
  up) wpctl set-volume --limit 1.0 "$sink" 5%+ ;;
  down) wpctl set-volume "$sink" 5%- ;;
  mute) wpctl set-mute "$sink" toggle ;;
  *)
    echo "usage: sofabox-volume up|down|mute" >&2
    exit 1
    ;;
esac

# wpctl prints "Volume: 0.45", or "Volume: 0.45 [MUTED]".
status=$(wpctl get-volume "$sink")
percent=$(awk '{ printf "%d", $2 * 100 }' <<<"$status")
label="Volume $percent%"
if [[ $status == *MUTED* ]]; then
  label="Muted"
fi

# The "synchronous" hint makes each new volume popup replace the previous one.
notify-send --app-name=volume --expire-time=1500 \
  --hint=string:x-canonical-private-synchronous:volume \
  --hint=int:value:"$percent" "$label"

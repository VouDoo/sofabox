#!/usr/bin/env bash
# The "Videos" menu entry: lists the videos in ~/Videos (subfolders included) in the same menu (fuzzel),
# and plays the chosen one fullscreen with mpv (settings in ~/.config/mpv/mpv.conf).
set -euo pipefail

videos_dir=~/Videos # created by the videos role (videos_dir)
extensions='avi|m4v|mkv|mov|mp4|mpeg|mpg|ogv|ts|webm|wmv'

videos=$(find "$videos_dir" -type f -regextype posix-extended -iregex ".*\.($extensions)" -printf '%P\n' |
  sort --version-sort)
if [[ -z $videos ]]; then
  notify-send "No videos" "Copy some to ~/Videos on the box."
  exit 0
fi

# Pressing Super while the list is open closes it (sofabox-menu stops fuzzel).
choice=$(fuzzel --dmenu <<<"$videos") || exit 0
[[ -n $choice ]] || exit 0
exec mpv "$videos_dir/$choice"

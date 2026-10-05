#!/usr/bin/env bash
# Opens a site in Brave Origin the way the box needs it. Used by the Super menu.
# Usage: sofabox-browser app  URL   its own fullscreen window, no browser UI
#        sofabox-browser tabs URL   a normal window with tabs and an address bar
set -euo pipefail

usage="usage: sofabox-browser app|tabs URL"
mode=${1:?$usage}
url=${2:?$usage}

# Native Wayland (not through Xwayland), hardware video decoding (VA-API),
# and dark mode: dark browser UI, and websites are told to use their dark theme.
flags=(--ozone-platform=wayland --enable-features=AcceleratedVideoDecodeLinuxGL --force-dark-mode)

case $mode in
  app) exec brave-origin "${flags[@]}" --app="$url" ;;
  tabs) exec brave-origin "${flags[@]}" --new-window "$url" ;;
  *)
    echo "$usage" >&2
    exit 1
    ;;
esac

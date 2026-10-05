#!/usr/bin/env bash
# The Super-key menu (bound in labwc's rc.xml).
# Lists the apps from settings.yml and opens the chosen one with sofabox-browser (or runs its command),
# or brings it to the front if it is already open.
# Typed text that matches no app opens as a website if it looks like one, otherwise as a search.
set -euo pipefail

apps_file=/etc/sofabox/apps.tsv # name <TAB> mode <TAB> url (or command, for mode "run")
# shellcheck source=/dev/null
source /etc/sofabox/menu.env # SEARCH_URL

# Chromium-based browsers name each app window after its URL without the port,
# e.g. "brave-www.example.com__-Default".
# Check with `wlrctl toplevel list` on the box.
app_id_prefix=brave

app_id_of() {
  local rest=${1#*://}
  local host_port=${rest%%/*}
  local path=${rest#"$host_port"}
  path=${path:-/}
  echo "$app_id_prefix-${host_port%%:*}_${path//\//_}-Default"
}

focus_if_open() {
  wlrctl toplevel focus "app_id:$(app_id_of "$1")" 2>/dev/null
}

urlencode() {
  python3 -c 'import sys, urllib.parse; print(urllib.parse.quote_plus(sys.argv[1]))' "$1"
}

# Pressing Super while the menu is open closes it.
if pkill --exact fuzzel; then
  exit 0
fi

choice=$(cut -f1 "$apps_file" | fuzzel --dmenu) || exit 0
[[ -n $choice ]] || exit 0

# One of the apps from settings.yml.
app=$(awk -F '\t' -v name="$choice" '$1 == name' "$apps_file")
if [[ -n $app ]]; then
  IFS=$'\t' read -r _ mode target <<<"$app"
  if [[ $mode == run ]]; then
    exec sh -c "$target"
  fi
  if [[ $mode != tabs ]] && focus_if_open "$target"; then
    exit 0
  fi
  exec sofabox-browser "$mode" "$target"
fi

# Free text: a website, or a search.
if [[ $choice =~ ^https?:// ]]; then
  url=$choice
# A name with a domain and/or a port, like "example.com" or "sofabox.local:9000".
elif [[ $choice =~ ^[^[:space:]/:]+(\.[a-z]{2,}(:[0-9]+)?|:[0-9]+)(/[^[:space:]]*)?$ ]]; then
  url="https://$choice"
else
  url=${SEARCH_URL//%s/$(urlencode "$choice")}
fi
exec sofabox-browser tabs "$url"

#!/usr/bin/env bash
# Daily check (sofabox-daily-check.timer), in the daytime:
# - alert if a disk is fuller than DISK_PERCENT;
# - alert if a unit is still failed, so a failure whose alert was lost (no internet at night) is still reported.
set -euo pipefail

# shellcheck source=/dev/null
source /etc/sofabox/alerts.env # DISK_PERCENT, BOX_USER

# One line per disk: btrfs shows the same disk once per subvolume (/, /home, /srv…).
full=$(df --output=source,pcent,target --local --exclude-type=tmpfs --exclude-type=devtmpfs --exclude-type=efivarfs |
  awk -v limit="$DISK_PERCENT" 'NR > 1 && int($2) > limit && !seen[$1]++ { printf "%s%s (%s)", sep, $3, $2; sep = ", " }')

if [[ -n $full ]]; then
  sofabox-alert "disk almost full" "Above ${DISK_PERCENT}%: $full"
fi

# System units, then the box user's (the containers). A unit stays failed until it succeeds again.
# A failed sofabox-alert@ unit only means an alert didn't get out: the unit it was about is listed itself.
failed=$({
  systemctl --failed --plain --no-legend
  systemctl --user --machine="$BOX_USER@" --failed --plain --no-legend
} | awk '$1 !~ /^sofabox-alert@/ { printf "%s%s", sep, $1; sep = ", " }')

if [[ -n $failed ]]; then
  sofabox-alert "still failed" "$failed. Details on the box: journalctl -u <unit> (add --user for a container's service)"
fi

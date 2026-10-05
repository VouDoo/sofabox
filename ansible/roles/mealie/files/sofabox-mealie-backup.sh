#!/usr/bin/env bash
# Nightly Mealie backup (run by sofabox-mealie-backup.timer).
# Asks Mealie to create its own backup (database + images: the zip that Admin → Backups restores),
# then keeps only the newest ones.
set -euo pipefail

# shellcheck source=/dev/null
source /etc/sofabox/mealie-backup.env # MEALIE_URL, MEALIE_TOKEN, BACKUP_DIR, KEEP

curl --fail --silent --show-error --max-time 600 \
  --request POST --header "Authorization: Bearer $MEALIE_TOKEN" \
  "$MEALIE_URL/api/admin/backups"
echo

# Mealie names its backups without spaces, so splitting on the first space is safe.
find "$BACKUP_DIR" -maxdepth 1 -name '*.zip' -printf '%T@ %p\n' |
  sort --reverse --numeric-sort |
  tail --lines=+"$((KEEP + 1))" |
  cut --delimiter=' ' --fields=2- |
  xargs --no-run-if-empty rm --verbose --

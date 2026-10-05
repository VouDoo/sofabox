#!/usr/bin/env bash
# Copies every service's backups from the box to this machine (`mise run fetch-backups`).
# Box: /srv/sofabox/<service>/backups/ → here: backups/<service>/backups/ (git-ignored).
# Only copies new and changed files, never deletes: an empty folder on a failing box can't wipe the copies here.
set -euo pipefail
cd "$(dirname "$0")/.."

connection=ansible/host_vars/box/connection.yml
host=$(sed -n 's/^ansible_host: //p' "$connection")
user=$(sed -n 's/^ansible_user: //p' "$connection")

# --relative from "/./" keeps the <service>/backups/ folders. No --delete, on purpose.
rsync --archive --relative --verbose "$user@$host:/srv/sofabox/./*/backups/" backups/

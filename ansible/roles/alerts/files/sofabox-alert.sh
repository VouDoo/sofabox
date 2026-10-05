#!/usr/bin/env bash
# Sends a push notification to your phone (ntfy app, subscribed to the private topic).
# Usage: sofabox-alert "title" "message"
# Services call it on failure through sofabox-alert@.service (OnFailure=sofabox-alert@%n.service).
set -euo pipefail

usage="usage: sofabox-alert TITLE MESSAGE"
title=${1:?$usage}
message=${2:?$usage}

# shellcheck source=/dev/null
source /etc/sofabox/alerts.env # NTFY_URL

curl --fail --silent --show-error --max-time 30 \
  --header "Title: $(hostname): $title" --header "Tags: warning" \
  --data "$message" "$NTFY_URL" >/dev/null

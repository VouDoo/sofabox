#!/usr/bin/env bash
# First-time setup of a control machine (`mise run setup`).
# Asks where the box is and creates the git-ignored local files:
#   ansible/host_vars/box/connection.yml  how to reach the box
#   ansible/host_vars/box/settings.yml    your own settings, on top of the defaults (created once, then yours)
#   ansible/host_vars/box/secrets.yml     secrets (ntfy topic generated, service tokens asked)
# Safe to re-run: the box address can be changed, existing secrets are kept, missing ones are created.
set -euo pipefail
cd "$(dirname "$0")/.."

connection=ansible/host_vars/box/connection.yml
my_settings=ansible/host_vars/box/settings.yml
secrets=ansible/host_vars/box/secrets.yml

# Defaults: sofabox.local (the hostname the install guide suggests), and the current user when re-running.
current() { if [[ -e $connection ]]; then sed -n "s/^$1: //p" "$connection"; fi; }
current_host=$(current ansible_host)
default_host=sofabox.local
default_user=$(current ansible_user)
default_user=${default_user:-$USER}

read -rp "Box hostname or IP address [$default_host]${current_host:+ (now: $current_host)}: " host
read -rp "Your user on the box [$default_user]: " user

mkdir -p "$(dirname "$connection")"
cat >"$connection" <<EOF
# Created by \`mise run setup\`. This machine only (git-ignored).
ansible_host: ${host:-$default_host}
ansible_user: ${user:-$default_user}
EOF
echo "Saved the box address in $connection"

if [[ ! -e $my_settings ]]; then
  printf '%s\n' "# Your own settings (git-ignored). They override the defaults in ansible/group_vars/all/settings.yml." \
    "# Copy here only the settings you change, e.g. \`tv_scale: 1.25\`. A list (like \`apps\`) is replaced as a whole." \
    >"$my_settings"
  echo "Created $my_settings for your own settings"
fi

# Readable by you only: other users of this machine must not see the secrets.
# Values only: what each key is stays in the example file, which git keeps up to date.
if [[ ! -e $secrets ]]; then
  (umask 077 && echo "# Created by \`mise run setup\`. What each key is: ansible/secrets.example.yml" >"$secrets")
  echo "Created $secrets"
fi

# Existing secrets are kept. A missing one is generated or asked again.
if ! grep -q '^ntfy_topic:' "$secrets"; then
  # 10 random lowercase letters and digits: impossible to guess, short enough to type in the ntfy app.
  # Read a fixed amount of randomness: `tr </dev/urandom | head` would exit with SIGPIPE under pipefail.
  chars=$(head -c 1000 /dev/urandom | LC_ALL=C tr -dc 'a-z0-9')
  echo "ntfy_topic: sofabox-${chars:0:10}" >>"$secrets"
  echo "Generated a new ntfy topic in $secrets: subscribe to it in the ntfy app"
fi

# Secrets only a service can create, listed in the example file as "# ask: <key>: <question>".
mapfile -t asks < <(sed -n 's/^# ask: //p' ansible/secrets.example.yml)
for ask in "${asks[@]}"; do
  key=${ask%%:*}
  if ! grep -q "^$key:" "$secrets"; then
    read -rp "${ask#*: } (Enter to skip): " value
    value=${value#"$key: "} # in case the whole "key: value" line was pasted
    if [[ -n $value ]]; then
      echo "$key: $value" >>"$secrets"
      echo "Saved $key in $secrets"
    fi
  fi
done

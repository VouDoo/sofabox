# shellcheck shell=sh
# Managed by Ansible (desktop role). Sourced at login, last (zz-…): start the TV desktop on the autologin console.
# When labwc exits, the console logs in again and labwc starts again.
# Its messages go to the system log: `journalctl -t labwc`.
if [ "$(tty)" = /dev/tty1 ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
  exec systemd-cat --identifier=labwc labwc
fi

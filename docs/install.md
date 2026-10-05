# Installing the box

What has to be true before Ansible takes over. How you get there is up to you.

## 1. Before wiping

- If the PC already runs Sofabox with services, **copy their latest backups off it** (`mise run fetch-backups`). They get restored later.
- Anything else worth keeping is copied off the PC.

## 2. Fedora on the PC

A fresh **Fedora, minimal install** (no desktop: Ansible adds everything the box needs). During the install:

- **Keyboard:** the layout of the keyboard you'll use on the couch. The box uses it for every keyboard.
- **Language and timezone:** yours. Ansible doesn't change them.
- **Hostname:** your choice. `sofabox` matches the default proposed by `mise run setup` (`sofabox.local`).
  > **Tip:** `.local` isn't part of the hostname. It's how Linux machines find each other on a home network without any router setup (mDNS): a machine named `sofabox` answers to `sofabox.local`. If that name doesn't answer from your control machine, give `mise run setup` the box's IP address instead.
- **Disk:** no encryption ([decision 0010](decisions/0010-no-disk-encryption.md)).
- **User:** an **administrator** (sudo) account. Root can stay disabled.

## 3. Hand over to Ansible

- **SSH** is running on the PC, and **your SSH key** from the control machine is accepted.
- On the control machine (any Linux PC with this repo and [mise](https://mise.jdx.dev)):
  ```sh
  mise install        # the project's tools
  mise run setup      # where the box is, your user on it (skip the service tokens for now)
  mise run ping       # should answer "pong"
  ```
- **Your settings:** the defaults are in `ansible/group_vars/all/settings.yml` (menu apps, `services`, TV picture…), and every one works as it is. Put the ones you change in `ansible/host_vars/box/settings.yml`, created by `mise run setup`.

From here, Ansible does the rest:

```sh
mise run check      # dry run: shows what would change
mise run deploy     # applies everything (asks your sudo password on the box)
```

On a brand-new box, the dry run can stop at a service that isn't installed yet (it would be installed by an earlier step). That's expected; the real deploy goes through.

## 4. After the first deploy

**Reboot once.** Some settings only apply at boot.

One-time steps in Brave that can't be automated:
- Brave Origin's first launch: **proceed with Origin for free on Linux**.
- Widevine (the DRM streaming sites use): **accept it** the first time a site asks.

Then:
- **Alerts:** install the ntfy app on your phone and subscribe to the `ntfy_topic` from `ansible/host_vars/box/secrets.yml` (server: ntfy.sh).

**For each service in `services`:** follow the one-time steps in its role's `README.md` (`ansible/roles/<service>/README.md`): restoring its backup, creating a token for its nightly backups…

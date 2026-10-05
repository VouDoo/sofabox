# Solution design

How the box works, on any x86_64 PC with an Intel or AMD GPU ([0019](decisions/0019-generic-project-sofabox.md)). The **why** behind each choice is in [`decisions/`](decisions/), what's left to do in [`ROADMAP.md`](../ROADMAP.md). Details specific to one part live next to its code, in its role.

---

## 1. Overview

```
┌───────────────────── your old PC · Fedora (minimal) ─────────────────────┐
│                                                                          │
│  boot → autologin → labwc                                                │
│                       ├─ background image                                │
│                       ├─ Super → app menu                                │
│                       └─ apps (Brave app windows, commands)              │
│                                                                          │
│  services listed in settings.yml: one rootless container each            │
│                                                                          │
│  timers: backups and updates at night · daily check in the daytime       │
└──────────────────────────────────────────────────────────────────────────┘
        ▲ configured by Ansible over SSH, from any machine with this repo
```

## 2. Configuration: Ansible ([0001](decisions/0001-provisioning-with-ansible.md))

- A fresh Fedora install becomes the finished box with **one command** (`mise run deploy`), and running it again is always safe.
- Everything the box needs comes from this repo. Nothing is hand-edited on the box.
- The default settings are in `settings.yml`. A box's own choices go in the git-ignored `host_vars/box/settings.yml`, which overrides them. Secrets are in one **git-ignored** file ([0016](decisions/0016-secrets-file-outside-git.md)).
- `mise run setup`, on each control machine, asks where the box is and creates the secrets. It's safe to re-run.
- `deploy` and `check` ask for your **sudo password** on the box.

## 3. Boot → TV screen

- **Autologin** ([0011](decisions/0011-systemd-autologin.md)): the first console logs the box user in and starts labwc. If labwc exits, it comes back by itself.
- **Background** ([0004](decisions/0004-background-image.md)): a still image with a "press ⊞ to open apps" hint.
- **Always on** ([0005](decisions/0005-always-on-no-suspend.md)): no suspend, and a closed lid is ignored. The screen turns off after `idle_minutes` without activity, never while video plays.
- **The browser is closed** after `close_browser_minutes` without activity, to free memory: forgotten app windows don't pile up. A playing video counts as activity.
- **Screens** ([0018](decisions/0018-screens-kanshi.md)): the TV only, at its own preferred mode, or at `tv_mode` and `tv_scale` when set. This is applied again whenever the TV reconnects. A laptop's own screen is off while the TV is connected. On a desktop PC, its single screen is the TV.

## 4. The TV experience

### Browser ([0002](decisions/0002-brave-origin-browser.md))
- Brave Origin, configured by **managed policies**: no sign-in, sync or promotions, nothing left running in the background. Ad blocking is on.
- **Dark mode** everywhere: the browser, and websites that have a dark theme.
- **Hardware video decoding** on Intel and AMD GPUs ([0008](decisions/0008-fedora.md)).
- A site opens either as its own fullscreen app window, or as a normal window with tabs.

### App menu ([0003](decisions/0003-super-key-menu.md), [0009](decisions/0009-labwc-custom-menu.md))
- **Pressing and releasing Super** opens the menu, on top of anything, even fullscreen video. Super+key combos still work.
- **Entries:** the `apps` list in `settings.yml`. Each one is a website (an app window, or a normal window with `tabs: true`) or a `command`. An entry with `service:` only shows when that service is listed.
- **Opening an entry** that is already open focuses it instead of opening a duplicate.
- **Typed text** that matches no entry opens as a website, or as a search (`search_url`).
- **Other keys:** `Super+Q` closes the current app, `Alt+Tab` switches between open apps. The keyboard's media keys control the volume, with an on-screen indicator.

## 5. Background services ([0007](decisions/0007-podman-quadlets.md))

- **Optional:** only the services listed in `services` are deployed, and Podman only when at least one is.
- **One role per service, all with the same shape:** a container run by the box user, its data folder, its firewall port, its own nightly backup, an alert on failure, and a `README.md` with its one-time steps. Adding a service = copying an existing service role, adapting it, and adding a line to `site.yml`.
- The containers run even without a login session.
- Each service keeps its data in `/srv/sofabox/<service>/`, owned by the box user, with its backups in `backups/` inside it. That folder is all that needs backing up.

## 6. Updates ([0013](decisions/0013-automatic-updates.md))

- **All updates**, every night at `updates_time`. The box reboots only when needed. A failure sends an alert.
- **Containers:** their pinned versions are updated by hand, in their role.
- **Major Fedora upgrade:** once a year, by hand, with Fedora's own upgrade procedure, then `mise run deploy`. Each release is supported for about a year: after that, the box gets no more security updates.
- **No snapshots** ([0014](decisions/0014-no-snapshots.md)): a broken system is reinstalled and redeployed, and the data comes back from backups.

## 7. Backups & alerts ([0006](decisions/0006-backups.md), [0012](decisions/0012-ntfy-alerts.md))

- **Each service role backs itself up**, every night at `backups_time` (apart from the updates), in the service's own format.
- **On the box's own disk**, in `/srv/sofabox/<service>/backups/`: this protects against mistakes, not a dead disk. Copying them elsewhere is up to you; `mise run fetch-backups` copies them to the control machine.
- **Alerts:** push notifications to a phone (ntfy, private topic, through the public ntfy.sh server) when a service, a backup or the updates fail, or a disk is almost full. A daily check in the daytime also reports any unit still failed, in case its alert couldn't get out.

## 8. Hardware & system settings

- **Battery:** a laptop stops charging at `battery_charge_limit`, since it's always plugged in.
- **Sound** goes to the TV over HDMI. When the TV is idle or on another input, it stops offering sound, so the box falls back to its own output until the TV wakes. Some PCs may name their HDMI output differently (known limit).
- **Keyboards:** every keyboard uses the layout chosen at the Fedora install. A laptop whose own keyboard has another layout types wrong characters (known limit).
- **Firewall:** only SSH and the services' ports are open. The box isn't reachable from the internet anyway: it sits behind your router.
- **SSH:** key only, no root login.

## 9. Installation

The manual steps are in [`install.md`](install.md). After that, everything is `mise run deploy`. To find a problem faster, a role can be applied alone with its tag (`mise run deploy -- --tags desktop`).

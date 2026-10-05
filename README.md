# Sofabox

Turn an old PC into a living-room media box. It works like an Android TV, built on open-source software: the only closed parts are what streaming sites require (DRM) and some hardware drivers.

- Boots straight to the TV, with no login.
- **Press Super (⊞)** to open the app menu: streaming sites, any website, a terminal. The list is yours to edit.
- Optional self-hosted services run in the background, each with its own nightly backup.
- Updates itself at night, and sends an alert to your phone when something fails.
- Fedora + labwc + Brave Origin + Podman, all configured by Ansible from this repo, in one command.

## What you need

- **The box:** any x86_64 PC, laptop or desktop, with an **Intel or AMD** GPU (NVIDIA isn't a focus of the project) and an HDMI cable to the TV. A wireless keyboard with a touchpad is the remote.
- **Another Linux PC** to deploy from, with [mise](https://mise.jdx.dev). Everything else is installed by mise, for this project only.

The stack is fixed on purpose: one distro, one desktop, one browser. Only the settings change from one box to the next ([decision 0019](docs/decisions/0019-generic-project-sofabox.md)).

## Make it yours

Clone this repo, or fork it if you want to change the code. `ansible/group_vars/all/settings.yml` holds the defaults: the menu apps, the services, the TV picture, timings. Put the ones you change in `ansible/host_vars/box/settings.yml`, which `mise run setup` creates and git ignores: only the settings you change go there.

## Usage

Start with [`docs/install.md`](docs/install.md): a fresh Fedora, then:

```sh
mise install                      # install the project's tools (Ansible, linters…)
mise run setup                    # where the box is, secrets (safe to re-run)
mise tasks                        # list the commands
mise run ping                     # is the box reachable?
mise run check                    # dry run: what would change
mise run deploy                   # apply (add `-- --tags menu` to apply one role only)
mise run fetch-backups            # copy the services' backups to this machine
mise run lint                     # check the code before committing
```

## Where things are

| I want to… | Look at |
|---|---|
| Install the box from scratch | [`docs/install.md`](docs/install.md) |
| Add a website to the menu, turn a service on or off | `ansible/host_vars/box/settings.yml` (defaults: `ansible/group_vars/all/settings.yml`) |
| Understand how it works | [`docs/design.md`](docs/design.md) |
| Know why something is done that way | [`docs/decisions/`](docs/decisions/) |
| See what's left to do | [`ROADMAP.md`](ROADMAP.md) |
| Change how a part works | `ansible/roles/<part>/` |
| Contribute: goals, code conventions | [`AGENTS.md`](AGENTS.md) (also read by AI coding agents) |

## Licence

[MIT](LICENSE).

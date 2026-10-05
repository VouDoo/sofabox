# Sofabox — Living-room media box

Turns an old PC into a living-room media box, with a fixed stack (decision 0019).

This file is the **stable context** for anyone working on the repo, people and AI coding agents alike.
- **What it is, what it needs:** `README.md`
- **What to do next:** `ROADMAP.md`
- **How it works:** `docs/design.md`
- **Why it's done that way:** `docs/decisions/`

## Goals

1. **Couch-first UX** – everything usable from a keyboard with a touchpad, at TV distance.
2. **Appliance behaviour** – power on → ready, with no login prompt and no maintenance chores.
3. **Background services** – optional, listed in `services`, one role each. Local network only.
4. **Reproducible** – the box is rebuilt from this repo with one command.
5. **Open source, nothing paid** – Linux only (never Windows). Everything is open source except what streaming sites require (DRM) and hardware drivers with no open alternative. No paid tiers, and the box depends on no proprietary hosted services.
6. **Simple** – anyone should be able to read the repo and understand how the box works.
7. **Light** – the box is an old PC. Nothing runs that isn't needed: no heavy tools, no background work that makes the CPU spike for nothing. Heavy scheduled jobs (backups, updates) run at night. Light checks that may alert run in the daytime, so a notification doesn't wake anyone.
8. **Generic** – nothing in the roles is specific to one machine. What differs between boxes is either handled the same way everywhere or is a setting.

## Repository structure

Standard Ansible layout under `ansible/` (one role per concern, listed in order in `site.yml`), plus what `ls` can't tell:
- `ansible/host_vars/box/` holds everything private to the box, **git-ignored** and created by `mise run setup`: `connection.yml` (box address + user), `settings.yml` (the box's own settings) and `secrets.yml`. `ansible/secrets.example.yml` lists the expected secret keys.
- Inside a role, only create the folders it actually uses.
- Service roles declare `podman` in their `meta/main.yml` and are listed in `site.yml` with `when: "'<name>' in services"`.

## Code conventions

- **Each role has a tag of its own name** in `site.yml`, so it can be applied alone (`mise run deploy -- --tags menu`).
- **Every service and timer alerts on failure**: `OnFailure=sofabox-alert@%n.service` in its unit.
- **One role = one concern.** Service roles all follow the same pattern: their data in `/srv/sofabox/<service>/`, owned by the box user, **their own backup** in `backups/` inside it, and a `README.md` with the service's one-time steps (where its backups are, what to do after the first deploy). A secret it needs is one `# ask:` line in `ansible/secrets.example.yml`, which `mise run setup` asks for. Adding a service means copying one and adapting it.
- **Config files are real files** in `files/` or `templates/`, named like their target (`rc.xml`, `<service>.container`). Never inline file contents inside YAML tasks.
- **Every task has a plain-English name** that says what it does ("Install Brave Origin", not "dnf").
- **Variables:**
  - Settings a person might change: their working default in `ansible/group_vars/all/settings.yml`. A box's own values go in the git-ignored `ansible/host_vars/box/settings.yml`, never in the repo.
  - Internal values go in the role's `defaults/main.yml`, prefixed with the role name (`<role>_version`).
  - Never use magic values buried in tasks.
- **Scripts:** bash with `set -euo pipefail`, a header comment saying what the script is for, and shellcheck-clean. If a script grows past ~100 lines, stop and rethink.
- **No placeholders to edit by hand** (`CHANGE-ME`…). Per-machine values come from `mise run setup`, and settings have working defaults.
- **No dead code.** Don't comment code out; delete it, since git keeps the history.
- **Container images are pinned**: to a major version tag when the project publishes one (e.g. `:v2`), otherwise to an exact version updated by hand.
- **`mise run lint` must pass** before a commit.
- **Project tools are listed in `mise.toml`** (decision 0017). Nothing is installed system-wide for this project.
- **Shell scripts end in `.sh`**, so `mise run lint` finds them.
- **Small commits**, one logical change each. Message format `<area>: <what changed>` (e.g. `menu: bigger font`).
- **Docs state concepts, not generic how-tos.** Say what must be true and which choices matter. Only spell out commands specific to this project (`mise run …`).
- **Decisions and the design doc state rules and patterns.** Details specific to one part (a service's quirks, a tool's flags, file paths) go in comments next to its code, so the docs don't grow with every service.
- **No measured figures in docs or comments** (memory, sizes, power): they go stale. Say what stays true ("no CPU once shown", "disk only, no RAM").
- **Docs move with code.** Update `ROADMAP.md`, `docs/design.md` or a decision in the same commit as the change.

## Rules for agents

- **Keep it light.** Before adding any package, daemon or timer, check what it costs (RAM, CPU, wake-ups) and prefer the lightest option. Ask before adding anything heavy.
- **Keep it generic** (decision 0019). Never put machine-specific values in roles (models, device names, keyboard layouts), and never make a setting of what the Fedora installer already asks. Prefer the same handling on every PC over detection logic.
- **Keep it simple.** Prefer built-in or default tools and fewer moving parts. **Before doing anything complex, stop and ask for confirmation**, and offer the simpler alternative.
- **On the box:** read-only checks through Ansible (`mise exec -- ansible box -m ansible.builtin.shell -a '…'`, no sudo) are allowed. **Ask before anything that changes it**, before anything destructive, and before a reboot. Deploys are run by the user (they need the sudo password).
- `ROADMAP.md` is the source of truth for what to do. It lists open work only: remove an item once it's done (git keeps the history), and add new ones as work happens. A fact worth keeping goes in `docs/design.md` or a decision.
- Record any non-trivial choice in `docs/decisions/NNNN-title.md` (context, decision, rejected options, consequences).
- Everything that ends up on the box goes through this repo. Never hand-edit the box.
- Secrets never go in git (decision 0016).

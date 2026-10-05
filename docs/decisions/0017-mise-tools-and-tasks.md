# 0017 – mise for project tools and tasks

- **Status:** accepted
- **Context:** The repo needs a few tools (Ansible, linters) and a few commands, only for this project: nothing installed system-wide.
- **Decision:** **mise**, one `mise.toml` for both:
  - **Tools**, installed per project. Versions are `latest`, except Ansible, pinned to its major version because a new major can remove modules.
  - **Tasks:** every command is a `mise run …` task. `mise tasks` lists them.
- **Rejected:**
  - A separate task runner: one more tool for what mise already does.
  - A language-specific tool manager: no tasks.
  - Reproducible environments or dev containers: too heavy for a handful of tools.
  - System packages: installed globally, with versions differing between machines.

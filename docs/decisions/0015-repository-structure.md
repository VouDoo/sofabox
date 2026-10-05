# 0015 – Repository structure and code conventions

- **Status:** accepted
- **Context:** The repo must stay clean and understandable after many commits.
- **Decision:**
  - A single `ansible/` tree with **one role per concern** and a standard role layout.
  - The default settings live in one versioned file, each box's own choices in one git-ignored file, and the secrets in another ([0016](0016-secrets-file-outside-git.md)).
  - Every command is a mise task ([0017](0017-mise-tools-and-tasks.md)).
  - The code conventions are written in `AGENTS.md`, which AI coding agents read too.
- **Rejected:** grouping config files by kind in top-level folders, outside the roles. It would mean two places to look for the same thing.

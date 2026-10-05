# 0006 – Backups: each service backs itself up; the off-box copy is up to the user

- **Status:** accepted. Changed: the off-box copy, first planned for later, is left to the user.
- **Context:** Only the service knows how to back itself up safely, and its own backup format is the one its restore understands.
- **Decision:**
  - **Each service role includes its own backup:** a nightly timer, apart from the updates, makes the service's own backup and keeps the newest ones in `/srv/sofabox/<service>/backups/`.
  - A credential the backup needs is asked by `mise run setup` and kept with the secrets.
  - **Copying the backups off the box is up to the user**, with any tool, from that one path. `mise run fetch-backups` copies them to the control machine over SSH.
- **Rejected:**
  - A shared backup tool on the box: one more tool, and copying a running service's files isn't a safe backup.
  - Sending the backups somewhere from the box: every user's destination is different (another PC, a NAS, a drive, a cloud), each with its own credentials.
- **Consequences:** the backups on the box's own disk protect against mistakes and bad updates, not a dead disk. Only a copy elsewhere does.

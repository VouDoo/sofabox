# 0016 – Secrets in a git-ignored file

- **Status:** accepted. Changed: the file sits in `host_vars/box/`, with the box's other private files.
- **Context:** A few values must stay secret (the alert topic, tokens for the services). The simplest option wins (goal 6).
- **Decision:**
  - The secrets live in one plain file, **git-ignored**, so it's never committed or pushed.
  - A committed example file lists the expected keys with fake values.
  - `mise run setup` creates the secrets file: it generates what it can and asks for the rest.
  - The file exists only on the control machine that created it: deploying from another machine needs a copy of it.
- **Rejected:** an encrypted file in git. It needs an extra password to unlock and is harder to understand.

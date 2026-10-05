# 0001 – Provision the box with Ansible

- **Status:** accepted
- **Context:** The box must be rebuildable from this repo with one command, from any machine.
- **Decision:** An Ansible playbook pushed over SSH. Secrets go in a git-ignored file ([0016](0016-secrets-file-outside-git.md)).
- **Rejected:**
  - A shell script: fragile when re-run.
  - A declarative OS (NixOS): steep learning curve, and it replaces the whole tool chain.
- **Consequences:** What Ansible can't do is listed in the install guide. The box's address is given once to `mise run setup`, never hard-coded.

# 0014 – No system snapshots

- **Status:** accepted
- **Context:** Fedora is a stable fixed release. The box must stay light (goal 7).
- **Decision:** No snapshot tooling. The filesystem stays Fedora's default.
- **Consequences:** if an update breaks the box, it gets reinstalled and redeployed from git, and the data comes back from backups.

# 0013 – Automatic nightly updates (all packages)

- **Status:** accepted
- **Decision:** All available updates are applied every night. The box reboots only when an update requires it. A failure sends an alert ([0012](0012-ntfy-alerts.md)).
- **Rejected:** security-only updates. Only Fedora's own repository publishes security advisories, so the third-party repositories (the browser, the video codecs) would never be updated.
- **Accepted risk:** a buggy update can break something. The box can then be redeployed or reinstalled from git, with its data from backups ([0014](0014-no-snapshots.md)).
- **Not automatic:** the yearly major Fedora upgrade, run on purpose.

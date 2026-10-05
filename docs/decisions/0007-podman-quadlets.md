# 0007 – Rootless Podman + Quadlets for services

- **Status:** accepted
- **Decision:**
  - Each service is a container described as a systemd unit (Quadlet), run by the box user. No daemon, no compose files.
  - Images are pinned to a major-version tag when the project publishes one, so automatic updates only bring non-breaking changes. Otherwise to an exact version, updated by hand, which is safer for a database anyway. Automatic image updates are set up once a service's image has such a tag.
- **Rejected:** a container daemon with compose files. It would work, but fits an appliance less well.

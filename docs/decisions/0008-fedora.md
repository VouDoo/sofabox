# 0008 – Fedora as the distribution

- **Status:** accepted
- **Context:** A rolling release isn't needed and adds maintenance. A bare distro keeps the box light (goal 7).
- **Decision:**
  - The latest **Fedora** release, from a minimal install, so the box has nothing but what Ansible adds.
  - **RPM Fusion** (community repositories, free and nonfree) for the video codecs and hardware decoding that stock Fedora leaves out for patent reasons.
  - SELinux stays **enforcing**.
- **Rejected:**
  - **Rolling releases** (Arch and its derivatives): manual updates and more breakage.
  - **Slow stable releases** (Debian): too old for a recent Wayland desktop.
  - **Image-based systems** (Fedora Atomic and its derivatives): awkward to configure with Ansible.
- **Consequences:** one major Fedora upgrade per year, run on purpose.

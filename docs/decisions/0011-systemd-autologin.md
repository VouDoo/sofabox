# 0011 – Autologin on the console

- **Status:** accepted
- **Decision:** The first console logs the box user in automatically, and that login starts labwc.
- **Rejected:** a login manager. It's cleaner at boot, but an extra package for the same result on a single-user box.
- **Consequences:**
  - A short text console may flash at boot.
  - If labwc exits, the console logs in again and labwc starts again.

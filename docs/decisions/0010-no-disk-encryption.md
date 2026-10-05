# 0010 – No disk encryption

- **Status:** accepted
- **Decision:** No disk encryption: the simplest unattended boot.
- **Accepted risk:** if the box or its disk is stolen, browser sessions, the services' data and their keys are readable.
- **Revisit if:** the box starts holding more sensitive data. Unlocking with the TPM at boot is the path, and needs a reinstall.

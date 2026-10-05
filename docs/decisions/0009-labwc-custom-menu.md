# 0009 – labwc + custom menu as the TV interface

- **Status:** accepted
- **Decision:** **labwc**, a light stacking Wayland compositor, with the custom Super-key menu ([0003](0003-super-key-menu.md)).
  - Apps run as undecorated, fullscreen windows.
  - The menu finds an app that is already open through the compositor's window list.
- **Rejected:**
  - A dedicated TV shell (Plasma Bigscreen): heavier, brand new, and less control.
  - A tiling compositor: no need for tiling.
  - A single-app kiosk compositor: no menu on top of the app.

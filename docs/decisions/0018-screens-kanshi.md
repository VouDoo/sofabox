# 0018 – Screens: the TV only, 1080p at 60 Hz by default, via kanshi

- **Status:** accepted. Changed: 1080p at 60 Hz is the default mode; an empty setting means the TV's own mode.
- **Context:**
  - A laptop's own screen stays on behind the closed lid, and windows open there.
  - The TV's preferred mode isn't always one the PC drives well: many older PCs drive 4K over HDMI only at 30 Hz (tiny text, choppy video).
- **Decision:** **kanshi** applies a screen profile, and applies it again whenever a screen connects (TV switched off and on):
  - TV connected: the TV only, at the mode from the settings: 1080p at 60 Hz by default, which practically every TV and PC handle. An empty mode means the TV's own preferred one. A scale can be set too.
  - Laptop without a TV: its own screen, so the box stays usable.
  - Desktop PC: its single screen is the TV.
- **Rejected:**
  - Picking the best mode the PC drives smoothly: it would need hardware detection ([0019](0019-generic-project-sofabox.md)).
  - Setting the screens once at startup: lost as soon as the TV reconnects.

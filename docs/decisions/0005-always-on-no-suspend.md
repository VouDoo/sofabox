# 0005 – Always on, screen off when idle (no suspend)

- **Status:** accepted
- **Context:** A wireless keyboard's USB receiver keeps waking the PC from sleep. Disabling USB wakeup would leave only the power button to wake it.
- **Decision:** Never suspend. The screen turns off when idle, but not while video plays. A laptop's battery charge is capped, since it's always plugged in.
- **Consequences:** the services stay reachable all the time, and the PC stays powered on.

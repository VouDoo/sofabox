# mealie

Mealie, the recipe manager, at `http://<box>:9000`. Listed in `services` to be deployed.

Its menu entry uses `127.0.0.1`, not `localhost`: `localhost` can resolve to IPv6, which Mealie doesn't serve.

## Before wiping a box

Copy the latest backup off the box (`mise run fetch-backups`), from `/srv/sofabox/mealie/backups/`.

## After the first deploy

- Restore your recipes (Mealie → Admin → Backups), then **restart Mealie** (`systemctl --user restart mealie` on the box). Until then, every login bounces back to the login page.
- **Nightly backups:** create an API token in Mealie (Profile → API Tokens), give it to `mise run setup`, then `mise run deploy -- --tags mealie`.

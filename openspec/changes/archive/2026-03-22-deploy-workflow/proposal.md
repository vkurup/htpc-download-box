## Why

Changes to the stack are currently made by SSHing into cartman and editing files directly, with no repeatable way to apply updates from a development machine. A lightweight deploy workflow lets the developer push changes from a laptop and apply them on the server with a single command.

## What Changes

- Add a `Makefile` with a `deploy` target that SSHes into cartman, pulls the latest git changes, and restarts affected containers
- Add a `deploy.sh` script (invoked by `make deploy`) with the server-side commands
- Document the workflow in README.md

## Capabilities

### New Capabilities
- `deploy`: SSH-based deploy from laptop — pulls latest git changes on cartman and runs `docker compose up -d`

### Modified Capabilities

## Impact

- Adds `Makefile` and `deploy.sh` to the repo root
- No changes to `compose.yml` or any container configuration
- Requires SSH access from laptop to cartman (key-based auth assumed)
- Server-side: repo must be cloned at a known path on cartman

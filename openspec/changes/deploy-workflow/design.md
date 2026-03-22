## Context

The stack runs on a single server (cartman, 192.168.1.20). Changes are currently made by SSHing in and editing files directly. The repo is already cloned on cartman. SSH key-based auth is assumed to be configured between the laptop and cartman.

## Goals / Non-Goals

**Goals:**
- Single command (`make deploy`) to push and apply changes from the laptop
- No new runtime dependencies on the server
- Works with the existing git + docker compose setup

**Non-Goals:**
- CI/CD automation or GitHub Actions
- Rolling deployments or zero-downtime restarts
- Multi-server support
- Secrets management (`.env` is managed manually on the server)

## Decisions

**Makefile over a bare shell script**
A `Makefile` provides a discoverable, conventional interface (`make deploy`, `make help`). The actual SSH logic lives in `bin/deploy.sh` so it can also be run directly if needed. Scripts live in `bin/` to keep the repo root clean and allow future scripts to live alongside it. Alternative: a single script at root — rejected because a Makefile is easier to extend with future targets (e.g., `make logs`, `make status`).

**Pull-on-server model over rsync/scp**
The server pulls from git rather than the laptop pushing files directly. This keeps git as the source of truth and avoids file sync edge cases. Requires changes to be pushed to the remote before deploying.

**Hardcoded server target in Makefile**
`cartman` (via SSH hostname) is hardcoded as the deploy target. This is a single-server personal setup — parameterization adds complexity with no benefit.

## Risks / Trade-offs

- [`.env` not managed by deploy] The `.env` file on cartman must be maintained manually. → Document this clearly; the deploy script will not touch `.env`.
- [Unpushed changes] Running `make deploy` before `git push` will deploy stale code. → The deploy script should print the commit being deployed so the user can verify.
- [Containers restart on deploy] `docker compose up -d` will restart containers whose config changed. → Acceptable for a home server; document expected behavior.

## Migration Plan

1. Add `Makefile` and `bin/deploy.sh` to the repo
2. Push to remote
3. Verify SSH alias `cartman` resolves (or update `bin/deploy.sh` with the correct hostname/IP)
4. Run `make deploy` from laptop to test end-to-end

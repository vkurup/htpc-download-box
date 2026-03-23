# Roadmap

Personal home server stack based on a fork of [htpc-download-box](https://github.com/sebgl/htpc-download-box). Running on `cartman` (192.168.1.20).

---

## WS1: Repo Hygiene ← in progress

Clean up the repo so it reflects what's actually running, not upstream docs.

- [ ] Remove or replace upstream README (references Jackett, NZBGet, Plex — none of which are in use)
- [ ] Delete Vagrantfile (not used)
- [ ] Stage the `docker-compose.yml → compose.yml` rename
- [ ] Restore `.env.example` with placeholder values (was deleted; documents required vars)
- [ ] Decide: commit `.claude/` and `openspec/` or gitignore them
- [ ] Verify `.gitignore` covers all secrets (`.env` is already there)
- [ ] Write a short README that describes the actual stack

---

## WS2: Deploy Workflow (laptop → cartman)

Make it easy to push changes from the laptop and apply them on the server.

**Goal:** `git push` from laptop, then a single command applies it on cartman.

Options to decide between:
- **Manual**: `ssh cartman`, `cd ~/dev/htpc-download-box`, `git pull`, `docker compose up -d`
- **Makefile target**: `make deploy` runs the above over SSH from laptop
- **Server-side git hook**: push triggers an automatic pull + restart on cartman

Suggested tasks:
- [ ] Add `Makefile` with `deploy` target (SSH + pull + compose up)
- [ ] Document the server path where the repo lives on cartman
- [ ] Document how Docker starts on boot (systemd `docker.service` + `restart: unless-stopped`)

---

## WS3: Books ✓ (partially complete)

**Calibre-Web** is running at `cartman:8083` serving the existing Calibre library from `$MEDIA_ROOT/media/books/library`. OPDS confirmed working at `/opds`.

**Readarr removed** — official project retired June 2025, community fork had SQLite permission issues. Book acquisition is manual for now (upload via Calibre-Web UI).

**Remaining TODOs:**
- Configure Send-to-Kindle email (`Admin → Email settings` in Calibre-Web)
- Verify OPDS with a reader app
- If automated book downloading becomes a priority, evaluate alternatives (e.g. LazyLibrarian)
- Metadata on upload: Google Books requires API key, Goodreads API is shut down. Evaluate alternatives (e.g. enable Calibre binaries + `fetch-ebook-metadata`, or a self-hosted metadata proxy)

---

## WS4: Access & Service Portal

Make services accessible with friendly hostnames, internally and over Tailscale.

**Current state:** raw IPs + ports (`192.168.1.20:8096`)

**Goal:** friendly names + a portal page with links to all services

**Suggested approach:**
- **Nginx Proxy Manager** (NPM) — GUI-based reverse proxy, easy to manage
  - Maps `jellyfin.cartman` → `localhost:8096`, etc.
  - Works the same over Tailscale (Tailscale IP resolves to same NPM)
- **Homepage** or **Homarr** — dashboard/portal with service tiles and status indicators
  - Integrates with Sonarr/Radarr/Jellyfin APIs to show live status
- **Local DNS** — point `*.cartman` at `192.168.1.20` on your router, or use Pi-hole/AdGuard

**Tailscale specifics:**
- Tailscale is already on cartman — services are reachable on Tailscale IP at same ports today
- Adding NPM means only one port needs to be exposed through Tailscale (443)
- Optional: Tailscale Funnel for external access without being on the VPN

**Suggested tasks:**
- [ ] Add Nginx Proxy Manager to compose.yml
- [ ] Add Homepage or Homarr to compose.yml
- [ ] Configure local DNS (router or Pi-hole) for `*.cartman` → `192.168.1.20`
- [ ] Configure Tailscale MagicDNS or split DNS for same hostnames over Tailscale

---

## WS5: Backup

Service configs live in `$CONFIG_ROOT` (`/mnt/storage/config`) on cartman. If the server dies without a backup, all UI configuration (indexers, download clients, quality profiles, users, etc.) is lost. Media in `$MEDIA_ROOT` has the same risk.

**Strategy: periodic offsite backup of `$CONFIG_ROOT`**

Config is small (MBs) and changes infrequently — easy to back up. Media is large and replaceable (re-downloadable), so backing it up is optional.

**Options:**
- **rclone to cloud** (Backblaze B2, S3, Google Drive) — good for offsite, cheap for small config dirs
- **rsync to NAS or another machine** — good if you have local storage elsewhere
- **`make backup` target** — rsync `$CONFIG_ROOT` from cartman to laptop on demand

**Suggested tasks:**
- [x] Determine where `/mnt/storage` lives on cartman — local ZFS pool
  - ZFS snapshots are available as a free first line of defense (protect against accidental deletion/corruption)
  - Still need offsite backup for hardware failure/theft
- [ ] Decide on backup destination (cloud vs. local)
- [ ] Add `bin/backup.sh` + `make backup` target (mirrors `$CONFIG_ROOT` off cartman)
- [ ] Schedule backup via cron on cartman or as a periodic manual step

---

## WS6: Claude Code Sandbox

Run Claude Code in an isolated environment so it can't affect the host system outside of intended boundaries (filesystem, network, process access). Useful for running Claude on cartman directly or from the laptop with controlled blast radius.

**Open questions:**
- What should be sandboxed? (filesystem writes, network access, shell commands, all of the above)
- Should the sandbox run on cartman, the laptop, or both?
- Acceptable performance/complexity tradeoff?

**Options to evaluate:**
- **Docker container** — easy to set up, good filesystem/network isolation, Claude Code runs inside
- **VM** (e.g. lima, multipass, UTM) — stronger isolation, more overhead
- **bubblewrap / firejail** — lightweight Linux sandboxing, no VM overhead, Linux-only
- **Claude Code's built-in permission system** — already provides some guardrails (tool approval, path restrictions)

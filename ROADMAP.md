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

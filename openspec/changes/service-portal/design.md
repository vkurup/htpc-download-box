## Context

All services currently use `network_mode: host` and are accessed directly by IP:port. Traefik needs to communicate with containers to proxy traffic. Since services use host networking, Traefik can reach them via `localhost:<port>` — no Docker network changes required.

TLS is handled via Let's Encrypt DNS challenge against Cloudflare, so no inbound ports need to be opened to the internet. Certs are stored on disk and reused across restarts.

## Goals / Non-Goals

**Goals:**
- `*.home.kurup.net` routes to the correct service with valid TLS
- Homepage at `home.kurup.net` links to all services with live status
- Works on LAN (via Ubiquiti DNS override) and over Tailscale (via Cloudflare DNS)
- No internet exposure required beyond DNS challenge

**Non-Goals:**
- Removing direct port access (ports stay open)
- Authentication/SSO in front of services (each service manages its own auth)
- External internet access (Tailscale is the external access path)

## Decisions

**Traefik with Docker provider + host networking**
Since all services use `network_mode: host`, they're not on a Docker network Traefik can discover via container inspection. Instead, Traefik uses file-based routing (`file` provider) with static config pointing at `localhost:<port>` for each service. Alternative: move services to a shared Docker network — rejected because it would require reworking all existing services.

**Let's Encrypt DNS challenge via Cloudflare**
DNS challenge works without opening port 80/443 to the internet — Traefik proves domain ownership by creating a TXT record in Cloudflare. Requires a `CF_DNS_API_TOKEN` with `Zone:DNS:Edit` permission scoped to `kurup.net`. Alternative: HTTP challenge — rejected because it requires port 80 to be publicly reachable.

**Cert storage in `$CONFIG_ROOT/traefik/`**
Certs are written to `acme.json` on disk, mounted into the Traefik container. This persists certs across container restarts and avoids hitting Let's Encrypt rate limits.

**Homepage config as checked-in YAML**
Homepage reads config from `/config` (mounted from `$CONFIG_ROOT/homepage/`). Config files (`services.yaml`, `widgets.yaml`, `settings.yaml`) are written to the repo and deployed via `make deploy`. This keeps service config version-controlled.

**Split DNS: Ubiquiti for LAN, Cloudflare for Tailscale**
- LAN clients: Ubiquiti router has a wildcard DNS entry `*.home.kurup.net` → `192.168.1.20`
- Tailscale clients: Cloudflare DNS has `*.home.kurup.net` CNAME or A record → cartman's Tailscale IP
- This avoids hairpin NAT issues and keeps LAN traffic local

## Risks / Trade-offs

- [Host networking + Traefik file provider] Traefik can't auto-discover services via Docker labels when services use host networking. Each service needs a manual entry in Traefik's dynamic config. → Accepted; new services just need a file config entry added.
- [Cert rate limits] Let's Encrypt has rate limits (5 certs/week per domain). Use staging certs during setup, switch to production once confirmed working.
- [Traefik as single point of failure] If Traefik crashes, `*.home.kurup.net` stops working. Direct IP:port access remains as fallback.
- [CF_DNS_API_TOKEN in .env] Token is a secret; `.env` is already gitignored. Token should be scoped minimally (DNS Edit on `kurup.net` only).

## Open Questions

- What Tailscale hostname/IP does cartman have? Needed for the Cloudflare DNS record.

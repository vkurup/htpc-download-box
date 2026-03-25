## Why

All services are currently accessed via raw IPs and ports (`192.168.1.20:8096`), which is unfriendly for family members and requires knowing which port maps to which service. Adding a reverse proxy and dashboard gives the stack a proper front door with friendly hostnames, TLS, and a single page linking to everything.

## What Changes

- Add **Traefik** to `compose.yml` as a reverse proxy — routes `*.home.kurup.net` to the appropriate container, obtains TLS certs automatically via Let's Encrypt + Cloudflare DNS challenge
- Add **Homepage** to `compose.yml` as a service dashboard — shows all services as tiles with live status from *arr APIs
- Add Traefik routing labels to each existing service in `compose.yml`
- Add `CF_DNS_API_TOKEN` to `.env` / `.env.example` for Cloudflare DNS challenge
- Configure split DNS: Ubiquiti router for LAN (`*.home.kurup.net` → `192.168.1.20`), Cloudflare for Tailscale (`*.home.kurup.net` → Tailscale IP)
- Write Homepage config YAML for all services

## Capabilities

### New Capabilities
- `reverse-proxy`: Traefik routes hostnames to services with automatic TLS certs
- `service-dashboard`: Homepage provides a portal with service tiles and live *arr stats

### Modified Capabilities

## Impact

- `compose.yml` gains two new services (`traefik`, `homepage`) and Traefik labels on all existing services
- New env var: `CF_DNS_API_TOKEN` (Cloudflare API token scoped to `kurup.net` DNS)
- Direct port access (`192.168.1.20:PORT`) continues to work alongside proxy
- Services become accessible at `<service>.home.kurup.net` on LAN and over Tailscale
- Requires one-time DNS setup in Cloudflare and Ubiquiti router

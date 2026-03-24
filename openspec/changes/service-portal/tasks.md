## 1. Cloudflare & DNS Preparation

- [x] 1.1 Create a Cloudflare API token scoped to `kurup.net` with `Zone:DNS:Edit` permission
- [x] 1.2 Add `CF_DNS_API_TOKEN=` to `.env.example`
- [x] 1.3 Add `CF_DNS_API_TOKEN=<your-token>` to `.env` on cartman
- [x] 1.4 Get cartman's Tailscale IP (`tailscale ip -4` on cartman)
- [x] 1.5 Add wildcard DNS record in Cloudflare: `*.home.kurup.net` A → cartman's Tailscale IP
- [x] 1.6 Add wildcard DNS record in EdgeRouter: `address=/home.kurup.net/192.168.1.20` via dnsmasq

## 2. Traefik

- [x] 2.1 Add `traefik` service to `compose.yml` (ports 80/443, mounts Docker socket and `$CONFIG_ROOT/traefik`)
- [x] 2.2 Create `config/traefik/traefik.yml` — static config (entrypoints, Let's Encrypt ACME with Cloudflare provider, file provider pointing to dynamic config dir)
- [x] 2.3 Create `config/traefik/dynamic/services.yml` with routes for all services
- [x] 2.4 Create empty `$CONFIG_ROOT/traefik/acme.json` with `chmod 600`
- [x] 2.5 Deploy and verify Traefik starts cleanly (`docker logs traefik`)
- [x] 2.6 Confirm cert obtained for `*.home.kurup.net` (check `acme.json` or Traefik dashboard)

## 3. Homepage

- [x] 3.1 Add `homepage` service to `compose.yml` (network_mode: host, mounts `./config/homepage`, env_file for HOMEPAGE_VAR_*)
- [x] 3.2 Traefik route for `home.kurup.net` in `config/traefik/dynamic/services.yml`
- [x] 3.3 Create `config/homepage/settings.yaml`
- [x] 3.4 Create `config/homepage/services.yaml` with tiles for all services
- [x] 3.5 Create `config/homepage/widgets.yaml`
- [x] 3.6 Add API keys to `.env` on cartman (HOMEPAGE_VAR_* + CF_DNS_API_TOKEN)

## 4. Deploy & Verify

- [x] 4.1 Commit, push, and `make deploy`
- [x] 4.2 Verify `https://jellyfin.home.kurup.net` loads on LAN with valid cert
- [x] 4.3 Verify `https://home.kurup.net` loads and all service tiles are present
- [ ] 4.4 Verify `https://jellyfin.home.kurup.net` loads over Tailscale from another device
- [x] 4.5 Confirm direct port access `http://192.168.1.20:8096` still works

## 5. Documentation

- [x] 5.1 Update `README.md` with service hostnames (`*.home.kurup.net`)
- [x] 5.2 Note Cloudflare API token requirement in README

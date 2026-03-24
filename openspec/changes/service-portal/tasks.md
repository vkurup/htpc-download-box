## 1. Cloudflare & DNS Preparation

- [ ] 1.1 Create a Cloudflare API token scoped to `kurup.net` with `Zone:DNS:Edit` permission
- [ ] 1.2 Add `CF_DNS_API_TOKEN=` to `.env.example`
- [ ] 1.3 Add `CF_DNS_API_TOKEN=<your-token>` to `.env` on cartman
- [ ] 1.4 Get cartman's Tailscale IP (`tailscale ip -4` on cartman)
- [ ] 1.5 Add wildcard DNS record in Cloudflare: `*.home.kurup.net` A → cartman's Tailscale IP
- [ ] 1.6 Add wildcard DNS record in Ubiquiti router: `*.home.kurup.net` → `192.168.1.20`

## 2. Traefik

- [ ] 2.1 Add `traefik` service to `compose.yml` (ports 80/443, mounts Docker socket and `$CONFIG_ROOT/traefik`)
- [ ] 2.2 Create `$CONFIG_ROOT/traefik/traefik.yml` — static config (entrypoints, Let's Encrypt ACME with Cloudflare provider, file provider pointing to dynamic config dir)
- [ ] 2.3 Create `$CONFIG_ROOT/traefik/dynamic/` directory with a route file per service (each routes `<service>.home.kurup.net` → `http://localhost:<port>`)
- [ ] 2.4 Create empty `$CONFIG_ROOT/traefik/acme.json` with `chmod 600`
- [ ] 2.5 Deploy and verify Traefik starts cleanly (`docker logs traefik`)
- [ ] 2.6 Confirm cert obtained for `*.home.kurup.net` (check `acme.json` or Traefik dashboard)

## 3. Homepage

- [ ] 3.1 Add `homepage` service to `compose.yml` (port 3000, mounts `$CONFIG_ROOT/homepage`)
- [ ] 3.2 Add Traefik route for `home.kurup.net` → `http://localhost:3000`
- [ ] 3.3 Create `$CONFIG_ROOT/homepage/settings.yaml` (title, theme, etc.)
- [ ] 3.4 Create `$CONFIG_ROOT/homepage/services.yaml` with tiles for all services
- [ ] 3.5 Create `$CONFIG_ROOT/homepage/widgets.yaml` with *arr API widgets (Sonarr, Radarr, Prowlarr, Jellyfin)
- [ ] 3.6 Add API keys for *arr services to Homepage config (retrieve from each service's Settings → General)

## 4. Deploy & Verify

- [ ] 4.1 Commit, push, and `make deploy`
- [ ] 4.2 Verify `https://jellyfin.home.kurup.net` loads on LAN with valid cert
- [ ] 4.3 Verify `https://home.kurup.net` loads and all service tiles are present
- [ ] 4.4 Verify `https://jellyfin.home.kurup.net` loads over Tailscale from another device
- [ ] 4.5 Confirm direct port access `http://192.168.1.20:8096` still works

## 5. Documentation

- [ ] 5.1 Update `README.md` with service hostnames (`*.home.kurup.net`)
- [ ] 5.2 Note Cloudflare API token requirement in README

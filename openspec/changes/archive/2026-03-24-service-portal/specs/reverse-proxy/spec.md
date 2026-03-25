## ADDED Requirements

### Requirement: Services accessible via friendly hostnames with TLS
Each service in the stack SHALL be accessible at `<service>.home.kurup.net` with a valid TLS certificate.

#### Scenario: Access service via hostname on LAN
- **WHEN** a LAN client navigates to `https://jellyfin.home.kurup.net`
- **THEN** they reach Jellyfin with a valid TLS certificate and no browser warning

#### Scenario: Access service via hostname over Tailscale
- **WHEN** a Tailscale client navigates to `https://jellyfin.home.kurup.net`
- **THEN** they reach Jellyfin with a valid TLS certificate and no browser warning

### Requirement: TLS certificates obtained automatically
Traefik SHALL obtain and renew TLS certificates automatically via Let's Encrypt DNS challenge against Cloudflare, without requiring any inbound ports to be opened to the internet.

#### Scenario: Certificate obtained on first start
- **WHEN** Traefik starts with a valid `CF_DNS_API_TOKEN`
- **THEN** a wildcard cert for `*.home.kurup.net` is obtained and stored in `acme.json`

#### Scenario: Certificate renewed automatically
- **WHEN** a cert approaches expiry
- **THEN** Traefik renews it automatically without manual intervention

### Requirement: Direct port access remains functional
The existing direct IP:port access (e.g. `192.168.1.20:8096`) SHALL continue to work alongside the proxy.

#### Scenario: Direct access still works after Traefik is added
- **WHEN** a user navigates to `http://192.168.1.20:8096`
- **THEN** they reach Jellyfin as before

## ADDED Requirements

### Requirement: Homepage provides a portal with links to all services
Homepage SHALL be accessible at `https://home.kurup.net` and display tiles for all stack services with links to their friendly hostnames.

#### Scenario: Browse service portal
- **WHEN** a user navigates to `https://home.kurup.net`
- **THEN** they see tiles for all services (Jellyfin, Sonarr, Radarr, etc.) with working links

### Requirement: Homepage shows live stats from *arr services
Homepage SHALL display live status information from Sonarr, Radarr, Prowlarr, and other services that provide an API.

#### Scenario: Live stats visible on dashboard
- **WHEN** a user views the Homepage dashboard
- **THEN** they see current download queue, library counts, or other live data from *arr APIs

### Requirement: Homepage config is version-controlled
Homepage configuration (services, widgets, settings) SHALL be stored as YAML files in the repo and deployed via `make deploy`.

#### Scenario: Config survives container rebuild
- **WHEN** the homepage container is recreated
- **THEN** all service tiles and settings are restored from the mounted config files

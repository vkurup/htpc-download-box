## Requirements

### Requirement: Deploy from laptop with a single command
The system SHALL provide a `make deploy` command that pushes the current branch and applies changes on cartman.

#### Scenario: Successful deploy
- **WHEN** the developer runs `make deploy` from the laptop
- **THEN** the latest committed changes are pulled on cartman and `docker compose up -d` is run

#### Scenario: Deploy prints the deployed commit
- **WHEN** `make deploy` runs
- **THEN** the commit hash and message being deployed are printed so the developer can verify

### Requirement: Deploy script is directly executable
The system SHALL provide `bin/deploy.sh` as a standalone executable that performs the server-side deploy steps over SSH.

#### Scenario: Direct script execution
- **WHEN** the developer runs `bin/deploy.sh` directly
- **THEN** it behaves identically to the `make deploy` target

### Requirement: Deploy does not touch .env
The deploy process SHALL never create, modify, or delete the `.env` file on the server.

#### Scenario: .env preserved after deploy
- **WHEN** `make deploy` is run
- **THEN** the `.env` file on cartman is unchanged

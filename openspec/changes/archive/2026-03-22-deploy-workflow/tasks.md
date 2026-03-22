## 1. Scripts

- [x] 1.1 Create `bin/deploy.sh` — SSH into cartman, print current commit, `git pull`, `docker compose up -d`
- [x] 1.2 Add dirty working tree check to `bin/deploy.sh` — warn if there are uncommitted local changes on the server
- [x] 1.3 Make `bin/deploy.sh` executable (`chmod +x`)

## 2. Makefile

- [x] 2.1 Create `Makefile` with a `deploy` target that invokes `bin/deploy.sh`
- [x] 2.2 Add a `help` target listing available targets

## 3. Documentation

- [x] 3.1 Update `README.md` deploy section with `make deploy` instructions
- [x] 3.2 Note that `.env` must be maintained manually on cartman

## 4. Verify

- [x] 4.1 Confirm SSH alias `cartman` resolves on the laptop (or update `bin/deploy.sh` with correct host)
- [x] 4.2 Run `make deploy` end-to-end and confirm containers come up cleanly

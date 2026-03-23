## 1. Preparation

- [x] 1.1 On cartman, run `find /mnt -name "metadata.db" 2>/dev/null` to locate any existing Calibre library
- [x] 1.2 Decide on final library path — move existing library to `$MEDIA_ROOT/media/books/` if needed, or note the existing path for Calibre-Web config
- [x] 1.3 On cartman, move library: `mv "/home/vinod/Sync/Vinod/Calibre Library" $MEDIA_ROOT/media/books`

## 2. compose.yml — Add Services

- [x] 2.1 Add `readarr` service to `compose.yml` (linuxserver/readarr, port 8787, network_mode: host, mounts `$MEDIA_ROOT` as `/data` and `$CONFIG_ROOT/readarr` as `/config`)
- [x] 2.2 Add `calibre-web` service to `compose.yml` (linuxserver/calibre-web, port 8083, network_mode: host, mounts `$MEDIA_ROOT/media/books` as `/books` and `$CONFIG_ROOT/calibre-web` as `/config`)

## 3. Deploy & Initial Setup

- [x] 3.1 Commit, push, and `make deploy`
- [x] 3.2 Open Calibre-Web at `http://cartman:8083`, complete setup wizard, point library at `/books`
- [x] 3.3 Enable OPDS in Calibre-Web admin settings (enabled by default, confirmed at `/opds`)
- [ ] 3.4 Configure Send-to-Kindle email in Calibre-Web (`Admin → Email settings`) — skipped, see ROADMAP
- [x] 3.5 Open Readarr at `http://cartman:8787`, add Prowlarr via Prowlarr Apps (use 192.168.1.20:8787, not localhost)
- [x] 3.6 Add Deluge and/or SABnzbd as download clients in Readarr
- [x] 3.7 Set Readarr's root folder to `/data/media/books/` (chown nobody:nogroup required)

## 4. Documentation

- [x] 4.1 Update `README.md` stack table with Readarr (8787) and Calibre-Web (8083)
- [x] 4.2 Add note about locating an existing Calibre library (`find /mnt -name "metadata.db"`)

## 5. Verify

- [x] 5.1 Browse Calibre-Web library in browser and confirm books are visible
- [x] 5.2 Connect a reader app via OPDS at `http://cartman:8083/opds` and confirm browsing works (tested with Librera FD on Android)
- [x] 5.3 Readarr removed — manual upload via Calibre-Web confirmed working instead

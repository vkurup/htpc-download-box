## Why

The existing stack handles TV and movies automatically but has no support for ebooks. Adding ebook services lets the family browse and download books to any reader (Kindle, Kindle app, Kobo, etc.) from a single self-hosted library.

## What Changes

- Add **Readarr** to `compose.yml` — monitors and auto-downloads books via Prowlarr (same pattern as Sonarr/Radarr)
- Add **Calibre-Web** to `compose.yml` — web UI for the Calibre library with OPDS catalog and Send-to-Kindle email support
- Add `$MEDIA_ROOT/media/books/` to the expected directory layout (Calibre library root)
- Update `README.md` to document the new services and book directory layout

## Capabilities

### New Capabilities
- `book-library`: Calibre-Web serves the ebook library via browser UI and OPDS catalog for reader apps
- `book-acquisition`: Readarr monitors for new books and triggers downloads via Prowlarr/Deluge/SABnzbd

### Modified Capabilities

## Impact

- `compose.yml` gains two new services: `readarr` (port 8787) and `calibre-web` (port 8083)
- New volume mount: `$MEDIA_ROOT/media/books` for the Calibre library
- Readarr integrates with existing Prowlarr (indexers) and Deluge/SABnzbd (downloaders) — no new download infrastructure needed
- Calibre-Web requires an existing Calibre `metadata.db` at the library root, or one will be created on first run

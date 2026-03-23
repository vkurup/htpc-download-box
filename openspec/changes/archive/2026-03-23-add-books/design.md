## Context

The stack follows the linuxserver.io container pattern throughout. Sonarr/Radarr handle TV and movies via Prowlarr for indexing and Deluge/SABnzbd for downloading. The book services slot into this same pattern: Readarr integrates with Prowlarr (already configured) and the existing downloaders, while Calibre-Web serves the resulting library.

The user may have an existing Calibre library on cartman that needs to be located and pointed at.

## Goals / Non-Goals

**Goals:**
- Add Readarr and Calibre-Web as services following the existing compose conventions
- Support OPDS for Kindle app, Kobo, and other reader apps
- Support Send-to-Kindle via Calibre-Web's email feature
- Fit into the existing `$MEDIA_ROOT` directory layout

**Non-Goals:**
- Automated Calibre library migration
- Public internet exposure (handled separately in WS4)
- DRM removal tooling

## Decisions

**Calibre-Web over raw Calibre**
Calibre-Web (`linuxserver/calibre-web`) provides a browser UI and OPDS catalog without running a full desktop Calibre instance. It reads the same `metadata.db` that Calibre manages, so it's compatible with any existing Calibre library. Alternative: `linuxserver/calibre` (full desktop via VNC) — heavier, unnecessary for a serve-only use case.

**Readarr over manual book management**
Readarr (`linuxserver/readarr`) follows the exact same model as Sonarr/Radarr and integrates with the already-configured Prowlarr instance. Alternative: manual downloads only — rejected because automation is the point of the existing stack.

**Network mode: host (matching Sonarr/Radarr)**
Both services use `network_mode: host` to be consistent with the rest of the arr stack and avoid port mapping complexity. Calibre-Web on port 8083, Readarr on port 8787.

**Book library path: `$MEDIA_ROOT/media/books/`**
Follows the existing layout (`media/movies/`, `media/tv/`). Calibre-Web and Readarr both mount `$MEDIA_ROOT` as `/data`, same as Sonarr/Radarr.

## Risks / Trade-offs

- [Existing Calibre library location] If the user has an existing library not at `$MEDIA_ROOT/media/books/`, Calibre-Web will start with an empty library. → Document how to point Calibre-Web at an existing library path in the README. User should run `find /mnt -name "metadata.db"` on cartman to locate it.
- [Readarr cold start] Readarr needs to be configured post-deploy (Prowlarr indexers, download clients) — same one-time setup as Sonarr/Radarr. → Note in tasks.
- [OPDS authentication] Calibre-Web's OPDS endpoint requires a user account. → Documented in Calibre-Web setup; not a blocker.

## Open Questions

- Does the user's existing Calibre library (if any) live at a path that can be bind-mounted, or does it need to be moved to `$MEDIA_ROOT/media/books/`?

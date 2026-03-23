## Requirements

### Requirement: Readarr monitors and downloads books automatically
The system SHALL run Readarr as a Docker container that monitors for wanted books and triggers downloads via Prowlarr and the existing download clients (Deluge/SABnzbd).

#### Scenario: Wanted book is downloaded automatically
- **WHEN** a book is added to Readarr's monitored list
- **THEN** Readarr searches via Prowlarr and sends the best match to Deluge or SABnzbd for download

### Requirement: Readarr integrates with existing Prowlarr instance
Readarr SHALL use the existing Prowlarr instance (port 9696) as its indexer source, requiring no additional indexer configuration.

#### Scenario: Readarr searches via Prowlarr
- **WHEN** Readarr searches for a book
- **THEN** it queries Prowlarr, which fans out to all configured indexers

### Requirement: Readarr places downloaded books in the Calibre library path
Readarr SHALL be configured to move completed downloads into `$MEDIA_ROOT/media/books/` so Calibre-Web picks them up automatically.

#### Scenario: Completed download appears in Calibre-Web
- **WHEN** Readarr finishes downloading a book
- **THEN** the file appears under `$MEDIA_ROOT/media/books/` and is visible in Calibre-Web after a library refresh

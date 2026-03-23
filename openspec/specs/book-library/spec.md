## Requirements

### Requirement: Calibre-Web serves the ebook library via browser UI
The system SHALL run Calibre-Web as a Docker container, serving a web UI for browsing and downloading books from the Calibre library.

#### Scenario: Browse library in browser
- **WHEN** a user navigates to `http://cartman:8083`
- **THEN** they see the Calibre-Web UI with the book collection

#### Scenario: Download a book
- **WHEN** a user selects a book and chooses a format (epub, mobi, pdf)
- **THEN** the file downloads to their device

### Requirement: Calibre-Web exposes an OPDS catalog
The system SHALL provide an OPDS catalog endpoint so reader apps (Kindle app, Kobo, Koreader, Moonreader, etc.) can browse and download books directly.

#### Scenario: Reader app connects via OPDS
- **WHEN** a reader app is configured with `http://cartman:8083/opds`
- **THEN** the app can browse the library and download books

### Requirement: Calibre-Web supports Send-to-Kindle email
The system SHALL support sending books directly to a Kindle device via Amazon's Send-to-Kindle email feature, configurable through the Calibre-Web admin UI.

#### Scenario: Send book to Kindle
- **WHEN** a user selects a book and chooses "Send to Kindle"
- **THEN** Calibre-Web emails the book to the configured Kindle address

### Requirement: Library data persists across restarts
The system SHALL mount the Calibre library from `$MEDIA_ROOT/media/books/` so library data survives container restarts and upgrades.

#### Scenario: Container restart preserves library
- **WHEN** the calibre-web container is restarted
- **THEN** all books and metadata are still available

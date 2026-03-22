# htpc-download-box

Personal home server media stack running on `cartman` (192.168.1.20).

Forked from [sebgl/htpc-download-box](https://github.com/sebgl/htpc-download-box).

## Stack

| Service | Port | Purpose |
|---|---|---|
| gluetun | — | VPN gateway (PureVPN via OpenVPN) |
| deluge | 8112 | Torrent downloader (via VPN) |
| sabnzbd | 8080 | Usenet downloader (via VPN) |
| prowlarr | 9696 | Indexer manager |
| sonarr | 8989 | TV show monitoring and downloads |
| radarr | 7878 | Movie monitoring and downloads |
| bazarr | 6767 | Subtitle downloader |
| jellyfin | 8096 | Media server |
| grampsweb | 5000 | Genealogy app |

## Setup

```bash
cp .env.example .env
# fill in .env values
docker compose up -d
```

## Deploy (from laptop)

```bash
make deploy
```

Pushes the latest committed changes to cartman and restarts affected containers. Requires SSH access to `cartman` and the repo cloned at `~/dev/htpc-download-box` on the server.

> **Note:** `.env` is never touched by deploy — manage it manually on cartman.

## Environment Variables

See `.env.example` for all required variables.

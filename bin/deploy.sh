#!/usr/bin/env bash
set -euo pipefail

HOST="cartman"
REPO_PATH="$HOME/dev/htpc-download-box"

ssh "$HOST" bash <<EOF
set -euo pipefail
cd "$REPO_PATH"

# Warn if working tree is dirty
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "WARNING: working tree on $HOST has uncommitted changes:"
  git status --short
  echo ""
fi

echo "Deploying commit: \$(git log -1 --oneline origin/master 2>/dev/null || git log -1 --oneline)"
git pull

echo ""
echo "Starting containers..."
docker compose up -d
echo "Done."
EOF

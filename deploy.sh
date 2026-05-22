#!/usr/bin/env bash
set -euo pipefail

REMOTE_USER="xtrymind"
REMOTE_HOST="10.11.12.13"
REMOTE_DIR="/srv/blog/public/"
LOCAL_DIR="public/"

echo ">>> Building Hugo..."
hugo --minify

echo ">>> Deploying to ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}..."
rsync -avz --delete \
  --exclude='.DS_Store' \
  "${LOCAL_DIR}" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}"

echo ">>> Deploy selesai!"

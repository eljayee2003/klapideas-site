#!/usr/bin/env bash
set -euo pipefail

echo "==> Syncing site to klapideas-prod:/var/www/klapideas.com/"
rsync -avz --delete \
  --exclude '.git/' \
  --exclude '.github/' \
  --exclude '.vscode/' \
  --exclude '.venv/' \
  --exclude 'node_modules/' \
  --exclude 'Dockerfile' \
  --exclude 'docker-compose.yml' \
  --exclude 'Caddyfile' \
  --exclude 'nginx.conf' \
  --exclude '*.sh' \
  ./ klapideas-prod:/var/www/klapideas.com/

echo "==> Checking endpoints"
for url in \
  https://klapideas.com/ \
  https://klapideas.com/media.html \
  https://klapideas.com/services.html \
  https://klapideas.com/sitemap.xml \
  https://klapideas.com/assets/hero.jpg
do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
  echo "$code  $url"
done

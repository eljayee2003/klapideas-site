#!/usr/bin/env bash
set -euo pipefail

# ---- config ----
TARGET="klapideas-prod:/var/www/klapideas.com/"
FILES=(
  index.html
  about.html
  services.html
  media.html
  careers.html
  contact.html
  sitemap.xml
  robots.txt
  styles.css
)
# ---- /config ----

echo "==> Syncing site to ${TARGET}"
# If ./assets exists, include it; otherwise sync only FILES.
if [ -d "assets" ]; then
  rsync -avz --delete "${FILES[@]}" assets/ "$TARGET"
else
  rsync -avz --delete "${FILES[@]}" "$TARGET"
fi

echo "==> Checking endpoints"
for url in / /media.html /services.html /sitemap.xml ; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://klapideas.com${url}")
  printf "%s  https://klapideas.com%s\n" "$code" "$url"
done

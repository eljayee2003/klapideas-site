set -euo pipefail

VER="${1:-2025-09-14-1}"

FILES=(index.html about.html services.html careers.html contact.html)

for f in "${FILES[@]}"; do
  sed -i '' -e "s|href=\"/styles.css\"|href=\"/styles.css?v=$VER\"|g" "$f"
  sed -i '' -e "s|href='/styles.css'|href='/styles.css?v=$VER'|g" "$f"

  sed -i '' -e "s|href=\"/styles.css\" as=\"style\"|href=\"/styles.css?v=$VER\" as=\"style\"|g" "$f"
  sed -i '' -e "s|<noscript><link rel=\"stylesheet\" href=\"/styles.css\"></noscript>|<noscript><link rel=\"stylesheet\" href=\"/styles.css?v=$VER\"></noscript>|g" "$f"
done

echo "Bumped CSS to version: $VER"

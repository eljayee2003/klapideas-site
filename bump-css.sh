#!/usr/bin/env bash
# Usage:
#   ./bump-css.sh                   # use current timestamp
#   ./bump-css.sh 2025-10-01-120501 # use explicit version
set -euo pipefail

VER="${1:-$(date +%Y-%m-%d-%H%M%S)}"
echo "Using CSS version: $VER"

# Choose sed -i syntax per platform (macOS vs GNU/Linux)
if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(sed -i)         # GNU sed
else
  SED_INPLACE=(sed -i '')      # BSD/macOS sed
fi

# Target all HTML files in repo root (adjust path if you keep html elsewhere)
shopt -s nullglob || true 2>/dev/null
HTML_FILES=( *.html )
if [ "${#HTML_FILES[@]}" -eq 0 ]; then
  echo "No *.html files found in current directory." >&2
  exit 1
fi

# 1) Replace any existing ?v=… on styles.css (double or single quotes)
# 2) If styles.css has NO ?v=, append one
# 3) Cover preload and noscript variants too
# Regex notes:
#   - Match /styles.css optionally followed by ?v=anything up to a quote
#   - Replace the whole match with /styles.css?v=$VER
for f in "${HTML_FILES[@]}"; do
  # Double-quoted href/src
  "${SED_INPLACE[@]}" -E "s|(href=\"/styles\.css)(\?v=[^\"]*)?(\")|\1?v=${VER}\3|g" "$f"
  "${SED_INPLACE[@]}" -E "s|(href=\"/styles\.css)(\?v=[^\"]*)?(\"[[:space:]]+as=\"style\")|\1?v=${VER}\3|g" "$f"
  "${SED_INPLACE[@]}" -E "s|(<noscript><link rel=\"stylesheet\" href=\"/styles\.css)(\?v=[^\"]*)?(\"></noscript>)|\1?v=${VER}\3|g" "$f"

  # Single-quoted href/src
  "${SED_INPLACE[@]}" -E "s|(href='/styles\.css)(\?v=[^']*)?(')|\1?v=${VER}\3|g" "$f"
  "${SED_INPLACE[@]}" -E "s|(href='/styles\.css)(\?v=[^']*)?(' [[:space:]]*as='style')|\1?v=${VER}\3|g" "$f"
  "${SED_INPLACE[@]}" -E "s|(<noscript><link rel='stylesheet' href='/styles\.css)(\?v=[^']*)?('></noscript>)|\1?v=${VER}\3|g" "$f"
done

echo "Bumped CSS to version: $VER"

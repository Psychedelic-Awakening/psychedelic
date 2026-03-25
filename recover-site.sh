#!/usr/bin/env bash

set -euo pipefail

# ============================================================================
# Site Recovery Script
#
# Purpose:
#   Recover page HTML, original asset URLs, media URLs, links, and rough text
#   content from a site page for reconstruction work.
#
# Usage:
#   chmod +x recover-site.sh
#   ./recover-site.sh "https://psychedelic-institute.net/" "./site-recovery"
#
# Notes:
#   - This is designed for reconstruction, not perfect offline mirroring.
#   - It prefers original files hidden behind transformed CDN URLs where possible.
#   - It does not attempt to preserve JS app behavior.
# ============================================================================

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <url> [output_dir]"
  exit 1
fi

URL="$1"
OUTPUT_DIR="${2:-./site-recovery}"

RAW_DIR="$OUTPUT_DIR/raw"
DATA_DIR="$OUTPUT_DIR/data"
ASSET_DIR="$OUTPUT_DIR/assets"
ORIGINAL_ASSET_DIR="$ASSET_DIR/original"
MEDIA_ASSET_DIR="$ASSET_DIR/media"
REPORT_DIR="$OUTPUT_DIR/reports"
TMP_DIR="$OUTPUT_DIR/tmp"

mkdir -p \
  "$RAW_DIR" \
  "$DATA_DIR" \
  "$ORIGINAL_ASSET_DIR" \
  "$MEDIA_ASSET_DIR" \
  "$REPORT_DIR" \
  "$TMP_DIR"

HTML_FILE="$RAW_DIR/page.html"
CLEAN_HTML_FILE="$TMP_DIR/page-clean.html"

ORIGINAL_ASSET_URLS="$DATA_DIR/original-assets.txt"
MEDIA_ASSET_URLS="$DATA_DIR/media-assets.txt"
ALL_LINKS_FILE="$DATA_DIR/all-links.txt"
BUTTON_LINKS_FILE="$DATA_DIR/button-links.txt"
TEXT_FILE="$DATA_DIR/visible-text.txt"
SUMMARY_FILE="$REPORT_DIR/summary.txt"
WGET_LOG="$REPORT_DIR/wget.log"

echo "==> Downloading HTML from: $URL"
wget \
  --quiet \
  --output-file="$WGET_LOG" \
  -O "$HTML_FILE" \
  "$URL"

if [[ ! -s "$HTML_FILE" ]]; then
  echo "Failed to download HTML or HTML file is empty."
  exit 1
fi

echo "==> Normalizing HTML"
# Flatten HTML to make regex extraction less flaky.
tr '\n' ' ' < "$HTML_FILE" \
  | sed 's/[[:space:]]\+/ /g' \
  > "$CLEAN_HTML_FILE"

echo "==> Extracting original asset URLs"
# These transformed URLs often contain the original asset path prefixed by u_https://...
# We strip the leading u_ to recover the original asset URL.
grep -Eo 'u_https://[^" )]+' "$CLEAN_HTML_FILE" \
  | sed 's/^u_//' \
  | sort -u \
  > "$TMP_DIR/original-from-transforms.txt" || true

# Direct original filesafe assets
grep -Eo 'https://assets\.cdn\.filesafe\.space/[^" )]+' "$CLEAN_HTML_FILE" \
  | sort -u \
  > "$TMP_DIR/direct-filesafe-assets.txt" || true

# Direct storage.googleapis.com references sometimes point to originals too
grep -Eo 'https://storage\.googleapis\.com/[^" )]+' "$CLEAN_HTML_FILE" \
  | sort -u \
  > "$TMP_DIR/google-storage-assets.txt" || true

cat \
  "$TMP_DIR/original-from-transforms.txt" \
  "$TMP_DIR/direct-filesafe-assets.txt" \
  "$TMP_DIR/google-storage-assets.txt" \
  2>/dev/null \
  | sed '/^$/d' \
  | sort -u \
  > "$ORIGINAL_ASSET_URLS"

echo "==> Extracting broader media URLs"
grep -Eo 'https://[^" )]+' "$CLEAN_HTML_FILE" \
  | grep -Ei '\.(png|jpg|jpeg|webp|gif|svg|ico)(\?.*)?$|/media/|img\.youtube\.com|i\.vimeocdn\.com|stcdn\.leadconnectorhq\.com/.+\.(css|js)(\?.*)?$' \
  | sed 's/^u_//' \
  | sort -u \
  > "$MEDIA_ASSET_URLS" || true

echo "==> Extracting all links"
grep -Eo 'https://[^" )]+' "$CLEAN_HTML_FILE" \
  | sed 's/^u_//' \
  | sort -u \
  > "$ALL_LINKS_FILE" || true

echo "==> Extracting likely button / action links"
grep -Eo 'href="https://[^"]+"' "$CLEAN_HTML_FILE" \
  | sed 's/^href="//; s/"$//' \
  | sort -u \
  > "$BUTTON_LINKS_FILE" || true

echo "==> Extracting visible text"
# This is a rough text extraction pass:
# 1. remove script/style blocks
# 2. turn some structural tags into newlines
# 3. strip remaining tags
# 4. decode a few common entities
perl -0777 -pe '
  s/<script\b[^>]*>.*?<\/script>//gis;
  s/<style\b[^>]*>.*?<\/style>//gis;
  s/<(br|\/p|\/div|\/h1|\/h2|\/h3|\/h4|\/h5|\/h6|\/li)>/\n/gi;
' "$HTML_FILE" \
  | sed -E 's/<[^>]+>//g' \
  | sed 's/&nbsp;/ /g; s/&amp;/\&/g; s/&quot;/"/g; s/&#39;/'"'"'/g; s/&lt;/</g; s/&gt;/>/g' \
  | sed 's/[[:space:]]\+/ /g' \
  | sed 's/ *$//g' \
  | tr '\r' '\n' \
  | sed '/^[[:space:]]*$/d' \
  | awk '!seen[$0]++' \
  > "$TEXT_FILE"

echo "==> Downloading original assets"
if [[ -s "$ORIGINAL_ASSET_URLS" ]]; then
  wget \
    --no-clobber \
    --continue \
    --content-disposition \
    --trust-server-names \
    --directory-prefix="$ORIGINAL_ASSET_DIR" \
    --input-file="$ORIGINAL_ASSET_URLS" \
    || true
fi

echo "==> Downloading broader media assets"
if [[ -s "$MEDIA_ASSET_URLS" ]]; then
  wget \
    --no-clobber \
    --continue \
    --content-disposition \
    --trust-server-names \
    --directory-prefix="$MEDIA_ASSET_DIR" \
    --input-file="$MEDIA_ASSET_URLS" \
    || true
fi

echo "==> Writing summary report"
ORIGINAL_COUNT=0
MEDIA_COUNT=0
LINK_COUNT=0
BUTTON_COUNT=0
TEXT_LINES=0

[[ -f "$ORIGINAL_ASSET_URLS" ]] && ORIGINAL_COUNT=$(wc -l < "$ORIGINAL_ASSET_URLS" | tr -d ' ')
[[ -f "$MEDIA_ASSET_URLS" ]] && MEDIA_COUNT=$(wc -l < "$MEDIA_ASSET_URLS" | tr -d ' ')
[[ -f "$ALL_LINKS_FILE" ]] && LINK_COUNT=$(wc -l < "$ALL_LINKS_FILE" | tr -d ' ')
[[ -f "$BUTTON_LINKS_FILE" ]] && BUTTON_COUNT=$(wc -l < "$BUTTON_LINKS_FILE" | tr -d ' ')
[[ -f "$TEXT_FILE" ]] && TEXT_LINES=$(wc -l < "$TEXT_FILE" | tr -d ' ')

cat > "$SUMMARY_FILE" <<EOF
Site Recovery Summary
=====================

Source URL:
$URL

Output Directory:
$OUTPUT_DIR

Files Created:
- HTML: $HTML_FILE
- Original asset URL list: $ORIGINAL_ASSET_URLS
- Media asset URL list: $MEDIA_ASSET_URLS
- All links: $ALL_LINKS_FILE
- Button/action links: $BUTTON_LINKS_FILE
- Visible text: $TEXT_FILE
- Wget log: $WGET_LOG

Counts:
- Original asset URLs: $ORIGINAL_COUNT
- Media asset URLs: $MEDIA_COUNT
- All links: $LINK_COUNT
- Button/action links: $BUTTON_COUNT
- Visible text lines: $TEXT_LINES

Downloaded Asset Directories:
- Original assets: $ORIGINAL_ASSET_DIR
- Media assets: $MEDIA_ASSET_DIR

Notes:
- "Original assets" are preferred because they try to bypass transformed CDN wrappers.
- "Media assets" include thumbnails, direct media references, and some supporting files.
- Text extraction is approximate and intended for reconstruction, not legal archiving.
EOF

echo
echo "Done."
echo
echo "Key outputs:"
echo "  HTML:                 $HTML_FILE"
echo "  Original asset URLs:  $ORIGINAL_ASSET_URLS"
echo "  Media asset URLs:     $MEDIA_ASSET_URLS"
echo "  All links:            $ALL_LINKS_FILE"
echo "  Button links:         $BUTTON_LINKS_FILE"
echo "  Visible text:         $TEXT_FILE"
echo "  Summary:              $SUMMARY_FILE"
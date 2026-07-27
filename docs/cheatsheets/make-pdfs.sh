#!/usr/bin/env bash
# Regenerate printable PDFs: Hyper-3 desk reference + Hillside D50 keymap.
# Output: ~/Desktop/*.pdf
set -euo pipefail

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
HERE="$(cd "$(dirname "$0")" && pwd)"
ZMK="$HOME/personal/zmk-config/zmk-workspace"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# 1. Desk reference (source of truth: hyper-desk-reference.html in this dir)
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$HOME/Desktop/hyper-desk-reference.pdf" \
  "$HERE/hyper-desk-reference.html"

# 2. Keymap: one layer group per page, rendered fresh from the keymap
cd "$ZMK"
direnv exec . just draw-d50
DTS="config/boards/shields/hillside_d50/hillside_d50-layouts.dtsi"
direnv exec . keymap -c draw/config_d50.yaml draw draw/hillside_d50.yaml -d "$DTS" -s Base Nav      > "$TMP/p1.svg"
direnv exec . keymap -c draw/config_d50.yaml draw draw/hillside_d50.yaml -d "$DTS" -s Num Fn Combos > "$TMP/p2.svg"
direnv exec . keymap -c draw/config_d50.yaml draw draw/hillside_d50.yaml -d "$DTS" -s Game Sys Mouse > "$TMP/p3.svg"

cat > "$TMP/keymap.html" <<'HTML'
<!doctype html>
<html><head><meta charset="utf-8"><title>Hillside D50 Keymap</title>
<style>
  @page { size: letter landscape; margin: 6mm; }
  html, body { margin: 0; background: #fff; }
  .page { page-break-after: always; page-break-inside: avoid; display: flex; align-items: center; justify-content: center; height: 96vh; }
  .page:last-child { page-break-after: avoid; }
  img { max-width: 100%; max-height: 100%; }
</style></head><body>
  <div class="page"><img src="p1.svg" alt="Base and Nav"></div>
  <div class="page"><img src="p2.svg" alt="Num, Fn, Combos"></div>
  <div class="page"><img src="p3.svg" alt="Game, Sys, Mouse"></div>
</body></html>
HTML

"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$HOME/Desktop/hillside-d50-keymap.pdf" \
  "$TMP/keymap.html"

echo "Done: ~/Desktop/hyper-desk-reference.pdf, ~/Desktop/hillside-d50-keymap.pdf"

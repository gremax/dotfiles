#!/bin/sh
# Cheat sheet of the live keymap in a floating overlay; the same chord closes it.
ctl=/Applications/agterm.app/Contents/MacOS/agtermctl
sock=$AGT_SOCKET
page=${XDG_CACHE_HOME:-$HOME/.cache}/agterm/shortcuts.html
mkdir -p "$(dirname "$page")"

if "$ctl" tree --json --socket "$sock" ${AGT_WINDOW_ID:+--window "$AGT_WINDOW_ID"} |
  /usr/bin/jq -e --arg id "$AGT_SESSION_ID" --arg page "$page" \
    '[.result.tree.workspaces[].sessions[] | select(.id == $id) | .htmlOverlays[]? | select(.file == $page)] | length > 0' >/dev/null; then
  exec "$ctl" session overlay close --target "$AGT_SESSION_ID" --socket "$sock"
fi

"$ctl" keymap list --json --socket "$sock" | /usr/bin/jq -r -f "$(dirname "$0")/shortcuts.jq" > "$page" || exit 1
exec "$ctl" session overlay open --html "$page" --js --size-percent 80 --target "$AGT_SESSION_ID" --socket "$sock"

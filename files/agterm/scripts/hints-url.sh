#!/bin/sh
# kitty-hints style: pick a URL from this pane's recent output and open it in the browser.
ctl=/Applications/agterm.app/Contents/MacOS/agtermctl
sock=$AGT_SOCKET

# newest first, deduplicated, trailing punctuation dropped
# (kept out of $(...): bash 3.2's /bin/sh misparses quotes inside a command substitution)
filter='[scan("https?://[^\\s<>\u0022\u0027\u0060]+") | sub("[.,;:!?)\\]}>]+$"; "")]
  | reverse | reduce .[] as $u ([]; if any(.[]; . == $u) then . else . + [$u] end)
  | .[:200] | map({id: ., label: .})'
items=$("$ctl" session text --lines 1000 --target "$AGT_SESSION_ID" --pane-id "$AGT_PANE_ID" --socket "$sock" |
  /usr/bin/jq -R -s -c "$filter")

if [ "$items" = "[]" ]; then
  exec "$ctl" session hud "no URLs on screen" --hide-after 2 --target "$AGT_SESSION_ID" --socket "$sock"
fi

url=$(printf '%s' "$items" | "$ctl" pick --prompt "Open URL" --window "$AGT_WINDOW_ID" --socket "$sock" |
  /usr/bin/jq -r 'select(.result == "picked") | .id')

case $url in
  http://* | https://*) exec open "$url" ;;
esac

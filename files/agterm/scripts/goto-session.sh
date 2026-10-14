#!/bin/sh
# Select the Nth session of the active workspace; 9 jumps to the last one.
n=$1
sock=${AGT_SOCKET:-$AGTERM_SOCKET}
ctl=/Applications/agterm.app/Contents/MacOS/agtermctl

id=$("$ctl" tree --json --socket "$sock" ${AGT_WINDOW_ID:+--window "$AGT_WINDOW_ID"} |
  /usr/bin/jq -r --argjson n "$n" '
    .result.tree.workspaces[] | select(.active) | .sessions
    | (if $n == 9 then last else .[$n - 1] end) | .id // empty')

[ -n "$id" ] || exit 0
exec "$ctl" session select --target "$id" --socket "$sock" ${AGT_WINDOW_ID:+--window "$AGT_WINDOW_ID"}

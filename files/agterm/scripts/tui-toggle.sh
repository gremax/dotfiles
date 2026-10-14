#!/bin/sh
# Toggle a long-lived TUI session: jump to it (creating it in the "tui" workspace on first use),
# or, when already there, jump back to the last non-TUI session.
# usage: tui-toggle.sh mail|irc|cal

case $1 in
  mail) prog=neomutt; cmd="exec neomutt" ;;
  # irssi's windowlist and nicklist plugins need tmux; attach to the running irc session if there is one.
  # The server must not inherit this session's AGTERM_* or every pane in it reports to the wrong session.
  irc)  prog=tmux;    cmd="exec env -u AGTERM_ENABLED -u AGTERM_PANE -u AGTERM_PANE_ID -u AGTERM_SESSION_ID -u AGTERM_SOCKET -u AGTERM_WINDOW_ID -u AGTERM_WORKSPACE_ID tmux new-session -A -s irc irssi" ;;
  cal)  prog=ikhal;   cmd="exec ikhal" ;;
  *) echo "unknown TUI: $1" >&2; exit 2 ;;
esac

name=$1
ctl=/Applications/agterm.app/Contents/MacOS/agtermctl
sock=${AGT_SOCKET:-$AGTERM_SOCKET}
state=${XDG_STATE_HOME:-$HOME/.local/state}/agterm-tui
mkdir -p "$state"

here=$AGT_SESSION_ID
id=$(cat "$state/$name.id" 2>/dev/null)

if [ -n "$id" ] && [ "$here" = "$id" ]; then
  prev=$(cat "$state/prev" 2>/dev/null)
  [ -n "$prev" ] && "$ctl" session select --target "$prev" --socket "$sock" 2>/dev/null
  exit 0
fi

# only a non-TUI session is worth coming back to
grep -qxF "$here" "$state"/*.id 2>/dev/null || printf '%s\n' "$here" > "$state/prev"

# reuse the session only while it still runs the program: a restart brings it back as a bare shell
found=$("$ctl" tree --json --socket "$sock" | /usr/bin/jq -r --arg id "$id" --arg prog "$prog" '
  [.result.tree.workspaces[].sessions[] | select(.id == $id)] | first
  | if . == null then "gone" elif any(.foreground[]?; split("/") | last == $prog) then "running" else "stale" end')

case $found in
  running) exec "$ctl" session select --target "$id" --socket "$sock" ;;
  stale) "$ctl" session close --target "$id" --socket "$sock" >/dev/null ;;
esac

"$ctl" session new --workspace-name tui --create-workspace --name "$name" --cwd "$HOME" \
  --command "/opt/homebrew/bin/fish -lc '$cmd'" --socket "$sock" > "$state/$name.id"

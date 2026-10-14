#!/bin/sh
# Dashboard of the panes running a coding agent, the ones waiting on you first; the same chord closes it.
ctl=/Applications/agterm.app/Contents/MacOS/agtermctl
sock=$AGT_SOCKET
win=${AGT_WINDOW_ID:-active}

tree=$("$ctl" tree --json --window "$win" --socket "$sock") || exit 1

if printf '%s' "$tree" | /usr/bin/jq -e '.result.tree.dashboardMembers' >/dev/null; then
  exec "$ctl" dashboard --close --window "$win" --socket "$sock"
fi

# a pane counts when its program (or the script a node/python launcher runs) is a known agent;
# blocked, then completed, then active, then the rest; the dashboard holds 9 panes
filter='
  def agent: (.[0:2] // []) | any(split("/") | last | IN("claude", "codex", "opencode", "gemini", "cursor-agent", "aider", "crush", "goose", "pi"));
  def rank: {"blocked": 0, "completed": 1, "active": 2}[.status // ""] // 3;
  [.result.tree.workspaces[].sessions[] | . as $s
   | (if (.foreground | agent) then "\(.id):left" else empty end,
      if (.splitForeground | agent) then "\(.id):right" else empty end)
   | {ref: ., rank: ($s | rank)}]
  | sort_by(.rank) | .[:9][].ref'
refs=$(printf '%s' "$tree" | /usr/bin/jq -r "$filter")

if [ -z "$refs" ]; then
  exec "$ctl" session hud "no agents running" --hide-after 2 --target "$AGT_SESSION_ID" --socket "$sock"
fi

# shellcheck disable=SC2086 # refs are "<uuid>:left|right", one per word
exec "$ctl" dashboard $refs --auto-size --window "$win" --socket "$sock"

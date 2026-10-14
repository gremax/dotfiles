#!/bin/sh
# Merge the agterm hooks into every Claude Code config dir given (default: the ones that exist of
# ~/.claude, ~/.claude-personal, ~/.claude-work). Idempotent: a hook already present, under any path
# spelling or quoting, is left alone; everything else in settings.json is kept.
#   - agent status glyphs (scripts installed by agterm's Help > Install Agent Status Hooks)
#   - restore pin: `claude --resume <id>` for agterm's re-run restore
set -eu

[ $# -gt 0 ] || set -- "$HOME/.claude" "$HOME/.claude-personal" "$HOME/.claude-work"

status='"$HOME/.config/agterm/agent-status/agterm-claude-status.sh"'
pin='"$HOME/.config/agterm/scripts/claude-restore-pin.sh"'

# event, matcher ("-" = none), command; tab-separated, and read collapses empty tab fields
hooks="Notification	permission_prompt	$status blocked
PostToolUse	-	$status active --blink
UserPromptSubmit	-	$status active --blink
Stop	-	$status completed --auto-reset
SessionStart	-	$pin start
Stop	-	$pin start
SessionEnd	-	$pin end"

filter='
  def norm: gsub("[^A-Za-z0-9_. /-]"; "") | sub("^.*/"; "");
  .hooks //= {}
  | if any(.hooks[$event][]?.hooks[]?; (.command | norm) == ($cmd | norm)) then .
    else .hooks[$event] += [{hooks: [{type: "command", command: $cmd}]}
                            + (if $matcher == "-" then {} else {matcher: $matcher} end)]
    end'
# jq programs live in variables: bash 3.2's /bin/sh misparses quotes and parens inside $(...)
count='[.hooks[][].hooks[] | select(.command | test("agterm"))] | length'

for dir; do
  [ -d "$dir" ] || continue
  f=$dir/settings.json
  [ -s "$f" ] || echo '{}' > "$f"
  [ -e "$f.bak-agterm" ] || cp "$f" "$f.bak-agterm"
  printf '%s\n' "$hooks" | while IFS='	' read -r event matcher cmd; do
    # status scripts come from agterm's Help > Install Agent Status Hooks; a hook on a missing file errors every turn
    case $cmd in *agent-status*) [ -x "$HOME/.config/agterm/agent-status/agterm-claude-status.sh" ] || continue ;; esac
    /usr/bin/jq --arg event "$event" --arg matcher "$matcher" --arg cmd "$cmd" "$filter" "$f" > "$f.tmp"
    mv "$f.tmp" "$f"
  done
  n=$(/usr/bin/jq "$count" "$f")
  echo "$f: $n agterm hooks"
done

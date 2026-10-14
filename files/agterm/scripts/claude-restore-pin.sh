#!/bin/sh
# Claude Code hook: while Claude runs in an agterm pane, pin that pane to `claude --resume <id>` so
# agterm's re-run restore brings the same conversation back after a restart.
#   SessionStart, Stop -> claude-restore-pin.sh start   (always the live id; CLAUDE_CONFIG_DIR is kept, so
#                                                        each account resumes in itself)
#   SessionEnd         -> claude-restore-pin.sh end     (drops the pin only when you quit Claude yourself)
# Claude saves nothing until the first prompt, and `--resume` on an unsaved id fails with "No conversation
# found". Until the transcript holds a prompt the pin is a fresh `claude`; Stop upgrades it after each turn.
[ -n "$AGTERM_SESSION_ID" ] || exit 0
# a shell inside tmux carries the env of whichever session started the server
[ -z "$TMUX" ] || exit 0

# skip headless runs (claude -p): they would steal the pin of the interactive Claude that spawned them.
# Walk up to the nearest Claude process by its executable, not by text in some shell's command line.
headless() {
  set -f
  pid=$PPID
  for _ in 1 2 3 4 5; do
    # shellcheck disable=SC2046 # split the argv on purpose
    set -- $(ps -o args= -p "$pid" 2>/dev/null)
    [ $# -gt 0 ] || return 1
    if [ "${1##*/}" = claude ] || { [ "${1##*/}" = node ] && [ "${2##*/}" = claude ]; }; then
      for a; do case $a in -p | --print) return 0 ;; esac; done
      return 1
    fi
    pid=$(ps -o ppid= -p "$pid" | tr -d ' ')
  done
  return 1
}
headless && exit 0

input=$(cat)
ctl=/Applications/agterm.app/Contents/MacOS/agtermctl
set -- "$1" --target "$AGTERM_SESSION_ID" --pane-id "$AGTERM_PANE_ID" --socket "$AGTERM_SOCKET"

case $1 in
  start)
    sid=$(printf '%s' "$input" | /usr/bin/jq -r '.session_id // empty')
    printf '%s\n' "$sid" | grep -Eq '^[A-Za-z0-9-]+$' || exit 0
    transcript=$(printf '%s' "$input" | /usr/bin/jq -r '.transcript_path // empty')
    cmd=claude
    if [ -n "$transcript" ] && grep -q '"type":"user"' "$transcript" 2>/dev/null; then
      cmd="claude --resume $sid"
    fi
    # claude-personal / claude-work are `env CLAUDE_CONFIG_DIR=... claude`: resume in the same account
    if [ -n "${CLAUDE_CONFIG_DIR:-}" ]; then
      printf '%s\n' "$CLAUDE_CONFIG_DIR" | grep -Eq '^[A-Za-z0-9_./-]+$' || exit 0
      cmd="env CLAUDE_CONFIG_DIR=$CLAUDE_CONFIG_DIR $cmd"
    fi
    shift; "$ctl" session restore "$cmd" "$@" ;;
  end)
    # agterm quitting kills Claude too ("other"): keep the pin for the restart
    case $(printf '%s' "$input" | /usr/bin/jq -r '.reason // empty') in
      prompt_input_exit | logout) shift; "$ctl" session restore --clear "$@" ;;
    esac ;;
esac >/dev/null 2>&1
exit 0

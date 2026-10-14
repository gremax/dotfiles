#!/bin/sh
# kitty show_scrollback: this pane's whole scrollback in read-only nvim over the session; q closes it.
ctl=/Applications/agterm.app/Contents/MacOS/agtermctl
f=$(mktemp -t agterm-scrollback) || exit 1
trap 'rm -f "$f"' EXIT

"$ctl" session text --all --target "$AGT_SESSION_ID" --pane-id "$AGT_PANE_ID" --socket "$AGT_SOCKET" > "$f" || exit 1

# --block keeps the temp file alive until nvim exits; closing with Cmd+W kills nvim, which is not a failure
"$ctl" session overlay open "/opt/homebrew/bin/fish -lc 'exec nvim -R + -c \"nnoremap <buffer> q <cmd>qa!<cr>\" -- $f'" \
  --block --cwd "${AGT_SESSION_PWD:-$HOME}" --target "$AGT_SESSION_ID" --socket "$AGT_SOCKET" >/dev/null
exit 0

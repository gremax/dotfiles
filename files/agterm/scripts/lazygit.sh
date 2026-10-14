#!/bin/sh
# Open lazygit over the session, in the directory of the pane the chord fired from.
ctl=/Applications/agterm.app/Contents/MacOS/agtermctl
dir=${AGT_SESSION_PWD:-$HOME}

if ! git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
  exec "$ctl" session hud "not a git repository" --detail "$dir" --hide-after 2 \
    --target "$AGT_SESSION_ID" --socket "$AGT_SOCKET"
fi

# fish -l gives lazygit the user's PATH instead of the app's GUI one
exec "$ctl" session overlay open "/opt/homebrew/bin/fish -lc lazygit" --cwd "$dir" \
  --target "$AGT_SESSION_ID" --socket "$AGT_SOCKET"

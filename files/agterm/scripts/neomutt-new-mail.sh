#!/bin/sh
# neomutt new_mail_command: put a mail glyph on the agterm session neomutt runs in.
# Typing in neomutt clears it (Settings > Agent Status > Status reset).
[ -n "$AGTERM_SESSION_ID" ] || exit 0
/Applications/agterm.app/Contents/MacOS/agtermctl session status completed --color '#83a598' --shape square \
  --target "$AGTERM_SESSION_ID" --pane-id "$AGTERM_PANE_ID" --socket "$AGTERM_SOCKET" >/dev/null 2>&1
exit 0

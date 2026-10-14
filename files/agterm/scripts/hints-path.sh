#!/bin/sh
# Open path[:line[:col]] in nvim over the session: the selection if it names a file,
# otherwise a pick of the existing files mentioned in this pane's recent output.
ctl=/Applications/agterm.app/Contents/MacOS/agtermctl
sock=$AGT_SOCKET
dir=${AGT_SESSION_PWD:-$HOME}
cd "$dir" || exit 1

# print "file line col" for an existing file; the strict charset keeps screen text out of the command line
resolve() {
  printf '%s\n' "$1" | grep -Eq '^[A-Za-z0-9_@+~./-]+(:[0-9]+){0,2}:?$' || return 1
  spec=${1%:}
  file=${spec%%:*}; pos=${spec#"$file"}; pos=${pos#:}
  line=${pos%%:*}; col=${pos#"$line"}; col=${col#:}
  case $file in "~/"*) file=$HOME/${file#"~/"} ;; esac
  # git diff prints a/ and b/ prefixes
  for f in "$file" "${file#a/}" "${file#b/}"; do
    [ -f "$f" ] && { echo "$f ${line:-1} ${col:-1}"; return 0; }
  done
  return 1
}

open_in_nvim() {
  exec "$ctl" session overlay open "/opt/homebrew/bin/fish -lc 'exec nvim \"+call cursor($2,$3)\" -- $1'" \
    --cwd "$dir" --target "$AGT_SESSION_ID" --socket "$sock"
}

sel=$(printf '%s' "$AGT_SELECTION" | tr -d '[:space:]')
if [ -n "$sel" ] && hit=$(resolve "$sel"); then
  open_in_nvim $hit
fi

# newest first, deduplicated; only names that resolve to a file survive
filter='[scan("(?:~/|\\.\\.?/|/)?[A-Za-z0-9_@+-][A-Za-z0-9_@+.-]*(?:/[A-Za-z0-9_@+.-]+)*(?::\\d+){0,2}") | select(test("[/.]"))]
  | reverse | reduce .[] as $p ([]; if any(.[]; . == $p) then . else . + [$p] end) | .[:300][]'
items=$("$ctl" session text --lines 1000 --target "$AGT_SESSION_ID" --pane-id "$AGT_PANE_ID" --socket "$sock" |
  /usr/bin/jq -R -s -r "$filter" |
  while IFS= read -r spec; do
    hit=$(resolve "$spec") && printf '%s\t%s\n' "$hit" "$spec"
  done | head -200 | /usr/bin/jq -R -s -c 'split("\n") | map(select(length > 0) | split("\t") | {id: .[0], label: .[1]})')

if [ "$items" = "[]" ]; then
  exec "$ctl" session hud "no file paths on screen" --hide-after 2 --target "$AGT_SESSION_ID" --socket "$sock"
fi

hit=$(printf '%s' "$items" | "$ctl" pick --prompt "Open in nvim" --window "$AGT_WINDOW_ID" --socket "$sock" |
  /usr/bin/jq -r 'select(.result == "picked") | .id')
[ -n "$hit" ] && open_in_nvim $hit
exit 0

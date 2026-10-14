# Render `agtermctl keymap list --json` as the shortcuts cheat sheet.
# Known entries get a section and a description; anything new still shows up under "Other".

def layout: [
  ["Navigation", [
    ["custom", "Session 1", "session 1…8 of the workspace"],
    ["custom", "Last session", "last session of the workspace"],
    ["action", "next_session", "next session"],
    ["action", "previous_session", "previous session"],
    ["action", "next_workspace", "next workspace"],
    ["action", "previous_workspace", "previous workspace"],
    ["action", "focus_left_pane", "left split pane"],
    ["action", "focus_right_pane", "right split pane"],
    ["action", "next_attention_session", "next needing attention"],
    ["action", "previous_attention_session", "previous needing attention"],
    ["action", "session_palette", "go to session"],
    ["action", "show_attention", "all needing attention"],
    ["action", "dashboard", "recent sessions dashboard"],
    ["custom", "Agents dashboard", "agents dashboard · waiting ones first"]
  ]],
  ["TUI", [
    ["custom", "Mail", "neomutt · again to go back"],
    ["custom", "IRC", "irssi in tmux · again to go back"],
    ["custom", "Calendar", "ikhal · again to go back"],
    ["custom", "Lazygit", "lazygit in the session dir"],
    ["custom", "Yazi", "yazi in the session dir"]
  ]],
  ["Hints", [
    ["custom", "Open URL", "URL from output → browser"],
    ["custom", "Open path in nvim", "file:line from selection or output → nvim"],
    ["custom", "Scrollback in nvim", "scrollback in nvim"],
    ["custom", "Shortcuts", "this cheat sheet"]
  ]],
  ["Sessions and panes", [
    ["action", "new_session", "new session"],
    ["action", "close_session", "close session"],
    ["action", "reopen_recent", "reopen closed"],
    ["action", "undo_close", "undo close"],
    ["action", "toggle_split", "vertical split"],
    ["action", "toggle_horizontal_split", "horizontal split"],
    ["action", "toggle_scratch", "scratch terminal"],
    ["action", "toggle_terminal_zoom", "zoom pane"],
    ["action", "toggle_search", "search"],
    ["action", "toggle_flag", "flag session"]
  ]],
  ["Window", [
    ["action", "new_window", "new window"],
    ["action", "new_workspace", "new workspace"],
    ["action", "open_directory", "open directory"],
    ["action", "toggle_sidebar", "sidebar"],
    ["action", "toggle_fullscreen", "full screen"],
    ["action", "quick_terminal", "quick terminal"],
    ["action", "command_palette", "command palette"],
    ["action", "custom_command_palette", "custom commands"],
    ["action", "increase_font_size", "bigger font"],
    ["action", "decrease_font_size", "smaller font"],
    ["action", "reset_font_size", "reset font"]
  ]]
];

def glyphs: {"ctrl": "⌃", "cmd": "⌘", "opt": "⌥", "shift": "⇧", "up": "↑", "down": "↓", "left": "←",
             "right": "→", "return": "↩", "space": "Space", "tab": "⇥", "delete": "⌫"};

# "ctrl+cmd+j" -> "⌃⌘J"; "cmd++" keeps its plus
def chord_text:
  (if endswith("++") then (.[:-2] | split("+")) + ["+"] else split("+") end)
  | map(glyphs[.] // ascii_upcase) | join("");

# alternatives (|) and leader sequences (>)
def keys_html:
  split("|") | map(split(">") | map(chord_text | @html "<kbd>\(.)</kbd>") | join("<span class=sep>then</span>"))
  | join("<span class=sep>/</span>");

def row($keys; $desc): @html "<div class=row><span>\($desc)</span>" + "<span class=keys>\($keys)</span></div>";

.result.keymap as $k
| ($k.actions | map(select(.chord) | {key: .action, value: .chord}) | from_entries) as $acts
| ($k.commands | map(select(.shortcut) | {key: .name, value: .shortcut}) | from_entries) as $cmds
| ([layout[][1][] | select(.[0] == "custom") | .[1]] + [range(2; 9) | "Session \(.)"]) as $known_cmds
| ([layout[][1][] | select(.[0] == "action") | .[1]]) as $known_acts
| [layout[] | .[0] as $title | [.[1][] |
    (if .[0] == "custom" then $cmds[.[1]] else $acts[.[1]] end) as $chord
    | select($chord)
    | if .[1] == "Session 1"
      then row("<kbd>⌘1</kbd><span class=sep>…</span><kbd>⌘8</kbd>"; .[2])
      else row($chord | keys_html; .[2]) end]
  | select(length > 0)
  | "<section><h2>\($title | @html)</h2>\(join(""))</section>"]
  + [[($cmds | to_entries[] | select(.key as $n | $known_cmds | index($n) | not) | row(.value | keys_html; .key)),
      ($acts | to_entries[] | select(.key as $n | $known_acts | index($n) | not) | row(.value | keys_html; .key | gsub("_"; " ")))]
     | select(length > 0) | "<section><h2>Other</h2>\(join(""))</section>"]
| join("") as $sections
| "<!doctype html>
<html lang=\"en\"><head><meta charset=\"utf-8\"><title>Shortcuts</title>
<style>
body { margin: 0; background: var(--agterm-background, Canvas); color: var(--agterm-foreground, CanvasText);
       font: 13px/1.45 -apple-system, BlinkMacSystemFont, sans-serif; }
.page { --accent: var(--agterm-color-3, #d79921); --muted: color-mix(in srgb, var(--agterm-foreground, CanvasText) 55%, transparent);
        --line: color-mix(in srgb, var(--agterm-foreground, CanvasText) 9%, transparent); padding: 20px 26px 16px; }
header { display: flex; align-items: baseline; justify-content: space-between; margin-bottom: 16px; }
h1 { font-size: 15px; font-weight: 600; margin: 0; }
.hint { color: var(--muted); font-size: 12px; }
.grid { columns: 3 270px; column-gap: 32px; }
section { break-inside: avoid; display: inline-block; width: 100%; padding-bottom: 20px; }
h2 { font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: .08em; color: var(--accent); margin: 0 0 6px; }
.row { display: flex; justify-content: space-between; align-items: center; gap: 14px; padding: 4px 0; border-bottom: 1px solid var(--line); }
.keys { white-space: nowrap; }
kbd { font: 12px ui-monospace, SFMono-Regular, Menlo, monospace; padding: 1px 6px; border-radius: 4px;
      background: color-mix(in srgb, var(--agterm-foreground, CanvasText) 9%, transparent);
      border: 1px solid color-mix(in srgb, var(--agterm-foreground, CanvasText) 16%, transparent); }
.sep { color: var(--muted); font-size: 11px; margin: 0 4px; }
footer { color: var(--muted); font-size: 12px; border-top: 1px solid var(--line); padding-top: 10px; }
</style></head>
<body><div class=\"page\">
<header><h1>Shortcuts</h1><span class=\"hint\">Esc · q · ⌃⌘/ to close</span></header>
<div class=\"grid\">\($sections)</div>
<footer>In palettes: <kbd>⌃J</kbd> <kbd>⌃K</kbd> down / up. In nvim scrollback: <kbd>q</kbd> closes.</footer>
</div>
<script>
document.addEventListener('keydown', e => {
  if (e.key === 'Escape' || e.key === 'q') agterm.request('session.overlay.close');
});
</script>
</body></html>"

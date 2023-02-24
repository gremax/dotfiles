--[[ opts.lua ]]
local opt = vim.opt
local cmd = vim.api.nvim_command
local autocmd = vim.api.nvim_create_autocmd

-- [[ Context ]]
opt.colorcolumn = '80' -- str:  Show col for max line length
opt.number = true -- bool: Show line numbers
opt.relativenumber = true -- bool: Show relative line numbers
opt.scrolloff = 4 -- int:  Min num lines of context
opt.signcolumn = 'yes' -- str:  Show the sign column
opt.wrap = false -- bool: Wrap the lines
opt.list = true -- bool: Show list chars
opt.listchars = {
  tab = '▸ ',
  trail = '·',
  eol = '¬',
  nbsp = '_',
  extends = '❯',
  precedes = '❮'
}
opt.title = true -- bool: Show the title
opt.autoindent = true -- bool: Auto indent
opt.showcmd = true -- bool: Show the command (def)
opt.cmdheight = 1 -- int:  Height of the command line (def)
opt.backup = false -- bool: Backup files

-- vim.cmd 'filetype plugin on'
-- vim.cmd 'filetype plugin indent on'
-- vim.cmd 'syntax on'

-- [[ Filetypes ]]
opt.encoding = 'utf8' -- str:  String encoding to use
opt.fileencoding = 'utf8' -- str:  File encoding to use

-- [[ Theme ]]
opt.syntax = 'ON' -- str:  Allow syntax highlighting
opt.termguicolors = true -- bool: If term supports ui color then enable
opt.cursorline = true -- bool: Highlight the current line
cmd [[colorscheme dracula]] -- cmd:  Set the colorscheme

-- [[ Search ]]
opt.ignorecase = true -- bool: Ignore case in search patterns
opt.smartcase = true -- bool: Override ignorecase if search contains capitals
opt.incsearch = true -- bool: Use incremental search
opt.hlsearch = true -- bool: Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 2 -- num:  Size of an indent
opt.softtabstop = 2 -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 2 -- num:  Number of spaces tabs count for
opt.smartindent = true -- bool: Use smart indent

-- [[ Splits ]]
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one

-- [[ Misc ]]
opt.path:append { '**' }
opt.wildignore:append { '*/node_modules/*' }

-- Undercurl
cmd [[let &t_Cs = "\e[4:3m"]]
cmd [[let &t_Ce = "\e[4:0m"]]

-- autocmd('BufEnter', '*.md', 'syntax on')
autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste'
})

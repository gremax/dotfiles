--[[ init.lua for servers ]]
-- The laptop's options and keys from nvim/, without plugins: nothing to clone,
-- compile or keep up to date on the server.

vim.g.mapleader = ','
vim.g.localleader = '\\'

local opt = vim.opt
local map = vim.api.nvim_set_keymap
local opts = { silent = true }

-- [[ Context ]]
opt.colorcolumn = '80'
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4
opt.signcolumn = 'yes'
opt.wrap = false
opt.list = true
opt.listchars = {
  tab = '▸ ',
  trail = '·',
  eol = '¬',
  nbsp = '_',
  extends = '❯',
  precedes = '❮'
}
opt.title = true
opt.showcmd = true
opt.backup = false

-- [[ Theme ]]
-- Built in since 0.10, from gruvbox's palette.
opt.termguicolors = true
opt.cursorline = true
opt.background = 'dark'
vim.cmd [[colorscheme retrobox]]

-- [[ Search ]]
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- [[ Whitespace ]]
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.smartindent = true

-- [[ Splits ]]
opt.splitright = true
opt.splitbelow = true

-- [[ Misc ]]
opt.path:append { '**' }

-- [[ Keys ]]
map('', '<Up>', [[<NOP>]], opts)
map('', '<Down>', [[<NOP>]], {})
map('', '<Left>', [[<NOP>]], {})
map('', '<Right>', [[<NOP>]], {})

map('n', '<Leader>h', [[:noh<CR>]], opts)
map('n', 'tt', [[:tabnew<CR>]], opts)

-- netrw on the left, where nvim-tree is on the laptop.
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
map('n', '<Space><Space>', [[:Lexplore<CR>]], opts)

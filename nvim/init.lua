--[[ init.lua ]]

vim.g.mapleader = ','
vim.g.localleader = '\\'

-- IMPORTS
require('plug') -- Plugins
require('vars') -- Variables
require('opts') -- Options
require('keys') -- Keymaps

-- PLUGINS
require('nvim-autopairs').setup {}
require('nvim-tree').setup {}


-- local has = function(x)
--   return vim.fn.has(x) == 1
-- end

-- local is_mac = has('macunix')
-- local is_win = has('win32')
-- local is_bsd = has('bsd')

-- if is_mac then
--   require('macos')
-- end

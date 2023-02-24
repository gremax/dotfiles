--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap
local opts = { silent = true }

-- Disable arrow keys
map('', '<Up>', [[<NOP>]], opts)
map('', '<Down>', [[<NOP>]], {})
map('', '<Left>', [[<NOP>]], {})
map('', '<Right>', [[<NOP>]], {})

-- Remap the key used to leave insert mode
-- map('i', 'jk', '', {})

-- Clear search highlights
map('n', '<Leader>h', [[:noh<CR>]], opts)

-- Tabs
map('n', '<Leader>t', [[:tabedit<CR>]], opts)

-- Toggle nvim-tree
map('n', '<Space><Space>', [[:NvimTreeToggle<CR>]], opts)
map('n', '<Leader>hf', [[:NvimTreeFindFile<CR>]], opts)

-- Toggle telescope
map('n', '<Leader>ff', [[:Telescope find_files<CR>]], opts)
map('n', '<Leader>fg', [[:Telescope live_grep<CR>]], opts)
map('n', '<Leader>fb', [[:Telescope buffers<CR>]], opts)
map('n', '<Leader>fh', [[:Telescope help_tags<CR>]], opts)

-- Toggle tagbar
map('n', '<Leader>tt', [[:TagbarToggle<CR>]], opts)

-- Generate ctags
map('', '<F10>',
  ':!ctags -R -f tags --languages=ruby --exclude=.git --exclude=logs --exclude=doc --exclude=tmp . $(bundle list --paths)<CR>'
  , opts)

-- Toggle Grepper
map('n', '<Leader>a', [[:Grepper -tool ag<CR>]], opts)

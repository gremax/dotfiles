-- [[ plug.lua ]]

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim' }
  use { 'L3MON4D3/LuaSnip' }
  use { 'aca/emmet-ls' }
  use { 'ellisonleao/gruvbox.nvim' }
  use { 'github/copilot.vim' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/nvim-cmp' }
  use { 'junegunn/gv.vim' }
  use { 'kchmck/vim-coffee-script' }
  use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons', opts = true } }
  use { 'majutsushi/tagbar' }
  use { 'mhinz/vim-grepper' }
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'onsails/lspkind.nvim' }
  use { 'ray-x/go.nvim' }
  use { 'ray-x/guihua.lua' }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-rails', ft = { 'ruby' } }
  use { 'vim-ruby/vim-ruby', ft = { 'ruby' }, config = function() require('plugins.ruby') end }
  use { 'vimwiki/vimwiki' }
  use { 'windwp/nvim-autopairs' }
  if packer_bootstrap then
    require('packer').sync()
  end
end)

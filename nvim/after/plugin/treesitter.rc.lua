local status, ts = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

ts.setup {
  highlight = { enable = true },
  indent = { enable = true },
  ensure_installed = {
    'css',
    'go',
    'html',
    'javascript',
    'json',
    'ruby',
    'yaml',
  },
}

local autotag_ok, autotag = pcall(require, 'nvim-ts-autotag')
if autotag_ok then
  autotag.setup()
end

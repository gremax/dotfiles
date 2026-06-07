local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, _)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = 0,
      callback = function() vim.lsp.buf.format() end,
    })
  end
end

vim.lsp.config('*', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('gopls', {
  flags = { debounce_text_changes = 250 },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
    },
  },
})

vim.lsp.config('emmet_ls', {
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'gohtmltmpl' },
  init_options = {
    html = {
      options = { ['bem.enabled'] = true },
    },
  },
})

vim.lsp.enable({ 'quick_lint_js', 'gopls', 'lua_ls', 'emmet_ls' })

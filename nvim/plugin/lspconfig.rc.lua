local status, plug = pcall(require, 'lspconfig')
if (not status) then return end

local protocol = require('vim.lsp.protocol')

local on_attach = function(client, _)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end
end

-- plug.solargraph.setup({
--   on_attach = on_attach
-- })



local lsp_flags = {
  debounce_text_changes = 250,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

plug.quick_lint_js.setup {}
plug.gopls.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}

plug.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      -- runtime = { version = 'LuaJIT', },
      diagnostics = { globals = { 'vim' }, },
      workspace = { library = vim.api.nvim_get_runtime_file('', true), },
      -- telemetry = { enable = false, },
    },
  },
}

-- local caps = vim.lsp.protocol.make_client_capabilities()
-- caps.textDocument.completion.completionItem.snippetSupport = true

plug.emmet_ls.setup {
  -- on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'gohtmltmpl' },
  init_options = {
    html = {
      options = {
        -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
        ['bem.enabled'] = true,
      },
    },
  }
}

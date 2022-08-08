-- Default conf from: https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lspconfig = require('lspconfig');

lspconfig['tsserver'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
lspconfig['sumneko_lua'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
      Lua = {
	runtime = {
	  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
	  version = 'LuaJIT',
	},
	diagnostics = {
	  -- Get the language server to recognize the `vim` global
	  globals = {'vim'},
	},
	workspace = {
	  -- Make the server aware of Neovim runtime files
	  library = vim.api.nvim_get_runtime_file("", true),
	},
	-- Do not send telemetry data containing a randomized but unique identifier
	telemetry = {
	  enable = false,
	},
      },
  },
}

lspconfig['pyright'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}

lspconfig['vimls'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}
-- Highlight line numbers for diagnostics
vim.fn.sign_define('DiagnosticSignError', { numhl = 'LspDiagnosticsLineNrError', text = '' })
vim.fn.sign_define('DiagnosticSignWarn', { numhl = 'LspDiagnosticsLineNrWarning', text = '' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '' })
vim.fn.sign_define('DiagnosticSignHint', { text = '' })

vim.cmd('highlight LspDiagnosticsLineNrError gui=bold guifg=#ff5370 guibg=#312a34')
vim.cmd('highlight LspDiagnosticsLineNrWarning gui=bold guifg=#f78c6c guibg=#312e3a')

-- Configure diagnostics displaying
--vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--  virtual_text = true,
--  signs = true,
--  update_in_insert = false,
--})


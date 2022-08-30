-- ######################## BEGIN LSPCONFIG ######################## 
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
-- ######################## END LSPCONFIG ######################## 

-- ######################## BEGIN COMPLETITION CONFIG ######################## 
local function border(hl_name)
  return {
    --{ "╭", hl_name },
    --{ "─", hl_name },
    --{ "╮", hl_name },
    --{ "│", hl_name },
    --{ "╯", hl_name },
    --{ "─", hl_name },
    --{ "╰", hl_name },
    --{ "│", hl_name },
    { "┌", hl_name },
    { "─", hl_name },
    { "┐", hl_name },
    { "│", hl_name },
    { "┘", hl_name },
    { "─", hl_name },
    { "└", hl_name },
    { "│", hl_name },
  }
end
-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    --completion = cmp.config.window.bordered(),
    completion = {
      border = border "CmpBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
    --documentation = cmp.config.window.bordered(),
    documentation = {
      --border = border "CmpDocBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'git' },
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    { name = 'path' },
    { name = 'buffer' },
  }),
  formatting = {
    format = function(_, vim_item)
      local icons = require("nvchad_ui.icons").lspkind
      vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
      return vim_item
    end,
  },
  experimental = {
    ghost_text = true,
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- ######################## END COMPLETITION CONFIG ######################## 

-- ######################## BEGIN LANGUAGE SERVERS CONFIG ######################## 
local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lspconfig = require('lspconfig');

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
lspconfig['sumneko_lua'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
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

-- lspconfig['tsserver'].setup{
--   on_attach = on_attach,
--   capabilities = capabilities,
--   flags = lsp_flags,
-- }

require("typescript").setup({
  disable_commands = false, -- prevent the plugin from creating Vim commands
  debug = true, -- enable debug logging for commands
  server = { -- pass options to lspconfig's setup method
    on_attach = on_attach,
    capabilities = capabilities,
  },
})

lspconfig['pyright'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig['vimls'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig['marksman'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig['cssls'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

lspconfig['cssmodules_ls'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

-- ######################## END LANGUAGE SERVERS CONFIG ######################## 

-- ######################## BEGIN VSNIP CONFIG ######################## 

-- ######################## END VSNIP CONFIG ######################## 

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

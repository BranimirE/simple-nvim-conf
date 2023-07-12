local my_lsp_servers = {
  'lua_ls',
  'tsserver',
  'bashls',
  'pyright',
  'vimls',
  'marksman',
  'cssls',
  'cssmodules_ls',
  'clangd',
  'yamlls',
  'html',
  'sqlls'
}

-- ######################## BEGIN LSPCONFIG ######################## 
-- Default conf from: https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
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
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  --vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  --vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end
-- ######################## END LSPCONFIG ######################## 
-- Setup lspconfig.
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

-- ######################## BEGIN LANGUAGE SERVERS CONFIG ######################## 
local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lspconfig = require('lspconfig');

local my_lsp_server_config = {
  -- sumneko_lua = {
  lua_ls = {
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
  },
  yamlls = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = lsp_flags,
    settings = {
      yaml = {
        format = {
          enable = true,
        },
        hover = true,
        completion = true,
        customTags = {
          "!fn",
          "!And",
          "!If",
          "!If sequence",
          "!Not",
          "!Not sequence",
          "!Equals",
          "!Equals sequence",
          "!Or",
          "!FindInMap sequence",
          "!Base64",
          "!Cidr",
          "!Ref",
          "!Ref Scalar",
          "!Sub",
          "!Sub sequence",
          "!GetAtt",
          "!GetAZs",
          "!ImportValue",
          "!Select",
          "!Split",
          "!Join sequence"
        },
      },
    }
  },
  tsserver = {
    capabilities = capabilities,
    on_attach = function(client)
      -- Disable annoying convert JS module message
      require('nvim-lsp-ts-utils').setup({
          filter_out_diagnostics_by_code = { 80001 },
      })
      require('nvim-lsp-ts-utils').setup_client(client)      -- client.resolved_capabilities.document_formatting = false

      client.server_capabilities.documentFormattingProvider = false
    end,
  }
}

for _, server_name in ipairs(my_lsp_servers) do
  if my_lsp_server_config[server_name] ~= nil then
    lspconfig[server_name].setup(my_lsp_server_config[server_name])
  else
    lspconfig[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
      flags = lsp_flags,
    })
  end
end
-- ######################## END LANGUAGE SERVERS CONFIG ######################## 

-- Highlight line numbers for diagnostics

-- Configure diagnostics displaying
--vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--  virtual_text = true,
--  signs = true,
--  update_in_insert = false,
--})

-- ######################## BEGIN LSP SAGA CONFIG ########################
local keymap = vim.keymap.set
require('lspsaga').setup()


-- Lsp finder find the symbol definition implement reference
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Code action
keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
keymap("v", "<leader>ca", "<cmd>Lspsaga range_code_action<CR>", { silent = true })

-- Rename
-- keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Definition preview
keymap("n", "<leader>gd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })

-- Show line diagnostics
keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- -- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Only jump to error
keymap("n", "[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
keymap("n","<leader>o", "<cmd>Lspsaga outline<CR>",{ silent = true })

-- Hover Doc
keymap("n", "<leader>k", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

-- Float terminal
keymap({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle lazygit<CR>")
-- ######################## END LSP SAGA CONFIG ######################## 

-- ######################## BEGIN NULL-LS CONFIG ########################
local setup, null_ls = pcall(require, 'null-ls')
if not setup then
  return
end

local formatting = null_ls.builtins.formatting
-- local diagnostic = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  sources = {
    code_actions.gitsigns,
    formatting.prettier
  }
})
-- ######################## END NULL-LS CONFIG ######################## 

-- Most of the code here was extracted from here:
-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/lsp.lua

local methods = vim.lsp.protocol.Methods
local myutils = require('myutils')

local M = {}

--- Returns the editor's capabilities + some overrides.
---@return lsp.ClientCapabilities
M.client_capabilities = function()
  return vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers.
    require('cmp_nvim_lsp').default_capabilities(),
    {
      workspace = {
        -- PERF: didChangeWatchedFiles is too slow.
        -- TODO: Remove this when https://github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed.
        didChangeWatchedFiles = { dynamicRegistration = false },
      },
    }
  )
end

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)

  myutils.load_mapping(mymappings.lsp(bufnr))
  local conditional_lsp_methods = require('mymappings').conditional_lsp_methods(bufnr)

  for method, mapping in pairs(conditional_lsp_methods) do
    if client.supports_method(method) then
      myutils.load_mapping(mapping)
    end
  end
  -- myutils.log('client.name='..client.name)
  -- myutils.log('client.server_capabilities.documentFormattingProvider='..vim.inspect(client.server_capabilities.documentFormattingProvider))
  -- myutils.log('client.server_capabilities.documentRangeFormattingProvider='..vim.inspect(client.server_capabilities.documentRangeFormattingProvider))
  if client.supports_method(methods.textDocument_documentHighlight) then
    local under_cursor_highlights_group =
    vim.api.nvim_create_augroup('branimir/cursor_highlights', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'BufEnter' }, {
      group = under_cursor_highlights_group,
      desc = 'Highlight references under the cursor',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = under_cursor_highlights_group,
      desc = 'Clear highlight references',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client.supports_method(methods.textDocument_inlayHint) then
    local inlay_hints_group = vim.api.nvim_create_augroup('branimir/toggle_inlay_hints', { clear = false })

    -- Initial inlay hint display.
    -- Idk why but without the delay inlay hints aren't displayed at the very start.
    vim.defer_fn(function()
      local mode = vim.api.nvim_get_mode().mode
      vim.lsp.inlay_hint.enable(bufnr, mode == 'n' or mode == 'v')
    end, 500)

    vim.api.nvim_create_autocmd('InsertEnter', {
      group = inlay_hints_group,
      desc = 'Enable inlay hints',
      buffer = bufnr,
      callback = function()
        vim.lsp.inlay_hint.enable(bufnr, false)
      end,
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
      group = inlay_hints_group,
      desc = 'Disable inlay hints',
      buffer = bufnr,
      callback = function()
        vim.lsp.inlay_hint.enable(bufnr, true)
      end,
    })
  end
end


return M

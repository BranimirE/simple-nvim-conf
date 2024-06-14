-- Most of the code here was extracted from here:
-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/lsp.lua

local methods = vim.lsp.protocol.Methods
local myutils = require('myutils')
local diagnostic_icons = {
  ERROR = '',
  WARN = '',
  HINT = '',
  INFO = '',
}

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
  local mymappings = require('mymappings')

  myutils.load_mapping(mymappings.lsp(bufnr))

  local conditional_lsp_methods = mymappings.conditional_lsp_methods(bufnr)
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

  local buf_file_name = vim.fn.bufname(bufnr)
  if client.supports_method(methods.textDocument_inlayHint) and not buf_file_name:match("%.js$") and not buf_file_name:match("%.jsx") then
    local inlay_hints_group = vim.api.nvim_create_augroup('branimir/toggle_inlay_hints', { clear = false })

    -- Initial inlay hint display.
    -- Idk why but without the delay inlay hints aren't displayed at the very start.
    vim.defer_fn(function()
      local mode = vim.api.nvim_get_mode().mode
      -- TODO:: Use this line in older neovim versions
      -- vim.lsp.inlay_hint.enable(bufnr, mode == 'n' or mode == 'v')
      vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v')
    end, 500)

    vim.api.nvim_create_autocmd('InsertEnter', {
      group = inlay_hints_group,
      desc = 'Enable inlay hints',
      buffer = bufnr,
      callback = function()
        -- TODO:: Use this line in older neovim versions
        -- vim.lsp.inlay_hint.enable(bufnr, false)
        vim.lsp.inlay_hint.enable(false)
      end,
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
      group = inlay_hints_group,
      desc = 'Disable inlay hints',
      buffer = bufnr,
      callback = function()
        -- TODO:: Use this line in older neovim versions
        -- vim.lsp.inlay_hint.enable(bufnr, true)
        vim.lsp.inlay_hint.enable(true)
      end,
    })
  end
end

-- Define the diagnostic signs.
for severity, icon in pairs(diagnostic_icons) do
  local formated_severity = severity:sub(1, 1) .. severity:sub(2):lower()
  local hl = 'DiagnosticSign' .. formated_severity
  vim.fn.sign_define(hl, { text = '', texthl = hl, numhl = 'LspDiagnosticsLineNr' .. formated_severity })
end

vim.cmd('highlight LspDiagnosticsLineNrError gui=bold guifg=#ff5370 guibg=#312a34')
vim.cmd('highlight LspDiagnosticsLineNrWarning gui=bold guifg=#f78c6c guibg=#312e3a')
vim.cmd('highlight LspDiagnosticsLineNrHint gui=bold guifg=#862AA1 guibg=#312e3a')

-- Diagnostic configuration.
vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local icon = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
      local message = vim.split(diagnostic.message, '\n')[1]
      return string.format('%s %s ', icon, message)
    end,
  },
  float = {
    border = 'rounded',
    source = 'if_many',
    -- Show severity icons as prefixes.
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      local prefix = string.format(' %s ', diagnostic_icons[level])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
  -- Disable signs in the gutter.
  -- signs = false,
}

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2)
      return diag1.severity > diag2.severity
    end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end,
  hide = hide_handler,
}

local md_namespace = vim.api.nvim_create_namespace 'branimir/lsp_float'

--- Adds extra inline highlights to the given buffer.
---@param buf integer
local function add_inline_highlights(buf)
  for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    for pattern, hl_group in pairs {
      ['@%S+'] = '@parameter',
      ['^%s*(Parameters:)'] = '@text.title',
      ['^%s*(Return:)'] = '@text.title',
      ['^%s*(See also:)'] = '@text.title',
      ['{%S-}'] = '@parameter',
      ['|%S-|'] = '@text.reference',
    } do
      local from = 1 ---@type integer?
      while from do
        local to
        from, to = line:find(pattern, from)
        if from then
          vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
            end_col = to,
            hl_group = hl_group,
          })
        end
        from = to and to + 1 or nil
      end
    end
  end
end

--- LSP handler that adds extra inline highlights, keymaps, and window options.
--- Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer?, integer?
---@param focusable boolean
---@return fun(err: any, result: any, ctx: any, config: any)
local function enhanced_float_handler(handler, focusable)
  return function(err, result, ctx, config)
    local bufnr, winnr = handler(
      err,
      result,
      ctx,
      vim.tbl_deep_extend('force', config or {}, {
        border = 'rounded',
        focusable = focusable,
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = math.floor(vim.o.columns * 0.6),
      })
    )

    if not bufnr or not winnr then
      return
    end

    -- Conceal everything.
    vim.wo[winnr].concealcursor = 'n'

    -- Extra highlights.
    add_inline_highlights(bufnr)

    -- Add keymaps for opening links.
    if focusable and not vim.b[bufnr].markdown_keys then
      vim.keymap.set('n', 'K', function()
        -- Vim help links.
        local url = (vim.fn.expand '<cWORD>' --[[@as string]]):match '|(%S-)|'
        if url then
          return vim.cmd.help(url)
        end

        -- Markdown links.
        local col = vim.api.nvim_win_get_cursor(0)[2] + 1
        local from, to
        from, to, url = vim.api.nvim_get_current_line():find '%[.-%]%((%S-)%)'
        if from and col >= from and col <= to then
          vim.system({ 'open', url }, nil, function(res)
            if res.code ~= 0 then
              vim.notify('Failed to open URL' .. url, vim.log.levels.ERROR)
            end
          end)
        end
      end, { buffer = bufnr, silent = true })
      vim.b[bufnr].markdown_keys = true
    end
  end
end
vim.lsp.handlers[methods.textDocument_hover] = enhanced_float_handler(vim.lsp.handlers.hover, true)
vim.lsp.handlers[methods.textDocument_signatureHelp] = enhanced_float_handler(vim.lsp.handlers.signature_help, false)

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  add_inline_highlights(bufnr)

  return contents
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})

return M

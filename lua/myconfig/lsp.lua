-- Most of the code here was extracted from here:
-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/lsp.lua

local methods = vim.lsp.protocol.Methods
local myutils = require('myutils')
local myconfig = require('myconfig')
local diagnostic_icons = {
  ERROR = '',
  WARN = '',
  HINT = '',
  INFO = '',
}

local M = {}

--- Returns the editor's capabilities + some overrides.
--- It is used by the myplugins.lua file
---@return lsp.ClientCapabilities
M.client_capabilities = function()
  return vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers.
    -- require('cmp_nvim_lsp').default_capabilities()
    require('blink.cmp').get_lsp_capabilities(),
    {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    }
  )
end

local ATTACHED_AUTOCMD = {}
local function get_registered_lsp_method_autcmds(client_id, bufnr)
  if not ATTACHED_AUTOCMD[bufnr] then
    ATTACHED_AUTOCMD[bufnr] = {}
  end
  if not ATTACHED_AUTOCMD[bufnr][client_id] then
    ATTACHED_AUTOCMD[bufnr][client_id] = {}
  end
  return ATTACHED_AUTOCMD[bufnr][client_id]
end
local function register_lsp_method_autocmds(client_id, bufnr, autocmd_id, ref)
  local t = get_registered_lsp_method_autcmds(client_id, bufnr)
  table.insert(t, {id = autocmd_id, ref = ref})
end

local function clear_lsp_method_autocmd(client_id, bufnr)
  if not ATTACHED_AUTOCMD[bufnr] then
    ATTACHED_AUTOCMD[bufnr] = {}
  end
  ATTACHED_AUTOCMD[bufnr][client_id] = {}
end

--- Sets up LSP keymaps and autocommands for the given buffer.
--- This function it is called by each lsp client that tries to attach
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  local client_id = client.id
  local mymappings = require('mymappings')

  myutils.load_mapping(mymappings.lsp(bufnr))

  local conditional_lsp_methods = mymappings.conditional_lsp_methods(bufnr)
  for method, mapping in pairs(conditional_lsp_methods) do
    if client:supports_method(method, bufnr) then
      myutils.load_mapping(mapping)
    end
  end

  if client:supports_method(methods.textDocument_documentHighlight, bufnr) then
    myutils.log("Method "..methods.textDocument_documentHighlight.." is supported by "..client.name.."("..client_id.."). Creating highlight autocmds")

    local under_cursor_highlights_group =
        vim.api.nvim_create_augroup('branimir/cursor_highlights', { clear = false })

    register_lsp_method_autocmds(client_id, bufnr,
      vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'BufEnter' }, {
        group = under_cursor_highlights_group,
        desc = 'Highlight references under the cursor',
        buffer = bufnr,
        callback = function ()
          if myconfig.REFERENCES_ON_CURSOR_HOLD then
            vim.lsp.buf.document_highlight()
          end
        end
      }),
      "Highlight references"
    )
    register_lsp_method_autocmds(client_id, bufnr,
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
        group = under_cursor_highlights_group,
        desc = 'Clear highlight references',
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      }),
      "Clear references"
    )
  end

  -- local buf_file_name = vim.fn.bufname(bufnr)
  -- if client.supports_method(methods.textDocument_inlayHint) and not buf_file_name:match("%.js$") and not buf_file_name:match("%.jsx") then
  --   local inlay_hints_group = vim.api.nvim_create_augroup('branimir/toggle_inlay_hints', { clear = false })
  --   local nvim_major_version = vim.version().major
  --   local nvim_minor_version = vim.version().minor
  --   -- Initial inlay hint display.
  --   -- Idk why but without the delay inlay hints aren't displayed at the very start.
  --   vim.defer_fn(function()
  --     local mode = vim.api.nvim_get_mode().mode
  --     if nvim_major_version == 0 and nvim_minor_version < 10 then
  --       ---@diagnostic disable-next-line: param-type-mismatch
  --       vim.lsp.inlay_hint.enable(bufnr, mode == 'n' or mode == 'v')
  --     else
  --       vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = bufnr })
  --     end
  --   end, 500)
  --
  --   register_lsp_method_autocmds(client_id, bufnr,
  --     vim.api.nvim_create_autocmd('InsertEnter', {
  --       group = inlay_hints_group,
  --       desc = 'Enable inlay hints',
  --       buffer = bufnr,
  --       callback = function()
  --         if nvim_major_version == 0 and nvim_minor_version < 10 then
  --           ---@diagnostic disable-next-line: param-type-mismatch
  --           vim.lsp.inlay_hint.enable(bufnr, false)
  --         else
  --           vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
  --         end
  --       end,
  --     }),
  --     "InsertEnter Enable inlay hints"
  --   )
  --   register_lsp_method_autocmds(client_id, bufnr,
  --     vim.api.nvim_create_autocmd('InsertLeave', {
  --       group = inlay_hints_group,
  --       desc = 'Disable inlay hints',
  --       buffer = bufnr,
  --       callback = function()
  --         if nvim_major_version == 0 and nvim_minor_version < 10 then
  --           ---@diagnostic disable-next-line: param-type-mismatch
  --           vim.lsp.inlay_hint.enable(bufnr, true)
  --         else
  --           vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  --         end
  --       end,
  --     }),
  --     "InsertLeave disable inlay hints"
  --   )
  -- end
end

---@param client vim.lsp.Client
---@param bufnr integer
local function on_detach(client, bufnr)
  local client_id = client.id
  local autocmd_ids = get_registered_lsp_method_autcmds(client_id, bufnr)
  ---@diagnostic disable-next-line: unused-local
  for index, autocmd_record in ipairs(autocmd_ids) do
    myutils.log("Removing autocmd \""..autocmd_record.ref.."\" from buffer="..bufnr.." clientId="..client_id)
    vim.api.nvim_del_autocmd(autocmd_record.id)
  end
  clear_lsp_method_autocmd(client_id, bufnr)
end

local signs = {
  text = {},
  numhl = {},
  texthl = {}
}
-- Define the diagnostic signs.
---@diagnostic disable-next-line: unused-local
for severity, icon in pairs(diagnostic_icons) do
  local formated_severity = severity:sub(1, 1) .. severity:sub(2):lower()
  local severity_id = vim.diagnostic.severity[severity]
  signs.text[severity_id] = ''
  signs.numhl[severity_id] = 'LspDiagnosticsLineNr'..formated_severity
  signs.texthl[severity_id] = 'DiagnosticSign' .. formated_severity
end

-- Diagnostic configuration.
vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    spacing = 2,
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
  signs = signs,
}

vim.cmd('highlight LspDiagnosticsLineNrError gui=bold guifg=#ff5370 guibg=#312a34')
vim.cmd('highlight LspDiagnosticsLineNrWarn gui=bold guifg=#f78c6c guibg=#312e3a')
vim.cmd('highlight LspDiagnosticsLineNrHint gui=bold guifg=#862AA1 guibg=#312e3a')

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)
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

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP attach',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    myutils.log("Attaching "..client.name.." lsp (clientId="..client.id..") to buffer "..args.buf)
    on_attach(client, args.buf)
  end,
})

-- Clean lsp configuration in case it is suddenly stopped(exited unexpectedly)
vim.api.nvim_create_autocmd('LspDetach', {
  desc = 'Configure LSP detach',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    myutils.log("Detaching "..client.name.." lsp for buffer "..args.buf)
    on_detach(client, args.buf)
  end,
})

-- Taken from: https://www.reddit.com/r/neovim/comments/1jrk37n/help_configuring_eslint_format_on_save_with_new/
M.eslint_fix_all = function(opts)
  opts = opts or {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  vim.validate("bufnr", bufnr, "number")

  local client = opts.client or vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })[1]

  if not client then return end

  local request

  if opts.sync then
    request = function(buf, method, params) client:request_sync(method, params, nil, buf) end
  else
    request = function(buf, method, params) client:request(method, params, nil, buf) end
  end

  local uri = vim.uri_from_bufnr(bufnr)
  vim.notify('Run EslintFixAll on '..string.gsub(uri, 'file://', ''))
  request(bufnr, "workspace/executeCommand", {
    command = "eslint.applyAllFixes",
    arguments = {
      {
        uri = uri,
        version = vim.lsp.util.buf_versions[bufnr],
      },
    },
  })
end

return M

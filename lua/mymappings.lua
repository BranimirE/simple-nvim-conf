local M = {}
local util = require('myutils')
local with_opts = util.with_opts

-- Default mode is normal('n') mode
M = {
  telescope = function()
    return with_opts({
      { '<leader>fg', util.telescope_auto_input(util.get_last_search, true) },
      { '<leader>fg', util.telescope_auto_input(util.get_visual_selection, false), mode = 'v' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>' },
      { '<leader>ff', '<cmd>Telescope find_files<cr>' },
    }, { noremap = true, silent = true })
  end,

  nvim_tree = function(nvim_tree_api, bufnr)
    return with_opts({
      { 'l',    nvim_tree_api.node.open.edit,              desc = 'nvim-tree: Open file' },
      { 'o',    nvim_tree_api.node.open.edit,              desc = 'nvim-tree: Open file' },
      { 't',    nvim_tree_api.node.open.tab,              desc = 'nvim-tree: Open file' },
      { '<cr>', nvim_tree_api.node.open.edit,              desc = 'nvim-tree: Open file' },
      { 'h',    nvim_tree_api.node.navigate.parent_close,  desc = 'nvim-tree: Close Directory' },
      { 'v',    nvim_tree_api.node.open.vertical,          desc = 'nvim-tree: Open on vertical split' },
      { 'L',    util.nvim_tree_smart_split(nvim_tree_api), desc = 'nvim-tree: Smart Split' },
    }, { noremap = true, silent = true, nowait = true, buffer = bufnr })
  end,

  tabufline = function()
    local nvtb = require("nvchad.tabufline")
    local mapping = {}

    for index = 1, 8 do
      table.insert(mapping, {
        '<A-' .. index .. '>',
        function ()
          pcall(nvtb.goto_buf, vim.t.bufs[index])
        end,
        mode = { 'i', 'n', 'v' }, silent = true
      })
    end
    return mapping
  end,

  bufferline = function(bl)
    local mapping = {
      { '<A-9>', function ()
        pcall(bl.go_to, -1)
      end, mode = { 'i', 'n', 'v' }, silent = true }
    }

    for index = 1, 8 do
      table.insert(mapping, {
        '<A-' .. index .. '>',
        function ()
          pcall(bl.go_to, index)
        end,
        mode = { 'i', 'n', 'v' }, silent = true
      })
      -- TODO: Feature - Check if the tab has splits, if so then instead of replacing the current window with the new buffer, change the focus to the windows that is displaying that buffer, or replace the buffer if it is not displayed
      -- keymap.set({'i', 'n', 'v'}, '<M-S-'..index..'>', '<Cmd>tabn '..index..'<CR>', { noremap = true })
    end
    return mapping
  end,

  nvim_cmp = function(cmp)
    return {
      { '<C-b>',     cmp.mapping.scroll_docs(-4) },
      { '<C-f>',     cmp.mapping.scroll_docs(4) },
      { '<C-Space>', cmp.mapping.complete() },
      { '<C-e>',     cmp.mapping.abort() },
      { '<CR>',      cmp.mapping.confirm({ select = false }) }, -- select = false to confirm explicitly selected items
      { '<tab>',     util.smart_tab(cmp),                    mode = { 'i', 's' } },
      { '<s-tab>',   util.shift_smart_tab(cmp),              mode = { 'i', 's' } },
    }
  end,

  gitsigns = function(gs, bufnr)
    return with_opts({
      { ']c',         util.next_hunk(gs),             expr = true },
      { '[c',         util.prev_hunk(gs),             expr = true },
      { '<leader>hd', gs.diffthis },                    -- Diff with the current changes
      { '<leader>hD', function() gs.diffthis('~') end } -- Diff with the last commit
    }, { buffer = bufnr })
  end,

  lsp = function(bufnr)
    return with_opts({
      { 'gr',         '<cmd>FzfLua lsp_references<cr>',                   desc = 'Go to references' },
      { 'gt',         '<cmd>FzfLua lsp_typedefs<cr>',                     desc = 'Got to type definition' },
      { '<leader>k',  vim.lsp.buf.hover,                                  desc = 'Hover doc' },
      { '<leader>o',  '<cmd>Lspsaga outline<cr>',                         desc = 'Show Outline' },
      { '<leader>cd', vim.diagnostic.open_float,                          desc = 'Show line diagnostics' },
      { '[e',         '<cmd>Lspsaga diagnostic_jump_prev<cr>',            desc = 'Previous warning/error' },
      { ']e',         '<cmd>Lspsaga diagnostic_jump_next<cr>',            desc = 'Next warning/error' },
      { '[E',         '<cmd>Lspsaga diagnostic_jump_prev severity=1<cr>', desc = 'Previous error' },
      { ']E',         '<cmd>Lspsaga diagnostic_jump_next severity=1<cr>', desc = 'Next error' },
      { 'gi',         vim.lsp.buf.implementation,                         desc = 'Got to the implementation' },
      { '<A-d>',      '<cmd>lua require("snacks").lazygit()<cr>',         desc = 'Open Lazygit',             mode = { 'n', 't' } },
      {
        '<A-h>',
        function()
          local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
          vim.lsp.inlay_hint.enable(not is_enabled)
        end,
        mode = { 'n', 't' },
        desc = 'Toggle inlay hints'
      }
    }, { noremap = true, silent = true, buffer = bufnr })
  end,

  conditional_lsp_methods = function(bufnr)
    local methods = vim.lsp.protocol.Methods
    local mappings = {
      [methods.textDocument_codeAction] = {
        { '<leader>ca', '<cmd>Lspsaga code_action<cr>', desc = 'Code actions' },
        { '<leader>ca', '<cmd>Lspsaga code_action<cr>', desc = 'Code actions', mode = 'v' },
      },
      [methods.textDocument_rename] = {
        { '<leader>rn', '<cmd>Lspsaga rename<cr>', desc = 'Rename' },
      },
      [methods.textDocument_definition] = {
        { 'gd',         vim.lsp.buf.definition,             desc = 'Go to definition' },
        { '<leader>gd', '<cmd>Lspsaga peek_definition<cr>', desc = 'Go to definition (floating)' },
      },
      [methods.textDocument_declaration] = {
        { 'gD', vim.lsp.buf.declaration, desc = 'Go to declaration' }
      },
      [methods.textDocument_signatureHelp] = {
        { 'K', vim.lsp.buf.signature_help, desc = 'Signature help' },
      },
      [methods.textDocument_typeDefinition] = {
        { '<leader>D', vim.lsp.buf.type_definition, desc = 'Go to type definition' },
      }
    }
    for method, mapping in pairs(mappings) do
      mappings[method] = with_opts(mapping, { noremap = true, silent = true, buffer = bufnr })
    end
    return mappings
  end,

  ufo = function()
    return {
      { 'zR', function() require('ufo').openAllFolds() end,  desc = 'Open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' }
    }
  end,

  comment = function()
    return {
      { 'gc', util.uncomment_block, desc = 'Toggle comment', mode = 'o' }
    }
  end,

  fzf_lua = function()
    return {
      { '<leader>ff', '<cmd>FzfLua files<cr>',          desc = 'Find files' },
      { '<leader>fg', '<cmd>FzfLua live_grep_glob<cr>', desc = 'Find Grep' },
      { '<leader>fg', '<cmd>FzfLua grep_visual<cr>',    desc = 'Grep Visual', mode = 'x' },
      { '<leader>fp', '<cmd>FzfLua resume<cr>',         desc = 'Grep Resume' },
    }
  end,

  grug_far = function ()
    return {
      { '<leader>fr', util.search_and_replace, desc = 'Find and replace', mode = { 'n', 'v' } }
    }
  end,

  misc = function()
    return {
      { 'jk',         '<esc>',                          mode = 'i' },      -- Go to normal mode in insert mode
      { '<leader>bd', util.delete_buffer_keep_layout, desc = 'Delete current buffer and preserve layout)' }, -- Close the current buffer
      { '<c-n>',      '<esc>:NvimTreeToggle<cr>', desc = 'Toggle nvim-tree', silent = true },
      { ',',          '<cmd>nohlsearch<cr>', desc = "Clear highlight search" },                             -- As C-l is used by tmux-navigator, use ',' instead
      { '<',          '<gv',                            mode = 'v' },      -- Avoid exit visual mode on left shifting
      { '>',          '>gv',                            mode = 'v' },      -- Avoid exit visual mode on right shifting
      { '<up>',       util.move_with_arrows('<up>'),   silent = true },   -- Use up arrow to navigate up in quickfix list.
      { '<down>',     util.move_with_arrows('<down>'), silent = true },   -- Use down arrow to navigate down in quickfix list.
      { '<right>',    '<cmd>tabnext<cr>',              silent = true },   -- Go to next tab. TODO: enable only if there is more than 1 tab opened
      { '<left>',     '<cmd>tabprevious<cr>',          silent = true },   -- Go to previous tab. TODO: The same as above
      { '<f10>', '<cmd>Trouble workspace_diagnostics<cr>', silent = true }, -- Open diagnostics with F9
      { 'J',          ":m '>+1<CR>gv=gv",               mode = 'v' },     -- Move visual block one line up
      { 'K',          ":m '<-2<CR>gv=gv",               mode = 'v' },     -- Move visual block one line down
      { '<leader>y',  '"+y',                            mode = { 'n', 'v' } }, -- Copy to the systemclipboard
      -- { '<leader>d',  '"_d',                            mode = { 'n', 'v' } }, -- Delete without without overwriting the clipboard
      { '<c-s>', '<esc>:w<cr>',                         mode = { 'n', 'i' } }, -- Mapping Ctrl+s to save the file
      { '<f9>',       '<esc>:RunNpmCommand<cr>',            mode = { 'n', 'i' } }
    }
  end,

  quicker = function()
    return {
      {
        '>',
        function()
          require('quicker').expand { before = 2, after = 2, add_to_existing = true }
        end,
        desc = 'Expand context'
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse context'
      },
    }
  end,
}

return M

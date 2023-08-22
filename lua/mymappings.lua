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
      { '<leader>q', vim.diagnostic.setloclist },
      { 'gD',        vim.lsp.buf.declaration },
      { 'gd',        vim.lsp.buf.definition },
      { 'gi',        vim.lsp.buf.implementation },
      { 'K',     vim.lsp.buf.signature_help },
      { '<leader>D', vim.lsp.buf.type_definition },
      { 'gr',        vim.lsp.buf.references },
    }, { noremap = true, silent = true, buffer = bufnr })
  end,

  lsp_saga = function()
    return with_opts({
      -- { 'gh',         '<cmd>Lspsaga finder<CR>' }, -- It is used by nvim to go to selection mode
      { '<leader>rn', '<cmd>Lspsaga rename<cr>' },
      { '<leader>gd', '<cmd>Lspsaga peek_definition<cr>' },
      { '<leader>cd', '<cmd>Lspsaga show_line_diagnostics<cr>' },
      { '[e',         '<cmd>Lspsaga diagnostic_jump_prev<cr>' },
      { ']e',         '<cmd>Lspsaga diagnostic_jump_next<cr>' },
      { '[E',         '<cmd>Lspsaga diagnostic_jump_prev severity=1<cr>' },
      { ']E',         '<cmd>Lspsaga diagnostic_jump_next severity=1<cr>' },
      { '<leader>o',  '<cmd>Lspsaga outline<cr>' },
      { '<leader>k',  '<cmd>Lspsaga hover_doc<cr>' },
      { '<leader>ca', '<cmd>Lspsaga code_action<cr>' },
      { '<leader>ca', '<cmd>Lspsaga code_action<cr>', mode = 'v' },
      { '<A-d>',      '<cmd>Lspsaga term_toggle lazygit<cr>', mode = { 'n', 't' } }
    }, { silent = true })
  end,

  neotest = function ()
    return {
      { '<f9>', util.run_current_file_tests},
    }
  end,

  misc = function()
    return {
      { 'jk',         '<esc>',                          mode = 'i' },      -- Go to normal mode in insert mode
      { '<leader>bd', '<esc>:bp|sp|bn|bd<cr>' },                                    -- Close the current buffer
      { '<c-n>',      '<esc>:NvimTreeToggle<cr>',       silent = true },
      { ',',          '<cmd>nohlsearch<cr>' },                             -- As C-l is used by tmux-navigator, use ',' instead
      { '<',          '<gv',                            mode = 'v' },      -- Avoid exit visual mode on left shifting
      { '>',          '>gv',                            mode = 'v' },      -- Avoid exit visual mode on right shifting
      { '<up>',       util.move_with_arrows('<up>'),   silent = true },   -- Use up arrow to navigate up in quickfix list.
      { '<down>',     util.move_with_arrows('<down>'), silent = true },   -- Use down arrow to navigate down in quickfix list.
      { '<right>',    '<cmd>tabnext<cr>',              silent = true },   -- Go to next tab. TODO: enable only if there is more than 1 tab opened
      { '<left>',     '<cmd>tabprevious<cr>',          silent = true },   -- Go to previous tab. TODO: The same as above
      { '<f10>', '<cmd>Trouble workspace_diagnostics<cr>', silent = true } -- Open diagnostics with F9
    }
  end
}

return M

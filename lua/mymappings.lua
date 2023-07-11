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
      { 'l', nvim_tree_api.node.open.edit, desc = 'nvim-tree: Open file' },
      { 'o', nvim_tree_api.node.open.edit, desc = 'nvim-tree: Open file' },
      { '<cr>', nvim_tree_api.node.open.edit, desc = 'nvim-tree: Open file' },
      { 'h', nvim_tree_api.node.navigate.parent_close, desc = 'nvim-tree: Close Directory' },
      { 'v', nvim_tree_api.node.open.vertical, desc = 'nvim-tree: Open on vertical split' },
      { 'L', util.nvim_tree_smart_split(nvim_tree_api), desc = 'nvim-tree: Smart Split' },
    }, { noremap = true, silent = true, nowait = true, buffer = bufnr })
  end,

  bufferline = function()
    local mapping = {
      { '<A-9>', '<cmd>BufferLineGoToBuffer -1<cr>', mode = { 'i', 'n', 'v' } }
    }

    for index = 1,8 do
      table.insert(mapping, { '<A-'..index..'>', '<cmd>BufferLineGoToBuffer '..index..'<cr>', mode = {'i', 'n', 'v'} } ) -- TODO: Feature - Check if the tab has splits, if so then instead of replacing the current window with the new buffer, change the focus to the windows that is displaying that buffer, or replace the buffer if it is not displayed
      -- keymap.set({'i', 'n', 'v'}, '<M-S-'..index..'>', '<Cmd>tabn '..index..'<CR>', { noremap = true })
    end
    return mapping
  end,

  nvim_cmp = function(cmp)
    return {
      {'<C-b>', cmp.mapping.scroll_docs(-4)},
      {'<C-f>', cmp.mapping.scroll_docs(4)},
      {'<C-Space>', cmp.mapping.complete()},
      {'<C-e>', cmp.mapping.abort()},
      {'<CR>', cmp.mapping.confirm({ select = false })}, -- select = false to confirm explicitly selected items
    }
  end,

  misc = function()
    return {
      { 'jk', '<esc>', mode = 'i' }, -- Go to normal mode in insert mode
      { '<leader>bd', '<esc>:bd<cr>' }, -- Close the current buffer
      { '<tab>', util.smart_tab, mode = { 'i', 's' } },
      { '<s-tab>', util.shift_smart_tab, mode = { 'i', 's' } },
      { '<c-n>',  '<esc>:NvimTreeToggle<cr>'},
      { ',', '<cmd>nohlsearch<cr>' }, -- As C-l is used by tmux-navigator, use ',' instead
    }
  end
}

return M

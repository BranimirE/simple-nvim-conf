local M = {}
local util = require('myutils')
local with_opts = util.with_opts

-- Default mode='n'
M = {
  telescope = function()
    return with_opts({
      { '<leader>fg', util.telescope_auto_input(util.getLastSearch, true) },
      { '<leader>fg', util.telescope_auto_input(util.getVisualSelection, false), mode = 'v' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>' },
      { '<leader>ff', '<cmd>Telescope find_files<cr>' },
    }, { noremap = true, silent = true })
  end,

  nvim_tree = function(nvim_tree_api, bufnr)
    return with_opts({
      { 'l', nvim_tree_api.node.open.edit, desc = 'nvim-tree: Open file' }
    }, { noremap = true, silent = true, nowait = true, buffer = bufnr })
  end
}
-- local function opts(desc)
--   return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
-- end
-- vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
-- vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
-- vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
-- vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
-- vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
-- vim.keymap.set('n', 'L', function ()
--   local current_layout = vim.fn.winlayout()
--   local first_level_split = current_layout[1]
--   local first_level_layout = current_layout[2]
--   if first_level_split == "row" then
--     local columns_count = 0
--     for _ in pairs(first_level_layout) do
--       columns_count = columns_count + 1
--     end
--     -- nvim-tree | panel | panel = 3
--     if columns_count == 3 then
--       api.node.open.horizontal()
--       return
--     end
--   end
--   api.node.open.vertical()
-- end, opts('Open: Vertical Split'))

function M.misc()
  local keymap = vim.keymap

  keymap.set('i', 'jk', '<esc>') -- Press jk to go normal mode in insert mode
  keymap.set('n', '<leader>bd', '<esc>:bd<cr>') -- Close the current buffer
  keymap.set({'i', 's'}, '<Tab>', util.smart_tab)
  keymap.set({'i', 's'}, '<S-Tab>', util.shift_smart_tab)
  keymap.set({'i', 'n'}, '<C-n>', '<esc>:NvimTreeToggle<cr>', { silent = true })

  -- Change current tabpage
  for index = 1,8 do
    keymap.set({'i', 'n', 'v'}, '<A-'..index..'>', '<Cmd>BufferLineGoToBuffer '..index..'<CR>') -- TODO: Feature - Check if the tab has splits, if so then instead of replacing the current window with the new buffer, change the focus to the windows that is displaying that buffer, or replace the buffer if it is not displayed
    -- keymap.set({'i', 'n', 'v'}, '<M-S-'..index..'>', '<Cmd>tabn '..index..'<CR>', { noremap = true })
  end
  keymap.set({'i', 'n', 'v'}, '<A-9>', '<Cmd>BufferLineGoToBuffer -1<CR>')
  -- <M-S-1> mapping does not work correctly this map <M-S-1> correctly
  -- keymap.set({'i', 'n', 'v'}, '<M-4>0', '<Cmd>tabn 1<CR>', { noremap = true })
  -- Inside tmux <M-S-{index}> are not being sent correctly, this is a workaround for English keyboard
  -- keymap.set({'i', 'n', 'v'}, '<M-@>', '<Cmd>tabn 2<CR>', { noremap = true })
  -- keymap.set({'i', 'n', 'v'}, '<M-#>', '<Cmd>tabn 3<CR>', { noremap = true })
  -- keymap.set({'i', 'n', 'v'}, '<M-$>', '<Cmd>tabn 4<CR>', { noremap = true })


  -- As we are using Ctrl+l to move to the right panel, we are remapping its functionality to ','
  keymap.set('n', ',', '<cmd>nohlsearch<cr>')
end

return M

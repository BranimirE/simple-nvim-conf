local M = {}
local util = require('myutils')

M.telescope = {
  {'<leader>fg', util.telescope_auto_input(util.getLastSearch, true), { noremap = true, silent = true }},
  {'<leader>fg', util.telescope_auto_input(util.getVisualSelection, false), mode = 'v', { noremap = true, silent = true }},
  {'<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true }},
  {'<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true }},
}

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

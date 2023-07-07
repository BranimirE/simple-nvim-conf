local M = {}

-- UTILS --
function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(M.t(key), mode, true)
end

-- LOGIC --

local exist_cmp, cmp = pcall(require, 'cmp')

function M.smart_tab()
  if exist_cmp and cmp.visible() then
    cmp.confirm({ select = true })
  else
    local exist_vsnip, vsnip_available = pcall(vim.fn['vsnip#available'])
    if exist_vsnip and vsnip_available == 1 then
      M.feedkey('<Plug>(vsnip-expand-or-jump)', '')
    else
      M.feedkey([[<Tab>]], 'n')
    end
  end
end

function M.shift_smart_tab()
  if exist_cmp and cmp.visible() then
    cmp.select_prev_item()
  else
    local exist_vsnip, vsnip_jumpable = pcall(vim.fn['vsnip#jumpable'], -1)
    if exist_vsnip and vsnip_jumpable == 1 then
      M.feedkey('<Plug>(vsnip-jump-prev)', '')
    else
      M.feedkey([[<S-Tab>]], 'n')
    end
  end
end

-- MAPPINGS --
local keymap = vim.keymap

keymap.set('i', 'jk', '<esc>') -- Press jk to go normal mode in insert mode
keymap.set('n', '<leader>bd', '<esc>:bd<cr>') -- Close the current buffer
keymap.set({'i', 's'}, '<Tab>', M.smart_tab)
keymap.set({'i', 's'}, '<S-Tab>', M.shift_smart_tab)
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

-- Auto search selected text in visual mode if telescope live grep is opened
keymap.set('v', '<leader>fg', function()
  local text = require('myutils').getVisualSelection()
  require('telescope.builtin').live_grep({ default_text = text })
end, { noremap = true, silent = true })

-- Auto search last nvim searched string with / when telescope live grep is opened
keymap.set('n', '<leader>fg', function()
  local text = require('myutils').getLastSearch()
  vim.cmd(M.t('nohlsearch')) -- Hide current highlighted search(if it exists)
  require('telescope.builtin').live_grep({ default_text = text })
end, { noremap = true, silent = true })

keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true })
keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })

-- As we are using Ctrl+l to move to the right panel, we are remapping its functionality to ','
keymap.set('n', ',', '<cmd>nohlsearch<cr>')

return M

local M = {}

-- UTILS --
function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(M.t(key), mode, true)
end

-- LOGIC --

local cmp = require('cmp')

function M.smart_tab()
  if cmp.visible() then
    cmp.confirm({ select = true })
  elseif vim.fn['vsnip#available']() == 1 then
    M.feedkey('<Plug>(vsnip-expand-or-jump)', '')
  else
    M.feedkey([[<Tab>]], 'n')
  end
end

function M.shift_smart_tab()
  if cmp.visible() then
    cmp.select_prev_item()
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    M.feedkey('<Plug>(vsnip-jump-prev)', '')
  else
    M.feedkey([[<S-Tab>]], 'n')
  end
end

-- MAPPINGS --
local keymap = vim.keymap

keymap.set('i', 'jk', '<esc>') -- Press jk to go normal mode in insert mode
keymap.set({'i', 's'}, '<Tab>', M.smart_tab)
keymap.set({'i', 's'}, '<S-Tab>', M.shift_smart_tab)
keymap.set({'i', 'n'}, '<C-n>', '<esc>:NvimTreeToggle<cr>')
keymap.set('n', '<leader>bd', '<esc>:bd<cr>')

-- Change current tabpage
for index = 1,8 do
  keymap.set({'i', 'n', 'v'}, '<A-'..tostring(index)..'>', '<Cmd>BufferLineGoToBuffer '..index..'<CR>')
end
keymap.set({'i', 'n', 'v'}, '<A-9>', '<Cmd>BufferLineGoToBuffer -1<CR>')

-- Auto search selected text in visual mode if telescope live grep is opened
keymap.set('v', '<leader>fg', function()
  local text = require('myutils').getVisualSelection()
  require('telescope.builtin').live_grep({ default_text = text })
end, { noremap = true, silent = true })

-- Auto search last nvim searched string with / when telescope live grep is opened
keymap.set('n', '<leader>fg', function()
  local text = require('myutils').getLastSearch()
  -- Hide current highlighted search(if it exists)
  vim.cmd(M.t('nohlsearch'))
  require('telescope.builtin').live_grep({ default_text = text })
end, { noremap = true, silent = true })

keymap.set('n', '<leader>fb', '<cmd>Telescope buffers', { noremap = true, silent = true })
keymap.set('n', '<leader>ff', '<cmd>Telescope find_files previewer=false theme=dropdown<cr>', { noremap = true, silent = true })

-- As we are using Ctrl+l to move to the right panel, we are remapping its functionality to ','
keymap.set('n', ',', '<cmd>nohlsearch<cr>')

return M

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

local bufferline = require("bufferline")

function M.go_to_buffer_fun(destination)
  return function ()
    bufferline.go_to_buffer(destination, true)
  end
end

-- MAPPINGS --

vim.keymap.set({'i', 's'}, '<Tab>', M.smart_tab)
vim.keymap.set({'i', 's'}, '<S-Tab>', M.shift_smart_tab)

for index = 1,8 do
  vim.keymap.set({'i', 'n', 'v'}, '<A-'..tostring(index)..'>', M.go_to_buffer_fun(index))
end
vim.keymap.set({'i', 'n', 'v'}, '<A-9>', M.go_to_buffer_fun(-1))

vim.keymap.set({'i', 'n'}, '<C-n>', '<esc>:NvimTreeToggle<cr>')



return M

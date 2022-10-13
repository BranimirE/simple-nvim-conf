local M = {}

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(M.t(key), mode, true)
end


local cmp = require('cmp')
function M.smartTab()
  if cmp.visible() then
    cmp.confirm({ select = true })
  elseif vim.fn['vsnip#available']() == 1 then
    M.feedkey('<Plug>(vsnip-expand-or-jump)', '')
  else
    M.feedkey([[<Tab>]], 'n')
  end
end

vim.keymap.set({'i', 's'}, '<Tab>', M.smartTab)

return M

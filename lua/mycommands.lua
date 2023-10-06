local myutils = require "myutils"

vim.api.nvim_create_user_command('EnableFormatOnSave', function()
  vim.g.FORMAT_ON_SAVE = true
end, {})

vim.api.nvim_create_user_command('DisableFormatOnSave', function()
  vim.g.FORMAT_ON_SAVE = false
end, {})

vim.api.nvim_create_user_command('ToggleFormatOnSave', function()
  if vim.g.FORMAT_ON_SAVE then
    vim.g.FORMAT_ON_SAVE = false
  else
    vim.g.FORMAT_ON_SAVE = true
  end
end, {})

vim.api.nvim_create_user_command('CloseOthers', function(cmd_opts)
  vim.cmd [[%bd|e#]]
end, {})

-- Create 'Format' command to format the document
vim.api.nvim_create_user_command('Format', myutils.format, { range = '%' })

-- Create 'Todos' command to list all the TODOS in the project
vim.api.nvim_create_user_command('Todos', 'TodoTrouble', {})

-- Disable indent-blankline plugin in big files
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/440#issuecomment-1165399724
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('IndentBlanklineBigFile', {}),
  pattern = '*',
  callback = function()
    if vim.api.nvim_buf_line_count(0) > 5000 then
      local success, blankline_commands = pcall(require, 'indent_blankline.commands')
      if success then
        blankline_commands.disable()
      end
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('LspFormatting', {}),
  pattern = '*',
  callback = function()
    myutils.format()
  end
})

-- Automatically have relative numbers on normal mode for only the focused window, disable it on other modes and windows
-- Taken from: https://jeffkreeftmeijer.com/vim-number/
local autoSetNumberGroup = vim.api.nvim_create_augroup('AutoSetNumberGroup', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  group = autoSetNumberGroup,
  pattern = '*',
  callback = function()
    if vim.opt.number._value and vim.api.nvim_get_mode()['mode'] ~= 'i' then
      vim.opt.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  group = autoSetNumberGroup,
  pattern = '*',
  callback = function()
    if vim.opt.number._value then
      vim.opt.relativenumber = false
    end
  end,
})

vim.api.nvim_create_user_command('RunNpmCommand', myutils.run_npm_command, {})

vim.cmd('hi NvimTreeEmptyFolderName guifg=#00afff')
vim.cmd('hi NvimTreeFolderIcon guifg=#00afff')
vim.cmd('hi NvimTreeFolderName guifg=#00afff')
vim.cmd('hi NvimTreeOpenedFolderName guifg=#00afff')

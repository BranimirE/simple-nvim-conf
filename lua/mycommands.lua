-- Create "Format" command to format the document
vim.api.nvim_create_user_command('Format', function(cmd_opts)
  vim.lsp.buf.format({
    range = {
      ['start'] = { cmd_opts.line1, 0 },
      ['end'] = { cmd_opts.line2, 0 }
    }
  })
end, { range = '%' })

-- Create "Format" command to format the document
vim.api.nvim_create_user_command('Todos', 'TodoTelescope', {})

-- Disable indent-blankline plugin in big files
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/440#issuecomment-1165399724
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("IndentBlanklineBigFile", {}),
  pattern = "*",
  callback = function()
    if vim.api.nvim_buf_line_count(0) > 5000 then
      local success, blankline_commands = pcall(require, 'indent_blankline.commands')
      if success then
        blankline_commands.disable()
      end
    end
  end,
})


vim.cmd('hi NvimTreeEmptyFolderName guifg=#00afff')
vim.cmd('hi NvimTreeFolderIcon guifg=#00afff')
vim.cmd('hi NvimTreeFolderName guifg=#00afff')
vim.cmd('hi NvimTreeOpenedFolderName guifg=#00afff')



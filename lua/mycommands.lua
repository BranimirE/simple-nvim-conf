-- Create "Format" command to format the document
vim.api.nvim_create_user_command('Format', function(cmd_opts)
  vim.lsp.buf.format({
    range = {
      ["start"] = {cmd_opts.line1, 0},
      ["end"] = {cmd_opts.line2, 0}
    }
  })
end, {range='%'})

-- Create "Format" command to format the document
vim.api.nvim_create_user_command('Todos', 'TodoTelescope', {})


require('mysettings')

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('myplugins', {
  defaults = { lazy = true },
  -- install = { colorscheme = { 'nvchad' } },
  checker = { enabled = false },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'bugreport',
        'compiler',
        'editorconfig',
        'ftplugin',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'matchit',
        'netrw',
        'netrwFileHandlers',
        'netrwPlugin',
        'netrwSettings',
        'optwin',
        'rplugin',
        'rrhelper',
        'spellfile_plugin',
        'synmenu',
        'tar',
        'tarPlugin',
        'tohtml',
        'tutor',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
      },
    },
  },
  ui = {
    border = "none",
    -- border = "single",
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },
})

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

vim.api.nvim_create_autocmd('User', {
 pattern = 'VeryLazy',
 callback = function()
  require('myutils').load_mapping(require('mymappings').misc())
  require('mycommands')
 end,
})

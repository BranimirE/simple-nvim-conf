local opt = vim.opt
local g = vim.g
local api = vim.api
vim.keymap.set({'n'}, '<space>', '<nop>', {noremap = true})
vim.keymap.set({'v'}, '<space>', '<nop>', {noremap = true})
g.mapleader = ' ' -- Set space as leader key

opt.splitright = true -- Open new split to the right
opt.splitbelow = true -- Open new split below
opt.joinspaces = false -- prevent joining spaces with J
opt.ignorecase = true -- Make search insensitive
opt.smartcase = true -- Make search sensitive if there is a capital letter
-- opt.signcolumn = 'yes' -- Show the signcolumn always
opt.path = '**' -- Make the project root directory as the dir to search when we use :find or similar commands
opt.foldcolumn = '0' -- How many columns use to show the folding icons, '0' to disable it
opt.foldexpr = 'nvim_treesitter#foldexpr()' -- Set nvim treesitter script to define the folding
opt.foldmethod = 'expr' -- opt.foldexpr option value will give the fold method
opt.foldlevel = 20 -- Automatically open 20 levels of folding when opening a file
-- opt.foldenable = false -- Disable folding at startup
opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... ' . '(' . (v:foldend - v:foldstart + 1) . ' lines)']] -- Set the folding format(How the folded line looks)
opt.fillchars:append [[fold: ,foldopen:,foldsep: ,foldclose:]] -- Update the folding icons on the numbers columns
opt.mouse = 'a' -- Enable mouse on (a)ll modes
opt.showmatch = true -- Show pair of parenthesis/curly brackets/brackets
opt.ruler = true -- Show row and column of the cursor on the status line
opt.cursorline = true -- Highlight the current line
opt.number = true -- Show line numbers column
opt.showcmd = true -- Show the commands that we are writing
opt.encoding = 'utf-8' -- Set default enconding
opt.fillchars:append [[eob: ]] -- Remove ~ chars at the end of the buffer
opt.termguicolors = true -- User GUI version colors(without it, only basic terminal colors will be available)
opt.list = true -- Enable list mode. It shows invisible chars as visible chars(using listchars values)
opt.listchars:append [[tab:→ ,trail:•]] -- Replace some default listchars
opt.pumheight = 12 -- Completion menu max height
opt.showmode = false

opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.relativenumber = true

opt.scrolloff = 8 -- Always have at least 8 lines above and below the highlighted line when we scroll
-- TODO: Avoid that when we return to a buffer it opens the folds that we closed previously
-- Open all the folding that are closed by default when a file is opened
-- vim.api.nvim_create_autocmd({"BufReadPost", 'FileReadPost'}, {
--   pattern = "*",
--   callback = function()
--     -- TODO: Check if this is not affecting to Gvdiff command on git diff
--     require('mymappings').feedkey('zR', 'n')
--   end,
-- })

api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.tyb', '*.typ', '*.tyc', '*.pkb', '*.pks', '*.PKB', '*.PKS'},
  command = [[setf sql]]
})

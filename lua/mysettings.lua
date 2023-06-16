local opt = vim.opt

opt.splitright = true -- Open new split to the right
opt.splitbelow = true -- Open new split below
opt.joinspaces = false -- prevent joining spaces with J
opt.ignorecase = true -- Make search insensitive
opt.smartcase = true -- Make search sensitive if there is a capital letter
-- opt.signcolumn = 'yes' -- Show the signcolumn always

opt.path = '**' -- Make the project root directory as the dir to search when we use :find or similar commands

-- Set nvim-treesitter for folding
opt.foldmethod = 'expr'
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- Automatically open 20 levels of folding on opening a file
opt.foldlevel = 20

-- Open all the folding that are closed by default when a file is opened
-- vim.api.nvim_create_autocmd({"BufReadPost", 'FileReadPost'}, {
--   pattern = "*",
--   callback = function()
--     -- TODO: Check if this is not affecting to Gvdiff command on git diff
--     require('mymappings').feedkey('zR', 'n')
--   end,
-- })

-- How many columns use to show the folding icons, '0' to disable it
vim.o.foldcolumn = '0'
vim.o.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... ' . '(' . (v:foldend - v:foldstart + 1) . ' lines)']]
vim.o.fillchars = [[fold: ,foldopen:,foldsep: ,foldclose:]]


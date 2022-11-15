local opt = vim.opt

opt.splitright = true -- Open new split to the right
opt.splitbelow = true -- Open new split below
opt.joinspaces = false -- prevent joining spaces with J
opt.ignorecase = true -- Make search insensitive
opt.smartcase = true -- Make search sensitive if there is a capital letter
-- opt.signcolumn = 'yes' -- Show the signcolumn always

opt.path = '**' -- Make the project root directory as the dir to search when we use :find or similar commands

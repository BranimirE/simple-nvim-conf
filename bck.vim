lua require('mysettings')
call plug#begin()

" Icons
Plug 'kyazdani42/nvim-web-devicons'
Plug 'onsails/lspkind.nvim'

" Language-Server-Protocol(LSP) completion plugins
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Show help when we are passing arguments to a function
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

" For snippets
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'dsznajder/vscode-es7-javascript-react-snippets', { 'do': 'yarn install --frozen-lockfile && yarn compile' }

" Git
Plug 'lewis6991/gitsigns.nvim'

" Telescope configs
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

" fzf for Telescope
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Use Telescope to manage vim show options to choose
Plug 'nvim-telescope/telescope-ui-select.nvim'

" Show background colors in color strings like #FF0000
Plug 'norcalli/nvim-colorizer.lua'

" Detect indentation in the file
Plug 'tpope/vim-sleuth'

" (Un)Install language server protocols Automatically
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Formatters and linting
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jayp0521/mason-null-ls.nvim'

" Add extra functionality to LSP
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }

" Git plugin
" Adds some useful commands to neovim, like:
"   :Git blame
"   :Gvdiff
Plug 'tpope/vim-fugitive'

" to disable annoying "File is a CommonJS module; it may be converted to an ES module."
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

call plug#end()

lua << EOF

-- " williamboman/mason.nvim
require("mason").setup()

-- " Automatically install lsp configured servers(it needs to be setup before lsp-config)
require("mason-lspconfig").setup({automatic_installation=true})

require("mason-null-ls").setup({
  ensure_installed = {'prettier'}
})

-- " neovim/nvim-lspconfig
require('mylspconfig')

-- " rcarriga/nvim-notify
-- vim.notify = require 'notify'
--
-- local notify = vim.notify
-- vim.notify = function(msg, ...)
--   if type(msg) == 'string' then
--     local is_suppressed_message = msg:match '%[lspconfig] Autostart for' or msg:match 'No information available'
--     if is_suppressed_message then
--       -- Do not show some messages
--       return
--     end
--   end
--
--   notify(msg, ...)
-- end

-- " lewis6991/gitsigns.nvim
require('gitsigns').setup {
  signs = {
    add = { hl = 'GitSignsAdd', text = '▌', numhl = 'GitSignsAddNr' },
    change = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr' },
    delete = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
    topdelete = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
    changedelete = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 100,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> ● <summary>',
  current_line_blame_formatter_nc = 'You, <author_time:%R> ● Uncommitted changes',
  preview_config = {
    border = 'rounded',
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })
    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<leader>hs', gs.stage_hunk)
    map({ 'n', 'v' }, '<leader>hr', gs.reset_hunk)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', 'gp', gs.preview_hunk)
    map('n', '<leader>hb', function()
      gs.blame_line { full = true }
    end)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function()
      gs.diffthis '~'
    end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
}

-- " nvim-telescope/telescope.nvim
require("telescope").setup {
  defaults = {
    file_ignore_patterns = {
      "ext.js",
      "ext-modern.js",
      "ext-modern-all.js",
      "ext-modern-all-sandbox.js",
      "ext-all.js",
      "ext-all-sandbox.js",
      "ext-all-rtl.js",
      "ext-all-rtl-sandbox.js"
    }
  },
  extensions = {
    fzf = {
      fuzzy = false,                   -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },

    ["ui-select"] = {
      require("telescope.themes").get_dropdown { }
    }
  },
  pickers = {
    find_files = {
      theme = 'dropdown',
      previewer = false,
      prompt_prefix = ' 󰱼 '
    },
    live_grep = {
      prompt_prefix = '  '
    }
  }
}

-- "nvim-telescope/telescope-fzf-native.nvim
require('telescope').load_extension('fzf')

-- "nvim-telescope/telescope-ui-select.nvim
require("telescope").load_extension("ui-select")

-- " norcalli/nvim-colorizer.lua
require'colorizer'.setup()

-- " lukas-reineke/indent-blankline.nvim
-- Disable the plugin in very big files
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/440#issuecomment-1165399724
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("IndentBlanklineBigFile", {}),
  pattern = "*",
  callback = function()
    if vim.api.nvim_buf_line_count(0) > 5000 then
      require("indent_blankline.commands").disable()
    end
  end,
})
EOF

" Remove background colors
" hi Normal guibg=NONE ctermbg=NONE

" Use blue colors in NvimTree
" hi NvimTreeEmptyFolderName guifg=#00afff
" hi NvimTreeFolderIcon guifg=#00afff
" hi NvimTreeFolderName guifg=#00afff
" hi NvimTreeOpenedFolderName guifg=#00afff

"hi GitSignsAddNr    gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsChangeNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsDeleteNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsDeleteNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsChangeNr gui=bold guibg=NONE ctermbg=NONE

" highlight SignColumn guibg=NONE

" lua << EOF
" require("catppuccin").setup({
"   transparent_background = true,
"   integrations = {
"   }
" })
" EOF


" Change split lines color
" hi VertSplit guifg=#00afff

" require("one_monokai").setup({
"   use_cmd = true,
"   transparent = true,
"   colors = {
"     gray = "#676e7b",
"     --pink = "#e06c75",
"     pink = "#F92672",
"     --green = "#98c379",
"     green = "#A6E22E",
"     --cyan = "#56b6c2",
"     cyan = "#00afff",
"     aqua = "#61afef",
"     --yellow = "#e5c07b",
"     yellow = "#E6DB74",
"     --purple = "#c678dd",
"     purple = "#AE81FF",
"     peanut = "#f6d5a4",
"     --orange = "#d19a66",
"     orange = "#FD971F",
"     none = "NONE",
"
"     -- support colors
"     red = "#ff0000",
"     --white = "#d7d7ff",
"     white = "#ffffff",
"     light_gray = "#9ca3b2",
"     dark_gray = "#4b5261",
"     --vulcan = "#383a3e",
"     vulcan = "#080a0e",
"     dark_green = "#2d2e27",
"     dark_blue = "#26292f",
"     black = "#1e2024",
"   }
" })


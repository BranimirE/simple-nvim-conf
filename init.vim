lua require('mysettings')
call plug#begin()

" Theme
"Plug 'ayu-theme/ayu-vim'
" Plug 'folke/gcctokyonight.nvim', { 'branch': 'main' }
"Plug 'ful1e5/onedark.nvim'
"Plug 'olimorris/onedarkpro.nvim' 
" Plug 'cpea2506/one_monokai.nvim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
" Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" NvChad's status line
Plug 'nvim-lualine/lualine.nvim'
" Plug 'NvChad/NvChad'
" Plug 'NvChad/base46'
" Plug 'NvChad/ui'

" Icons
Plug 'kyazdani42/nvim-web-devicons'
Plug 'onsails/lspkind.nvim'
" Tabline
" Plug 'BranimirE/nvim-tabline'
" Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'akinsho/bufferline.nvim'

" Auto pairs
Plug 'windwp/nvim-autopairs'

" Language-Server-Protocol(LSP) completion plugins
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Show help when we are passing arguments to a function
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
" Specific features for typescript
" Plug 'jose-elias-alvarez/typescript.nvim'

" For snippets
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
" Plug 'rafamadriz/friendly-snippets'

"Plug 'burkeholland/simple-react-snippets'
Plug 'dsznajder/vscode-es7-javascript-react-snippets', { 'do': 'yarn install --frozen-lockfile && yarn compile' }

" Navigation Tree
Plug 'kyazdani42/nvim-tree.lua'

" Notifications
Plug 'rcarriga/nvim-notify'

" Git
Plug 'lewis6991/gitsigns.nvim'

" Improve highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Autoclose and autorename tags in html(using treesitter)
Plug 'windwp/nvim-ts-autotag'

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
" Plug 'nmac427/guess-indent.nvim'

" (Un)Install language server protocols Automatically
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Formatters and linting
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jayp0521/mason-null-ls.nvim'

" context_commentstring
Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Gitdiff view
"Plug 'sindrets/diffview.nvim'

" Show indent lines
Plug 'lukas-reineke/indent-blankline.nvim'

" Add extra functionality to LSP
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }

" Git plugin
" Adds some useful commands to neovim, like:
"   :Git blame
"
Plug 'tpope/vim-fugitive'

" tmux change panel integration
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" Set space as Leader key
"nnoremap <SPACE> <Nop>
"let mapleader=" "
"
"map <Space> <Leader>
"
"lua vim.g.mapleader = "<Space>"
"
let mapleader = "\<Space>"

"Enable mouse
set mouse=a
set clipboard=unnamed
syntax enable
"show the commands that we are writing
set showcmd
"show the row and col
set ruler

set encoding=utf-8

"show pair of a parenthesis
set showmatch

"use two spaces instead of tabs
"set sw=2

"as we are going to install a pluging we dont need to show the mode
" set noshowmode

"highlight the current line
set cursorline

"Show line numbers
set number

"Remove ~ chars at the end of the buffer
"Only works for neovim, note that there is ' ' (a blank space) after the '\' char
set fillchars+=eob:\ 

"Setting the theme
set termguicolors

" akinsho/bufferline.nvim
lua << EOF
  require("bufferline").setup {
    options = {
      -- mode = "tabs",
      -- numbers = "ordinal",
      color_icons = true,
      -- separator_style = "slant",
      separator_style = {"", ""},
      indicator = {
        style = 'none'
      },
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "NvimTree",
          padding = 1 -- For some reason it is not calculating the value correctly, this fix it
        },
      },
      hover = {
        enabled = true,
        delay = 200,
        reveal = {'close'}
      }
    },
    highlights = {
      buffer_selected = {
        fg = "#DDDDDD",
      },
      -- close_button_selected = {
      --   fg = "#EEEEEE",
      -- }
    }
  }
EOF

" " BranimirE/nvim-tabline
" lua << EOF
"   require('tabline').setup({
"       show_index = false,        -- show tab index
"       show_modify = true,       -- show buffer modification indicator
"       show_icon = true,        -- show file extension icon
"       modify_indicator = 'M', -- modify indicator
"       no_name = 'No name',      -- no name buffer name
"       brackets = { '', '' },  -- file name brackets surrounding
"       nvimtree_side = 'left', -- nvimtree integration
"   })
" EOF


" lua << EOF
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
" EOF

" NvChad/base46 && NvChad/ui
lua << EOF
  -- vim.g.nvchad_theme = "onedark"
  -- vim.g.nvchad_theme = "radium"
  -- require("base46").load_theme()
  -- require("base46").load_highlight("statusline")

  -- function _G.nvchadstatusline()
  --   return require("nvchad_ui.statusline").run({
  --     separator_style = "default", -- default/round/block/arrow
  --   })
  -- end
  -- vim.opt.statusline = "%!v:lua.nvchadstatusline()"
  -- vim.opt.laststatus = 3 -- show only a global statusline
EOF


" nvim-lualine/lualine.nvim
lua require('myconfig/evil_lualine')

" windwp/nvim-autopairs
lua << EOF
  require("nvim-autopairs").setup {
    check_ts = true, -- check treesitter for autopairing
    enable_moveright = true,
  }
EOF

" williamboman/mason.nvim
lua require("mason").setup()
" Automatically install lsp configured servers(it needs to be setup before lsp-config)
lua require("mason-lspconfig").setup({automatic_installation=true})

lua << EOF
  require("mason-null-ls").setup({
    ensure_installed = {'prettier'}
  })
EOF

" neovim/nvim-lspconfig
lua require('mylspconfig')

" hrsh7th/vim-vsnip
" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

" kyazdani42/nvim-tree.lua
lua << EOF
require("nvim-tree").setup({
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- BEGIN_DEFAULT_ON_ATTACH
    api.config.mappings.default_on_attach(bufnr)
    -- END_DEFAULT_ON_ATTACH

    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
    vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
  end,
  renderer = {
    root_folder_label = false,
    highlight_opened_files = 'all',
    -- show indent lines(vertical lines)
    indent_markers = {
      enable = true,
    },
    icons = {
      -- position files' git status icon
      git_placement = "after",
      show = {
        folder_arrow = false, 
        -- show files' git status icons
        git = true,
      },
    },
  },
  -- highlight current opened file when we change the focus
  update_focused_file = {
    enable = true,
  },
  -- maintain cursor on the first letter of the file name
  hijack_cursor = true,
  git = {
    ignore = false -- hide files/dirs in gitignore?
  },
})
EOF
" Not migrated configs. TODO: Review them
" lua << EOF
"   -- https://github.com/kyazdani42/nvim-tree.lua/issues/674
"   local tree_cb = require'nvim-tree.config'.nvim_tree_callback
"   require("nvim-tree").setup {
"     renderer = {
"       highlight_git = false,
"     },
"     diagnostics = {
"       enable = true,
"     },
"     view = {
"       adaptive_size = true,
"       side = "left",
"       width = 25,
"       hide_root_folder = true,
"     },
"     filesystem_watchers = {
"       enable = true,
"     },
"     actions = {
"       open_file = {
"         resize_window = true,
"       },
"     },
"   }
" EOF
" map <C-n> :NvimTreeToggle<CR>

" rcarriga/nvim-notify
lua << EOF
  require("notify").setup({
    background_colour = "#000000",
  })
  vim.notify = require 'notify'

  local notify = vim.notify
  vim.notify = function(msg, ...)
    if type(msg) == 'string' then
      local is_suppressed_message = msg:match '%[lspconfig] Autostart for' or msg:match 'No information available'
      if is_suppressed_message then
        -- Do not show some messages
        return
      end
    end

    notify(msg, ...)
  end
EOF

" lewis6991/gitsigns.nvim
lua << EOF
require('gitsigns').setup {
  signs = {
    add = { hl = 'GitSignsAdd', text = '▌', numhl = 'GitSignsAddNr' },
    change = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr' },
    delete = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
    -- delete = { hl = 'GitSignsDelete', text = '▌_', numhl = 'GitSignsDeleteNr' },
    topdelete = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
    -- topdelete = { hl = 'GitSignsDelete', text = '▌‾', numhl = 'GitSignsDeleteNr' },
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
  --current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> ⏺ <summary>',
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
EOF

" nvim-treesitter/nvim-treesitter

lua << EOF
  require('nvim-treesitter.configs').setup {
    -- A list of parser names, or "all"
    ensure_installed = { "vim", "lua", "javascript", "bash", "css", "json", "json5", "python", "typescript", "html", "yaml", 'markdown', 'markdown_inline', 'scss', 'jsdoc', 'tsx'},
    sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
    auto_install = true, -- Automatically install missing parsers when entering buffer
    -- ignore_install = { "javascript" }, -- List of parsers to ignore installing (for "all")
    highlight = {
      enable = true, -- `false` will disable the whole extension
      disable = function(lang, bufnr)
        if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
          return false
        end
        local n_lines = vim.api.nvim_buf_line_count(bufnr)
        -- https://github.com/dapc11/dnvim/blob/2724e18d558a0abf268b9443b7cbdc4cc2c73131/lua/core/autocommands.lua#L38
        return  n_lines > 5000 or (n_lines > 0 and  vim.fn.getfsize(vim.fn.expand("%")) / n_lines > 10000)
      end,
      use_languagetree = true, -- use this to enable language injection
      -- disable = { "c", "rust" }, -- list of language that will be disabled

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true, -- Indent with = using treesitter
    },
    autotag = {
      enable = true,
    },
    autopairs = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  }
EOF

" nvim-telescope/telescope.nvim
lua << EOF
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
  }
}
EOF
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({}))<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

"nvim-telescope/telescope-fzf-native.nvim
lua require('telescope').load_extension('fzf')

"nvim-telescope/telescope-ui-select.nvim
lua require("telescope").load_extension("ui-select")

" norcalli/nvim-colorizer.lua
lua require'colorizer'.setup()

" numToStr/Comment.nvim
lua << EOF
  require('Comment').setup {
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  }
EOF

" lukas-reineke/indent-blankline.nvim
let g:indent_blankline_char = '▏'
lua << EOF
require("indent_blankline").setup {
  -- for example, context is off by default, use this to turn it on
  --char = '',
  show_current_context = true,
  --show_current_context_start = true,
  use_treesitter = true,
  show_trailing_blankline_indent = false,
  show_first_indent_level = false, -- so we can detect if the line is only composed by trailing whitespaces
  max_indent_increase = 1
}

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
" highlight IndentBlanklineContextChar guifg=#2f2f2f gui=nocombine
" highlight IndentBlanklineChar guifg=#101010  gui=nocombine

"Remove Alacritty padding when nvim is opened
lua << EOF
  function Sad(line_nr, from, to, fname)
    vim.cmd(string.format("silent !sed -i '%ss/%s/%s/' %s", line_nr, from, to, fname))
  end

  function IncreasePadding()
    Sad('52', 0, 8, '~/.config/alacritty/alacritty.yml')
    Sad('53', 0, 8, '~/.config/alacritty/alacritty.yml')
  end

  function DecreasePadding()
    Sad('52', 8, 0, '~/.config/alacritty/alacritty.yml')
    Sad('53', 8, 0, '~/.config/alacritty/alacritty.yml')
  end
EOF

"autocmd VimEnter * lua DecreasePadding()
"autocmd VimLeavePre * lua IncreasePadding()

" Remove background colors
" hi Normal guibg=NONE ctermbg=NONE


" Use blue colors in NvimTree
" hi NvimTreeEmptyFolderName guifg=#00afff
" hi NvimTreeFolderIcon guifg=#00afff
" hi NvimTreeFolderName guifg=#00afff
" hi NvimTreeOpenedFolderName guifg=#00afff
"
"
" Overwrite base46 colors for statusline
" hi St_NormalMode guibg=#00afff
" hi St_NormalModeSep guifg=#00afff

hi LspDiagnosticsLineNrError gui=bold guifg=#ff5370 guibg=#312a34

"hi GitSignsAddNr    gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsChangeNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsDeleteNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsDeleteNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsChangeNr gui=bold guibg=NONE ctermbg=NONE

" highlight SignColumn guibg=NONE

" Show tabs and trailing spaces as visible characters
"set showbreak=↪
"set list listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:•
"hi Whitespace guifg=#000000
set list listchars+=tab:→\ ,trail:•
" set list

lua require('mymappings')

au BufNewFile,BufRead *.tyb,*.typ,*.tyc,*.pkb,*.pks setf sql

" lua << EOF
" require("catppuccin").setup({
"   transparent_background = true,
"   integrations = {
"   }
" })
" EOF

colorscheme tokyonight-night
" colorscheme catppuccin-mocha

" Change split lines color
" hi VertSplit guifg=#00afff

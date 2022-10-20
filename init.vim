lua require('mysettings')
call plug#begin()

" Theme
"Plug 'ayu-theme/ayu-vim'
"Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
"Plug 'ful1e5/onedark.nvim'
"Plug 'olimorris/onedarkpro.nvim' 
Plug 'cpea2506/one_monokai.nvim'

" Tabline
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }

" NvChad's status line
Plug 'NvChad/NvChad'
Plug 'NvChad/base46'
Plug 'NvChad/ui'

" Icons
Plug 'kyazdani42/nvim-web-devicons'

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

" (Un)Install language server protocols Automatically
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

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
Plug 'tpope/vim-fugitive'

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
set noshowmode

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
      --mode = "tabs",
      numbers = "ordinal",
      color_icons = true,
      --separator_style = "slant",
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "NvimTree"
        }
      }
    }
  }
EOF

lua << EOF
require("one_monokai").setup({
  use_cmd = true,
  transparent = true,
  colors = {
    gray = "#676e7b",
    --pink = "#e06c75",
    pink = "#F92672",
    --green = "#98c379",
    green = "#A6E22E",
    --cyan = "#56b6c2",
    cyan = "#00afff",
    aqua = "#61afef",
    --yellow = "#e5c07b",
    yellow = "#E6DB74",
    --purple = "#c678dd",
    purple = "#AE81FF",
    peanut = "#f6d5a4",
    --orange = "#d19a66",
    orange = "#FD971F",
    none = "NONE",

    -- support colors
    red = "#ff0000",
    --white = "#d7d7ff",
    white = "#ffffff",
    light_gray = "#9ca3b2",
    dark_gray = "#4b5261",
    --vulcan = "#383a3e",
    vulcan = "#080a0e",
    dark_green = "#2d2e27",
    dark_blue = "#26292f",
    black = "#1e2024",
  }
})
EOF

" NvChad/base46 && NvChad/ui
lua << EOF
  --vim.g.nvchad_theme = "onedark"
  vim.g.nvchad_theme = "ayu-dark"
  --require("base46").load_theme()
  require("base46").load_highlight("statusline")

  function _G.nvchadstatusline()
    return require("nvchad_ui.statusline").run({
      separator_style = "default", -- default/round/block/arrow
      --overriden_modules = nil,
    })
  end
  vim.opt.statusline = "%!v:lua.nvchadstatusline()"
  vim.opt.laststatus = 3 -- show only a global statusline
EOF

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

" neovim/nvim-lspconfig
lua require('mylspconfig')

" hrsh7th/vim-vsnip
" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

" kyazdani42/nvim-tree.lua
lua << EOF
  -- https://github.com/kyazdani42/nvim-tree.lua/issues/674
  local tree_cb = require'nvim-tree.config'.nvim_tree_callback
  require("nvim-tree").setup {
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = false,
    },
    renderer = {
      highlight_git = false,
      highlight_opened_files = "all",
      indent_markers = {
        enable = true
      },
      icons = {
        git_placement = "after",
        show = {
          file = true,
          folder = true,
          folder_arrow = false, 
          git = false,
        },
        glyphs = {
          default = "",
          symlink = "",
          --folder = {
          --  --arrow_open = "ﯰ",
          --  --arrow_open = "",
          --  --arrow_closed = "ﰂ",
          --  --arrow_closed = "樂",
          --},
          --git = {
          --  unstaged = "✗",
          --  staged = "✓",
          --  unmerged = "",
          --  renamed = "➜",
          --  untracked = "★",
          --  deleted = "",
          --  ignored = "◌",
          --},
        },
      },
    },
    git = {
      ignore = false -- hide files/dirs in gitignore?
    },
    diagnostics = {
      enable = true,
    },
    view = {
      mappings = {
        custom_only = false,
        list = {
          { key = {"l", "<CR>", "o"}, cb = tree_cb "edit" },
          { key = "h", cb = tree_cb "close_node" },
          { key = "v", cb = tree_cb "vsplit" },
        }
      },
      adaptive_size = true,
      side = "left",
      width = 25,
      hide_root_folder = true,
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },
  }
EOF
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
    add = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr' },
    change = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr' },
    delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr' },
    topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr' },
    changedelete = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr' },
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
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
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


" sindrets/diffview.nvim
lua << EOF
--local actions = require("diffview.actions")
--require("diffview").setup({
  -- diff_binaries = false,    -- Show diffs for binaries
  -- enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  -- git_cmd = { "git" },      -- The git executable followed by default args.
  -- use_icons = true,         -- Requires nvim-web-devicons
  -- icons = {                 -- Only applies when use_icons is true.
  --   folder_closed = "",
  --   folder_open = "",
  -- },
  -- signs = {
  --   fold_closed = "",
  --   fold_open = "",
  -- },
  -- file_panel = {
  --   listing_style = "tree",             -- One of 'list' or 'tree'
  --   tree_options = {                    -- Only applies when listing_style is 'tree'
  --     flatten_dirs = true,              -- Flatten dirs that only contain one single dir
  --     folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
  --   },
  --   win_config = {                      -- See ':h diffview-config-win_config'
  --     position = "left",
  --     width = 35,
  --   },
  -- },
  -- file_history_panel = {
  --   log_options = {   -- See ':h diffview-config-log_options'
  --     single_file = {
  --       diff_merges = "combined",
  --     },
  --     multi_file = {
  --       diff_merges = "first-parent",
  --     },
  --   },
  --   win_config = {    -- See ':h diffview-config-win_config'
  --     position = "bottom",
  --     height = 16,
  --   },
  -- },
  -- commit_log_panel = {
  --   win_config = {},  -- See ':h diffview-config-win_config'
  -- },
  -- default_args = {    -- Default args prepended to the arg-list for the listed commands
  --   DiffviewOpen = {},
  --   DiffviewFileHistory = {},
  -- },
  -- hooks = {},         -- See ':h diffview-config-hooks'
  -- keymaps = {
  --   disable_defaults = false, -- Disable the default keymaps
  --   view = {
  --     -- The `view` bindings are active in the diff buffers, only when the current
  --     -- tabpage is a Diffview.
  --     ["<tab>"]      = actions.select_next_entry, -- Open the diff for the next file
  --     ["<s-tab>"]    = actions.select_prev_entry, -- Open the diff for the previous file
  --     ["gf"]         = actions.goto_file,         -- Open the file in a new split in the previous tabpage
  --     ["<C-w><C-f>"] = actions.goto_file_split,   -- Open the file in a new split
  --     ["<C-w>gf"]    = actions.goto_file_tab,     -- Open the file in a new tabpage
  --     ["<leader>e"]  = actions.focus_files,       -- Bring focus to the files panel
  --     ["<leader>b"]  = actions.toggle_files,      -- Toggle the files panel.
  --   },
  --   file_panel = {
  --     ["j"]             = actions.next_entry,         -- Bring the cursor to the next file entry
  --     ["<down>"]        = actions.next_entry,
  --     ["k"]             = actions.prev_entry,         -- Bring the cursor to the previous file entry.
  --     ["<up>"]          = actions.prev_entry,
  --     ["<cr>"]          = actions.select_entry,       -- Open the diff for the selected entry.
  --     ["o"]             = actions.select_entry,
  --     ["<2-LeftMouse>"] = actions.select_entry,
  --     ["-"]             = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
  --     ["S"]             = actions.stage_all,          -- Stage all entries.
  --     ["U"]             = actions.unstage_all,        -- Unstage all entries.
  --     ["X"]             = actions.restore_entry,      -- Restore entry to the state on the left side.
  --     ["R"]             = actions.refresh_files,      -- Update stats and entries in the file list.
  --     ["L"]             = actions.open_commit_log,    -- Open the commit log panel.
  --     ["<c-b>"]         = actions.scroll_view(-0.25), -- Scroll the view up
  --     ["<c-f>"]         = actions.scroll_view(0.25),  -- Scroll the view down
  --     ["<tab>"]         = actions.select_next_entry,
  --     ["<s-tab>"]       = actions.select_prev_entry,
  --     ["gf"]            = actions.goto_file,
  --     ["<C-w><C-f>"]    = actions.goto_file_split,
  --     ["<C-w>gf"]       = actions.goto_file_tab,
  --     ["i"]             = actions.listing_style,        -- Toggle between 'list' and 'tree' views
  --     ["f"]             = actions.toggle_flatten_dirs,  -- Flatten empty subdirectories in tree listing style.
  --     ["<leader>e"]     = actions.focus_files,
  --     ["<leader>b"]     = actions.toggle_files,
  --   },
  --   file_history_panel = {
  --     ["g!"]            = actions.options,          -- Open the option panel
  --     ["<C-A-d>"]       = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
  --     ["y"]             = actions.copy_hash,        -- Copy the commit hash of the entry under the cursor
  --     ["L"]             = actions.open_commit_log,
  --     ["zR"]            = actions.open_all_folds,
  --     ["zM"]            = actions.close_all_folds,
  --     ["j"]             = actions.next_entry,
  --     ["<down>"]        = actions.next_entry,
  --     ["k"]             = actions.prev_entry,
  --     ["<up>"]          = actions.prev_entry,
  --     ["<cr>"]          = actions.select_entry,
  --     ["o"]             = actions.select_entry,
  --     ["<2-LeftMouse>"] = actions.select_entry,
  --     ["<c-b>"]         = actions.scroll_view(-0.25),
  --     ["<c-f>"]         = actions.scroll_view(0.25),
  --     ["<tab>"]         = actions.select_next_entry,
  --     ["<s-tab>"]       = actions.select_prev_entry,
  --     ["gf"]            = actions.goto_file,
  --     ["<C-w><C-f>"]    = actions.goto_file_split,
  --     ["<C-w>gf"]       = actions.goto_file_tab,
  --     ["<leader>e"]     = actions.focus_files,
  --     ["<leader>b"]     = actions.toggle_files,
  --   },
  --   option_panel = {
  --     ["<tab>"] = actions.select_entry,
  --     ["q"]     = actions.close,
  --   },
  -- },
--})
EOF


" lukas-reineke/indent-blankline.nvim
" let g:indent_blankline_char = ''
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
highlight IndentBlanklineContextChar guifg=#2f2f2f gui=nocombine
highlight IndentBlanklineChar guifg=#101010  gui=nocombine

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

" Change split lines color
hi VertSplit guifg=#00afff

" Use blue colors in NvimTree
hi NvimTreeEmptyFolderName guifg=#00afff
hi NvimTreeFolderIcon guifg=#00afff
hi NvimTreeFolderName guifg=#00afff
hi NvimTreeOpenedFolderName guifg=#00afff

" Overwrite base46 colors for statusline
hi St_NormalMode guibg=#00afff
hi St_NormalModeSep guifg=#00afff

"set statusline+=%{get(b:,'vgit_status','')}

hi LspDiagnosticsLineNrError gui=bold guifg=#ff5370 guibg=#312a34

"hi GitSignsAddNr    gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsChangeNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsDeleteNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsDeleteNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsChangeNr gui=bold guibg=NONE ctermbg=NONE
highlight SignColumn guibg=NONE

" Show tabs and trailing spaces as visible characters
"set showbreak=↪
"set list listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:•
"hi Whitespace guifg=#000000
set list listchars+=tab:→\ ,trail:•
set list


lua require('mymappings')

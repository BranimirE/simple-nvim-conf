call plug#begin()

" Theme
Plug 'ayu-theme/ayu-vim'

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

" Plug 'nvim-lua/plenary.nvim'
" Plug 'tanvirtin/vgit.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"Indents plugin
"Plug 'Yggdroot/indentLine'

"Telescope to have fuzy search on files
"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
"Plug 'nvim-telescope/telescope-ui-select.nvim'
"
"Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

call plug#end()

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
set sw=2

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
let ayucolor="dark"
colorscheme ayu

" akinsho/bufferline.nvim
lua << EOF
  require("bufferline").setup {
    options = {
      --mode = "tabs",
      numbers = "none",
      color_icons = true,
      separator_style = "slant",
      offsets = {
	{
	  filetype = "NvimTree"
	}
      }
    }
  }
EOF
nnoremap <silent><A-1> <cmd>lua require("bufferline").go_to_buffer(1, true)<cr>
nnoremap <silent><A-2> <cmd>lua require("bufferline").go_to_buffer(2, true)<cr>
nnoremap <silent><A-3> <cmd>lua require("bufferline").go_to_buffer(3, true)<cr>
nnoremap <silent><A-4> <cmd>lua require("bufferline").go_to_buffer(4, true)<cr>
nnoremap <silent><A-5> <cmd>lua require("bufferline").go_to_buffer(5, true)<cr>
nnoremap <silent><A-6> <cmd>lua require("bufferline").go_to_buffer(6, true)<cr>
nnoremap <silent><A-7> <cmd>lua require("bufferline").go_to_buffer(7, true)<cr>
nnoremap <silent><A-8> <cmd>lua require("bufferline").go_to_buffer(8, true)<cr>
nnoremap <silent><A-9> <cmd>lua require("bufferline").go_to_buffer(9, true)<cr>
nnoremap <silent><A-$> <cmd>lua require("bufferline").go_to_buffer(-1, true)<cr>

" NvChad/base46
lua << EOF
  --vim.g.nvchad_theme = "onedark"
  vim.g.nvchad_theme = "ayu-dark"
  --require("base46").load_theme()
  require("base46").load_highlight("statusline")
EOF

" NvChad/ui
lua << EOF
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

" neovim/nvim-lspconfig
lua require('mylspconfig')
" Needed:
" npm i -g typescript typescript-language-server
" npm i -g pyright
" sudo pacman -S lua-language-server
" npm install -g vim-language-server

" hrsh7th/vim-vsnip
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

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
      ignore = true
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
map <C-n> :NvimTreeToggle<CR>

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
  current_line_blame_formatter = '<author>, <author_time:%R> ⏺ <summary>',
  current_line_blame_formatter_nc = 'You, <author_time:%R> ⏺ Uncommitted changes',
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
    map('n', 'gb', function()
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

" Plug 'tanvirtin/vgit.nvim'
"lua << EOF
"  require('vgit').setup()
"
"  vim.o.updatetime = 300
"  vim.o.incsearch = false
"  vim.wo.signcolumn = 'yes'
"EOF
lua << EOF
  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "vim", "lua", "javascript", "bash", "css", "json", "json5", "python", "typescript", "html", "yaml", 'markdown', 'markdown_inline', 'scss', 'jsdoc', 'tsx'},
    sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
    auto_install = true, -- Automatically install missing parsers when entering buffer
    -- ignore_install = { "javascript" }, -- List of parsers to ignore installing (for "all")
    highlight = {
      enable = true, -- `false` will disable the whole extension
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

autocmd VimEnter * lua DecreasePadding()
autocmd VimLeavePre * lua IncreasePadding()

" Remove background colors
hi Normal guibg=NONE ctermbg=NONE

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

hi LspDiagnosticsLineNrError gui=bold guifg=#ff5370 guibg=#312a34'

"hi GitSignsAddNr    gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsChangeNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsDeleteNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsDeleteNr gui=bold guibg=NONE ctermbg=NONE
"hi GitSignsChangeNr gui=bold guibg=NONE ctermbg=NONE
highlight SignColumn guibg=NONE

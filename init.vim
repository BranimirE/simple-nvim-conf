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

" Language-Server-Protocol(LSP) plugins
Plug 'neovim/nvim-lspconfig'

" Navigation Tree
Plug 'kyazdani42/nvim-tree.lua'

"Indents plugin
"Plug 'Yggdroot/indentLine'

"Telescope to have fuzy search on files
"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
"Plug 'nvim-telescope/telescope-ui-select.nvim'
"
"Plug 'nvim-treesitter/nvim-treesitter'
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
lua require("nvim-autopairs").setup {}

" neovim/nvim-lspconfig
lua require('mylspconfig')
" Needed:
" npm i -g typescript typescript-language-server
" npm i -g pyright
" sudo pacman -S lua-language-server
" npm install -g vim-language-server

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
  -- Set background transparent
  -- require("notify").setup({
  --   background_colour = "#000000",
  -- })
EOF
map <C-n> :NvimTreeToggle<CR>

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

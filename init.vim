call plug#begin()
"Theme
Plug 'ayu-theme/ayu-vim'
"Plug 'JoosepAlviste/palenightfall.nvim'

"Powerline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"NerdTree
Plug 'preservim/nerdtree'

Plug 'ryanoasis/vim-devicons'

"Move with Ctrl+[h|j|k|l] in splited panes
Plug 'christoomey/vim-tmux-navigator'

"Auto pairs plugin(TODO: Check this pluging. It seems that is adding a bug
"when we remove chars)
"Plug 'jiangmiao/auto-pairs'
"Check if the next one doesn't have that bug
Plug 'windwp/nvim-autopairs'

autocmd VimEnter * call s:load_nvim_autopairs()

function! s:load_nvim_autopairs()
lua << EOF
  require("nvim-autopairs").setup {}
EOF
endfunction

"Indents plugin
Plug 'Yggdroot/indentLine'

"Intellisense autocomplete
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Telescope to have fuzy search on files
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-ui-select.nvim'

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'neovim/nvim-lspconfig'

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

set number

"Setting the theme
set termguicolors
let ayucolor="dark"
colorscheme ayu
"colorscheme palenightfall

"airline
"show the buffers name at the top
let g:airline#extensions#tabline#enabled = 1
"show only the files names without the path in buffer names
let g:airline#extensions#tabline#formatter = 'unique_tail'
"Enable powerline fonts, the border are shown as arrows(triangles)
let g:airline_powerline_fonts = 1

"Open NerdTree at starting up
"autocmd vimenter * NERDTree

"Open/Close NerdTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen = 1
"let g:NERDTreeDirArrowExpandable = '>'
"let g:NERDTreeDirArrowCollapsible = 'v'

"Install COC languages
":CocInstall coc-sh
":CocInstall coc-clangd
":CocInstall coc-css
":CocInstall coc-html
":CocInstall coc-json
":CocInstall coc-pyright
":CocInstall coc-markdownlint
":CocInstall coc-tsserver
"
let mapleader=" "
"Telescope keybindings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

map <leader>ff <cmd>Telescope find_files<cr>
map <leader>fg <cmd>Telescope live_grep<cr>
map <leader>fb <cmd>Telescope buffers<cr>
map <leader>fh <cmd>Telescope help_tags<cr>


"Remove Alacritty padding when nvim is opened
lua << EOF
function Sad(line_nr, from, to, fname)
  vim.cmd(string.format("silent !sed -i '%ss/%s/%s/' %s", line_nr, from, to, fname))
end

function IncreasePadding()
  Sad('52', 0, 10, '~/.config/alacritty/alacritty.yml')
  Sad('53', 0, 10, '~/.config/alacritty/alacritty.yml')
end

function DecreasePadding()
  Sad('52', 10, 0, '~/.config/alacritty/alacritty.yml')
  Sad('53', 10, 0, '~/.config/alacritty/alacritty.yml')
end
EOF


autocmd VimEnter * lua DecreasePadding()
autocmd VimLeavePre * lua IncreasePadding()

"vim.cmd[[
"  augroup ChangeAlacrittyPadding
"    au!
"    au VimEnter * lua DecreasePadding()
"    au VimLeavePre * lua IncreasePadding()
"  augroup END
"]]

hi Normal guibg=NONE ctermbg=NONE

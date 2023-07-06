Show correct mapping representation that neovim receives when we press keys
===
Going into insert mode and type control-v followed by control-shift-tab to see what Vim receives and interprets that combo as, if anything. If you see <C-S-Tab> then you can map that combination of keys, e.g., nnoremap <C-S-Tab> :make<CR>; otherwise you cannot map that key combination in the terminal emulator you are using—try a different one.
Example:
Pressing Ctrl+Shift+1, neovim receives '<M-4>0'

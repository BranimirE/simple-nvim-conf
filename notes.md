Show correct mapping representation that neovim receives when we press keys
===
Going into insert mode and type control-v followed by control-shift-tab to see what Vim receives and interprets that combo as, if anything. If you see <C-S-Tab> then you can map that combination of keys, e.g., nnoremap <C-S-Tab> :make<CR>; otherwise you cannot map that key combination in the terminal emulator you are using—try a different one.
Example:
Pressing Ctrl+Shift+1, neovim receives '<M-4>0'

Lazy.nvim - Call the same plugin package in opts object
===
As we are creating the object that will be passed to the plugin.setup(opts) function, the plugin is still not loaded, so if we have something like:
```lua
{
    'plugin/path',
    opts = {
        value = require(plugin.package.a).get_value()
    },
    -- ...
}
```
It is going to fail as the plugin is not still in memory.
To fix this we can do:
```lua
{
    'plugin/path',
    opts = function()
        return {
            value = require(plugin.package.a).get_value()
        },
    end,
    -- ...
}
```


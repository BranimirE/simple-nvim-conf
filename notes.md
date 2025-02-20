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

Setup `eslint` correctly
==
- Use `eslint LSP`:
    Artifacts:

    * eslint listed in package.json
    * eslint binary file in node_modules/.bin folder
    * eslint configuration file (eslint.config.js, .eslintrc.csj)

    Escenarios:

    a) User does not want to use eslint at all -> lsp is not attached
        (No artifacts present)
    b) eslint is listed in the package.json file, but the binary is not installed (npm install was not called)
    c) 

* eslint in package.json
    - eslint binary exists
        * config file exists
            => OK: All working fine. It takes local or global eslint
        * config file does not exists
            -> OK: If an old version is passed it shows a message "ERROR: eslint: -32603: Request textDocument/diagnostic failed with message: Could not find config file.", eslint is attached
                > I suspect that the root file was detected to start the language server, but the LS did not find a valid config file as it was expecting a new version of the config file (Eslint is attached), CONFIRMED!!

            => SUPER FAIL: It does nothing, eslint not attached, no messages
                > SOLVED: Detecting package.json folder as root_dir. LSP is attached and responds "No config file found"
    - eslint binary does not exists
        * config file exists
            => OK: lspconfig responds: "[lspconfig] Unable to find ESLint library."

        * config file does not exists
            => OK: lspconfig respons: "[lspconfig] Unable to find ESLint library."

* eslint not in package.json
    > SOLVED: Checking if any eslint configfile exists before attaching the eslint LSP
    * config file exists
        => OK: It shows "[lspconfig] Unable to find ESLint library."

    * config file does not exists
        => OK: eslint LSP is not attached, completely sure the project is not using eslint at all

eslint LSP is able to recognize as root_dir the dir that contain the next files:
  - '.eslintrc',
  - '.eslintrc.js',
  - '.eslintrc.cjs',
  - '.eslintrc.yaml',
  - '.eslintrc.yml',
  - '.eslintrc.json',
  - 'eslint.config.js',
  - 'eslint.config.mjs',
  - 'eslint.config.cjs',
  - 'eslint.config.ts',
  - 'eslint.config.mts',
  - 'eslint.config.cts',
  - 'package.json'


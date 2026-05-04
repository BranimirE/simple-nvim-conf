local mymappings = require('mymappings')
return {
  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring', -- Comment embedded scripts
      { -- Autoclose and rename html tags
        'windwp/nvim-ts-autotag',
        event = 'InsertEnter',
        opts = {}
      },
      { -- Autoclose ()[]{}
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {
          check_ts = true -- check treesitter for autopairing
        }
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        init = function()
          -- Disable entire built-in ftplugin mappings to avoid conflicts.
          -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
          vim.g.no_plugin_maps = true

          -- Or, disable per filetype (add as you like)
          -- vim.g.no_python_maps = true
          -- vim.g.no_ruby_maps = true
          -- vim.g.no_rust_maps = true
          -- vim.g.no_go_maps = true
        end,
        config = function()
          -- TODO: move this keybindings
          vim.keymap.set({ "x", "o" }, "af", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
          end)
          vim.keymap.set({ "x", "o" }, "if", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
          end)
          vim.keymap.set({ "x", "o" }, "ac", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
          end)
          vim.keymap.set({ "x", "o" }, "ic", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
          end)
        end,
      }
    }, -- tree-sitter CLI must be installed system-wide
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local isBigfile = vim.bo.filetype == 'bigfile'
      require("tree-sitter-manager").setup({
        -- Default Options
        ensure_installed = {
          'vim', 'lua', 'javascript', 'bash', 'css', 'json', 'json5', 'jsonc', 'python', 'typescript', 'html', 'yaml', 'markdown', 'markdown_inline', 'scss', 'jsdoc', 'tsx', 'regex', 'diff', 'vimdoc'
        }, -- list of parsers to install at the start of a neovim session
        -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
        auto_install = true, -- if enabled, install missing parsers when editing a new file
        highlight = not isBigfile, -- treesitter highlighting is enabled by default
        -- languages = {}, -- override or add new parser sources
        -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
        -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
      })

      if not isBigfile then
        -- TODO: move this keybindings
        -- Incremental/Decremental selection
        vim.keymap.set({ 'x', 'o' }, '<cr>', function()
          if vim.treesitter.get_parser(nil, nil, { error = false }) then
            require 'vim.treesitter._select'.select_parent(vim.v.count1)
          else
            vim.lsp.buf.selection_range(vim.v.count1)
          end
        end, { desc = 'Select parent treesitter node or outer incremental lsp selections' })

        vim.keymap.set({ 'x', 'o' }, '<bs>', function()
          if vim.treesitter.get_parser(nil, nil, { error = false }) then
            require 'vim.treesitter._select'.select_child(vim.v.count1)
          else
            vim.lsp.buf.selection_range(-vim.v.count1)
          end
        end, { desc = 'Select child treesitter node or inner incremental lsp selections' })
      end
    end
  },
  { -- Improved folding management
    "kevinhwang91/nvim-ufo",
    dependencies = { 'kevinhwang91/promise-async', 'romus204/tree-sitter-manager.nvim' },
    event = { 'BufRead', 'BufWinEnter', 'BufNewFile' },
    keys = mymappings.ufo(),
    opts = {
      ---@diagnostic disable-next-line: unused-local
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end
    }
  },
  { -- Improve view markdown files
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    ft = 'markdown',                                                                -- only load on markdown files
    config = true,
    dependencies = { 'romus204/tree-sitter-manager.nvim', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  },
}

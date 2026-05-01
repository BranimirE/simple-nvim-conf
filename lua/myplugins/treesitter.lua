return {
  -- { -- Advanced highlighting
  --   'nvim-treesitter/nvim-treesitter',
  --   build = ':TSUpdate',
  --   cmd = { 'TSUpdateSync' },
  --   dependencies = {
  --   },
  --   event = { 'BufReadPost', 'BufNewFile' },
  --   opts = {
  --     ensure_installed = { 'vim', 'lua', 'javascript', 'bash', 'css', 'json', 'json5', 'jsonc', 'python', 'typescript', 'html', 'yaml', 'markdown', 'markdown_inline', 'scss', 'jsdoc', 'tsx', 'regex', 'diff', 'vimdoc' },
  --     sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
  --     auto_install = true,  -- Automatically install missing parsers when entering buffer
  --     highlight = {
  --       enable = true,      -- `false` will disable the whole extension
  --       ---@diagnostic disable-next-line: unused-local
  --       disable = function(lang, bufnr)
  --         if vim.fn.expand('%:t') == 'lsp.log' or vim.bo.filetype == 'help' then
  --           return false
  --         end
  --         -- local n_lines = vim.api.nvim_buf_line_count(bufnr)
  --         -- -- https://github.com/dapc11/dnvim/blob/2724e18d558a0abf268b9443b7cbdc4cc2c73131/lua/core/autocommands.lua#L38
  --         -- return n_lines > 5000 or (n_lines > 0 and vim.fn.getfsize(vim.fn.expand('%')) / n_lines > 10000)
  --         -- Trying another options to disable treesitter
  --         local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  --         return ok and stats and stats.size > (250 * 1024)
  --       end,
  --       use_languagetree = true,                   -- use this to enable language injection
  --       additional_vim_regex_highlighting = false, -- Enable syntax on at the same time?
  --     },
  --     incremental_selection = {
  --       enable = true,
  --       keymaps = {
  --         init_selection = '<cr>',
  --         node_incremental = '<cr>',
  --         scope_incremental = false,
  --         node_decremental = '<bs>',
  --       },
  --     },
  --     indent = { enable = true }, -- Indent with = using treesitter
  --     -- autotag = { enable = true }, -- Do not use. Deprecated!
  --     autopairs = { enable = true },
  --     context_commentstring = {
  --       enable = true,
  --       enable_autocmd = false,
  --     },
  --     rainbow = { enable = true },
  --     textobjects = {
  --       select = {
  --         enable = true,
  --         lookahead = true,
  --         keymaps = {
  --           ['af'] = '@function.outer',
  --           ['if'] = '@function.inner',
  --           ['ac'] = '@class.outer',
  --           ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
  --           ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
  --         },
  --       },
  --     },
  --   },
  --   -- main = 'nvim-treesitter.configs'
  -- },
  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring', -- Comment embedded scripts
      {
        'windwp/nvim-ts-autotag',                    -- Autoclose and rename html tags
        event = 'InsertEnter',
        opts = {}
      },
      -- { -- Add function and class selectors vaf = 'visual around function', '=if' = Format inner function
      --   'nvim-treesitter/nvim-treesitter-textobjects',
      --   branch = 'main',
      --   opts = {
      --     select = {
      --       enable = true,
      --       lookahead = true,
      --       keymaps = {
      --         ['af'] = '@function.outer',
      --         ['if'] = '@function.inner',
      --         ['ac'] = '@class.outer',
      --         ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
      --         ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
      --       },
      --     }
      --   }
      -- },
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
    event = "VeryLazy",
    config = function()
      require("tree-sitter-manager").setup({
        -- Default Options
        -- ensure_installed = {}, -- list of parsers to install at the start of a neovim session
        -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
        auto_install = true, -- if enabled, install missing parsers when editing a new file
        -- highlight = true, -- treesitter highlighting is enabled by default
        -- languages = {}, -- override or add new parser sources
        -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
        -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
      })
    end
  }

}

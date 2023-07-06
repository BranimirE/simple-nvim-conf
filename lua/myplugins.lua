return {
  { -- Theme
    'folke/tokyonight.nvim',
    event = 'VeryLazy',
    opts = {
      style = 'night',
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    init = function()
      vim.cmd('colorscheme tokyonight')
    end
  },
  { -- Status line
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = function()
      require('myconfig/evil_lualine')
    end
  },
  { -- File tree viewer
    'nvim-tree/nvim-tree.lua',
    cmd = { "NvimTreeToggle", "NvimTreeFocus" }, -- Lazy-load on commands
    opts = {
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
        vim.keymap.set('n', 'L', function ()
          local current_layout = vim.fn.winlayout()
          local first_level_split = current_layout[1]
          local first_level_layout = current_layout[2]
          if first_level_split == "row" then
            local columns_count = 0
            for _ in pairs(first_level_layout) do
              columns_count = columns_count + 1
            end
            -- nvim-tree | panel | panel = 3
            if columns_count == 3 then
              api.node.open.horizontal()
              return
            end
          end
          api.node.open.vertical()
        end, opts('Open: Vertical Split'))
      end,
      renderer = {
        root_folder_label = false,
        highlight_opened_files = 'all',
        indent_markers = {
          enable = true, -- show indent lines(vertical lines)
        },
        icons = {
          git_placement = "after", -- position files' git status icon
          show = {
            folder_arrow = false,
            git = true, -- show files' git status icons
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
    }
  },
  { -- Tmux switch panels keys integration
    'christoomey/vim-tmux-navigator',
    lazy = false
  },
  { -- Autoclose ()[]{}
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      check_ts = true, -- check treesitter for autopairing
      enable_moveright = true -- TODO: Remove this line
    }
  },
  { -- Comment plugin
    'numToStr/Comment.nvim',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {'JoosepAlviste/nvim-ts-context-commentstring'}, -- Comment embedded scripts
    config = function(_, opts)
      local success, ts_context_commentstring = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      if sucess then
        opts = { pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook() }
      end
      require('Comment').setup(opts)
    end,
  },
  { -- Advanced highlighting
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cmd = { "TSUpdateSync" },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring', -- Comment embedded scripts
      'windwp/nvim-ts-autotag', -- Autoclose and rename html tags
      'HiPhish/nvim-ts-rainbow2', -- Colorize parenthesis pairs with distinct colors
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "vim", "lua", "javascript", "bash", "css", "json", "json5", "jsonc", "python", "typescript", "html", "yaml", 'markdown', 'markdown_inline', 'scss', 'jsdoc', 'tsx', 'regex', 'diff'},
      sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
      auto_install = true, -- Automatically install missing parsers when entering buffer
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
        additional_vim_regex_highlighting = false, -- Enable syntax on at the same time?
      },
      indent = { enable = true }, -- Indent with = using treesitter
      autotag = { enable = true },
      autopairs = { enable = true },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      rainbow = { enable = true }
    },
    main = 'nvim-treesitter.configs'
  },
  { -- Tabline
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    opts = {
      options = {
        color_icons = true,
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
      -- highlights = {
        -- buffer_selected = {
        --   fg = "#DDDDDD",
        -- },
      -- }
    }
  },
  { -- Notifications windows
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    opts = {}
  },
  { -- Vertical lines on indentation
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      char = '▏',
      context_char = '▏',
      show_current_context = true,
      use_treesitter = true,
      show_trailing_blankline_indent = false,
      show_first_indent_level = false, -- so we can detect if the line is only composed by trailing whitespaces
      max_indent_increase = 1
    }
  },
  { -- Git signs on the number column and git blame as virtual text
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { hl = 'GitSignsAdd', text = '▌', numhl = 'GitSignsAddNr' },
        change = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr' },
        delete = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
        topdelete = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
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
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim' -- Show code actions in Telescope dropdown TODO: (a) check if this is still necessary with LspSaga
    },
    cmd = 'Telescope',
    init = function()
      require('telescope').load_extension('fzf')
      require("telescope").load_extension("ui-select") -- TODO: (a) same
    end,
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
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
      -- TODO: (a) same
      -- extensions = {
      --   ["ui-select"] = {
      --     require("telescope.themes").get_dropdown({})
      --   }
      -- },
      pickers = {
        find_files = {
          theme = 'dropdown',
          previewer = false,
          prompt_prefix = ' 󰱼 '
        },
        live_grep = {
          prompt_prefix = '  '
        }
      }
    }
  }
}

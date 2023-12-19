local mymappings = require('mymappings')
local myutils = require('myutils')

return {
  -- { -- Theme Tokyonight
  --   'folke/tokyonight.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     style = 'night',
  --     transparent = true,
  --     styles = {
  --       sidebars = 'transparent',
  --       floats = 'transparent',
  --     },
  --   },
  --   init = function()
  --     vim.cmd('colorscheme tokyonight')
  --   end
  -- },
  { -- Theme Onedark
    'navarasu/onedark.nvim',
    event = 'VeryLazy',
    opts = {
      style = 'deep',
      transparent = true,
      colors = {
        black = "#0c0e15",
        bg0 = "#19212F",  --background_colour
        bg1 = "#20283D", -- nvim-tree highlight line background
        bg2 = "#283347",
        bg3 = "#2a324a",
        bg_d = "#121B25", -- nvim-tree background
        bg_blue = "#54b0fd",
        bg_yellow = "#f2cc81",
        -- fg = "#90A4C6", -- < character
        fg = "#B8C5DB", -- < character
        purple = "#D74CF0", -- class word
        green = "#74D046", -- strings
        orange = "#E98C31", -- true/false word and numbers
        blue = "#00A8FF", -- has_many word, function names, raise word
        yellow = "#F7BC47", -- class name
        cyan = "#00C1D2", -- ":comments" word
        red = "#FF4761", -- function parameters
        grey = "#425577", -- comments
        light_grey = "#697D9F", -- Curly brackets {}
        dark_cyan = "#1b6a73",
        dark_red = "#992525", -- some icons color
        dark_yellow = "#8f610d",
        dark_purple = "#862aa1",
        diff_add = "#27341c",
        diff_delete = "#331c1e",
        diff_change = "#102b40",
        diff_text = "#1c4a6e",
      },
      highlights = {
        StatusLine = { bg = 'none' },
        StatusLineTerm = { bg = 'none' },
        StatusLineNC = { bg = 'none' },
        StatusLineTermNC = { bg = 'none' },
        -- Telescope
        TelescopeMatching = { fg = '#00afff' },
        TelescopeBorder = { fg = '#00afff' },
        -- Lspsaga groups and Floating terminal
        NormalFloat = { bg = 'none' },
        FloatBorder = { bg = 'none' },
        -- Nvim-tree
        NvimTreeWindowPicker = { bg = '#00afff', fg = '#000000', gui = 'bold' },
        -- FzfLuaa
        FzfLuaBorder = { fg = '#00afff' },
      },
    },
    init = function()
      require('onedark').load()
    end
  },
  -- { -- Theme
  --   'cpea2506/one_monokai.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     transparent = true,
  --     colors = {
  --       gray = "#676e7b",
  --       pink = "#F92672",
  --       green = "#A6E22E",
  --       cyan = "#00afff",
  --       aqua = "#61afef",
  --       yellow = "#E6DB74",
  --       purple = "#AE81FF",
  --       peanut = "#f6d5a4",
  --       orange = "#FD971F",
  --       none = "NONE",
  --
  --       -- support colors
  --       red = "#ff0000",
  --       white = "#ffffff",
  --       light_gray = "#9ca3b2",
  --       dark_gray = "#4b5261",
  --       vulcan = "#080a0e",
  --       dark_green = "#2d2e27",
  --       dark_blue = "#26292f",
  --       black = "#1e2024",
  --     }
  --   }
  -- },
  { -- Status line
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = function()
      require('myconfig/evil_lualine')
    end
  },
  { -- File tree viewer
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' }, -- Lazy-load on commands
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')
        api.config.mappings.default_on_attach(bufnr)
        myutils.load_mapping(mymappings.nvim_tree(api, bufnr))
      end,
      renderer = {
        root_folder_label = false,
        highlight_opened_files = 'all',
        indent_markers = {
          enable = true, -- show indent lines(vertical lines)
        },
        icons = {
          git_placement = 'after', -- position files' git status icon
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
      view = {
        adaptive_size = true,
      }
    }
  },
  { -- Tmux switch panels keys integration
    'christoomey/vim-tmux-navigator',
    lazy = false
  },
  { -- Autoclose ()[]{}
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true        -- check treesitter for autopairing
    }
  },
  { -- Comment plugin
    'numToStr/Comment.nvim',
    keys = mymappings.comment(),
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = 'JoosepAlviste/nvim-ts-context-commentstring', -- Comment embedded scripts
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      })
    end,
  },
  { -- Advanced highlighting
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cmd = { 'TSUpdateSync' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring', -- Comment embedded scripts
      'windwp/nvim-ts-autotag',                      -- Autoclose and rename html tags
      {
        'HiPhish/rainbow-delimiters.nvim', -- Colorize parenthesis pairs with distinct colors
        url = 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim'
      },
      'nvim-treesitter/nvim-treesitter-textobjects', -- Add function and class selectors vaf = 'visual around function', '=if' = Format inner function
    },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      ensure_installed = { 'vim', 'lua', 'javascript', 'bash', 'css', 'json', 'json5', 'jsonc', 'python', 'typescript', 'html', 'yaml', 'markdown', 'markdown_inline', 'scss', 'jsdoc', 'tsx', 'regex', 'diff', 'vimdoc' },
      sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
      auto_install = true,  -- Automatically install missing parsers when entering buffer
      highlight = {
        enable = true,      -- `false` will disable the whole extension
        ---@diagnostic disable-next-line: unused-local
        disable = function(lang, bufnr)
          if vim.fn.expand('%:t') == 'lsp.log' or vim.bo.filetype == 'help' then
            return false
          end
          local n_lines = vim.api.nvim_buf_line_count(bufnr)
          -- https://github.com/dapc11/dnvim/blob/2724e18d558a0abf268b9443b7cbdc4cc2c73131/lua/core/autocommands.lua#L38
          return n_lines > 5000 or (n_lines > 0 and vim.fn.getfsize(vim.fn.expand('%')) / n_lines > 10000)
        end,
        use_languagetree = true,                   -- use this to enable language injection
        additional_vim_regex_highlighting = false, -- Enable syntax on at the same time?
      },
      indent = { enable = true },                  -- Indent with = using treesitter
      autotag = { enable = true },
      autopairs = { enable = true },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      rainbow = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
            ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
          },
        },
      },
    },
    main = 'nvim-treesitter.configs'
  },
  { -- Tabline
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = 'VeryLazy',
    opts = {
      options = {
        color_icons = true,
        separator_style = { '', '' },
        indicator = {
          style = 'none'
        },
        always_show_bufferline = false,
        offsets = {
          {
            filetype = 'NvimTree',
            padding = 1, -- For some reason it is not calculating the value correctly, this fix it
            highlight = "Normal", -- Only required for ondedark.nvim theme
          },
        },
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' }
        }
      },
    },
    config = function (_, opts)
      local bl = require('bufferline')
      bl.setup(opts)
      myutils.load_mapping(mymappings.bufferline(bl))
    end
  },
  { -- Notifications windows
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    opts = {
      background_colour = '#000000', -- WARN: Remove this line if the colorscheme is not transparent
    },
    config = function(_, opts)
      local notify = require('notify')
      notify.setup(opts)
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.notify = function(msg, ...)
        if type(msg) == 'string' then
          -- Disable notifications that contains those strings
          local is_suppressed_message = msg:match '%[lspconfig] Autostart for' or msg:match 'No information available' or msg:match '%[Lspsaga] response of request method textDocument/definition is empty' or msg:match 'for_each_child'
          if is_suppressed_message then
            -- Do not show some messages
            return
          end
        end

        notify(msg, ...)
      end

    end,
  },
  { -- Vertical lines on indentation
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = {
        char = '▏',
      },
      scope = {
        show_start = false,
        show_end = false,
      },
      whitespace = {
        remove_blankline_trail = false,
      },
    },
    config = function (_, opts)
      local hooks = require('ibl.hooks')
      -- so we can detect if the line is only composed by trailing whitespaces(tabs or spaces)
      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_space_indent_level
      )
      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_tab_indent_level
      )
      require('ibl').setup(opts)
    end
  },
  { -- Git signs on the number column and git blame as virtual text
    'lewis6991/gitsigns.nvim',
    dependencies = {
      {
        'ruifm/gitlinker.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        opts = function()
          return {
            callbacks = {
              ["ghe.coxautoinc.com"] = require"gitlinker.hosts".get_github_type_url,
            },
            mappings = nil
          }
        end
      }
    },
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { hl = 'GitSignsAdd', text = '▌', numhl = 'GitSignsAddNr' },
        change = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr' },
        delete = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
        topdelete = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr' },
        changedelete = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr' },
      },
      signcolumn = true,         -- Toggle with `:Gitsigns toggle_signs`
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 100,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = ' <author>, <author_time:%R> ● <summary>',
      current_line_blame_formatter_nc = ' <You>, <author_time:%R> ● Uncommitted changes',
      preview_config = {
        border = 'rounded',
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        myutils.load_mapping(mymappings.gitsigns(gs, bufnr))
      end,
    }
  },
  -- { -- Telescope - Fuzzy finder
  --   'nvim-telescope/telescope.nvim',
  --   tag = '0.1.5',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  --     'nvim-treesitter/nvim-treesitter'
  --   },
  --   cmd = 'Telescope',
  --   keys = mymappings.telescope(),
  --   opts = function()
  --     return {
  --       defaults = {
  --         prompt_prefix = ' ',
  --         selection_caret = ' ',
  --         file_ignore_patterns = {
  --           'node_modules',
  --           'ext.js',
  --           'ext-modern.js',
  --           'ext-modern-all.js',
  --           'ext-modern-all-sandbox.js',
  --           'ext-all.js',
  --           'ext-all-sandbox.js',
  --           'ext-all-rtl.js',
  --           'ext-all-rtl-sandbox.js'
  --         },
  --         mappings = {
  --           n = { ['q'] = require('telescope.actions').close },
  --         },
  --       },
  --       pickers = {
  --         find_files = {
  --           theme = 'dropdown',
  --           previewer = false,
  --           prompt_prefix = '  '
  --         },
  --         live_grep = {
  --           prompt_prefix = ' 󰱼 '
  --           -- prompt_prefix = ''
  --         }
  --       }
  --     }
  --   end,
  --   config = function(_, opts)
  --     local telescope = require('telescope')
  --     telescope.setup(opts)
  --     telescope.load_extension('fzf')
  --     -- telescope.load_extension('ui-select') -- TODO: (a) same
  --   end
  -- },
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = mymappings.fzf_lua(),
    cmd = 'FzfLua',
    opts = function ()
      local actions = require 'fzf-lua.actions'
      return {
        fzf_colors = {
          bg = { 'bg', 'Normal' },
          gutter = { 'bg', 'Normal' },
          info = { 'fg', 'Conditional' },
          scrollbar = { 'bg', 'Normal' },
          separator = { 'fg', 'Comment' },
        },
        fzf_opts = {
          ['--info'] = 'default',
        },
        keymap = {
          builtin = {
            ['<F1>']  = 'toggle-help',
            ['<F2>']  = 'toggle-fullscreen',
            ['<C-i>'] = 'toggle-preview',
            ['<C-f>'] = 'preview-page-down',
            ['<C-b>'] = 'preview-page-up',
            ['<tab>'] = nil,
          },
          fzf = {
            ['ctrl-a'] = 'toggle-all',
            ['alt-s'] = 'toggle',
          },
        },
        -- Configuration for specific commands.
        files = {
          winopts = {
            height = 0.7,
            width = 0.55,
            preview = {
              hidden = 'hidden',
              horizontal = 'right:60%',
            },
          },
          cwd_prompt = false,
          prompt = '  ❯ ',
          actions = {
            ['ctrl-g'] = actions.toggle_ignore,
          },
        },
        grep = {
          fzf_opts = {
            ['--layout'] = 'reverse-list',
          },
        }
      }
    end
  },
  { -- Auto detect file indent settings
    'tpope/vim-sleuth',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  { -- Hihglight TODOs and show a list with all TODOs
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { --[[ 'TodoTrouble',  ]] 'TodoTelescope', 'TodoQuickFix' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
  },
  { -- Colorize color strings like #00afff or magenta
    'NvChad/nvim-colorizer.lua',
    event = { 'BufRead', 'BufWinEnter', 'BufNewFile' },
    config = true,
  },
  { -- Bridge between vsnip and nvim-cmp
    'hrsh7th/cmp-vsnip',
    dependencies = {
      'hrsh7th/vim-vsnip',                                -- Snippets engine
      -- {
      --   'dsznajder/vscode-es7-javascript-react-snippets', -- TODO: Load plugin by filetype(only js and ts type files)
      --   build = 'yarn install --frozen-lockfile && yarn compile'
      -- }
    }
  },
  { -- Autocompletion plugin
    'hrsh7th/nvim-cmp',
    version = false,
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-cmdline',
      'onsails/lspkind.nvim',
      -- 'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    opts = function()
      local cmp = require('cmp')
      local compare = require('cmp.config.compare')
      return {
        snippet = { -- REQUIRED
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },
        completion = {
          -- completeopt = 'menu,menuone,noinsert', -- same as vim's completeopt(see :help completeopt)
          completeopt = 'menu,menuone,noselect,noinsert', -- TODO: Check that this one is required
        },
        window = {
          completion = vim.tbl_deep_extend('force', cmp.config.window.bordered(), {
            -- Move the menu to the left to match the completion string
            col_offset = -3,
            side_padding = 0,
          }),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert(myutils.parse_nvim_cmp_mapping(mymappings.nvim_cmp(cmp))),
        sources = cmp.config.sources({ -- The order matters!!!
          -- { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' },
          -- { name = 'vsnip' },
          { name = 'git' },
          { name = 'path' },
          { name = 'buffer', keyword_length = 4 },
        }),
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require('lspkind').cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            kind.menu = '  ' .. (strings[2] or '')

            return kind
          end,
        },
        experimental = {
          ghost_text = true,
        },
        sorting = {
          comparators = {
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.sort_text,
            compare.length,
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require('cmp')
      cmp.setup(opts)

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
            { name = 'buffer' },
          })
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline('/', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = 'buffer' }
      --   }
      -- })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
            { name = 'cmdline' }
          })
      })

      -- If you want insert `(` after select function or method item
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim', -- It need to be setup before nvim-lspconfig
        dependencies = {
          {
            'williamboman/mason.nvim',
            cmd = 'Mason',
            build = ':MasonUpdate',
            opts = {
              ui = {
                border = 'rounded',
                width = 0.7,
                height = 0.8,
              },
            },
          }
        },
        opts = { automatic_installation = true }, -- Automatically install the lsp server with mason if it is configured
        config = function(_, opts)
          require('mason-lspconfig').setup(opts)
        end,
      },
      {
        'hrsh7th/cmp-nvim-lsp',
        cond = function()
          return myutils.has('nvim-cmp')
        end,
      },
      'nvimdev/lspsaga.nvim',
      { -- Collection of json schemas for json lsp
        'b0o/schemastore.nvim',
        version = false,
      },
      { -- LSP progress messages
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = true
      },
      { -- Show signature when we writte function parameters
        "ray-x/lsp_signature.nvim",
        opts = {hint_enable = false},
        config = function(_, opts)
          require('lsp_signature').setup(opts)
        end
      },
      { -- Show virtual text with # references and definitions like JetBrains
        "VidocqH/lsp-lens.nvim",
        opts = {
          enable = true,
          include_declaration = false, -- Reference include declaration
          sections = { -- Enable / Disable specific request
            definition = false,
            references = true,
            implementation = true,
          },
          ignore_filetype = {},
        },
        { -- Improved lua settings for neovim config
          "folke/neodev.nvim",
          opts = {
            library = { types = false }
          },
        }
      }
    },
    config = function()
      local my_lsp_servers = {
        'lua_ls',
        'bashls',
        'pyright',
        'vimls',
        'marksman',
        'cssls',
        'cssmodules_ls',
        'yamlls',
        'html',
        'sqlls',
        'jsonls',
        'docker_compose_language_service',
        'dockerls',
        'angularls'
      }

      if not myutils.is_npm_package_installed('eslint') then
        myutils.log('eslint is not installed in package.json. Using eslint lsp')
        table.insert(my_lsp_servers, 'eslint')
      end

      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      end

      local capabilities = require('myconfig/lsp').client_capabilities
      local lspconfig = require('lspconfig')

      local my_lsp_server_config = {
        yamlls = {
          on_attach = on_attach,
          capabilities = capabilities(),
          settings = {
            yaml = {
              format = {
                enable = true,
              },
              hover = true,
              completion = true,
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
              },
              schemas = require('schemastore').yaml.schemas(),
              customTags = {
                '!fn',
                '!And',
                '!If',
                '!If sequence',
                '!Not',
                '!Not sequence',
                '!Equals',
                '!Equals sequence',
                '!Or',
                '!FindInMap sequence',
                '!Base64',
                '!Cidr',
                '!Ref',
                '!Ref Scalar',
                '!Sub',
                '!Sub sequence',
                '!GetAtt',
                '!GetAZs',
                '!ImportValue',
                '!Select',
                '!Split',
                '!Join sequence'
              },
            },
          }
        },
        jsonls = {
          on_attach = on_attach,
          capabilities = capabilities(),
          settings = {
            json = {
              validate = { enable = true },
            },
          },
          -- Lazy-load schemas.
          on_new_config = function(config)
              config.settings.json.schemas = config.settings.json.schemas or {}
              vim.list_extend(config.settings.json.schemas, require('schemastore').json.schemas())
          end,
        },
      }

      for _, server_name in ipairs(my_lsp_servers) do
        if my_lsp_server_config[server_name] ~= nil then
          lspconfig[server_name].setup(my_lsp_server_config[server_name])
        else
          lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities(),
          })
        end
      end

      vim.fn.sign_define('DiagnosticSignError', { numhl = 'LspDiagnosticsLineNrError', text = '' })
      vim.fn.sign_define('DiagnosticSignWarn', { numhl = 'LspDiagnosticsLineNrWarning', text = '' })
      vim.fn.sign_define('DiagnosticSignInfo', { text = '' })
      vim.fn.sign_define('DiagnosticSignHint', { text = '' })

      vim.cmd('highlight LspDiagnosticsLineNrError gui=bold guifg=#ff5370 guibg=#312a34')
      vim.cmd('highlight LspDiagnosticsLineNrWarning gui=bold guifg=#f78c6c guibg=#312e3a')
    end
  },
  {
    'pmizio/typescript-tools.nvim',
    event = { 'BufReadPre *.ts,*.tsx,*.js,*.jsx', 'BufNewFile *.ts,*.tsx,*.js,*.jsx' },
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-lspconfig' },
    opts = function ()
      return {
        settings = {
          tsserver_file_preferences = {
            -- includeInlayParameterNameHints = 'literals',
            includeInlayParameterNameHints = 'all',
            includeInlayVariableTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
        handlers = {
          -- Remove message "File is a CommonJS module; it may be converted to an ES module."
          -- Info: https://github.com/LunarVim/LunarVim/discussions/4239#discussioncomment-6223638
          --       https://github.com/neovim/neovim/issues/20745#issuecomment-1285183325
          ["textDocument/publishDiagnostics"] = require('typescript-tools.api').filter_diagnostics({ 80001 })
        }
      }
    end,
  },
  { -- Extra tools for lsp
    'nvimdev/lspsaga.nvim',
    opts = {
      lightbulb = {
        enable = false,
        enable_in_insert = false,
        sign = false,        -- Don't put lightbulb on the numbers line
        sign_priority = 40,
        virtual_text = true, -- Puth the lightbulb on the virtual text
      },
      symbol_in_winbar = {
        enable = false
      }
    }
  },
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      ensure_installed = { 'flake8', 'black', 'prettier' }
    },
    dependencies = {
      'williamboman/mason.nvim',
      {
        'nvimtools/none-ls.nvim',
        opts = function ()
          local null_ls = require('null-ls')

          local formatting = null_ls.builtins.formatting
          local diagnostics = null_ls.builtins.diagnostics
          local code_actions = null_ls.builtins.code_actions

          local sources = {
            code_actions.gitsigns,
            formatting.black,
            diagnostics.flake8,
          }

          if myutils.is_npm_package_installed('eslint') then
            myutils.log('has eslint. Setting up null-ls eslint diagnostics and code_actions')
            -- Use node_modules EsLint for diagnostics and code actions
            -- Note: Do not use eslint_lsp as node_modules/.bin/eslint version is prefered
            table.insert(sources, diagnostics.eslint.with({ command = './node_modules/.bin/eslint' }))
            table.insert(sources, code_actions.eslint.with({ command = './node_modules/.bin/eslint' }))
          end

          if myutils.is_npm_package_installed('prettier') then
            myutils.log('has prettier')
            if myutils.is_npm_package_installed('eslint') then
              myutils.log('has eslint')
              if myutils.is_npm_package_installed('eslint-plugin-prettier') then
                myutils.log('has eslint-prettier integration')
                -- Use EsLint as formatter(It will use prettier internally)
                table.insert(sources, formatting.eslint.with({
                  command = './node_modules/.bin/eslint',
                }))
              else
                myutils.log('it does not have eslint-prettier integration. Using only prettier')
                table.insert(sources, formatting.prettier.with({
                  command = './node_modules/.bin/prettier',
                }))
              end
            else
              myutils.log('it does not have eslint. Using only prettier 2')
              table.insert(sources, formatting.prettier.with({
                command = './node_modules/.bin/prettier',
              }))
            end
          else
            myutils.log('Project does not have prettier. Using global(mason-null-ls) prettier')
            table.insert(sources, formatting.prettier)
          end

          return {
            sources = sources,
            root_dir = require('null-ls.utils').root_pattern('.null-ls-root', 'Makefile', '.git', 'package.json'),
          }
        end
      },
    },
    config = function(_, opts)
      require('mason-null-ls').setup(opts)
    end,
  },
  { -- Useful Git commands. Ex: Git blame
    'tpope/vim-fugitive',
    cmd = { 'Git' }
  },
  { -- Pretty list component
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      action_keys = { -- key mappings for actions in the trouble list
        open_split = { '<c-x>', '|' }, -- open buffer in new split
        open_vsplit = { '<c-v>', '-' }, -- open buffer in new vsplit
        toggle_fold = {'zA', 'za', 'h', 'l'} -- toggle fold of current file
      },
      auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = true, -- automatically fold a file trouble list at creation
    },
    cmd = { 'Trouble' }, -- Lazy-load on commands
  },
  { -- Force vim motion operators instead of pressing lots of j's and k's movements keys
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {
      disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'Trouble' },
      disabled_keys = {
        ['<Up>'] = {},
        ['<Down>'] = {},
        ['<Left>'] = {},
        ['<Right>'] = {},
      }
    },
    event = { 'BufReadPost', 'BufNewFile' },
  },
  { -- Change surrounds more easily
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'InsertEnter',
    config = true
  },
  { -- Improve input and select nvim UI components
    'stevearc/dressing.nvim',
    dependencies = {'benmills/vimux'}, -- Execute tmux commands from neovim. Used by my custom command 'RunNpmCommand'
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      -- vim.ui.input = function(...)
      --   require('lazy').load({ plugins = { 'dressing.nvim' } })
      --   return vim.ui.input(...)
      -- end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
    end,
  },
  { -- Smooth scroll for neovim
    'declancm/cinnamon.nvim',
    event = 'VeryLazy',
    opts = { centered = false }
  },
  { -- Improved folding management
    "kevinhwang91/nvim-ufo",
    dependencies = {'kevinhwang91/promise-async', 'nvim-treesitter/nvim-treesitter'},
    event = { 'BufRead', 'BufWinEnter', 'BufNewFile' },
    keys = mymappings.ufo(),
    opts = {
      ---@diagnostic disable-next-line: unused-local
      provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
      end
    }
  },
  { -- Fix vim's behaviour put current line in the middle of the screen when switch between buffers
    'BranimirE/fix-auto-scroll.nvim',
    config = true,
    event = 'VeryLazy'
  },
  { -- Highlight URLs everywhere
    'itchyny/vim-highlighturl',
    event = 'VeryLazy',
    config = function()
      -- Disable the plugin in some places where the default highlighting is preferred.
      vim.api.nvim_create_autocmd('FileType', {
        desc = 'Disable URL highlights',
        pattern = {
          'fzf',
        },
        command = 'call highlighturl#disable_local()',
      })
    end,
  },
  {
    'nvim-pack/nvim-spectre',
    dependencies = 'nvim-lua/plenary.nvim',
    cmd = {'SearchAndReplace', 'FindAndReplace'},
    keys = mymappings.nvim_spectre(),
    opts = { open_cmd = 'noswapfile vnew' },
  },
}

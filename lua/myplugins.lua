local mymappings = require('mymappings')
local myutils = require('myutils')

return {
  { -- Theme
    'folke/tokyonight.nvim',
    event = 'VeryLazy',
    opts = {
      style = 'night',
      -- transparent = true,
      -- styles = {
      --   sidebars = 'transparent',
      --   floats = 'transparent',
      -- },
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
      check_ts = true,        -- check treesitter for autopairing
      enable_moveright = true -- TODO: Remove this line if it is not needed
    }
  },
  { -- Comment plugin
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = 'JoosepAlviste/nvim-ts-context-commentstring', -- Comment embedded scripts
    config = function()
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
      'HiPhish/nvim-ts-rainbow2',                    -- Colorize parenthesis pairs with distinct colors
      'nvim-treesitter/nvim-treesitter-textobjects', -- Add function and class selectors vaf = 'visual around function', '=if' = Format inner function
    },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      ensure_installed = { 'vim', 'lua', 'javascript', 'bash', 'css', 'json', 'json5', 'jsonc', 'python', 'typescript',
        'html', 'yaml', 'markdown', 'markdown_inline', 'scss', 'jsdoc', 'tsx', 'regex', 'diff', 'vimdoc' },
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
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
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
            padding = 1 -- For some reason it is not calculating the value correctly, this fix it
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
    -- opts = {
    --   background_colour = '#000000', -- WARN: Remove this line if the colorscheme is not transparent
    -- },
    config = function(_, opts)
      local notify = require('notify')
      notify.setup(opts)
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.notify = function(msg, ...)
        if type(msg) == 'string' then
          local is_suppressed_message = msg:match '%[lspconfig] Autostart for' or msg:match 'No information available' or msg:match '%[Lspsaga] response of request method textDocument/definition is empty'
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
  { -- Telescope - Fuzzy finder
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      -- 'nvim-telescope/telescope-ui-select.nvim' -- Show code actions in Telescope dropdown TODO: (a) check if this is still necessary with LspSaga
      'nvim-treesitter/nvim-treesitter'
    },
    cmd = 'Telescope',
    keys = mymappings.telescope(),
    opts = function()
      return {
        defaults = {
          prompt_prefix = ' ',
          selection_caret = ' ',
          file_ignore_patterns = {
            'node_modules',
            'ext.js',
            'ext-modern.js',
            'ext-modern-all.js',
            'ext-modern-all-sandbox.js',
            'ext-all.js',
            'ext-all-sandbox.js',
            'ext-all-rtl.js',
            'ext-all-rtl-sandbox.js'
          },
          mappings = {
            n = { ['q'] = require('telescope.actions').close },
          },
        },
        -- TODO: (a) same
        -- extensions = {
        --   ['ui-select'] = {
        --     require('telescope.themes').get_dropdown({})
        --   }
        -- },
        pickers = {
          find_files = {
            theme = 'dropdown',
            previewer = false,
            prompt_prefix = '  '
          },
          live_grep = {
            prompt_prefix = ' 󰱼 '
            -- prompt_prefix = ''
          }
        }
      }
    end,
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      telescope.load_extension('fzf')
      -- telescope.load_extension('ui-select') -- TODO: (a) same
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
      {
        'dsznajder/vscode-es7-javascript-react-snippets', -- TODO: Load plugin by filetype(only js and ts type files)
        build = 'yarn install --frozen-lockfile && yarn compile'
      }
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
      'onsails/lspkind.nvim'
    },
    opts = function()
      local cmp = require('cmp')
      local defaults = require('cmp.config.default')()
      return {
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },
        completion = {
          -- completeopt = 'menu,menuone,noinsert', -- same as vim's completeopt(see :help completeopt)
          completeopt = 'menu,menuone,noselect,noinsert', -- TODO: Check that this one is required
        },
        window = {
          completion = {
                         -- Move the menu to the left to match the
            col_offset = -3,
            side_padding = 0,
          },
        },
        mapping = cmp.mapping.preset.insert(myutils.parse_nvim_cmp_mapping(mymappings.nvim_cmp(cmp))),
        sources = cmp.config.sources({
          { name = 'git' },
          { name = 'vsnip' },
          { name = 'path' },
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
        }),
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require('lspkind').cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            kind.menu = '    (' .. (strings[2] or '') .. ')'

            return kind
          end,
        },
        experimental = {
          ghost_text = true,
        },
        sorting = defaults.sorting,
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
    'williamboman/mason.nvim',
    config = true
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim', -- It need to be setup before nvim-lspconfig
        dependencies = 'williamboman/mason.nvim',
        opts = { automatic_installation = true },
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
      {
        'hrsh7th/cmp-nvim-lsp-signature-help',
        cond = function()
          return myutils.has('nvim-cmp')
        end,
      },
      'jose-elias-alvarez/nvim-lsp-ts-utils', -- TODO: Load only for javascript files
      'nvimdev/lspsaga.nvim',
      { -- Collection of json schemas for json lsp
        'b0o/schemastore.nvim',
        ft = {'json', 'yaml', 'yml'},
      },
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = true
      }
    },
    config = function()
      local my_lsp_servers = {
        'lua_ls',
        'tsserver',
        'bashls',
        'pyright',
        'vimls',
        'marksman',
        'cssls',
        'cssmodules_ls',
        'clangd',
        'yamlls',
        'html',
        'sqlls',
        'eslint',
        'jsonls'
      }

      -- Most of lspsaga key mappings can be triggered using null-ls sources
      myutils.load_mapping(mymappings.lsp_saga())

      local on_attach = function(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        myutils.load_mapping(mymappings.lsp(bufnr))
      end

      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )
      -- capabilities.textDocument.completion.completionItem.snippetSupport = true

      local lspconfig = require('lspconfig');

      local my_lsp_server_config = {
        lua_ls = {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim' }, -- Get the language server to recognize the `vim` global
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true), -- Make the server aware of Neovim runtime files
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            },
          },
        },
        yamlls = {
          on_attach = on_attach,
          capabilities = capabilities,
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
        tsserver = {
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            -- Disable annoying convert JS module message
            require('nvim-lsp-ts-utils').setup({
              filter_out_diagnostics_by_code = { 80001 },
            })
            require('nvim-lsp-ts-utils').setup_client(client) -- client.resolved_capabilities.document_formatting = false
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
        jsonls = {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        }
      }
      for _, server_name in ipairs(my_lsp_servers) do
        if my_lsp_server_config[server_name] ~= nil then
          lspconfig[server_name].setup(my_lsp_server_config[server_name])
        else
          lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
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
    }
  },
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      ensure_installed = { 'prettier', 'flake8', 'black' }
    },
    dependencies = {
      'williamboman/mason.nvim',
      {
        'jose-elias-alvarez/null-ls.nvim',
        opts = function ()
          local null_ls = require('null-ls')

          local formatting = null_ls.builtins.formatting
          local diagnostics = null_ls.builtins.diagnostics
          local code_actions = null_ls.builtins.code_actions
          return {
            sources = {
              code_actions.gitsigns,
              -- code_actions.eslint,
              formatting.prettier,
              formatting.black,
              -- diagnostics.eslint
              diagnostics.flake8,
            }
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
    event = { 'BufReadPre', 'BufNewFile' },
  },
}

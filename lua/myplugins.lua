local mymappings = require('mymappings')
local myutils = require('myutils')

return {
  {
    "nvchad/ui",
    event = "VeryLazy",
    config = function()
      myutils.load_mapping(mymappings.tabufline())
      require "nvchad"
    end
  },
  {
    "nvchad/base46",
    event = "VeryLazy",
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "nvchad/volt",
    event = "VeryLazy",
  },
  {                                              -- File tree viewer
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' }, -- Lazy-load on commands
    dependencies = 'echasnovski/mini.icons',
    opts = function()
      return {
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
          adaptive_size = false,
        }
      }
    end,
    config = function (_, opts)
      require('nvim-tree').setup(opts)
      local nt_api = require('nvim-tree.api')
      myutils.sync_nvim_tree_lsp_rename(nt_api)
      -- Remove status line for nvim-tree
      nt_api.events.subscribe(nt_api.events.Event.TreeOpen, function()
        local tree_winid = nt_api.tree.winid()
        if tree_winid ~= nil then
          -- '' does not work as it set the global status line
          vim.api.nvim_set_option_value('statusline', ' ', {win = tree_winid})
          -- make the non-focused empty statusline background looks similar to nvim-tree background
          vim.api.nvim_set_hl(0, 'StatusLineNC', { link = 'NvimTreeNormal' })
        end
      end)
    end
  },
  { -- Tmux switch panels keys integration
    'christoomey/vim-tmux-navigator',
    lazy = false
  },
  { -- Autoclose ()[]{}
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true -- check treesitter for autopairing
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
      -- {
      --   'HiPhish/rainbow-delimiters.nvim',           -- Colorize parenthesis pairs with distinct colors
      --   url = 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim'
      -- },
      {
        'windwp/nvim-ts-autotag', -- Autoclose and rename html tags
        event = 'InsertEnter',
        opts = {}
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
          -- local n_lines = vim.api.nvim_buf_line_count(bufnr)
          -- -- https://github.com/dapc11/dnvim/blob/2724e18d558a0abf268b9443b7cbdc4cc2c73131/lua/core/autocommands.lua#L38
          -- return n_lines > 5000 or (n_lines > 0 and vim.fn.getfsize(vim.fn.expand('%')) / n_lines > 10000)
          -- Trying another options to disable treesitter
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          return ok and stats and stats.size > (250 * 1024)
        end,
        use_languagetree = true,                   -- use this to enable language injection
        additional_vim_regex_highlighting = false, -- Enable syntax on at the same time?
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<cr>',
          node_incremental = '<cr>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      indent = { enable = true }, -- Indent with = using treesitter
      -- autotag = { enable = true }, -- Do not use. Deprecated!
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
  { -- Notifications windows
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    opts = {
      background_colour = '#000000', -- WARN: Remove this line if the colorscheme is not transparent
      level = vim.log.levels.DEBUG,
      stages = "slide",
    },
    config = function(_, opts)
      local notify = require('notify')
      notify.setup(opts)
      ---@diagnostic disable-next-line: duplicate-set-field
      -- vim.notify = function(msg, ...)
      --   if type(msg) == 'string' then
      --     -- Disable notifications that contains those strings
      --     local is_suppressed_message = msg:match '%[lspconfig] Autostart for' or msg:match 'No information available' or
      --         msg:match '%[Lspsaga] response of request method textDocument/definition is empty' or
      --         msg:match 'for_each_child'
      --     if is_suppressed_message then
      --       -- Do not show some messages
      --       return
      --     end
      --   end
      --
      --   notify(msg, ...)
      -- end
      vim.notify = notify
    end,
  },
  { -- Vertical lines on indentation
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    commit = 'e7a4442e055ec953311e77791546238d1eaae507',
    event = { 'BufReadPost', 'BufNewFile' },
    ---@module "ibl"
    ---@type ibl.config
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
    config = function(_, opts)
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
              ["ghe.coxautoinc.com"] = require "gitlinker.hosts".get_github_type_url,
            },
            mappings = nil
          }
        end
      }
    },
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▌' },
        change = { text = '▌' },
        delete = { text = '▌' },
        topdelete = { text = '▌' },
        changedelete = { text = '▌' },
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
  {
    'ibhagwan/fzf-lua',
    keys = mymappings.fzf_lua(),
    cmd = 'FzfLua',
    opts = function()
      local actions = require 'fzf-lua.actions'
      -- vim.cmd('hi FzfLuaBorder guifg=#141423')
      vim.cmd('hi FzfLuaBorder guifg=#171927')
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
          -- Include .github files but continue excluding .git/ files
          rg_opts =
          "--column --line-number --no-heading --color=always --sort=path --smart-case --max-columns=4096 --hidden -g '!.git/*' -e",
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
    opts = {
      signs = false,
    },
    config = true,
  },
  { -- Set of already configured lsp clients
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'mason-org/mason-lspconfig.nvim', -- It need to be setup before nvim-lspconfig
        dependencies = {
          {
            'mason-org/mason.nvim',
            cmd = 'Mason',
            build = ':MasonUpdate',
            opts = function()
              return {
                ui = {
                  border = 'rounded',
                  width = 0.7,
                  height = 0.8,
                },
              }
            end
          }
        },
        opts = {
          ensure_installed = {
            'lua_ls',
            'bashls',
            'pyright',
            'vimls',
            'marksman',
            'cssls',
            -- Go to definition and hover for css classes references in js(x)/ts(x) files
            -- 'cssmodules_ls',
            'yamlls',
            'html',
            'sqlls',
            'jsonls',
            'docker_compose_language_service',
            'dockerls',
            'angularls',
            'terraformls',
            'ansiblels',
            'vtsls',
            'eslint'
          },
          automatic_enable = true, -- Automatically call to vim.lsp.enable('server-name') for all installed servers
        },
        config = function(_, opts)
          require('mason-lspconfig').setup(opts)
        end,
      },
      'nvimdev/lspsaga.nvim',
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
          },
        },
        dependencies = 'Bilal2453/luvit-meta'
      },
      {
        'b0o/schemastore.nvim',
        ft = 'json'
      }
    },
    config = function ()
      local lspconfig = require('lspconfig')
      local my_lsp_config = require('./myconfig/lsp')

      vim.lsp.config('*', {
        capabilities = my_lsp_config.client_capabilities()
      })

      local pyenv_virtualenv_python_path = myutils.get_pyenv_virtual_env_path()
      if pyenv_virtualenv_python_path ~= nil then
        vim.lsp.config('pyright', {
          settings = {
            python = {
              pythonPath = pyenv_virtualenv_python_path
            }
          }
        })
      end
      vim.lsp.config('yamlls', {
        settings = {
          yaml = {
            validate = true,
            format = {
              enable = true,
            },
            hover = true,
            completion = true,
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = true,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "", -- IMPORTANT!!! WITHOUT THIS NOTHING WORKS
            },
            schemas = {
              ['https://raw.githubusercontent.com/aws/serverless-application-model/main/samtranslator/schema/schema.json'] =
                '/template.yml',
            },
            -- schemas = require('schemastore').yaml.schemas(),
            customTags = {
              "!Ref",
              "!GetAtt",
              "!Fn",
              "!And",
              "!If sequence",
              "!Not",
              "!Not sequence",
              "!Equals",
              "!Equals sequence",
              "!Or",
              "!FindInMap sequence",
              "!Base64",
              "!Cidr",
              "!Sub",
              "!GetAZs",
              "!ImportValue",
              "!Select sequence",
              "!Split sequence",
              "!Join sequence",
            },
          },
        }
      })
      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
        -- Lazy-load schemas.
        -- on_new_config = function(config)
        --   config.settings.json.schemas = config.settings.json.schemas or {}
        --   vim.list_extend(config.settings.json.schemas, require('schemastore').json.schemas())
        -- end,
      })
      -- Configuration schema: https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
      vim.lsp.config('vtsls', {
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = false, -- It will use Vtsls bundled typescript version instead of node_modules typescript package
                                          -- Use :VtsExec select_ts_version to select the node_modules typescript
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              parameterNames = { enabled = 'all' },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              -- parameterNames = { enabled = 'all' },
              -- variableTypes = { enabled = true },
              -- functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          }
        },
        handlers = {
          -- Remove the message "File is a CommonJS module; it may be converted to an ES module."
          -- TODO: Migrate this function to myutils such that it can be used for other lsp servers
          ["textDocument/publishDiagnostics"] = function(err, res, ctx)
            local filtered = {}
            for _, diagnostic in ipairs(res.diagnostics) do
              if diagnostic.source == "ts" and diagnostic.code ~= 80001 then
                table.insert(filtered, diagnostic)
              end
            end

            res.diagnostics = filtered
            vim.lsp.diagnostic.on_publish_diagnostics(err, res, ctx)
          end
        }
      })
      -- vim.lsp.config('cssmodules_ls', {
      --   capabilities = vim.tbl_deep_extend("force", capabilities(), { definitionProvider = false }),
      -- })
      vim.lsp.config('eslint', {
        -- root_dir = function(cur_file_path)
        root_dir = function(bufnr, on_dir)
          local cur_file_path = vim.api.nvim_buf_get_name(bufnr)
          local package_json_dir = lspconfig.util.root_pattern('package.json')(cur_file_path)
          if not package_json_dir or not myutils.is_npm_package_installed('eslint', package_json_dir) then
            myutils.log('no eslint found in the package.json file')
            myutils.log(
              'checking any eslint config file existence to attach eslint LSP and show related notifications')
            -- If eslint config file is not find, LSP server is not attached
            on_dir(require('lspconfig.configs.eslint').default_config.root_dir(cur_file_path))
          end

          myutils.log('eslint found in the package.json file')
          myutils.log(
            'Detecting package.json folder as root_dir to attach eslint LSP server, so accurate messages are shown regarding eslint installation and config file')
          local root_path = lspconfig.util.root_pattern('package.json')(cur_file_path)
          on_dir(root_path)
        end,
        on_init = function(client)
          vim.api.nvim_create_user_command("CustomEslintFixAll", function() my_lsp_config.eslint_fix_all({ client = client, sync = true }) end, {})
        end,
      })
    end
  },
  { -- vtsls wrapper for typescript lsp
    "yioneko/nvim-vtsls",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    dependencies = 'neovim/nvim-lspconfig',
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
      ensure_installed = { 'stylua', 'shfmt', 'prettier' }
    },
    dependencies = {
      'mason-org/mason.nvim',
      {
        'nvimtools/none-ls.nvim',
        dependencies = {
          'nvimtools/none-ls-extras.nvim'
        },
        opts = function()
          local null_ls = require('null-ls')

          local code_actions = null_ls.builtins.code_actions

          local sources = {
            code_actions.gitsigns,
          }

          return {
            sources = sources,
            root_dir = require('null-ls.utils').root_pattern('.null-ls-root', 'Makefile', '.git', 'package.json',
              'index.js', 'main.js', 'index.py', 'main.py'),
            -- on_attach = function(client, bufnr)
            --   -- Disable hover for null-ls to prevent "No information found" message
            --   if client.name == "null-ls" then
            --     client.server_capabilities.hoverProvider = false
            --   end
            -- end,
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
    dependencies = { 'echasnovski/mini.icons' },
    opts = {
      action_keys = {                          -- key mappings for actions in the trouble list
        open_split = { '<c-x>', '|' },         -- open buffer in new split
        open_vsplit = { '<c-v>', '-' },        -- open buffer in new vsplit
        toggle_fold = { 'zA', 'za', 'h', 'l' } -- toggle fold of current file
      },
      auto_preview = false,                    -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = true,                        -- automatically fold a file trouble list at creation
    },
    cmd = { 'Trouble' },                       -- Lazy-load on commands
  },
  {                                            -- Force vim motion operators instead of pressing lots of j's and k's movements keys
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {
      disable_mouse = false, -- We do not want to disable the mouse scroll button
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
  {                -- Change surrounds more easily
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'InsertEnter',
    config = true
  },
  {
    'benmills/vimux',
    cmd = { 'RunNpmCommand', 'VimuxRunCommand' },
    ft = { 'cpp', 'javascript' }
  },
  {                                      -- Improve input and select nvim UI components
    'stevearc/dressing.nvim',
    dependencies = { 'benmills/vimux' }, -- Execute tmux commands from neovim. Used by my custom command 'RunNpmCommand'
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
  { -- Improved folding management
    "kevinhwang91/nvim-ufo",
    dependencies = { 'kevinhwang91/promise-async', 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufRead', 'BufWinEnter', 'BufNewFile' },
    keys = mymappings.ufo(),
    opts = {
      ---@diagnostic disable-next-line: unused-local
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
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
  { -- Icons
    "echasnovski/mini.icons",
    opts = {},
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        -- needed since it will be false when loading and mini will fail
        package.loaded["nvim-web-devicons"] = {}
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  { -- Formatters
    'stevearc/conform.nvim',
    event = { 'LspAttach', 'BufWritePre' },
    init = function()
      -- Use conform for gq.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        -- lua = { 'stylua' },
        sh = { 'shfmt' },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
      },
      format_on_save = false,
      log_level = vim.log.levels.DEBUG,
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      ---@diagnostic disable-next-line: duplicate-set-field
      require("conform.log").log = function(level, message, ...)
        if level == vim.log.levels.INFO or message:match('^Running LSP') ~= nil then
          local text = myutils.format_conform_log(message, ...)
          vim.notify(text)
        end
      end
    end
  },
  { -- Search and Replace
    'MagicDuck/grug-far.nvim',
    cmd = { 'GrugFar', 'SearchAndReplace', 'FindAndReplace' },
    keys = mymappings.grug_far(),
    lazy = false,
    opts = {
      -- transient = true, -- does not list this buffer and delete it when not in use
      keymaps = {
        help = { n = '?' }
      },
      resultsSeparatorLineChar = '='
    }
  },
  { -- Improve quickfix
    'stevearc/quicker.nvim',
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    keys = mymappings.quicker(),
    opts = {
      borders = {
        vert = '│',
        soft_header = "-"
      },
    },
  },
  { -- Improve view markdown files
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    ft = 'markdown',                                                                -- only load on markdown files
    config = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = false,
      },
      messages = {
        enabled = false,
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          -- ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = "*",
      },
    },
    event = "InsertEnter",

    -- use a release tag to download pre-built binaries
    -- version = 'v0.8.2',
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- snippets = {
      --   expand = function(snippet, _)
      --     return LazyVim.cmp.expand(snippet)
      --   end,
      -- },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = false,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        -- nerd_font_variant = 'mono'
        nerd_font_variant = 'normal',
        kind_icons = {
          Constant = '',
          Field = '',
          Property = '',
          Interface = '',
          Keyword = '',
          Type = '',
          TypeParameter = '',
          Variable = '',
          Class = '',
          Function = '',
          Method = '',
        }
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          treesitter_highlighting = true,
          window = {
            border = 'rounded',
            max_width = 100
          }
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },
      fuzzy = { implementation = 'prefer_rust' },
      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
        -- cmdline = function()
        --   local type = vim.fn.getcmdtype()
        --   -- Search forward and backward
        --   if type == '/' or type == '?' then
        --     -- return { 'buffer' }
        --     return {} -- We do not want suggestions on / and ? search
        --   end
        --   -- Commands
        --   if type == ':' then return { 'cmdline' } end
        --   return {}
        -- end,
        per_filetype = {
          codecompanion = { "codecompanion" },
        }
        -- min_keyword_length = 2, -- Minimmun chars to trigger completion menu
      },
      -- Experimental signature help support
      signature = { enabled = false }, -- false: we are gonna use noice.nvim signature
      keymap = {
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback'
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      },
    },
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },
  {
    "echasnovski/mini.indentscope", -- animate the indent line
    version = '*', -- wait till new 0.7.0 release to put it back on semver
    event = "VeryLazy",
    opts = {
      symbol = '▏',
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "Trouble",
          "alpha",
          "dashboard",
          "fzf",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "notify",
          "snacks_dashboard",
          "snacks_notif",
          "snacks_terminal",
          "snacks_win",
          "toggleterm",
          "trouble",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        callback = function(data)
          vim.b[data.buf].miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "folke/snacks.nvim", -- Images support
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- Leave configs  empty to use the default settings
      image = { enabled = true }, -- Show images in neovim using kitty images protocol
      bigfile = { enabled = true }, -- Detect big files and prevent some plugins to load
      scroll = { enabled = true, -- Smooth scroll
        animate = {
          duration = { step = 30, total = 150 },
          easing = "linear",
        },
      },
      lazygit = { enabled = true }, -- Configure lazygit to use nvim colorscheme colors
      styles = {
        float = { -- Configure lazygit height and width
          height = 0.8,
          width = 0.8,
          relative = "editor"
        }
      },
      toggle = { enabled = true,
        which_key = true,
        notify = true,
      }
    },
    config = function (_, opts)
      require('snacks').setup(opts)
      require('myconfig').setup_toggles()
    end
  },
  {
    "folke/persistence.nvim", -- Session management
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      need = 0, -- Always save the session
    }
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = "CopilotChat",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {},
  },
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapContinue",
      "DapLoadLaunchJSON",
      "DapRestartFrame",
      "DapSetLogLevel",
      "DapShowLog",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapTerminate",
      "DapToggleBreakpoint",
      "DapToggleRepl",
    },
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
          "mason-org/mason.nvim",
        },
        opts = {
          ensure_installed = {
            -- mappings -> https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
            "js", -- js-debug-adapter
            "chrome", -- 'chrome-debug-adapter'
          }
        }
      },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = {
          { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI toggle" },
        },
        opts = {
          icons = {
            collapsed = "",
            current_frame = "",
            expanded = "",
          },
        },
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text", -- virtual text for the debugger
        opts = {},
      }
    },
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      local dap = require("dap")
      -- Set Icons
      vim.api.nvim_call_function(
        "sign_define",
        { "DapBreakpoint", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
      )

      vim.api.nvim_call_function(
        "sign_define",
        { "DapBreakpointCondition", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
      )

      vim.api.nvim_call_function(
        "sign_define",
        { "DapLogPoint", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
      )

      vim.api.nvim_call_function(
        "sign_define",
        { "DapStopped", { linehl = "GitSignsChangeVirtLn", text = "", texthl = "diffChanged", numhl = "" } }
      )

      vim.api.nvim_call_function(
        "sign_define",
        { "DapBreakpointRejected", { linehl = "", text = "", texthl = "", numhl = "" } }
      )

      -- Setup the adapters
      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = { "${port}" },
          },
        }
      end

      -- The node adapter is not used as its modern alternative is pwa-node
      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then
            config.type = "pwa-node"
          end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      if not dap.adapters["pwa-chrome"] then
        dap.adapters["pwa-chrome"] = {
          type = 'executable',
          command = vim.fn.exepath('chrome-debug-adapter'),
        }
      end

      -- Setup compatibility with vscode dap config files
      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      ---@diagnostic disable-next-line: duplicate-set-field
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes

      -- Setup configurations
      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch current file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach to a running process (node --inspect flag is needed)",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-chrome",
              request = "launch",
              name = "Launch Chrome to debug client side code",
              -- default vite dev server url
              url = "http://localhost:5173",
              -- for TypeScript/Svelte
              sourceMaps = true,
              webRoot = "${workspaceFolder}/src",
              protocol = "inspector",
              port = 9222,
              -- skip files from vite's hmr
              skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
            }
          }
        end
      end
    end,
  },
  -- {
  --   'folke/flash.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     jump = { nohlsearch = true },
  --     prompt = {
  --       win_config = {
  --         border = 'none',
  --         -- Place the prompt above the statusline.
  --         row = -3,
  --       },
  --     },
  --     search = {
  --       exclude = {
  --         'flash_prompt',
  --         'qf',
  --         function(win)
  --           -- Non-focusable windows.
  --           return not vim.api.nvim_win_get_config(win).focusable
  --         end,
  --       },
  --     },
  --     modes = {
  --       -- Enable flash when searching with ? or /
  --       search = { enabled = false },
  --     },
  --   },
  --   keys = {
  --     {
  --       's',
  --       mode = { 'n', 'x', 'o' },
  --       function()
  --         require('flash').jump()
  --       end,
  --       desc = 'Flash',
  --     },
  --   },
  -- }
}

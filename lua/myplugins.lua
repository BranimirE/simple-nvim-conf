return {
  { -- Theme
    'folke/tokyonight.nvim',
    event = 'VeryLazy'
  },
  { -- Status line
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = function()
      require('myconfig/evil_lualine')
    end
  },
  {
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
        -- show indent lines(vertical lines)
        indent_markers = {
          enable = true,
        },
        icons = {
          -- position files' git status icon
          git_placement = "after",
          show = {
            folder_arrow = false, 
            -- show files' git status icons
            git = true,
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
  }
}

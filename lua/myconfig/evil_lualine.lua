-- Eviline config for lualine
-- Author: shadmansaleh(modfied by Branimir)
-- Credit: glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg          = '#16161E',
  bg_inactive = '#181821',
  fg          = '#bbc2cf',
  yellow      = '#ECBE7B',
  cyan        = '#00AFFF',
  darkblue    = '#081633',
  green       = '#A6E22E',
  orange      = '#FF8800',
  violet      = '#a9a1e1',
  magenta     = '#FF00FF',
  blue        = '#283457',
  red         = '#ec5f67',
  dark        = '#16161E',
  light       = '#ffffff',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 85
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg_inactive } },
    },
    disabled_filetypes = { 'NvimTree' },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    lualine_a = {
      {
        function ()
        --return '      '
          return '████████'
        end,
        -- color = { bg = colors.fg, fg = colors.dark },
        color = { fg = colors.blue },
        padding = { left = 0, right = 0 },
      },
    },
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  -- extensions = {'quickfix', 'nvim-tree'},
  extensions = { 'nvim-tree' },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  'mode',
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.cyan,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    local mode_color_fg = {
      n = colors.dark,
      i = colors.dark,
      v = colors.light,
      [''] = colors.light,
      V = colors.light,
      c = colors.light,
      no = colors.light,
      s = colors.dark,
      S = colors.dark,
      [''] = colors.dark,
      ic = colors.dark,
      R = colors.dark,
      Rv = colors.dark,
      cv = colors.light,
      ce = colors.light,
      r = colors.dark,
      rm = colors.dark,
      ['r?'] = colors.dark,
      ['!'] = colors.light,
      t = colors.light,
    }
    local mode_val = vim.fn.mode()
    return { bg = mode_color[mode_val], fg = mode_color_fg[mode_val], gui = 'bold' }
  end,
  padding = { left = 1, right = 1 },
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.cyan, gui = 'bold' },
}

ins_left {
  'branch',
  icon = '',
  color = { gui = 'bold' },
}

ins_left {
  'diff',
  symbols = { added = ' ', modified = ' ', removed = ' ' },
  diff_color = {
    added = { fg = colors.cyan },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}

ins_left {
  -- Lsp servers' name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    local lsp_servers = ''
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        if lsp_servers ~= '' then
          lsp_servers = lsp_servers .. ', '
        end
        lsp_servers = lsp_servers .. client.name
      end
    end
    if lsp_servers ~= '' then
      return lsp_servers
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
  cond = conditions.hide_in_width,
}

-- Add components to right sections
ins_right {
  'o:encoding',       -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

ins_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_right { 'location' }

lualine.setup(config)

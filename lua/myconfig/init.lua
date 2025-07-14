local M = {
  FORMAT_ON_SAVE = false,
  ESLINT_FIX_ALL_ON_SAVE = false,
  REFERENCES_ON_CURSOR_HOLD = true,
}

M.setup_toggles = function()
  local snacks = require('snacks')

  local toggles = {
    ---@type snacks.toggle.Opts
    {
      name = 'Format on save',
      keys = '<leader>tf',
      get = function() return M.FORMAT_ON_SAVE end,
      set = function(value) M.FORMAT_ON_SAVE = value end
    },
    ---@type snacks.toggle.Opts
    {
      name = 'Eslint Fix All on save',
      keys = '<leader>te',
      get = function() return M.ESLINT_FIX_ALL_ON_SAVE end,
      set = function(value) M.ESLINT_FIX_ALL_ON_SAVE = value end
    },
    ---@type snacks.toggle.Opts
    {
      name = 'Highlight references',
      keys = '<leader>tr',
      get = function() return M.REFERENCES_ON_CURSOR_HOLD end,
      set = function(value) M.REFERENCES_ON_CURSOR_HOLD = value end
    }
  }
  for _, toggle in ipairs(toggles) do
    snacks.toggle.new(toggle):map(toggle.keys, { mode = { "n" } })
  end
end

return M

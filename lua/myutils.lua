local M = {}

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(M.t(key), mode, true)
end

function M.get_visual_selection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

function M.get_last_search()
  local text = vim.fn.histget('/')

  if #text > 3 and text:find("^\\<.*\\>$") then
    text = text:sub(3, -3)
  end

  if #text > 0 then
    return text
  else
    return ''
  end
end

function M.smart_tab(cmp)
  return function()
    if cmp.visible() then
      cmp.confirm({ select = true })
    else
      local exist_vsnip, vsnip_available = pcall(vim.fn['vsnip#available'])
      if exist_vsnip and vsnip_available == 1 then
        M.feedkey('<Plug>(vsnip-expand-or-jump)', '')
      else
        M.feedkey([[<Tab>]], 'n')
      end
    end
  end
end

function M.shift_smart_tab(cmp)
  return function()
    if cmp.visible() then
      cmp.select_prev_item()
    else
      local exist_vsnip, vsnip_jumpable = pcall(vim.fn['vsnip#jumpable'], -1)
      if exist_vsnip and vsnip_jumpable == 1 then
        M.feedkey('<Plug>(vsnip-jump-prev)', '')
      else
        M.feedkey([[<S-Tab>]], 'n')
      end
    end
  end
end

function M.telescope_auto_input(source_input_fn, clean_hl_search)
  return function()
    local text = source_input_fn()
    if clean_hl_search then
      vim.cmd(M.t('nohlsearch')) -- Hide current highlighted search(if it exists)
    end
    -- Reference: https://github.com/nvim-telescope/telescope.nvim/issues/1939
    require('telescope.builtin').live_grep({
      default_text = text,
      on_complete = {
        function(picker)
          local mode = vim.fn.mode()
          local keys = mode ~= 'n' and '<esc>' or ''
          M.feedkey(keys .. '^2lv$<C-g>', 'n')

          -- should you have more callbacks, just pop the first one
          table.remove(picker._completion_callbacks, 1)

          local prompt_bufnr = picker.prompt_bufnr
          vim.keymap.set('s', '<cr>', '<esc>', { buffer = prompt_bufnr })
        end,
      }
    })
  end
end

function M.opts_parser(keys)
  local opts = {}
  for k, v in pairs(keys) do
    if type(k) ~= "number" and k ~= "mode" then
      opts[k] = v
    end
  end
  return opts
end

function M.load_mapping(mapping_table)
  for _, mapping in pairs(mapping_table) do
    local keys = vim.deepcopy(mapping)
    local opts = M.opts_parser(keys)
    keys.mode = keys.mode or 'n'

    vim.keymap.set(keys.mode, keys[1], keys[2], opts)
  end
end

function M.with_opts(mapping_table, extra_opts)
  local ret = {}
  for _, mapping in pairs(mapping_table) do
    table.insert(ret, vim.tbl_extend('keep', mapping, extra_opts)) -- Do not overwrite the existings opts
  end

  return ret
end

function M.nvim_tree_smart_split(nvim_tree_api)
  return function()
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
        nvim_tree_api.node.open.horizontal()
        return
      end
    end
    nvim_tree_api.node.open.vertical()
  end
end

function M.parse_nvim_cmp_mapping(mapping_table)
  local parsed = {}
  for _, mapping in pairs(mapping_table) do
    parsed[mapping[1]] = mapping[2]
  end
  return parsed
end

function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

function M.next_hunk(gitsigns)
  return function()
    if vim.wo.diff then
      return ']c'
    end
    vim.schedule(function()
      gitsigns.next_hunk()
    end)
    return '<Ignore>'
  end
end

function M.prev_hunk(gitsigns)
  return function()
    if vim.wo.diff then
      return '[c'
    end
    vim.schedule(function()
      gitsigns.prev_hunk()
    end)
    return '<Ignore>'
  end
end

function M.is_range_formatting_supported()
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.server_capabilities.documentRangeFormattingProvider then
      print(client.name .. ' supports range formatting')
      return true
    end
  end
  return false
end

function M.is_win_type_visible(win_type)
  local wins = vim.fn.getwininfo()
  for _, win in ipairs(wins) do
    if win[win_type] > 0 then
      return true
    end
  end
  return false
end

function M.get_opened_filetypes()
  local filetypes = {}
  local buffers = vim.api.nvim_list_bufs()
  for _, buffer in ipairs(buffers) do
    local buf_filetype = vim.api.nvim_buf_get_option(buffer, 'filetype')
    if buf_filetype and not vim.tbl_contains(filetypes, buf_filetype) then
      table.insert(filetypes, buf_filetype)
    end
  end
  return filetypes
end

function M.is_buffer_type_visible(buffer_type)
  local buffers = vim.api.nvim_list_bufs()
  for _, buffer in ipairs(buffers) do
    local buf_filetype = vim.api.nvim_buf_get_option(buffer, 'filetype')
    if buf_filetype == buffer_type then
      return true
    end
  end
  return false
end

function M.move_with_arrows(direction)
  return function ()
    if M.is_win_type_visible('quickfix') then
      if direction == '<up>' then
        if not pcall(vim.cmd, 'cprevious') then
          pcall(vim.cmd, 'clast')
        end
      else
        if not pcall(vim.cmd, 'cnext') then
          pcall(vim.cmd, 'cfirst')
        end
      end
      return
    end
    if M.is_buffer_type_visible('Trouble') then
      local trouble = require('trouble')
      if direction == '<up>' then
        trouble.previous({skip_groups = true, jump = true})
      else
        trouble.next({skip_groups = true, jump = true})
      end
      return
    end
    M.feedkey(direction, 'n')
  end
end

return M

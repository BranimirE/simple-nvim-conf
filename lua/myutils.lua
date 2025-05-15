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

  ---@diagnostic disable-next-line: param-type-mismatch
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

-- function M.parse_nvim_cmp_mapping(mapping_table)
--   local parsed = {}
--   for _, mapping in pairs(mapping_table) do
--     parsed[mapping[1]] = mapping[2]
--   end
--   return parsed
-- end

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

function M.is_win_type_visible(win_type)
  local wins = vim.fn.getwininfo()
  ---@diagnostic disable-next-line: param-type-mismatch
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
  return function()
    if M.is_win_type_visible('quickfix') then
      if direction == '<up>' then
        ---@diagnostic disable-next-line: param-type-mismatch
        if not pcall(vim.cmd, 'cprevious') then
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, 'clast')
        end
      else
        ---@diagnostic disable-next-line: param-type-mismatch
        if not pcall(vim.cmd, 'cnext') then
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, 'cfirst')
        end
      end
      return
    end
    if M.is_buffer_type_visible('Trouble') then
      local trouble = require('trouble')
      if direction == '<up>' then
        trouble.previous({ skip_groups = true, jump = true })
      else
        trouble.next({ skip_groups = true, jump = true })
      end
      return
    end
    M.feedkey(direction, 'n')
  end
end

function M.run_current_file_tests()
  require('neotest').summary.open()
  vim.defer_fn(function()
    require('neotest').run.run(vim.fn.expand('%'))
  end, 100)
end

function M.list_npm_commands()
  local npm_commands = {}
  local success, commands_str = pcall(vim.fn.system,
    "node -e \"var filePath='.' + require('path').sep + 'package.json'; process.stdout.write(Object.keys((require('fs').existsSync(filePath) && require(filePath).scripts) || {}).join(','))\"")
  if success then
    ---@diagnostic disable-next-line: param-type-mismatch
    for command in string.gmatch(commands_str, '([^,]+)') do
      npm_commands[#npm_commands + 1] = command
    end
  end

  return npm_commands
end

function M.select_npm_command(cb)
  local npm_commands = M.list_npm_commands()

  if next(npm_commands) == nil then
    print("No npm command found")
    cb(nil)
    return
  end

  vim.ui.select(npm_commands, { prompt = 'Select command:' }, cb)
end

function M.run_command(command_str)
  if vim.fn.exists('$TMUX') ~= 0 then
    local prev_vimux_orientation = vim.g.VimuxOrientation
    vim.g.VimuxOrientation = 'h'
    vim.api.nvim_call_function("VimuxRunCommand", { command_str })
    vim.g.VimuxOrientation = prev_vimux_orientation
  else
    vim.cmd('vsp | terminal ' .. command_str)
    -- Move the terminal to the right side of the screen
    M.feedkey([[<c-w>L]], 'n')
    M.feedkey([[54<c-w>|]], 'n')
  end
end

function M.run_program()
  local filetype = vim.bo.filetype

  if filetype == 'cpp' then
    vim.cmd('wa')
    vim.cmd('make')
    M.feedkey([[<cr>]], 'n')
  end

  if filetype == 'javascript' then
    M.select_npm_command(function(npm_command_str)
      if npm_command_str ~= nil then
        M.run_command("npm run " .. npm_command_str)
      else
        M.run_command("clear && node " .. vim.fn.expand('%'))
      end
    end)
  end
end

function M.file_exists(filename)
  local Path = require('plenary.path')
  local path = Path:new(filename)
  return path:exists()
end

-- Taken from: https://github.com/JoosepAlviste/dotfiles/blob/master/config/nvim/lua/j/utils.lua
function M.read_json_file(filename, parent_dir)
  local Path = require('plenary.path')
  local path = nil
  if parent_dir then
    path = Path:new(parent_dir, filename)
  else
    path = Path:new(filename)
  end
  if not path:exists() then
    return nil
  end

  local json_contents = path:read()
  local json = vim.fn.json_decode(json_contents)

  return json
end

function M.read_package_json(package_json_dir)
  return M.read_json_file('package.json', package_json_dir)
end

-- Check if the given NPM package is installed in the current project.
-- @param package string
-- @return boolean
function M.is_npm_package_installed(package, package_json_dir)
  local package_json = M.read_package_json(package_json_dir)
  if not package_json then
    return false
  end

  if package_json.dependencies and package_json.dependencies[package] then
    return true
  end

  if package_json.devDependencies and package_json.devDependencies[package] then
    return true
  end

  return false
end

function M.disable_formatting(lsp_client)
  M.log("Disabling formatting for client=" .. lsp_client.name)
  lsp_client.server_capabilities.documentFormattingProvider = false
  lsp_client.server_capabilities.documentRangeFormattingProvider = false
end

function M.log(message)
  if not vim.g.CUSTOM_LOGS then
    local file = io.open(vim.loop.os_homedir() .. '/nvimlogs.log', "a")
    if not message then
      message = 'nil'
    end

    if file then
      file:write(message .. "\n")
      file:close()
    else
      print("Error: Unable to open the log file for appending.")
    end
  end
end

function M.format_conform_log(msg, ...)
  local args = vim.F.pack_len(...)
  for i = 1, args.n do
    local v = args[i]
    if type(v) == "table" then
      args[i] = vim.inspect(v)
    elseif v == nil then
      args[i] = "nil"
    end
  end
  local ok, text = pcall(string.format, msg, vim.F.unpack_len(args))
  if ok then
    return text
  else
    return string.format(
      "[ERROR] error formatting log line: '%s' args %s",
      vim.inspect(msg),
      vim.inspect(args)
    )
  end
end

function M.format(cmd_opts, is_async)
  M.log('Formating!!')
  M.notify('Format', 'Formatting !!!')
  if is_async == nil then
    is_async = true -- Default value for async will be true
  end
  local range = nil
  if cmd_opts ~= nil and cmd_opts.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, cmd_opts.line2 - 1, cmd_opts.line2, true)[1]
    range = {
      start = { cmd_opts.line1, 0 },
      ['end'] = { cmd_opts.line2, end_line:len() },
    }
  end
  require('conform').format({ async = is_async, range = range })
end

-- Taken from: https://github.com/numToStr/Comment.nvim/issues/22#issuecomment-1272569139
function M.uncomment_block()
  local utils = require 'Comment.utils'

  local row = vim.api.nvim_win_get_cursor(0)[1]

  local comment_str = require('Comment.ft').calculate {
    ctype = utils.ctype.linewise,
    range = {
      srow = row,
      scol = 0,
      erow = row,
      ecol = 0,
    },
    cmotion = utils.cmotion.line,
    cmode = utils.cmode.toggle,
  } or vim.bo.commentstring
  local l_comment_str, r_comment_str = utils.unwrap_cstr(comment_str)

  local is_commented = utils.is_commented(l_comment_str, r_comment_str, true)

  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
  if next(line) == nil or not is_commented(line[1]) then
    return
  end

  local comment_start, comment_end = row, row
  repeat
    comment_start = comment_start - 1
    line = vim.api.nvim_buf_get_lines(0, comment_start - 1, comment_start, false)
  until next(line) == nil or not is_commented(line)
  comment_start = comment_start + 1
  repeat
    comment_end = comment_end + 1
    line = vim.api.nvim_buf_get_lines(0, comment_end - 1, comment_end, false)
  until next(line) == nil or not is_commented(line)
  comment_end = comment_end - 1

  vim.cmd(string.format('normal! %dGV%dG', comment_start, comment_end))
end

function M.open_in_browser()
  require('gitlinker').get_buf_range_url('n', { action_callback = require('gitlinker.actions').open_in_browser })
end

function M.get_link()
  require('gitlinker').get_buf_range_url('n', {})
end

function M.search_and_replace()
  -- TODO: Make open existing GrugFar when we call search and replace when it is already opened
  -- use this as reference https://github.com/MagicDuck/grug-far.nvim/tree/main#:~:text=other%20fields%20intact-,Nvim,-tree%20lazy%20plugin
  require('grug-far').open()
end

function M.is_empty(s)
  return s == nil or s == ''
end

function M.get_pyenv_virtual_env_path()
  local virtual_env = vim.fn.system('pyenv virtualenvs | grep -e "^*"')
  if not M.is_empty(virtual_env) then
    local python_path = vim.fn.trim(vim.fn.system('pyenv which python'))
    M.log("Pyenv python path detected="..python_path)
    return python_path
  end
  return nil
end

-- nvim-tree utilities
local path_sep = package.config:sub(1, 1)

function M.trim_sep(path)
  return path:gsub(path_sep .. "$", "")
end

function M.uri_from_path(path)
  return vim.uri_from_fname(M.trim_sep(path))
end

function M.is_sub_path(path, folder)
  path = M.trim_sep(path)
  folder = M.trim_sep(folder)
  if path == folder then
    return true
  else
    return path:sub(1, #folder + 1) == folder .. path_sep
  end
end

function M.check_folders_contains(folders, path)
  for _, folder in pairs(folders) do
    if M.is_sub_path(path, folder.name) then
      return true
    end
  end
  return false
end

function M.match_file_operation_filter(filter, name, type)
  if filter.scheme and filter.scheme ~= "file" then
    -- we do not support uri scheme other than file
    return false
  end
  local pattern = filter.pattern
  local matches = pattern.matches

  if type ~= matches then
    return false
  end

  local regex_str = vim.fn.glob2regpat(pattern.glob)
  if vim.tbl_get(pattern, "options", "ignoreCase") then
    regex_str = "\\c" .. regex_str
  end
  return vim.regex(regex_str):match_str(name) ~= nil
end

function M.sync_nvim_tree_lsp_rename(nvim_tree_api)
  nvim_tree_api.events.subscribe(nvim_tree_api.events.Event.NodeRenamed, function(data)
    local stat = vim.loop.fs_stat(data.new_name)
    if not stat then
      return
    end
    local type = ({ file = "file", directory = "folder" })[stat.type]
    local clients = vim.lsp.get_clients({})
    for _, client in ipairs(clients) do
      if M.check_folders_contains(client.workspace_folders, data.old_name) then
        local filters = vim.tbl_get(client.server_capabilities, "workspace", "fileOperations", "didRename", "filters")
            or {}
        for _, filter in pairs(filters) do
          if
              M.match_file_operation_filter(filter, data.old_name, type)
              and M.match_file_operation_filter(filter, data.new_name, type)
          then
            client.notify(
              "workspace/didRenameFiles",
              { files = { { oldUri = M.uri_from_path(data.old_name), newUri = M.uri_from_path(data.new_name) } } }
            )
          end
        end
      end
    end
  end)
end

function M.delete_buffer_keep_layout()
  if not vim.bo.modified then
    vim.cmd('bp|sp|bn|bd')
  else
    vim.notify('Buffer has been modified!!\nSave before deleting the buffer', vim.log.levels.WARN)
  end
end

function M.calc_paplay_volume(percentage)
  return percentage / 100.0 * 65536.0
end

function M.play_sound(path)
  local function cb(code)
    if code ~= 0 then
      print("Couldn't play sound, exit code: " .. code)
    end
  end

  if not M.file_exists(path) then
    print('File not found!')
    return
  end

  local handle, pid = vim.uv.spawn('paplay', { args = { '--volume=' .. M.calc_paplay_volume(30), path } }, cb)
  if handle == nil then
    print("Error spawning paplay")
  end
end

-- Idea taken from https://github.com/rcarriga/nvim-notify/issues/43#issuecomment-1030604806
function M.notify(title, message)
  if title == nil then
    title = "Title goes here"
    message = "Content of the message here"
  end
  local level = vim.log.levels.INFO
  local display = ""
  local notification = vim.notify(display, level, {
    title = title,
    timeout = false,
    hide_from_history = true
  })

  local function show_animation()
    if message ~= display then
      local idx = string.len(display) + 1
      local cur = string.sub(message, idx, idx)
      display = display .. cur

      if cur ~= ' ' then
        M.play_sound(vim.loop.os_homedir() .. '/sounds/tick.ogg')
      end

      local next
      if message == display then
        next = vim.notify(display, nil, {
          hide_from_history = false,
          replace = notification,
          timeout = 2000
        })
      else
        next = vim.notify(display, nil, { replace = notification })
      end

      notification = next
      vim.defer_fn(function()
        show_animation()
      end, 30)
    end
  end

  vim.defer_fn(show_animation, 400)
end

return M

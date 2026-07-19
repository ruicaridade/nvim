local M = {}

local targets = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Herdr" })
end

---@param path string
---@return string
local function relative_path(path)
  local ok, relative = pcall(vim.fs.relpath, vim.fn.getcwd(0), path)
  return ok and relative and relative ~= "" and relative or path
end

---@param args string[]
---@return table|nil result
---@return string|nil error
local function command(args)
  if vim.fn.executable("herdr") ~= 1 then
    return nil, "herdr is not installed or is not on PATH"
  end

  local argv = { "herdr" }
  vim.list_extend(argv, args)

  local process = vim.system(argv, { text = true }):wait()
  if process.code ~= 0 then
    local error = vim.trim(process.stderr or "")
    return nil, error ~= "" and error or ("herdr exited with code %d"):format(process.code)
  end

  local ok, response = pcall(vim.json.decode, process.stdout)
  if not ok or type(response) ~= "table" or type(response.result) ~= "table" then
    return nil, "herdr returned an invalid response"
  end

  return response.result
end

---@return table|nil pane
---@return string|nil error
local function current_pane()
  if vim.env.HERDR_ENV ~= "1" or not vim.env.HERDR_PANE_ID then
    return nil, "Neovim is not running in a Herdr pane"
  end
  local result, error = command({ "pane", "current", "--current" })
  return result and result.pane or nil, error
end

---@param workspace_id string
---@return table[]|nil panes
---@return string|nil error
local function workspace_panes(workspace_id)
  local result, error = command({ "pane", "list", "--workspace", workspace_id })
  return result and result.panes or nil, error
end

---@param pane table
---@return string
local function agent_name(pane)
  return pane.display_agent or pane.title or pane.label or pane.agent or pane.pane_id
end

---@param pane table
---@param current table
---@return string
local function format_agent(pane, current)
  local location = pane.tab_id == current.tab_id and "current tab" or pane.tab_id
  local cwd = pane.foreground_cwd or pane.cwd
  local details = { location, pane.agent_status }
  if cwd and cwd ~= "" then
    details[#details + 1] = vim.fn.fnamemodify(cwd, ":~")
  end
  return ("%s  [%s]"):format(agent_name(pane), table.concat(details, " · "))
end

---@param panes table[]
---@param current table
---@return table[]
local function agents(panes, current)
  local result = vim.tbl_filter(function(pane)
    return pane.agent ~= nil and pane.terminal_id ~= current.terminal_id
  end, panes)

  table.sort(result, function(left, right)
    local left_local = left.tab_id == current.tab_id
    local right_local = right.tab_id == current.tab_id
    if left_local ~= right_local then
      return left_local
    end
    return format_agent(left, current) < format_agent(right, current)
  end)

  return result
end

---@param choices table[]
---@param current table
---@param callback fun(pane: table)
local function choose(choices, current, callback)
  vim.ui.select(choices, {
    prompt = "Send review to Herdr agent",
    format_item = function(pane)
      return format_agent(pane, current)
    end,
  }, function(pane)
    if not pane then
      return
    end
    targets[current.tab_id] = pane.terminal_id
    callback(pane)
  end)
end

---@param callback fun(pane: table)
---@param opts? { force: boolean }
local function resolve_agent(callback, opts)
  local current, current_error = current_pane()
  if not current then
    notify(current_error or "Neovim is not running in a Herdr pane", vim.log.levels.ERROR)
    return
  end

  local panes, panes_error = workspace_panes(current.workspace_id)
  if not panes then
    notify(panes_error or "Could not list Herdr panes", vim.log.levels.ERROR)
    return
  end

  local choices = agents(panes, current)
  if #choices == 0 then
    notify("No agents found in this Herdr workspace", vim.log.levels.WARN)
    return
  end

  if not (opts and opts.force) then
    local remembered = targets[current.tab_id]
    if remembered then
      for _, pane in ipairs(choices) do
        if pane.terminal_id == remembered then
          callback(pane)
          return
        end
      end
      targets[current.tab_id] = nil
    end

    local local_agents = vim.tbl_filter(function(pane)
      return pane.tab_id == current.tab_id
    end, choices)

    if #local_agents == 1 then
      targets[current.tab_id] = local_agents[1].terminal_id
      callback(local_agents[1])
      return
    elseif #local_agents > 1 then
      choose(local_agents, current, callback)
      return
    elseif #choices == 1 then
      targets[current.tab_id] = choices[1].terminal_id
      callback(choices[1])
      return
    end
  end

  choose(choices, current, callback)
end

---@param text string
---@param opts? { submit: boolean }
function M.send(text, opts)
  if type(text) ~= "string" or text == "" then
    notify("There is nothing to send", vim.log.levels.WARN)
    return
  end

  resolve_agent(function(pane)
    local result, error = command({ "pane", "send-text", pane.pane_id, text .. "\n" })
    if not result then
      notify(error or "Could not send text to the agent", vim.log.levels.ERROR)
      return
    end

    if opts and opts.submit then
      result, error = command({ "pane", "send-keys", pane.pane_id, "enter" })
      if not result then
        notify(error or "The review was inserted but could not be submitted", vim.log.levels.ERROR)
        return
      end
    end

    notify(("Sent review to %s"):format(agent_name(pane)))
  end)
end

function M.send_review()
  local ok, store = pcall(require, "review.store")
  if not ok then
    notify("review.nvim is not loaded", vim.log.levels.ERROR)
    return
  end
  if store.count() == 0 then
    notify("No review comments to send", vim.log.levels.WARN)
    return
  end

  M.send(require("review.export").generate_markdown())
end

---@return string|nil context
---@return string|nil error
function M.editor_context()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" then
    return nil, "The current buffer is not backed by a file"
  end

  local name = relative_path(path)
  local mode = vim.fn.mode()
  if not vim.tbl_contains({ "v", "V", "\22" }, mode) then
    local cursor = vim.api.nvim_win_get_cursor(0)
    return ("%s:%d"):format(name, cursor[1])
  end

  local from = vim.fn.getpos("v")
  local to = vim.fn.getpos(".")
  local start_row = math.min(from[2], to[2])
  local end_row = math.max(from[2], to[2])
  return end_row == start_row
      and ("%s:%d"):format(name, start_row)
    or ("%s:%d-%d"):format(name, start_row, end_row)
end

function M.send_context()
  local was_visual = vim.tbl_contains({ "v", "V", "\22" }, vim.fn.mode())
  local context, error = M.editor_context()
  if not context then
    notify(error or "Could not read the current selection", vim.log.levels.WARN)
    return
  end
  if was_visual then
    local escape = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(escape, "nx", false)
  end
  M.send(context)
end

function M.select_agent()
  resolve_agent(function(pane)
    notify(("Selected %s for this tab"):format(agent_name(pane)))
  end, { force = true })
end

function M.setup()
  vim.api.nvim_create_user_command("HerdrAgentSelect", M.select_agent, {
    desc = "Select the Herdr agent that receives Neovim messages",
  })
end

return M

-- The sidebar shrinks to fit its contents, but never grows past MAX_WIDTH.
local MIN_WIDTH, MAX_WIDTH = 20, 40

-- Room taken by indent guides, expander and file icon, plus a little slack for
-- the git status / diagnostics trailing a line.
local LINE_OVERHEAD = 8

-- Width of the widest line neo-tree will draw for the current tree. Measured
-- from the tree rather than the buffer, since drawn lines are truncated to the
-- window width and so can never ask for more room.
local function widest_line(tree, parent_id)
  local width = 0
  for _, node in ipairs(tree:get_nodes(parent_id)) do
    local depth = node:get_depth()
    -- The root node's name is the whole cwd path, but it is drawn shortened.
    local name = depth == 1 and vim.fs.basename(node.name or "") or node.name or ""
    width = math.max(width, (depth - 1) * 2 + vim.api.nvim_strwidth(name))
    if node:has_children() and node:is_expanded() then
      width = math.max(width, widest_line(tree, node:get_id()))
    end
  end
  return width
end

local function sidebar_width(state)
  -- Fall back to the max on the very first open, before a tree exists.
  local width = state.tree and widest_line(state.tree, nil) + LINE_OVERHEAD or MAX_WIDTH
  return math.min(MAX_WIDTH, math.max(MIN_WIDTH, width))
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- Re-fit the sidebar whenever its contents change, so expanding a folder or
    -- filtering resizes it instead of leaving it as it opened.
    local function fit(state)
      local position = state.current_position
      if position ~= "left" and position ~= "right" then
        return
      end
      if not state.winid or not vim.api.nvim_win_is_valid(state.winid) then
        return
      end
      local width = sidebar_width(state)
      if width ~= vim.api.nvim_win_get_width(state.winid) then
        vim.api.nvim_win_set_width(state.winid, width)
      end
    end

    -- after_render covers opening and refreshing; some commands (collapsing all
    -- nodes, for one) redraw the buffer without firing it, hence the watcher.
    local watched = {}
    require("neo-tree.events").subscribe({
      event = "after_render",
      handler = function(state)
        fit(state)
        local bufnr = state.bufnr
        if not bufnr or watched[bufnr] then
          return
        end
        watched[bufnr] = true
        vim.api.nvim_buf_attach(bufnr, false, {
          on_lines = function()
            vim.schedule(function()
              fit(state)
            end)
          end,
          on_detach = function()
            watched[bufnr] = nil
          end,
        })
      end,
    })

    -- Auto-refresh neo-tree when Neovim regains focus (e.g. after lazygit, claude code)
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        local events = require("neo-tree.events")
        events.fire_event(events.GIT_EVENT)
        events.fire_event(events.FS_EVENT)
      end,
    })
  end,
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        never_show = { ".git" },
        hide_by_pattern = { "*_templ.go" },
      },
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    window = {
      position = "left",
      width = sidebar_width,
    },
  },
}

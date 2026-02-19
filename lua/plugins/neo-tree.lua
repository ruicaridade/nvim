return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

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
      width = 35,
    },
  },
}

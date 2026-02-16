return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        never_show = { ".git" },
        hide_by_pattern = { "*_templ.go" },
      },
      follow_current_file = { enabled = true },
    },
    window = {
      width = 35,
    },
  },
}

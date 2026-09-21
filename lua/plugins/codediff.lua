return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Git diff: working tree" },
      {
        "<leader>gD",
        function()
          vim.ui.input({ prompt = "Base branch: ", default = "develop" }, function(base)
            if base and base ~= "" then
              vim.cmd.CodeDiff(base .. "...")
            end
          end)
        end,
        desc = "Git diff: against base",
      },
      { "<leader>gh", "<cmd>CodeDiff history<cr>", desc = "Git diff: history" },
    },
    opts = {
      diff = {
        cycle_hunks_across_files = true,
      },
      explorer = {
        initial_focus = "modified",
        line_stats = {
          enabled = true,
          count_untracked = true,
        },
      },
    },
  },
}

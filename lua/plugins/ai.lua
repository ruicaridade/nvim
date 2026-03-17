return {
  {
    "folke/sidekick.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      nes = {
        enabled = false,
      },
      cli = {
        mux = {
          enabled = true,
          backend = "tmux",
        },
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        mode = { "n", "x" },
        desc = "Select AI CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Toggle AI CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "n", "x" },
        desc = "Send to AI CLI",
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Toggle Claude CLI",
      },
      {
        "<leader>ao",
        function()
          require("sidekick.cli").toggle({ name = "opencode", focus = true })
        end,
        desc = "Toggle OpenCode CLI",
      },
    },
  },
}

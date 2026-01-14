return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      input = { enabled = true },
      statuscolumn = { enabled = true },
      rename = { enabled = true },
      notifier = { enabled = true },
      picker = {
        sources = {
          explorer = {
            layout = {
              layout = {
                width = 35,
              },
            },
          },
        },
      },
      indent = {
        enabled = true,
        animate = { enabled = false },
        scope = { enabled = false },
      },
    }
  },
  {
    "nvim-mini/mini.pairs",
    config = true,
  },
  {
    "nvim-mini/mini.icons",
    config = true,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    config = true,
  },
  { "tpope/vim-sleuth" },
  {
    "otavioschwanck/arrow.nvim",
    opts = {
      leader_key = ';'
    }
  },
}

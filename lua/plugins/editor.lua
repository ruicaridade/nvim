return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "elixir", "heex", "eex", "lua", "python", "rust",
        "javascript", "typescript", "go", "gomod", "gosum",
        "gowork", "templ",
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      input = { enabled = true },
      statuscolumn = { enabled = true },
      rename = { enabled = true },
      explorer = { enabled = false },
      notifier = { enabled = false },
      picker = {},
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
  {
    "petertriho/nvim-scrollbar",
    dependencies = { "lewis6991/gitsigns.nvim" },
    config = function()
      local colors = {
        handle = "#524f67",
        bg = "#1f1d2e",
        error = "#eb6f92",
        warn = "#f6c177",
        info = "#9ccfd8",
        hint = "#c4a7e7",
        git_add = "#9ccfd8",
        git_change = "#f6c177",
        git_delete = "#eb6f92",
      }
      require("scrollbar").setup({
        excluded_filetypes = {
          "snacks_picker_list",
          "snacks_picker_preview",
          "neo-tree",
        },
        handle = {
          color = colors.handle,
        },
        handlers = {
          cursor = false,
        },
        marks = {
          Error = { color = colors.error },
          Warn = { color = colors.warn },
          Info = { color = colors.info },
          Hint = { color = colors.hint },
          GitAdd = { color = colors.git_add },
          GitChange = { color = colors.git_change },
          GitDelete = { color = colors.git_delete },
        },
      })
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
}

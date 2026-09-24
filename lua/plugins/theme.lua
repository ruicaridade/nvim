return {
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = true,
    config = function()
      require('kanagawa').setup({
        transparent = true,
      })
      vim.cmd('colorscheme kanagawa')
    end
  },
  {
    "nvim-mini/mini.base16",
    branch = "stable",
    lazy = false,
    priority = 1000,
    config = function()
      if not require('omarchy_theme').setup() then
        vim.cmd('colorscheme kanagawa')
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = true,
  },
}

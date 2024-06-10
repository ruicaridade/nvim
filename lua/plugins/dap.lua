return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "jay-babu/mason-nvim-dap.nvim",

    -- Plugins
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    require "configs.dap"
  end,
}

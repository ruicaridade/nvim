return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",

    -- Plugins
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    require "configs.dap"
  end,
}

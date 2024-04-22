local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local servers = {
  -- JS
  tsserver = {},
  tailwindcss = {},
  html = {},

  -- Python
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          typeCheckingMode = "off",
        },
      },
    },
  },

  -- Go
  gopls = {
    completeUnimported = true,
    analyses = {
      unusedparams = true,
    },
  },

  -- SQL
  sqls = {},
}

for name, opts in pairs(servers) do
  opts.on_init = on_init
  opts.on_attach = on_attach
  opts.capabilities = capabilities

  require("lspconfig")[name].setup(opts)
end

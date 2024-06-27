local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local servers = {
  -- Web
  tailwindcss = {
    filetypes = { "templ", "astro", "javascript", "typescript", "react", "html" },
    init_options = { userLanguages = { templ = "html" } },
  },
  htmx = {
    filetypes = { "html", "templ" },
  },
  html = {},

  -- JS
  tsserver = {},

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
  jinja_lsp = {},

  -- Go
  gopls = {
    completeUnimported = true,
    analyses = {
      unusedparams = true,
    },
  },
  templ = {},

  -- SQL
  sqls = {},

  -- PHP
  intelephense = {},

  -- Elixir
  elixirls = {
    cmd = { vim.fn.expand "~/elixir/language_server.sh" },
  },
}

for name, opts in pairs(servers) do
  opts.on_init = on_init
  opts.on_attach = on_attach
  opts.capabilities = capabilities

  require("lspconfig")[name].setup(opts)
end

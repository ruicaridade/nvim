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
  astro = {},
  eslint = {},

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

  -- Svelte
  svelte = {},
}

for name, opts in pairs(servers) do
  opts.on_init = on_init
  opts.on_attach = on_attach
  opts.capabilities = capabilities
  opts.settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  }

  dofile(vim.g.base46_cache .. "lsp")
  require("nvchad.lsp").diagnostic_config()
  require("lspconfig")[name].setup(opts)
end

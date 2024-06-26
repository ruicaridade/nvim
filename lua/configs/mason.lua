require("mason").setup {
  ensure_installed = {
    "lua-language-server",
    "stylua",
    "css-lsp",
    "prettier",
    "typescript-language-server",
    "flake8",
    "isort",
    "mypy",
    "pyright",
    "gopls",
    "intelephense",
    "elixirls",
    "jinja-lsp",
    "templ",
    "htmx",
    "tailwindcss",
    "html",
    "astro",
  },
}

local null_ls = require "null-ls"

require("mason-null-ls").setup {
  automatic_installation = false,
  methods = {
    diagnostics = true,
    formatting = false, -- This is handled by conform
    code_actions = true,
    completion = true,
    hover = true,
  },
  handlers = {},
}

null_ls.setup()

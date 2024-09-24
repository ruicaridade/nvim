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
    "eslint",
  },
}

local null_ls = require "null-ls"
null_ls.setup()

require("mason-null-ls").setup {
  automatic_installation = true,
  methods = {
    diagnostics = true,
    formatting = false, -- This is handled by conform
    code_actions = true,
    completion = true,
    hover = true,
  },
  handlers = {},
}

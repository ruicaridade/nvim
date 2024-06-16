require("mason").setup {
  ensure_installed = {
    "lua-language-server",
    "stylua",
    "html-lsp",
    "css-lsp",
    "prettier",
    "typescript-language-server",
    "tailwindcss-language-server",
    "flake8",
    "isort",
    "mypy",
    "pyright",
    "gopls",
    "intelephense",
    "elixirls",
    "jinja-lsp",
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

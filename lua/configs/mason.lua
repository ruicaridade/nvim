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
  handlers = {
    mypy = function()
      null_ls.register(null_ls.builtins.diagnostics.mypy.with {
        prefer_local = ".venv/bin",
      })
    end,
    flake8 = function()
      null_ls.register(null_ls.builtins.diagnostics.flake8.with {
        prefer_local = ".venv/bin",
      })
    end,
    black = function()
      null_ls.register(null_ls.builtins.formatting.black.with {
        prefer_local = ".venv/bin",
      })
    end,
    isort = function()
      null_ls.register(null_ls.builtins.formatting.isort.with {
        prefer_local = ".venv/bin",
      })
    end,
  },
}

null_ls.setup()

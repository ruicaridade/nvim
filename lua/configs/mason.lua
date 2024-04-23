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
    mypy = function(source_name, methods)
      null_ls.register(null_ls.builtins.diagnostics.mypy.with {
        extra_args = function()
          local virtual = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX" or "/usr"
          return { "--python-executable", virtual .. "/bin/python3" }
        end,
      })
    end,
  },
}

null_ls.setup()

return {
  { "neovim/nvim-lspconfig" },
  {
    "mason-org/mason.nvim",
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- Python
        'ty',
        'jinja_lsp',
        'ruff',
        -- Lua
        'lua_ls',
        -- Rust
        'rust_analyzer',
        -- JavaScript
        'ts_ls',
      }
    }
  },
}

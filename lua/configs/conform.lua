local slow_format_filetypes = {}

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    python = { "black", "isort" },
    go = { "goimports-reviser", "gofmt" },
    templ = { "templ" },
    sql = { "sql_formatter" },
    php = { "pint", "blade-formatter" },
    elixir = { "mix" },
    htmldjango = { "djlint" },
    svelte = { "prettier" },
  },

  format_on_save = function(bufnr)
    if slow_format_filetypes[vim.bo[bufnr].filetype] then
      return
    end
    local function on_format(err)
      if err and err:match "timeout$" then
        slow_format_filetypes[vim.bo[bufnr].filetype] = true
      end
    end

    return { timeout_ms = 200, lsp_format = "fallback" }, on_format
  end,

  format_after_save = function(bufnr)
    if not slow_format_filetypes[vim.bo[bufnr].filetype] then
      return
    end
    return { lsp_format = "fallback" }
  end,
}

require("conform").setup(options)

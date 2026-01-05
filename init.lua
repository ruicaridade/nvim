---@diagnostic disable: undefined-global

-- Misc
vim.o.swapfile = false
vim.g.mapleader = ' '
vim.o.winborder = "rounded"
vim.o.cmdheight = 1
vim.o.autoread = true

-- Text
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false

-- Tab
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.shiftround = true

-- Clipboard
vim.api.nvim_set_option('clipboard', 'unnamedplus')

-- Filetype associations
vim.filetype.add({
  extension = {
    j2 = 'jinja',
    jinja2 = 'jinja',
  }
})

-- Plugins
vim.pack.add({
  -- Theme
  'https://github.com/rose-pine/neovim',
  'https://github.com/nvim-lualine/lualine.nvim',

  -- Misc & utilities
  'https://github.com/folke/snacks.nvim',
  'https://github.com/nvim-mini/mini.pairs',
  'https://github.com/nvim-mini/mini.icons',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',

  -- Auto indentation
  'https://github.com/tpope/vim-sleuth',

  -- LSP
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',

  -- Formatting & Linting
  'https://github.com/stevearc/conform.nvim',

  -- AI
  'https://github.com/folke/sidekick.nvim',
  'https://github.com/supermaven-inc/supermaven-nvim',

  -- Cmp
  'https://github.com/saghen/blink.cmp',

  -- Git
  'https://github.com/lewis6991/gitsigns.nvim',

  -- Navigation
  'https://github.com/otavioschwanck/arrow.nvim'
})

-- Theme
require('rose-pine').setup({
  styles = {
    transparency = true,
  }
})
vim.cmd('colorscheme rose-pine')

-- Misc
require('lualine').setup()
require('mini.pairs').setup()
require('mini.icons').setup()
require('render-markdown').setup()

-- Snacks
require('snacks').setup({
  input = { enabled = true },
  statuscolumn = { enabled = true },
  rename = { enabled = true },
  notifier = { enabled = true },
  picker = { enabled = true },
  indent = {
    enabled = true,
    animate = { enabled = false },
    scope = { enabled = false },
  }
})

-- LSP
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    -- Python
    'ty',
    'jinja_lsp',

    -- Lua
    'lua_ls',

    -- Rust
    'rust_analyzer',

    -- JavaScript
    'ts_ls',
  }
})

-- Formatting
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    python = { 'black', 'isort' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- Diagnostics
vim.o.updatetime = 300
vim.diagnostic.config({
  virtual_text = false,
})

-- Cmp
require('blink.cmp').setup({
  keymap = {
    preset = 'enter'
  },
  appearance = {
    nerd_font_variant = 'normal'
  },
  fuzzy = {
    implementation = 'lua'
  }
})

-- Git
require('gitsigns').setup({
  current_line_blame = true,
})

-- Harpoon
require('arrow').setup({
  leader_key = ';'
})

-- AI
require('sidekick').setup({
  nes = {
    enabled = false,
  },
  cli = {
    mux = {
      backend = 'tmux',
      enabled = true,
    }
  }
})

require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<Tab>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-j>",
  },
  log_level = "info",                -- set to "off" to disable logging completely
  disable_inline_completion = false, -- disables inline completion for use with cmp
  disable_keymaps = false,           -- disables built in keymaps for more manual control
})

-- Keybinds
local map = vim.keymap.set

-- Keybinds: LSP
function format()
  if vim.fn.executable('ruff') == 1 then
    local buf = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(buf)
    if filename ~= '' then
      vim.cmd('silent write')
      vim.fn.system('ruff check --select I --fix ' .. vim.fn.shellescape(filename))
      vim.cmd('edit!')
    end
  end

  vim.lsp.buf.format()
end

-- Keybinds: Cmp
map('i', '<C-@>', function() require('blink.cmp').show() end, { silent = true })

-- Keybinds: LSP
map('n', '<leader>lm', ':Mason<CR>')
map('n', '<leader>ff', format)
map('n', 'gd', vim.lsp.buf.definition)
map('n', 'gD', vim.lsp.buf.declaration)
map('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true })
map('n', '<leader>rn', vim.lsp.buf.rename, { nowait = true })
map('n', '<leader>ca', vim.lsp.buf.code_action, { nowait = true })

-- Keybinds: Find
map('n', '<leader>sf', function() Snacks.picker.files() end, { desc = 'Search files' })
map('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Search Grep' })
map('n', '<leader>sb', function() Snacks.picker.buffers() end, { desc = 'Search Buffers' })
map('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'Search Symbols' })
map('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Search Workspace Symbols' })

-- Keybinds: File explorer
map('n', '<leader>e', function() Snacks.explorer() end)

-- Keybinds: Git
map('n', '<leader>gg', function() Snacks.lazygit() end)
map('n', '<leader>gb', ':Gitsigns blame<CR>')

-- Keybinds: AI
local sidekick_cli = require('sidekick.cli')
map({ "n", "x" }, "<leader>af", function() sidekick_cli.send({ msg = "{file}" }) end, { desc = "" })
map({ "n", "x" }, "<leader>al", function() sidekick_cli.send({ msg = "{selection}" }) end, { desc = "" })
map({ "n", "t" }, "<leader>aa", function() sidekick_cli.toggle() end, { desc = "Sidekick Toggle" })

-- Keybinds: Diagnostics
map('n', '<leader>sd', function() Snacks.picker.diagnostic() end)
map('n', '<leader>dd', vim.diagnostic.open_float, { noremap = true, silent = true })
map('n', '<leader>dn', vim.diagnostic.goto_next, { noremap = true, silent = true })
map('n', '<leader>dp', vim.diagnostic.goto_prev, { noremap = true, silent = true })

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

-- Plugins
vim.pack.add({
  -- Theme
  'https://github.com/rose-pine/neovim',
  'https://github.com/nvim-lualine/lualine.nvim',

  -- Misc & utilities
  'https://github.com/folke/snacks.nvim',
  'https://github.com/nvim-mini/mini.pairs',
  'https://github.com/nvim-mini/mini.icons',

  -- Auto indentation
  'https://github.com/tpope/vim-sleuth',

  -- LSP
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',

  -- AI
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/folke/sidekick.nvim',

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
  ensure_installed = { 'ty', 'ruff', 'copilot', 'lua_ls', 'ts_ls', 'rust_analyzer' }
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
require('copilot').setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = false,
    debounce = 0,
  },
})
vim.g.sidekick_nes = true
require('sidekick').setup({
  cli = {
    mux = {
      backend = 'tmux',
      enabled = true,
    }
  }
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

local sidekick = require('sidekick')
map({ "i", "n" }, "<M-n>", function() sidekick.nes_jump_or_apply() end, { desc = "Accept Next Edit Suggestion" })

local copilot = require('copilot.suggestion')
map({ "i" }, "<M-l>", function() copilot:accept() end, { desc = "Accept Copilot suggestion" })

-- Keybinds: Diagnostics
map('n', '<leader>sd', function() Snacks.picker.diagnostic() end)
map('n', '<leader>dd', vim.diagnostic.open_float, { noremap = true, silent = true })
map('n', '<leader>dn', vim.diagnostic.goto_next, { noremap = true, silent = true })
map('n', '<leader>dp', vim.diagnostic.goto_prev, { noremap = true, silent = true })

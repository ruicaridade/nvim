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

  -- Misc & utilities
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/nvim-lua/plenary.nvim',

  -- Automatically set indentation based on file
  'https://github.com/tpope/vim-sleuth',

  -- LSP
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',

  -- AI
  'https://github.com/NickvanDyke/opencode.nvim',
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/copilotlsp-nvim/copilot-lsp',

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

-- Mini
require('mini.statusline').setup()
require('mini.cmdline').setup({
  autocomplete = {
    delay = 250
  }
})
require('mini.pairs').setup()
require('mini.icons').setup()
require('mini.snippets').setup()
require('mini.icons').setup()

-- Snacks
require('snacks').setup({
  input = { enabled = true },
  picker = { enabled = true },
  statuscolumn = { enabled = true },
  indent = {
    enabled = true,
    animate = {
      enabled = false
    },
    scope = {
      enabled = false
    }
  }
})

-- LSP
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'pyright', 'ts_ls', 'rust_analyzer' }
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
  nes = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<M-l>",
      accept_and_goto = "<M-n>",
      dismiss = "<Esc>",
    },
  },
})

-- Keybinds
local map = vim.keymap.set

-- Keybinds: LSP
map('n', '<leader>lm', ':Mason<CR>')
map('n', '<leader>ff', vim.lsp.buf.format)
map('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
map('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
map('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })

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
local openc = require('opencode')
map({ "n", "x" }, "<leader>aa", function() openc.ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
map({ "n", "x" }, "<leader>ae", function() openc.select() end, { desc = "Execute opencode action…" })
map({ "n", "x" }, "<leader>al", function() openc.prompt("@this") end, { desc = "Add to opencode" })
map({ "n", "t" }, "<leader>at", function() openc.toggle() end, { desc = "Toggle opencode" })

local copilot = require('copilot.suggestion')
map({ "i" }, "<M-l>", function() copilot:accept() end, { desc = "Accept Copilot suggestion" })

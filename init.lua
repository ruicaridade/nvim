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

-- Plugins
vim.pack.add({
  -- Theme
  { src = 'https://github.com/rose-pine/neovim' },

  -- Misc & utilities
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/folke/snacks.nvim' },

  -- Automatically set indentation based on file
  { src = 'https://github.com/tpope/vim-sleuth' },

  -- LSP
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },

  -- AI
  { src = 'https://github.com/NickvanDyke/opencode.nvim' },

  -- Cmp
  { src = 'https://github.com/saghen/blink.cmp' },

  -- Git
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
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

-- Keybinds: LSP
vim.keymap.set('n', '<leader>lm', ':Mason<CR>')
vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format)
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })

-- Keybinds: Find
vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end, { desc = 'Search files' })
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Search Grep' })
vim.keymap.set('n', '<leader>sb', function() Snacks.picker.buffers() end, { desc = 'Search Buffers' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'Search Symbols' })
vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end,
  { desc = 'Search Workspace Symbols' })

-- Keybinds: File explorer
vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end)

-- Keybinds: Git
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end)
vim.keymap.set('n', '<leader>gb', ':Gitsigns blame<CR>')

-- Keybinds: AI
local openc = require('opencode')
vim.keymap.set({ "n", "x" }, "<leader>aa", function() openc.ask("@this: ", { submit = true }) end,
  { desc = "Ask opencode" })
vim.keymap.set({ "n", "x" }, "<leader>ae", function() openc.select() end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "x" }, "<leader>al", function() openc.prompt("@this") end, { desc = "Add to opencode" })
vim.keymap.set({ "n", "t" }, "<leader>at", function() openc.toggle() end, { desc = "Toggle opencode" })
vim.keymap.set("n", "<S-C-u>", function() openc.command("session.half.page.up") end, { desc = "opencode page up" })
vim.keymap.set("n", "<S-C-d>", function() openc.command("session.half.page.down") end, { desc = "opencode page down" })
vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })

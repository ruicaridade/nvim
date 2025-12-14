-- Misc
vim.o.swapfile = false
vim.g.mapleader = ' '
vim.o.winborder = "rounded"
vim.o.cmdheight = 1

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

  -- Utilities
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/folke/snacks.nvim' },

  -- Automatically set indentation based on file
  { src = 'https://github.com/tpope/vim-sleuth' },

  -- LSP
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
})

-- Theme
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
require('mini.completion').setup()
require('mini.icons').setup()

-- Snacks
require('snacks').setup({
  explorer = {
    enabled = true
  }
})

-- LSP
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls' }
})

-- Keybinds: LSP
vim.keymap.set('n', '<leader>lm', ':Mason<CR>')
vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format)
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait= true, desc = 'References' })

-- Keybinds: Find
vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end, { desc = 'Search files' })
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Search Grep' })
vim.keymap.set('n', '<leader>sb', function() Snacks.picker.buffers() end, { desc = 'Search Buffers' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'Search Symbols' })
vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Search Workspace Symbols' })

-- Keybinds: File explorer
vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end)

-- Keybinds: Git
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end)
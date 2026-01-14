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

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup("plugins")

-- Diagnostics
vim.o.updatetime = 300
vim.diagnostic.config({
  virtual_text = false,
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
map('n', '<leader>rr', ':LspRestart<CR>')

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
-- local sidekick_cli = require('sidekick.cli')
-- map({ "n", "x" }, "<leader>af", function() sidekick_cli.send({ msg = "{file}" }) end, { desc = "" })
-- map({ "n", "x" }, "<leader>al", function() sidekick_cli.send({ msg = "{selection}" }) end, { desc = "" })
-- map({ "n", "t" }, "<leader>aa", function() sidekick_cli.toggle() end, { desc = "Sidekick Toggle" })

-- Keybinds: Diagnostics
map('n', '<leader>sd', function() Snacks.picker.diagnostic() end)
map('n', '<leader>dd', vim.diagnostic.open_float, { noremap = true, silent = true })
map('n', '<leader>dn', vim.diagnostic.goto_next, { noremap = true, silent = true })
map('n', '<leader>dp', vim.diagnostic.goto_prev, { noremap = true, silent = true })

-- Misc
vim.o.swapfile = false
vim.g.mapleader = ' '
vim.o.winborder = "rounded"
vim.o.cmdheight = 0
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
    templ = 'templ',
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
map('i', '<C-@>', function() require('blink.cmp').show() end, { silent = true, desc = "Show completions" })

-- Keybinds: LSP
map('n', '<leader>lm', ':Mason<CR>', { desc = "Mason" })
map('n', '<leader>ff', format, { desc = "Format file" })
map('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = "Go to definition" })
map('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
map('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
map('n', '<leader>rn', vim.lsp.buf.rename, { nowait = true, desc = "Rename symbol" })
map('n', '<leader>ca', vim.lsp.buf.code_action, { nowait = true, desc = "Code action" })
map('n', '<leader>rr', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    vim.notify('Restarting LSP: ' .. client.name)
    client:stop()
  end
  vim.cmd('edit!')
end, { desc = "Restart LSP" })

-- Keybinds: Find
map('n', '<leader>sf', function() Snacks.picker.files() end, { desc = 'Search files' })
map('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Search Grep' })
map('n', '<leader>sb', function() Snacks.picker.buffers() end, { desc = 'Search Buffers' })
map('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'Search Symbols' })
map('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Search Workspace Symbols' })

-- Keybinds: File explorer
map('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Explorer" })

-- Keybinds: Git
map('n', '<leader>gg', function() Snacks.lazygit() end, { desc = "Lazygit" })
map('n', '<leader>gb', ':Gitsigns blame<CR>', { desc = "Blame" })

-- Keybinds: AI
-- local sidekick_cli = require('sidekick.cli')
-- map({ "n", "x" }, "<leader>af", function() sidekick_cli.send({ msg = "{file}" }) end, { desc = "" })
-- map({ "n", "x" }, "<leader>al", function() sidekick_cli.send({ msg = "{selection}" }) end, { desc = "" })
-- map({ "n", "t" }, "<leader>aa", function() sidekick_cli.toggle() end, { desc = "Sidekick Toggle" })

-- Keybinds: Diagnostics
map('n', '<leader>sd', function() Snacks.picker.diagnostic() end, { desc = "Search diagnostics" })
local diag_float_win = nil
map('n', '<leader>dd', function()
  if diag_float_win and vim.api.nvim_win_is_valid(diag_float_win) then
    vim.api.nvim_set_current_win(diag_float_win)
    diag_float_win = nil
    return
  end
  local _, winnr = vim.diagnostic.open_float({ focus = false })
  diag_float_win = winnr
end, { noremap = true, silent = true, desc = "Line diagnostics" })
map('n', '<leader>dn', vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next diagnostic" })
map('n', '<leader>dp', vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Prev diagnostic" })

-- Document highlighting
map('n', '<leader>hh', function()
  vim.lsp.buf.clear_references()
  vim.lsp.buf.document_highlight()
end, { desc = 'Highlight references' })
map('n', '<leader>hc', vim.lsp.buf.clear_references, { desc = 'Clear highlights' })

require "nvchad.mappings"

local map = vim.keymap.set

local telescope = require "telescope.builtin"
map("n", "<leader>fs", telescope.lsp_dynamic_workspace_symbols)

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

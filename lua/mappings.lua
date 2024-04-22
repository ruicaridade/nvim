require "nvchad.mappings"

local map = vim.keymap.set

local telescope = require "telescope.builtin"
map("n", "<leader>gr", telescope.lsp_references, { desc = "Telescope Goto References" })
map("n", "<leader>fd", telescope.lsp_document_symbols, { desc = "Telescope Document Symbols" })
map("n", "<leader>fs", telescope.lsp_dynamic_workspace_symbols, { desc = "Telescope Workspace Symbols" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

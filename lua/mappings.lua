require "nvchad.mappings"

local map = vim.keymap.set

-- LSP
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

-- Telescope
local telescope = require "telescope.builtin"
map("n", "<leader>gr", telescope.lsp_references, { desc = "Telescope Goto References" })
map("n", "<leader>fd", telescope.lsp_document_symbols, { desc = "Telescope Document Symbols" })
map("n", "<leader>fs", telescope.lsp_dynamic_workspace_symbols, { desc = "Telescope Workspace Symbols" })
map("n", "<leader>fr", telescope.lsp_references, { desc = "Telescope Find References" })

-- Harpoon
local harpoon = require "harpoon"

map("n", "<leader>ta", function()
  harpoon:list():add()
end, { desc = "Harpoon Add" })
map("n", "<leader>tt", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Toggle" })
map("n", "<C-t>1", function()
  harpoon:list():select(1)
end, { desc = "Harpoon Select 1" })
map("n", "<C-t>2", function()
  harpoon:list():select(2)
end, { desc = "Harpoon Select 2" })
map("n", "<C-t>3", function()
  harpoon:list():select(3)
end, { desc = "Harpoon Select 3" })
map("n", "<C-t>4", function()
  harpoon:list():select(4)
end, { desc = "Harpoon Select 4" })
map("n", "<C-t>5", function()
  harpoon:list():select(5)
end, { desc = "Harpoon Select 5" })

-- Misc
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

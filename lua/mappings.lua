require "nvchad.mappings"

local map = vim.keymap.set

-- Telescope
local telescope = require "telescope.builtin"
map("n", "<leader>gr", telescope.lsp_references, { desc = "Telescope Goto References" })
map("n", "<leader>fd", telescope.lsp_document_symbols, { desc = "Telescope Document Symbols" })
map("n", "<leader>fs", telescope.lsp_dynamic_workspace_symbols, { desc = "Telescope Workspace Symbols" })

-- Harpoon
local harpoon = require "harpoon"

map("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Harpoon Add" })
map("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Toggle" })
map("n", "<leader>1", function()
  harpoon:list():select(1)
end, { desc = "Harpoon Select 1" })
map("n", "<leader>2", function()
  harpoon:list():select(2)
end, { desc = "Harpoon Select 2" })
map("n", "<leader>3", function()
  harpoon:list():select(3)
end, { desc = "Harpoon Select 3" })
map("n", "<leader>4", function()
  harpoon:list():select(4)
end, { desc = "Harpoon Select 4" })

-- Misc
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

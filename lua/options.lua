require "nvchad.options"

vim.wo.relativenumber = true

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

vim.filetype.add { extension = { templ = "templ" } }

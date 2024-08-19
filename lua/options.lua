require "nvchad.options"

vim.o.backupcopy = "yes"

vim.wo.relativenumber = true

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

vim.filetype.add { extension = { templ = "templ" } }

-- Enable vertical wrap line
vim.opt.colorcolumn = "120"

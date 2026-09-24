local omarchy = vim.uv.os_uname().sysname == 'Linux'
  and vim.fn.executable('omarchy-theme-color') == 1
  and vim.fn.filereadable(vim.fn.expand('~/.local/state/omarchy/current/theme/colors.toml')) == 1
assert(vim.g.colors_name == (omarchy and 'omarchy' or 'kanagawa'), 'expected the platform colorscheme to be active')

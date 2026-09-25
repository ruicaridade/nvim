-- Run with: nvim --headless -u NONE -l tests/omarchy_theme_spec.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:append(vim.fn.stdpath('data') .. '/lazy/mini.base16')
local root = vim.fn.tempname()
local path = root .. '/theme/colors.toml'
local function switch(theme)
  vim.fn.delete(root .. '/theme', 'rf')
  vim.fn.mkdir(root .. '/theme', 'p')
  vim.fn.writefile(vim.fn.readfile('/usr/share/omarchy/themes/' .. theme .. '/colors.toml'), path)
end
local function foreground()
  return vim.api.nvim_get_hl(0, { name = 'Normal' }).fg
end
local function luminance(hex)
  local value = 0
  for i, weight in ipairs({ 0.2126, 0.7152, 0.0722 }) do
    local c = tonumber(hex:sub(i * 2, i * 2 + 1), 16) / 255
    value = value + weight * (c <= 0.04045 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4)
  end
  return value
end
local function color(theme)
  local result = vim.system({ 'omarchy-theme-color', '--file', '/usr/share/omarchy/themes/' .. theme .. '/colors.toml', 'foreground' }, { text = true }):wait()
  return tonumber(vim.trim(result.stdout):sub(2), 16)
end
switch('kanagawa')
local theme = require('omarchy_theme')
assert(theme.setup({ path = path }), 'initial palette must load')
assert(foreground() == color('kanagawa'), 'startup uses Omarchy foreground')
assert(vim.api.nvim_get_hl(0, { name = 'Normal' }).bg == nil, 'preserve transparent background')
vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'unsaved work' })
for _, name in ipairs({ 'catppuccin-latte', 'solitude', 'kanagawa' }) do
  switch(name)
  local expected = color(name)
  assert(vim.wait(5000, function() return foreground() == expected end, 100), 'live palette reload: ' .. name)
  assert(vim.o.background == (name == 'catppuccin-latte' and 'light' or 'dark'))
  local bg = luminance(MiniBase16.config.palette.base00)
  for _, group in ipairs({ 'Type', 'Function', 'Keyword', 'String', 'Comment' }) do
    local fg = luminance(string.format('#%06x', vim.api.nvim_get_hl(0, { name = group, link = false }).fg))
    assert((math.max(fg, bg) + 0.05) / (math.min(fg, bg) + 0.05) >= 4.5, group .. ' needs readable contrast')
  end
  for group, channel in pairs({ DiffAdd = 2, DiffDelete = 1 }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false }).bg
    local rgb = { math.floor(hl / 65536), math.floor(hl / 256) % 256, hl % 256 }
    for i = 1, 3 do
      assert(i == channel or rgb[channel] > rgb[i], group .. ' needs a tinted background: ' .. name)
    end
  end
  if name == 'solitude' then
    local seen = {}
    for _, group in ipairs({ 'Type', 'Function', 'Keyword', 'String' }) do
      local fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
      local r, g, b = math.floor(fg / 65536), math.floor(fg / 256) % 256, fg % 256
      assert(math.max(r, g, b) - math.min(r, g, b) >= 40, group .. ' needs a chromatic syntax accent')
      assert(not seen[fg], group .. ' needs a distinct syntax accent')
      seen[fg] = true
    end
  end
end
assert(vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == 'unsaved work')
assert(vim.bo.modified, 'theme switching preserves unsaved buffer')
vim.fn.delete(root, 'rf')
print('Omarchy theme startup and repeated dark/light live reload: OK')

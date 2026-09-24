local M = {}
local watcher

local function rgb(hex)
  return { tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16) }
end

local function luminance(channels)
  local result = 0
  for i, weight in ipairs({ 0.2126, 0.7152, 0.0722 }) do
    local c = channels[i] / 255
    result = result + weight * (c <= 0.04045 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4)
  end
  return result
end

local function readable(hex, background)
  local channels, bg = rgb(hex), luminance(rgb(background))
  local target = bg > 0.179 and 0 or 255
  for step = 0, 20 do
    local adjusted = {}
    for i, c in ipairs(channels) do adjusted[i] = math.floor(c + (target - c) * step / 20 + 0.5) end
    local fg = luminance(adjusted)
    if (math.max(fg, bg) + 0.05) / (math.min(fg, bg) + 0.05) >= 4.5 then
      return string.format('#%02x%02x%02x', unpack(adjusted))
    end
  end
end

local function chromatic(hex)
  if not hex or not hex:match('^#%x%x%x%x%x%x$') then return false end
  local c = rgb(hex)
  return math.max(unpack(c)) - math.min(unpack(c)) >= 40
end

function M.setup(opts)
  if vim.uv.os_uname().sysname ~= 'Linux' or vim.fn.executable('omarchy-theme-color') ~= 1 then
    return false
  end
  local path = (opts or {}).path or vim.fn.expand('~/.local/state/omarchy/current/theme/colors.toml')
  local function apply()
    if vim.fn.filereadable(path) ~= 1 then return false end
    local result = vim.system({ 'omarchy-theme-color', '--file', path, '--all' }, { text = true }):wait(3000)
    if result.code ~= 0 then return false end
    local colors = {}
    for key, value in result.stdout:gmatch('([^\n\t]+)\t([^\n]+)') do
      colors[key] = value
    end
    local mapping = {
      base00 = 'background', base01 = 'lighter_background', base02 = 'selection_background',
      base03 = 'muted', base04 = 'dark_foreground', base05 = 'foreground',
      base06 = 'light_foreground', base07 = 'bright_foreground', base08 = 'red',
      base09 = 'orange', base0A = 'yellow', base0B = 'green', base0C = 'cyan',
      base0D = 'blue', base0E = 'magenta', base0F = 'brown',
    }
    local palette = {}
    for base, key in pairs(mapping) do
      if not colors[key] or not colors[key]:match('^#%x%x%x%x%x%x$') then return false end
      palette[base] = colors[key]
    end
    -- Monochrome desktop themes still need distinct, readable code colors.
    -- Prefer the theme's own accents, then its bright variants, then these
    -- Kanagawa-inspired syntax accents. Adjust contrast for light themes too.
    local accents = {
      base08 = '#e06c75', base09 = '#ffa066', base0A = '#e6c384', base0B = '#98bb6c',
      base0C = '#7fb4ca', base0D = '#7e9cd8', base0E = '#b49cde', base0F = '#d27e99',
    }
    for base, fallback in pairs(accents) do
      local color = palette[base]
      if not chromatic(color) then color = colors['bright_' .. mapping[base]] end
      if not chromatic(color) then color = fallback end
      palette[base] = readable(color, colors.background)
    end
    palette.base03 = readable(palette.base03, colors.background)
    palette.base04 = readable(palette.base04, colors.background)
    vim.o.termguicolors = true
    vim.o.background = colors.mode == 'light' and 'light' or 'dark'
    require('mini.base16').setup({ palette = palette })
    -- Keep the transparent editor background used by our Kanagawa fallback.
    for _, name in ipairs({ 'Normal', 'NormalNC', 'SignColumn', 'EndOfBuffer' }) do
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      hl.bg = nil
      vim.api.nvim_set_hl(0, name, hl)
    end
    vim.g.colors_name = 'omarchy'
    vim.api.nvim_exec_autocmds('ColorScheme', { pattern = 'omarchy', modeline = false })
    return true
  end
  local loaded = apply()
  if watcher then watcher:stop(); watcher:close() end
  -- Poll the path, not its inode: Omarchy replaces the entire theme directory.
  -- Only a changed file runs the palette resolver (no shell command each tick).
  watcher = assert(vim.uv.new_fs_poll())
  watcher:start(path, 1000, vim.schedule_wrap(function(err)
    if not err then apply() end
  end))
  local group = vim.api.nvim_create_augroup('OmarchyTheme', { clear = true })
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    callback = function()
      if watcher then watcher:stop(); watcher:close(); watcher = nil end
    end,
  })
  return loaded
end

return M

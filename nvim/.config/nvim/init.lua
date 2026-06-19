_G.Config = {}

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

local misc = require("misc")

-- Execute immediately. Use for what must be executed during startup.
-- Like colorscheme, statusline, tabline, dashboard, etc.
Config.now = function(f) misc.safely("now", f) end

-- Execute a bit later. Use for things not needed during startup.
Config.later = function(f) misc.safely("later", f) end

-- Use only if needed during startup when Neovim is started
-- like `nvim -- path/to/file`, but otherwise delaying is fine.
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

-- Execute once on a first matched event. Like "delay until
-- first Insert mode enter": `on_event('InsertEnter', function() ... end)`.
Config.on_event = function(ev, f) misc.safely('event:' .. ev, f) end

-- Execute once on a first matched filetype. Like "delay
-- until first Lua file": `on_filetype('lua', function() ... end)`.
Config.on_filetype = function(ft, f) misc.safely('filetype:' .. ft, f) end


local group = vim.api.nvim_create_augroup('nvim_config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = group, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback(ev.data)
  end
  Config.new_autocmd('PackChanged', '*', f, desc)
end

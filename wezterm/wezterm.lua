local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.color_scheme = "Gruvbox light, medium (base16)"
config.font_size = 11.5
config.font = wezterm.font("Zed Mono Extended")

config.keys = {
  {
    key = '-',
    mods = 'CTRL|ALT',
    action = wezterm.action.SplitPane {
      direction = 'Down',
    },
  },
  {
    key = '\\',
    mods = 'CTRL|ALT',
    action = wezterm.action.SplitHorizontal
  },
}

return config

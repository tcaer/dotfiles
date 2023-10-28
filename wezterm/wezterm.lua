local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

function get_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Gruvbox dark, medium (base16)'
  else
    return 'Gruvbox light, medium (base16)'
  end
end

config.window_decorations = "RESIZE"
config.color_scheme = get_appearance(wezterm.gui.get_appearance())
config.font_size = 13.0

wezterm.on('update-right-status', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = query_appearance_gnome()
  local scheme = scheme_for_appearance(appearance)
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

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

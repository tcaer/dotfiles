local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Gruvbox dark, medium (base16)'
config.font_size = 13.0

config.keys = {
	{
		key = '-',
		mods = 'CTRL|ALT',
		action = wezterm.action.SplitHorizontal,
	},
	{
		key = '|',
		mods = 'CTRL|ALT',
		action = wezterm.action.SplitPane {
			direction = 'Down',
		},
	},
}

return config

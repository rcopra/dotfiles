local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 17

-- Enable Kitty graphics protocol for image rendering
config.enable_kitty_graphics = true

-- Allow SHIFT to bypass mouse reporting (for tmux/vim)
config.bypass_mouse_reporting_modifiers = "SHIFT"

config.keys = {
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
	{
		key = "k",
		mods = "CMD",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },
}
-- Enable hyperlink detection
config.hyperlink_rules = wezterm.default_hyperlink_rules()

config.mouse_bindings = {
	-- Open URLs with Cmd+Click
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = act.OpenLinkAtMouseCursor,
	},
}

config.window_decorations = "RESIZE"

-- Gruvbox Material Mix (Hard) custom color scheme
config.colors = {
	foreground = "#e2cca9",
	background = "#1d2021",
	cursor_bg = "#e2cca9",
	cursor_fg = "#1d2021",
	cursor_border = "#e2cca9",
	selection_bg = "#504945",
	selection_fg = "#e2cca9",
	ansi = {
		"#1d2021", -- black
		"#f2594b", -- red
		"#b0b846", -- green
		"#e9b143", -- yellow
		"#80aa9e", -- blue
		"#d3869b", -- purple
		"#8bba7f", -- aqua
		"#e2cca9", -- white
	},
	brights = {
		"#504945", -- bright black
		"#f2594b", -- bright red
		"#b0b846", -- bright green
		"#e9b143", -- bright yellow
		"#80aa9e", -- bright blue
		"#d3869b", -- bright purple
		"#8bba7f", -- bright aqua
		"#e2cca9", -- bright white
	},
	tab_bar = {
		background = "#1d2021",
	},
}

return config

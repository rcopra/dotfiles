local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
config.font = wezterm.font_with_fallback({
	{
		family = "Iosevka Term",
		stretch = "Expanded",
		weight = "Medium",
	},
	{ family = "Symbols Nerd Font Mono" },
})
config.font_size = 14

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
config.enable_tab_bar = false

-- Theme
config.color_scheme = "Catppuccin Macchiato"

return config

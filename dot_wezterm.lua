local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
local rose_pine = wezterm.plugin.require("https://github.com/neapsix/wezterm").moon

config.font = wezterm.font("Hack Nerd Font")
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

config.colors = rose_pine.colors()
config.window_frame = rose_pine.window_frame()

return config

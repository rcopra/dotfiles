-- Global hotkeys that used to live in Karabiner. Karabiner must ignore the
-- ZMK dongle (it splits ZMK's atomic mod-morph HID reports and reorders the
-- events, breaking shift+comma -> semicolon), so anything that should fire
-- from the Hillside lives here instead. Hammerspoon observes events after
-- macOS applies each HID report atomically, so it can't reproduce that bug.

require("hs.ipc")

local hyper = { "ctrl", "alt", "cmd" }

-- Hyper app switchers (G=Ghostty D=Discord)
local applications = {
	g = "Ghostty",
	d = "Discord",
}

for key, application in pairs(applications) do
	hs.hotkey.bind(hyper, key, function()
		hs.application.launchOrFocus(application)
	end)
end

-- Safari opens a new window in its existing process.
hs.hotkey.bind(hyper, "w", function()
	local safari = hs.application.get("Safari")
	if safari then
		safari:selectMenuItem({ "File", "New Window" })
	else
		hs.application.launchOrFocus("Safari")
	end
end)

-- Launching Firefox's inner executable on macOS 27 prevents it from reading
-- its profile, so use LaunchServices and the existing process's menu instead.
hs.hotkey.bind(hyper, "b", function()
	local firefox = hs.application.get("Firefox")
	if firefox then
		firefox:selectMenuItem({ "File", "New Window" })
	else
		hs.application.launchOrFocus("Firefox")
	end
end)

hs.hotkey.bind({ "alt" }, "return", function()
	local ghostty = hs.application.get("Ghostty")
	if ghostty then
		ghostty:selectMenuItem({ "File", "New Window" })
	else
		hs.application.launchOrFocus("Ghostty")
	end
end)

-- Reload on config change.
configWatcher = hs.pathwatcher.new(hs.configdir, hs.reload)
configWatcher:start()
hs.alert.show("Hammerspoon loaded")

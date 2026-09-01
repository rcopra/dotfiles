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

-- Firefox intentionally launches a new window.
hs.hotkey.bind(hyper, "b", function()
	hs.task.new("/Applications/Firefox.app/Contents/MacOS/firefox", nil, { "--new-window" }):start()
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

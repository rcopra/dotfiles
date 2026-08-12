-- Global hotkeys that used to live in Karabiner. Karabiner must ignore the
-- ZMK dongle (it splits ZMK's atomic mod-morph HID reports and reorders the
-- events, breaking shift+comma -> semicolon), so anything that should fire
-- from the Hillside lives here instead. Hammerspoon observes events after
-- macOS applies each HID report atomically, so it can't reproduce that bug.

local hyper = { "ctrl", "alt", "cmd" }

-- Hyper app launchers (G=Ghostty W=Safari B=Firefox S=Slack D=Discord)
local launchers = {
  g = "open -a Ghostty",
  w = "open -na Safari",
  b = "nohup /Applications/Firefox.app/Contents/MacOS/firefox --new-window >/dev/null 2>&1 &",
  s = "open -a Slack",
  d = "open -a Discord",
}
for key, cmd in pairs(launchers) do
  hs.hotkey.bind(hyper, key, function() hs.execute(cmd) end)
end

hs.hotkey.bind({ "alt" }, "return", function() hs.execute("open -na Ghostty") end)

-- Reload on config change.
hs.pathwatcher.new(hs.configdir, hs.reload):start()
hs.alert.show("Hammerspoon loaded")

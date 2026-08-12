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

-- Workspace move: OmniWM's own Shift+Cmd+N binding moves the window; this tap
-- adds the follow by tapping Cmd+N afterwards. Cmd+Shift+Opt+N moves silently
-- via omniwmctl (OmniWM ignores the chord with Opt held, so we consume it).
local omniwmctl = "/Applications/OmniWM.app/Contents/MacOS/omniwmctl"
local hasOmniwmctl = hs.fs.attributes(omniwmctl) ~= nil

local workspaceTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
  if e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) ~= 0 then
    return false
  end
  local key = hs.keycodes.map[e:getKeyCode()]
  if type(key) ~= "string" or not key:match("^[1-9]$") then
    return false
  end

  local flags = e:getFlags()
  if flags:containExactly({ "cmd", "shift" }) then
    hs.timer.doAfter(0.1, function()
      hs.eventtap.keyStroke({ "cmd" }, key, 0)
    end)
    return false -- pass through: OmniWM performs the move
  elseif flags:containExactly({ "cmd", "shift", "alt" }) and hasOmniwmctl then
    hs.execute(omniwmctl .. " command move-to-workspace " .. key)
    return true
  end
  return false
end)
workspaceTap:start()

-- Reload on config change.
hs.pathwatcher.new(hs.configdir, hs.reload):start()
hs.alert.show("Hammerspoon loaded")

-- Global hotkeys that used to live in Karabiner. Karabiner must ignore the
-- ZMK dongle (it splits ZMK's atomic mod-morph HID reports and reorders the
-- events, breaking shift+comma -> semicolon), so anything that should fire
-- from the Hillside lives here instead. Hammerspoon observes events after
-- macOS applies each HID report atomically, so it can't reproduce that bug.

require("hs.ipc")

local hyper = { "ctrl", "alt", "cmd" }

-- Hyper app launchers (G=Ghostty W=Safari B=Firefox S=Slack D=Discord)
local launchers = {
  g = { app = "Ghostty", spawn = "open -a Ghostty" },
  w = { app = "Safari", spawn = "open -na Safari", opensNewWindow = true },
  b = {
    app = "Firefox",
    spawn = "nohup /Applications/Firefox.app/Contents/MacOS/firefox --new-window >/dev/null 2>&1 &",
    opensNewWindow = true,
  },
  s = { app = "Slack", spawn = "open -a Slack" },
  d = { app = "Discord", spawn = "open -a Discord" },
}

-- Neither macOS activation nor OmniWM gives focus to a window a launcher just
-- spawned, so every launcher waits for its window and focuses it; focusing
-- carries OmniWM to that window's workspace, which is how the launchers reach
-- apps pinned elsewhere (Slack, Discord).
local windowPollInterval = 0.1
local windowPollTimeout = 5
local focusRetryInterval = 0.15
local focusAttempts = 8

-- `open -n` starts a second instance, so a launched window can belong to an app
-- object that hs.application.get never returns.
local function windowsOf(appName)
  local windows = {}
  for _, app in ipairs(hs.application.runningApplications()) do
    if app:name() == appName then
      for _, window in ipairs(app:allWindows()) do
        table.insert(windows, window)
      end
    end
  end
  return windows
end

local function openWindowIDs(appName)
  local ids = {}
  for _, window in ipairs(windowsOf(appName)) do
    ids[window:id()] = true
  end
  return ids
end

local function mainWindowOf(appName)
  local app = hs.application.get(appName)
  return app and app:mainWindow()
end

-- Window ids climb, so the newest unseen window is the spawned one even when a
-- busy app answers an Accessibility query with a short window list.
local function spawnedWindow(launcher, alreadyOpen)
  local newest
  for _, window in ipairs(windowsOf(launcher.app)) do
    if window:isStandard() and not alreadyOpen[window:id()] then
      if not newest or window:id() > newest:id() then
        newest = window
      end
    end
  end
  if newest or launcher.opensNewWindow then
    return newest
  end
  return mainWindowOf(launcher.app)
end

-- OmniWM tiles a new window a beat after it appears and hands focus back to
-- whatever held it, so focus has to be re-asserted until it sticks.
local function keepFocus(window, attemptsLeft)
  window:focus()
  if attemptsLeft <= 1 then
    return
  end
  hs.timer.doAfter(focusRetryInterval, function()
    local focused = hs.window.focusedWindow()
    if not focused or focused:id() ~= window:id() then
      keepFocus(window, attemptsLeft - 1)
    end
  end)
end

local function focusWhenReady(launcher, alreadyOpen, deadline)
  local window = spawnedWindow(launcher, alreadyOpen)
  if window then
    keepFocus(window, focusAttempts)
  elseif hs.timer.secondsSinceEpoch() < deadline then
    hs.timer.doAfter(windowPollInterval, function()
      focusWhenReady(launcher, alreadyOpen, deadline)
    end)
  end
end

local function launch(launcher)
  local alreadyOpen = openWindowIDs(launcher.app)
  hs.execute(launcher.spawn)
  focusWhenReady(launcher, alreadyOpen, hs.timer.secondsSinceEpoch() + windowPollTimeout)
end

for key, launcher in pairs(launchers) do
  hs.hotkey.bind(hyper, key, function() launch(launcher) end)
end

hs.hotkey.bind({ "alt" }, "return", function()
  launch({ app = "Ghostty", spawn = "open -na Ghostty", opensNewWindow = true })
end)

-- Reload on config change.
hs.pathwatcher.new(hs.configdir, hs.reload):start()
hs.alert.show("Hammerspoon loaded")

-- Rex keybindings. Rex's built-in shortcuts stay as they are; this file adds
-- chords Rex leaves unbound and extends Cmd+Alt+arrows into Neovim. See the
-- navigation map in AGENTS.md.

local home = os.getenv('HOME')

-- Pane focus: Cmd+Alt+arrows (Rex's default) also crosses Neovim splits. In a
-- Neovim pane the action forwards Alt+arrow, which smart-splits maps and hands
-- back to Rex at an edge. The module ships with the Neovim backend plugin; if
-- it's missing, Rex's default pane focus stays bound.
local ok, err = pcall(function()
  dofile(home .. '/.local/share/nvim/site/pack/core/opt/smart-splits-backend-rex/rex/lua/smart-splits-rex/init.lua').setup()
end)
if ok then
  for _, dir in ipairs({ 'left', 'right', 'up', 'down' }) do
    rex.bind('cmd+alt+' .. dir, 'smart_splits_focus', { direction = dir, key = 'alt+' .. dir })
  end
else
  rex.log('warn', 'smart-splits-rex not loaded: ' .. tostring(err))
end

-- Tabs and sessions: Alt+Shift+arrows step through the next scope up.
rex.bind('alt+shift+left', 'client.tab.previous')
rex.bind('alt+shift+right', 'client.tab.next')
rex.bind('alt+shift+up', 'session.previous')
rex.bind('alt+shift+down', 'session.next')

-- Project picker in a floating pane.
rex.action({
  name = 'sessionizer',
  title = 'Open Project…',
  run = function()
    rex.session.new_layer({
      bounds = { 0.1, 0.2, 0.8, 0.6 },
      layout = rex.layout.block({
        flavor = 'com.superlogical.terminal.shell',
        options = { command = { home .. '/bin/rex-sessionizer' } },
      }),
      focus = true,
    })
  end,
})
rex.bind('alt+shift+s', 'sessionizer')

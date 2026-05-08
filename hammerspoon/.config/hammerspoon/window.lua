local hyperKey = { "alt", "ctrl", "cmd", "shift" }

hs.hotkey.bind(hyperKey, "left", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 1 })
end)
hs.hotkey.bind(hyperKey, "right", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 1 })
end)
hs.hotkey.bind(hyperKey, "up", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 0.5 })
end)
hs.hotkey.bind(hyperKey, "down", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0.5, 1, 0.5 })
end)

-- full screen
hs.hotkey.bind(hyperKey, "f", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 1 })
end)

-- move to another screen
hs.hotkey.bind(hyperKey, "c", function()
	-- get the focused window
	local win = hs.window.focusedWindow()
	-- get the screen where the focused window is displayed, a.k.a. current screen
	local screen = win:screen()
	-- compute the unitRect of the focused window relative to the current screen
	-- and move the window to the next screen setting the same unitRect
	win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)

hs.hotkey.bind({ "ctrl", "cmd" }, "l", function()
	hs.eventtap.keyStroke({ "ctrl" }, "tab")
end)

hs.hotkey.bind({ "ctrl", "cmd" }, "h", function()
	hs.eventtap.keyStroke({ "ctrl", "shift" }, "tab")
end)

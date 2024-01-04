--[[

--]]
local DraeUI = select(2, ...)

local M = DraeUI:NewModule("Misc", "AceEvent-3.0", "AceTimer-3.0")

local UIErrorsFrame = _G.UIErrorsFrame
local interruptMsg = _G.INTERRUPTED .. " %s's \124cff71d5ff\124Hspell:%d\124h[%s]\124h\124r!"
local floor, format = math.floor, string.format

--[[

--]]
M.ErrorFrameToggle = function(self, event)
	if (event == "PLAYER_REGEN_DISABLED") then
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	else
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
	end
end

--[[
		PLAYER_LOGIN
--]]
M.OnEnable = function(self)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "ErrorFrameToggle")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "ErrorFrameToggle")
end

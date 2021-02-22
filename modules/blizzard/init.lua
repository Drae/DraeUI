--[[


--]]
local DraeUI = select(2, ...)

local B = DraeUI:NewModule("Blizzard", "AceEvent-3.0", "AceHook-3.0")

--[[

--]]
B.OnEnable = function(self)
	self:EnhanceColorPicker()
	self:AlertMovers()
	self:PositionDurabilityFrame()
	self:PositionGMFrames()
	self:PositionVehicleFrame()
	self:MoveWatchFrame()
	self:PositionTalkingHead()

	CreateFrame("Frame"):SetScript("OnUpdate", function(self, elapsed)
		if (LFRBrowseFrame.timeToClear) then
			LFRBrowseFrame.timeToClear = nil
		end
	end)
end

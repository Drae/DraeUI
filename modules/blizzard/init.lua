--[[


--]]
local DraeUI = select(2, ...)

local B = DraeUI:NewModule("Blizzard")

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
end

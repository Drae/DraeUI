--[[


--]]
local DraeUI = select(2, ...)

local B = DraeUI:GetModule("Blizzard")

--[[
		Durability frame
--]]
B.PositionDurabilityFrame = function(self)
	hooksecurefunc(DurabilityFrame, "SetPoint", function(self, _, parent)
		if (parent == "MinimapCluster" or parent == _G["MinimapCluster"]) then
			DurabilityFrame:ClearAllPoints()
			DurabilityFrame:SetPoint("RIGHT", Minimap, "LEFT", -90, -50)
			DurabilityFrame:SetScale(0.8)
		end
	end)
end

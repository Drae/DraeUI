--[[


--]]
local T, C, G, P, U, _ = select(2, ...):unpack()

local B = T:GetModule("Blizzard")

--[[

--]]
local noop = function() end

B.MoveWatchFrame = function(self)
	ObjectiveTrackerFrame:SetMovable(true)
	ObjectiveTrackerFrame:SetResizable(true)
	ObjectiveTrackerFrame:SetClampedToScreen(false)
	ObjectiveTrackerFrame:ClearAllPoints()
	ObjectiveTrackerFrame:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMRIGHT", -5, -40)
	ObjectiveTrackerFrame:SetHeight(ObjectiveTrackerFrame:GetTop() - CONTAINER_OFFSET_Y)
	ObjectiveTrackerFrame:SetScale(0.95)
	ObjectiveTrackerFrame:SetUserPlaced(true)
	ObjectiveTrackerFrame:SetMovable(false)
	ObjectiveTrackerFrame:SetResizable(false)

	ObjectiveTrackerFrame.SetPoint = noop
end

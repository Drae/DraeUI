--[[


--]]
local DraeUI = select(2, ...)

local B = DraeUI:GetModule("Blizzard")

--[[

--]]
local ObjectiveFrameHolder = CreateFrame("Frame", "ObjectiveFrameHolder", UIParent)
ObjectiveFrameHolder:SetWidth(ObjectiveTrackerFrame:GetWidth())
ObjectiveFrameHolder:SetHeight(ObjectiveTrackerFrame:GetTop() - CONTAINER_OFFSET_Y)
ObjectiveFrameHolder:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMRIGHT", -10, -30)

B.MoveWatchFrame = function(self)
	ObjectiveFrameHolder:SetScale(0.95)

	ObjectiveTrackerFrame:ClearAllPoints()
	ObjectiveTrackerFrame:SetPoint("TOP", ObjectiveFrameHolder, "TOP")
	ObjectiveTrackerFrame:SetHeight(ObjectiveTrackerFrame:GetTop() - CONTAINER_OFFSET_Y)

	hooksecurefunc(ObjectiveTrackerFrame,"SetPoint", function(_, _, parent)
		if (parent ~= ObjectiveFrameHolder) then
			ObjectiveTrackerFrame:ClearAllPoints()
            ObjectiveTrackerFrame:SetPoint("TOP", ObjectiveFrameHolder, "TOP")
		end
	end)
end

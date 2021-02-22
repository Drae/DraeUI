--[[


--]]
local DraeUI = select(2, ...)

local B = DraeUI:GetModule("Blizzard")

--
local _G = _G

--[[

--]]
B.PositionVehicleFrame = function(self)
	hooksecurefunc(
		VehicleSeatIndicator,
		"SetPoint",
		function(_, _, parent) -- vehicle seat indicator
			if (parent == "MinimapCluster" or parent == _G["MinimapCluster"]) then
				VehicleSeatIndicator:ClearAllPoints()

				if (VehicleSeatMover) then
					VehicleSeatIndicator:SetPoint("TOPLEFT", VehicleSeatMover, "TOPLEFT", 0, 0)
				else
					VehicleSeatIndicator:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 22, -45)
				end

				VehicleSeatIndicator:SetScale(0.8)
			end
		end
	)

	-- We've hooked Point for this frame as above so call it rather than our own Point()
	VehicleSeatIndicator:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT", 2, 2) -- initialize mover
	VehicleSeatIndicator:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT", 2, 2) -- initialize mover
end

--[[


--]]
local T, C, G, P, U, _ = select(2, ...):unpack()

local B = T:GetModule("Blizzard")

--[[

--]]
function B:PositionDraenorSpellBtn()
	DraenorZoneAbilityFrame:ClearAllPoints()
	DraenorZoneAbilityFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -370)

	DraenorZoneAbilityFrame.SetPoint = function() return end
end

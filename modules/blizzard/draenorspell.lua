--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local B = T:GetModule("Blizzard")

--[[

--]]
function B:PositionDraenorSpellBtn()
	DraenorZoneAbilityFrame:ClearAllPoints()
	DraenorZoneAbilityFrame:Point("CENTER", T.UIParent, "CENTER", 0, 240)

	DraenorZoneAbilityFrame.SetPoint = function() return end
end

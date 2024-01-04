local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- Auchindoun

UF["raiddebuffs"]["instances"]["Freehold"] = function()
	-- Galvazzt
	UF:AddRaidDebuff(true, 255579, 8) -- Galvanize
end

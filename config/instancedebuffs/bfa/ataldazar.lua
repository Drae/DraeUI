local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Auchindoun

UF["raiddebuffs"]["instances"]["Atal'Dazar"] = function()
	-- Galvazzt
	UF:AddRaidDebuff(true, 255579, 8) -- Galvanize
end

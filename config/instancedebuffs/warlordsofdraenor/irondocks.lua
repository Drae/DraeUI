local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- Iron Docks

UF["raiddebuffs"]["instances"]["Iron Docks"] = function()
	-- Fleshrender Nok'gar
	UF:AddRaidDebuff(true, 164632, 6) -- Burning Arrows
	UF:AddRaidDebuff(true, 164837, 6) -- Savage Mauling

	-- Grimrail Enforcers
	UF:AddRaidDebuff(true, 163740, 6) -- Tainted Blood
	UF:AddRaidDebuff(true, 163276, 6) -- Savage Mauling

	-- Oshir
	UF:AddRaidDebuff(true, 162415, 6, true) -- Time to Feed
	UF:AddRaidDebuff(true, 178155, 6) -- Acid Spit

	-- Skulloc
	UF:AddRaidDebuff(true, 168955, 6) -- Melee Sparks
	UF:AddRaidDebuff(true, 168348, 6, true) -- Rapid Fire
end

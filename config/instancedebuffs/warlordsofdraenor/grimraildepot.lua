local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- Grimrail Depot

UF["raiddebuffs"]["instances"]["Grimrail Depot"] = function()
	-- Railmaster Rocketspark

	-- Nitrogg Thundertower
	UF:AddRaidDebuff(true, 166570, 6) -- Slag Blast (p1)
	UF:AddRaidDebuff(true, 166570, 6, true) -- Carrying Mortar shells (p2)
	UF:AddRaidDebuff(true, 166570, 6, true) -- Carrying Grenades (p2)
	UF:AddRaidDebuff(true, 160681, 8, true) -- Suppressive Fire

	-- Skylord Tovra
	UF:AddRaidDebuff(true, 162066, 8) -- Freezing Snare
	UF:AddRaidDebuff(true, 161588, 8, true) -- Diffused Energy
	UF:AddRaidDebuff(true, 163447, 8, true) -- Hunter's Mark
end

local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Mists of Tirna Scithe"] = function()
	-- Trash
	UF:AddRaidDebuff(true, 322557, 5) -- Soul split
	UF:AddRaidDebuff(true, 322486, 5) -- Overgrowth

	--Ingra Maloch
	UF:AddRaidDebuff(true, 323146, 5) --Death Shroud
	UF:AddRaidDebuff(true, 328756, 5) --Repulsive Visage
	UF:AddRaidDebuff(true, 323250, 5) --Anima Puddle

	--Mistcaller
	UF:AddRaidDebuff(true, 321891, 4, true) --Freeze Tag Fixation
	UF:AddRaidDebuff(true, 321893, 5) --Freezing Burst

	--Tred'ova
	UF:AddRaidDebuff(true, 322563, 5) --Marked Prey
	UF:AddRaidDebuff(true, 322648, 5) --Mind Link
	UF:AddRaidDebuff(true, 326309, 5) --Decomposing Acid
end

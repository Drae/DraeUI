local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Plaguefall"] = function()
	--Globgrog
	UF:AddRaidDebuff(true, 324652, 5) --Debilitating Plague
	UF:AddRaidDebuff(true, 326242, 5) --Slime Wave
	UF:AddRaidDebuff(true, 330069, 5) --Concentrated Plague

	--Doctor Ickus
	UF:AddRaidDebuff(true, 330069, 5) --Concentrated Plague
	UF:AddRaidDebuff(true, 329110, 5) --Slime Injection
	UF:AddRaidDebuff(true, 322358, 5) --Burning Strain
	UF:AddRaidDebuff(true, 322410, 5) --Withering Filth

	--Domina Venomblade
	UF:AddRaidDebuff(true, 333406, 5) --Assassinate
	UF:AddRaidDebuff(true, 325552, 5) --Cytotoxic Slash
	UF:AddRaidDebuff(true, 331818, 5) --Shadow Ambush
	UF:AddRaidDebuff(true, 332397, 5) --Shroudweb

	--Stradama Margrave
	UF:AddRaidDebuff(true, 331399, 5) --Infectios Rain
	UF:AddRaidDebuff(true, 330135, 5) --Fount of Pestilence
end

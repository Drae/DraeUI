local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["De Other Side"] = function()
	--Hakkar the Soulflayer
	UF:AddRaidDebuff(true, 322746, 5) --Corrupted Blood
	UF:AddRaidDebuff(true, 328987, 5) --Zealous
	UF:AddRaidDebuff(true, 323118, 5) --Blood Barrage
	UF:AddRaidDebuff(true, 323569, 5) --Spilled Essence

	--The Manastorms
	UF:AddRaidDebuff(true, 320147, 5) --Bleeding
	UF:AddRaidDebuff(true, 320786, 5) --Power Overwhelming
	UF:AddRaidDebuff(true, 320008, 4) --Frostbolt
	UF:AddRaidDebuff(true, 323877, 5) --Echo Finger Laser X-treme
	UF:AddRaidDebuff(true, 320144, 5) --Buzz-Saw
	UF:AddRaidDebuff(true, 320142, 5) --Diabolical Dooooooom!
	UF:AddRaidDebuff(true, 324010, 5) --Eruption
	UF:AddRaidDebuff(true, 320132, 5) --Shadowfury

	--Dealer Xy'exa
	UF:AddRaidDebuff(true, 323692, 4) --Arcane Vulnerability
	UF:AddRaidDebuff(true, 323687, 5) --Arcane Lightning
	UF:AddRaidDebuff(true, 342961, 5) --Localized Explosive Contrivance
	UF:AddRaidDebuff(true, 320232, 5) --Explosive Contrivance

	--Mueh'zala
	UF:AddRaidDebuff(true, 325725, 4) --Cosmic Artifice
	UF:AddRaidDebuff(true, 334913, 5) --Master of Death
	UF:AddRaidDebuff(true, 327649, 4) --Crushed Soul
end

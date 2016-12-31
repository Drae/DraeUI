local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- PvP/World

UF["raiddebuffs"]["pvp"] = function()
	UF:AddRaidDebuff(true, 23335,  6, true) -- Silverwing Flag
	UF:AddRaidDebuff(true, 34976,  6, true) -- Netherstorm Flag

	UF:AddRaidDebuff(true, 118,    8, false, true) --Polymorph
	UF:AddRaidDebuff(true, 3355,   8) --Freezing Trap
	UF:AddRaidDebuff(true, 20066,  8) --Repentance
	UF:AddRaidDebuff(true, 5782,   8) --Fear
	UF:AddRaidDebuff(true, 6770,   8) --Sap
	UF:AddRaidDebuff(true, 2094,   8) --Blind
	UF:AddRaidDebuff(true, 51514,  8) --Hex
	UF:AddRaidDebuff(true, 853,    8) --Hammer of Justice
	UF:AddRaidDebuff(true, 30108,  10) --Unstable Affliction
	UF:AddRaidDebuff(true, 339,    8) --Entangling Roots
	UF:AddRaidDebuff(true, 122,    8, true) --Frost Nova

	-- Temp Karazhan
	UF:AddRaidDebuff(true, 228808, 5)  -- Charred Earth
	UF:AddRaidDebuff(true, 228796, 9)  -- Ignite Soul
	UF:AddRaidDebuff(true, 228829, 4)  -- Burning Bones
	UF:AddRaidDebuff(true, 228835, 6)  -- Absorb Vitality
	UF:AddRaidDebuff(true, 228833, 8, true)  -- Bone Shrapnel

end

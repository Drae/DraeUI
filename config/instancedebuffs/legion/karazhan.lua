local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Karazhan"] = function()
	-- Trash
	UF:AddRaidDebuff(true) -- Fixate (Abyssal)

	-- Nightbane
	UF:AddRaidDebuff(true, 228808, 5)  -- Charred Earth
	UF:AddRaidDebuff(true, 228796, 9, false, true)  -- Ignite Soul
	UF:AddRaidDebuff(true, 228829, 7)  -- Burning Bones
	UF:AddRaidDebuff(true, 228835, 6)  -- Absorb Vitality
	UF:AddRaidDebuff(true, 228833, 8)  -- Bone Shrapnel
end

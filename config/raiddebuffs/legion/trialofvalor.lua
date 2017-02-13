local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Trial of Valor
UF["raiddebuffs"]["instances"]["Trial of Valor"] = function()
	local zoneid = 1114

	-- Odyn
	UF:AddRaidDebuff(true, 227959, 5) -- Storm of Justice
	UF:AddRaidDebuff(true, 227475, 5) -- Cleansing Flame
	UF:AddRaidDebuff(true, 192044, 5) -- Expel Light
	UF:AddRaidDebuff(true, 227781, 5) -- Glowing Fragment

	-- Guarm
	UF:AddRaidDebuff(true, 228226, 8) -- Flame Lick
	UF:AddRaidDebuff(true, 228246, 8) -- Frost Lick
	UF:AddRaidDebuff(false, 228250, 4) -- Shadow Lick
	UF:AddRaidDebuff(true, 227539, 3) -- Fiery Phlegm
	UF:AddRaidDebuff(true, 227566, 3) -- Salty Spittle
	UF:AddRaidDebuff(true, 227570, 3) -- Dark Discharge
	UF:AddRaidDebuff(true, 228794, 7, true) -- Flaming Volatile Foam
	UF:AddRaidDebuff(true, 228819, 7, true) -- Shadowy Volatile Foam
	UF:AddRaidDebuff(true, 228811, 7, true) -- Briney Volatile Foam

	-- Helya
	UF:AddRaidDebuff(true, 227903, 5) -- Orb of Corruption
	UF:AddRaidDebuff(true, 228058, 5) -- Orb of Corrosion
	UF:AddRaidDebuff(true, 228054, 7) -- Taint of the Sea
	UF:AddRaidDebuff(true, 193367, 5) -- Fetid Rot
	UF:AddRaidDebuff(true, 227982, 5) -- Bilewater Redox
	UF:AddRaidDebuff(true, 228519, 5) -- Anchor Slam
	UF:AddRaidDebuff(true, 202476, 5) -- Rabid
	UF:AddRaidDebuff(true, 232450, 5) -- Corrupted Axion

end

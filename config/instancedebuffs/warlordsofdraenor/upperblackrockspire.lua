local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Upper Blackrock Spire

UF["raiddebuffs"]["instances"]["Upper Blackrock Spire"] = function()
	-- Orebender Gor'ashan

	-- Kyrak
	UF:AddRaidDebuff(true, 161119, 6, true) -- Debilitating Fixation
	UF:AddRaidDebuff(true, 162644, 6) -- Salve of Toxic Fumes

	-- Commander Tharbek
	UF:AddRaidDebuff(true, 161765, 6) -- Iron Axe
	UF:AddRaidDebuff(true, 161772, 6) -- Incincerating Breath
	UF:AddRaidDebuff(true, 161833, 6) -- Noxious Spit

	-- Ragewing the Untamed
	UF:AddRaidDebuff(true, 155031, 6) -- Engulfing Fire
	UF:AddRaidDebuff(true, 155051, 6) -- Magma Spit

	-- Warlord Zaela
	UF:AddRaidDebuff(true, 155720, 6, true) -- Black Iron Cyclone
	UF:AddRaidDebuff(true, 166041, 6) -- Burning Breath
end

local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- Auchindoun

UF["raiddebuffs"]["instances"]["Skyreach"] = function()
	-- Araknath
	UF:AddRaidDebuff(true, 157304, 5, true) -- Energize

	-- Ranjit
	UF:AddRaidDebuff(true, 156793, 5) -- Four Winds
	UF:AddRaidDebuff(true, 153757, 5) -- Fan of Blades
	UF:AddRaidDebuff(true, 153315, 5) -- Windwall
	UF:AddRaidDebuff(true, 154043, 5, true) -- Lens Flare

	-- Rukhran
	UF:AddRaidDebuff(true, 153794, 5) -- Pierce Armor

	-- Viryx
	UF:AddRaidDebuff(true, 153954, 6, true) -- Cast Down
end

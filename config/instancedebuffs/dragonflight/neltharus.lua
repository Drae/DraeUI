local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Neltharus"] = function()
	-- Chargath, Bane of Scales
	UF:AddRaidDebuff(true, 374471, 5) --erupted-ground
	UF:AddRaidDebuff(true, 374482, 5) --grounding-chain

	-- Forgemaster Gorek
	UF:AddRaidDebuff(true, 381482, 5) --forgefire

	-- Magmatusk
	UF:AddRaidDebuff(true, 375890, 5) --magma-eruption
	UF:AddRaidDebuff(true, 374410, 5) --magma-tentacle

	-- Warlord Sargha
	UF:AddRaidDebuff(true, 377522, 5) --burning-pursuit
	UF:AddRaidDebuff(true, 376784, 5) --flame-vulnerability
	UF:AddRaidDebuff(true, 377018, 5) --molten-gold
	UF:AddRaidDebuff(true, 377022, 5) --hardened-gold
	UF:AddRaidDebuff(true, 377542, 5) --burning-ground
end

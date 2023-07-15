local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Court of Stars"] = function()
	local zoneid = 1081

	--Whole Dungeon/Trash/Mythic Plus
	UF:AddRaidDebuff(true, 214692, 6) --Shadow Bolt Volley
	UF:AddRaidDebuff(true, 211464, 6) --Fel Detonation
	UF:AddRaidDebuff(true, 211473, 6) --Shadow Slash
	UF:AddRaidDebuff(true, 207981, 6) --Disintegration Beam
	UF:AddRaidDebuff(true, 211391, 6) --Felblaze Puddle
	UF:AddRaidDebuff(true, 209036, 6) --Throw Torch
	UF:AddRaidDebuff(true, 209378, 6) --Whirling Blades
	UF:AddRaidDebuff(true, 214690, 6) --Cripple
	UF:AddRaidDebuff(true, 209512, 6) --Disrupting Energy
	UF:AddRaidDebuff(true, 209516, 6) --Mana Fang
	UF:AddRaidDebuff(true, 209413, 6) --Suppress

	--Patrol Captain Gerdo
	UF:AddRaidDebuff(true, 207278, 6) --Arcane Lockdown

	--Talixae Flamewreath
	UF:AddRaidDebuff(true, 154415, 6) --

	--Advisor Melandrus
	UF:AddRaidDebuff(true, 209667, 6) --Blade Surge
end

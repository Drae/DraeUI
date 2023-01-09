local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Algeth'ar Academy"] = function()
	-- Trash
	UF:AddRaidDebuff(true, 390918, 5) --Seed Detonation
	UF:AddRaidDebuff(true, 377344, 5) --Peck
	UF:AddRaidDebuff(true, 388912, 5) --Severing Slash
	UF:AddRaidDebuff(true, 388866, 5) --Mana Void
	UF:AddRaidDebuff(true, 388984, 5) --Vicious Ambush
	UF:AddRaidDebuff(true, 388392, 5) --Monotonous Lecture
	UF:AddRaidDebuff(true, 387932, 5) --Astral Whirlwind
	UF:AddRaidDebuff(true, 378011, 5) --Deadly Winds
	UF:AddRaidDebuff(true, 387843, 5) --Astral Bomb

	-- Vexamus
	UF:AddRaidDebuff(true, 391977, 5) --Oversurge
	UF:AddRaidDebuff(true, 386181, 5) --Mana Bomb
	UF:AddRaidDebuff(true, 386201, 5) --Corrupted Mana

	-- Overgrown Ancient
	UF:AddRaidDebuff(true, 388544, 5) --Barkbreaker
	UF:AddRaidDebuff(true, 396716, 5) --Splinterbark
	UF:AddRaidDebuff(true, 389033, 5) --Lasher Toxin

	-- Crawth
	UF:AddRaidDebuff(true, 397210, 5) --Sonic Vulnerability
	UF:AddRaidDebuff(true, 376449, 5) --Firestorm
	UF:AddRaidDebuff(true, 376997, 5) --Savage Peck

	-- Echo of Doragosa
	UF:AddRaidDebuff(true, 374350, 5) --Energy Bomb
	UF:AddRaidDebuff(true, 389011, 6) --Overwhelming Power
end

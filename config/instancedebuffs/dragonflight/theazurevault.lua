local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["The Azure Vault"] = function()
	-- Trash
	UF:AddRaidDebuff(true, 387564, 5) --Mystic Vapors
	UF:AddRaidDebuff(true, 370764, 5) --Piercing Shards
	UF:AddRaidDebuff(true, 375596, 5) --Erratic Growth
	UF:AddRaidDebuff(true, 375602, 5) --Erratic Growth
	UF:AddRaidDebuff(true, 375649, 5) --Infused Ground
	UF:AddRaidDebuff(true, 370766, 5) --Crystalline Rupture
	UF:AddRaidDebuff(true, 371007, 5) --Splintering Shards
	UF:AddRaidDebuff(true, 375591, 5) --Sappy Burst
	UF:AddRaidDebuff(true, 395492, 5) --Scornful Haste
	UF:AddRaidDebuff(true, 395532, 5) --Sluggish Adoration
	UF:AddRaidDebuff(true, 390301, 5) --Hardening Scales
	UF:AddRaidDebuff(true, 386549, 5) --Waking Bane
	UF:AddRaidDebuff(true, 371352, 5) --Forbidden Knowledge
	UF:AddRaidDebuff(true, 377488, 5) --Icy Bindings
	UF:AddRaidDebuff(true, 386640, 5) --Tear Flesh

	-- Leymor
	UF:AddRaidDebuff(true, 374789, 5) --Infused Strike
	UF:AddRaidDebuff(true, 374523, 5) --Stinging Sap
	UF:AddRaidDebuff(true, 374567, 5) --Explosive Brand

	-- Azureblade

	-- Telash Greywing
	UF:AddRaidDebuff(true, 386881, 5) --Frost Bomb
	UF:AddRaidDebuff(true, 387150, 5) --Frozen Ground
	UF:AddRaidDebuff(true, 387151, 5) --Icy Devastator
	UF:AddRaidDebuff(true, 388072, 5) --Vault Rune
	UF:AddRaidDebuff(true, 396722, 5) --Absolute Zero

	-- Umbrelskul
	UF:AddRaidDebuff(true, 388777, 5) --Oppressive Miasma
	UF:AddRaidDebuff(true, 384978, 5) --Dragon Strike
	UF:AddRaidDebuff(true, 385331, 5) --Fracture
	UF:AddRaidDebuff(true, 385267, 5) --Crackling Vortex
end

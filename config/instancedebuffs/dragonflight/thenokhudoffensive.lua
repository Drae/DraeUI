local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["The Nokhud Offensive"] = function()
	-- Trash
	UF:AddRaidDebuff(true, 384134, 5) --Pierce
	UF:AddRaidDebuff(true, 381692, 5) --Swift Stab
	UF:AddRaidDebuff(true, 334610, 5) --Hunt Prey
	UF:AddRaidDebuff(true, 384336, 5) --War Stomp
	UF:AddRaidDebuff(true, 384492, 5) --Hunter's Mark
	UF:AddRaidDebuff(true, 386025, 5) --Tempest
	UF:AddRaidDebuff(true, 386912, 5) --Stormsurge Cloud
	UF:AddRaidDebuff(true, 388801, 5) --Mortal Strike
	UF:AddRaidDebuff(true, 387615, 5) --Grasp of the Dead
	UF:AddRaidDebuff(true, 387616, 5) --Grasp of the Dead
	UF:AddRaidDebuff(true, 381530, 5) --Storm Shock
	UF:AddRaidDebuff(true, 373395, 5) --Bloodcurdling Shout
	UF:AddRaidDebuff(true, 387629, 5) --Rotting Wind
	UF:AddRaidDebuff(true, 395035, 5) --Shatter Soul

	-- The Raging Tempest
	UF:AddRaidDebuff(true, 384185, 5) --Lightning Strike
	UF:AddRaidDebuff(true, 386916, 5) --The Raging Tempest
	UF:AddRaidDebuff(true, 382628, 5) --Surge of Power

	-- Teera and Maruuk
	UF:AddRaidDebuff(true, 392151, 5) --Gale Arrow
	UF:AddRaidDebuff(true, 395669, 5) --Aftershock

	-- Balakar Khan
	UF:AddRaidDebuff(true, 375937, 5) --Rending Strike
	UF:AddRaidDebuff(true, 376634, 5) --Iron Spear
	UF:AddRaidDebuff(true, 393421, 5) --Quake
	UF:AddRaidDebuff(true, 376730, 5) --Stormwinds
	UF:AddRaidDebuff(true, 376827, 5) --Conductive Strike
	UF:AddRaidDebuff(true, 376864, 5) --Static Spear
	UF:AddRaidDebuff(true, 376894, 5) --Crackling Upheaval
	UF:AddRaidDebuff(true, 376899, 5) --Crackling Cloud
end

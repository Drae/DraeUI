local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Ruby Life Pools"] = function()
	-- Trash
	UF:AddRaidDebuff(true, 372697, 5) --Jagged Earth
	UF:AddRaidDebuff(true, 372047, 5) --Steel Barrage
	UF:AddRaidDebuff(true, 373869, 5) --Burning Touch
	UF:AddRaidDebuff(true, 392641, 5) --Rolling Thunder
	UF:AddRaidDebuff(true, 373693, 5) --Living Bomb
	UF:AddRaidDebuff(true, 373692, 5) --Inferno
	UF:AddRaidDebuff(true, 395292, 5) --Fire Maw
	UF:AddRaidDebuff(true, 372796, 5) --Blazing Rush
	UF:AddRaidDebuff(true, 392406, 5) --Thunderclap
	UF:AddRaidDebuff(true, 392451, 5) --Flashfire
	UF:AddRaidDebuff(true, 392924, 5) --Shock Blast
	UF:AddRaidDebuff(true, 373589, 7) --Primal Chill

	-- Melidrussa Chillworn
	UF:AddRaidDebuff(true, 385518, 5) --Chillstorm
	UF:AddRaidDebuff(true, 372963, 5) --Chillstorm
	UF:AddRaidDebuff(true, 372682, 7) --Primal Chill
	UF:AddRaidDebuff(true, 378968, 5) --Flame Patch
	UF:AddRaidDebuff(true, 373022, 5) --Frozen Solid

	-- Kokia Blazehoof
	UF:AddRaidDebuff(true, 372860, 5) --Searing Wounds
	UF:AddRaidDebuff(true, 372820, 5) --Scorched Earth
	UF:AddRaidDebuff(true, 372811, 5) --Molten Boulder
	UF:AddRaidDebuff(true, 384823, 5) --Inferno

	-- Kyrakka and Erkhart Stormvein
	UF:AddRaidDebuff(true, 381526, 5) --Roaring Firebreath
	UF:AddRaidDebuff(true, 381862, 5) --Infernocore
	UF:AddRaidDebuff(true, 381515, 5) --Stormslam
	UF:AddRaidDebuff(true, 381518, 5) --Winds of Change
	UF:AddRaidDebuff(true, 384773, 5) --Flaming Embers
end

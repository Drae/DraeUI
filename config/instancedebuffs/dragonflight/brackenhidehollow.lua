local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Brackenhide Hollow"] = function()
	-- Hackclaw's War-Band
	UF:AddRaidDebuff(true, 378020, 5) --gash-frenzy
	UF:AddRaidDebuff(true, 381379, 5) --decayed-senses

	-- Treemouth
	UF:AddRaidDebuff(true, 377864, 5) --infectious-spit
	UF:AddRaidDebuff(true, 378054, 5) --withering-away
	UF:AddRaidDebuff(true, 378022, 5) --consuming
	UF:AddRaidDebuff(true, 376933, 5) --grasping-vines

	-- Gutshot
	UF:AddRaidDebuff(true, 376997, 5) --savage-peck

	-- Decatriarch Wratheye
	UF:AddRaidDebuff(true, 373896, 5) --withering-rot
end

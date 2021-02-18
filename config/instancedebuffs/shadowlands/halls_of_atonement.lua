local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Halls of Atonement"] = function()
	--Halkias, the Sin-Stained Goliath
	UF:AddRaidDebuff(true, 323001, 5) --Glass Shards
	UF:AddRaidDebuff(true, 339237, 5) --Sinlight Visions

	--Echelon
	UF:AddRaidDebuff(true, 344874, 5) --Shattered
	UF:AddRaidDebuff(true, 319603, 5) --Curse of Stone
	UF:AddRaidDebuff(true, 319611, 4) --Turned to Stone
	UF:AddRaidDebuff(true, 319703, 5) --Blood Torrent

	--High Adjudicator Aleez
	UF:AddRaidDebuff(true, 323650, 4) --Haunting Fixation

	--Lord Chamberlain
	UF:AddRaidDebuff(true, 323437, 5) --Stigma of Pride
	UF:AddRaidDebuff(true, 335338, 5) --Ritual of Woe
end

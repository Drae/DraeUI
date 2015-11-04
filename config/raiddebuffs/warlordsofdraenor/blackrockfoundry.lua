local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Blackrock Foundry

UF["raiddebuffs"]["instances"]["Blackrock Foundry"] = function()
	--Blackhand
	UF:AddRaidDebuff(true, 156096, 8, true) -- MARKEDFORDEATH
	UF:AddRaidDebuff(true, 156743, 5) 		-- IMPALED
	UF:AddRaidDebuff(true, 156047, 6) 		-- SLAGGED
	UF:AddRaidDebuff(true, 156401, 5) 		-- MOLTENSLAG
	UF:AddRaidDebuff(true, 156404, 6) 		-- BURNED
	UF:AddRaidDebuff(true, 158054, 7) 		-- SHATTERINGSMASH 158054 155992 159142
	UF:AddRaidDebuff(true, 156888, 5) 		-- OVERHEATED
	UF:AddRaidDebuff(true, 157000, 4) 		-- ATTACHSLAGBOMBS
	UF:AddRaidDebuff(true, 156999, 4) 		-- THROWSLAGBOMBS
	UF:AddRaidDebuff(true, 156772, 4, true)		-- Incendiary Rounds

	--Beastlord Darmac
	UF:AddRaidDebuff(true, 155365, 4, true) -- PINNEDDOWN
	UF:AddRaidDebuff(true, 162283, 5) 		-- RENDANDTEAR
	UF:AddRaidDebuff(true, 155030, 6) 		-- SEAREDFLESH
	UF:AddRaidDebuff(true, 155236, 6) 		-- CRUSHARMOR
	UF:AddRaidDebuff(true, 155657, 6) 		-- FLAMEINFUSION
	UF:AddRaidDebuff(true, 155399, 6) 		-- CONFLAGRATION
	UF:AddRaidDebuff(true, 155499, 6) 		-- SUPERHEATEDSHRAPNEL

	--Flamebender Ka'graz
	UF:AddRaidDebuff(true, 155277, 4) 		-- BLAZINGRADIANCE
	UF:AddRaidDebuff(true, 154952, 4, true)	-- FIXATE
	UF:AddRaidDebuff(true, 155074, 4) 		-- CHARRINGBREATH (Tank)
	UF:AddRaidDebuff(true, 154932, 6)		-- Molten Torrent

	--Operator Thogar
	UF:AddRaidDebuff(true, 155921, 5, true) -- ENKINDLE
	UF:AddRaidDebuff(true, 165195, 5) 		-- PROTOTYPEPULSEGRENADE
	UF:AddRaidDebuff(true, 155701, 5) 		-- SERRATEDSLASH
	UF:AddRaidDebuff(true, 156310, 5) 		-- LAVASHOCK
	UF:AddRaidDebuff(true, 164380, 5, true) -- BURNING

	--The Blast Furnace
	UF:AddRaidDebuff(true, 155240, 6) -- TEMPERED
	UF:AddRaidDebuff(true, 155192, 7, true) -- BOMB
	UF:AddRaidDebuff(true, 156934, 5) -- RUPTURE
	UF:AddRaidDebuff(true, 175104, 6) -- MELTARMOR
	UF:AddRaidDebuff(true, 176121, 4) -- VOLATILEFIRE
	UF:AddRaidDebuff(true, 155196, 6, true) -- FIXATE
	UF:AddRaidDebuff(true, 155225, 5) -- MELT
    UF:AddRaidDebuff(true, 158247, 6, true) -- Hot blooded
	
	--Hans'gar and Franzok
	UF:AddRaidDebuff(true, 157139, 6) -- SHATTEREDVERTEBRAE
	UF:AddRaidDebuff(true, 161570, 5) -- SEARINGPLATES
	UF:AddRaidDebuff(true, 157853, 5) -- AFTERSHOCK

	--Gruul
	UF:AddRaidDebuff(true, 155080, 5) -- INFERNOSLICE
	UF:AddRaidDebuff(true, 143962, 6) -- INFERNOSTRIKE
	UF:AddRaidDebuff(true, 155078, 6) -- OVERWHELMINGBLOWS
	UF:AddRaidDebuff(true, 36240, 5)  -- CAVEIN
	UF:AddRaidDebuff(true, 165300, 6) -- FLARE Mythic

	--Kromog
	UF:AddRaidDebuff(true, 157060, 5) 		-- RUNEOFGRASPINGEARTH
	UF:AddRaidDebuff(true, 156766, 6, true) -- WARPEDARMOR
	UF:AddRaidDebuff(true, 161839, 7) 		-- RUNEOFCRUSHINGEARTH

	--Oregorger
	UF:AddRaidDebuff(true, 156309, 6) -- ACIDTORRENT
	UF:AddRaidDebuff(true, 156203, 5) -- RETCHEDBLACKROCK
	UF:AddRaidDebuff(true, 173471, 5) -- ACIDMAW

	--The Iron Maidens
	UF:AddRaidDebuff(true, 164271, 6, true) -- PENETRATINGSHOT
	UF:AddRaidDebuff(true, 158315, 6) -- DARKHUNT
--	UF:AddRaidDebuff(true, 156601, 6, true) -- SANGUINESTRIKES
--	UF:AddRaidDebuff(true, 170395, 6) -- SORKASPREY
	UF:AddRaidDebuff(true, 170405, 6, true) -- MARAKSBLOODCALLING
--	UF:AddRaidDebuff(true, 158692, 6) -- DEADLYTHROW
--	UF:AddRaidDebuff(true, 158702, 4, true) -- FIXATE
--	UF:AddRaidDebuff(true, 158686, 6) -- EXPOSEARMOR
	UF:AddRaidDebuff(true, 158683, 5, true) -- CORRUPTEDBLOOD
    UF:AddRaidDebuff(true, 156112, 8) -- Convulsive Shadows
end

local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- Highmaul
UF["raiddebuffs"]["instances"]["Highmaul"] = function()
	-- enable, spell, priority, secondary, pulse, flash

	-- The Butcher
	UF:AddRaidDebuff(true, 156152, 5, true) -- GUSHINGWOUNDS
	UF:AddRaidDebuff(true, 156151, 6) 		-- THETENDERIZER
	UF:AddRaidDebuff(true, 156143, 5, true) -- THECLEAVER
	UF:AddRaidDebuff(true, 163046, 5) 		-- PALEVITRIOL

	-- Kargath Bladefist
	UF:AddRaidDebuff(true, 159113, 5) -- IMPALE
	UF:AddRaidDebuff(true, 159178, 6) -- OPENWOUNDS
	UF:AddRaidDebuff(true, 159213, 7) -- MONSTERSBRAWL
	UF:AddRaidDebuff(true, 158986, 8, true) -- BERSERKERRUSH
	UF:AddRaidDebuff(true, 159410, 5) -- MAULINGBREW
	UF:AddRaidDebuff(true, 160521, 6) -- VILEBREATH
	UF:AddRaidDebuff(true, 159386, 5) -- IRONBOMB
	UF:AddRaidDebuff(true, 159188, 5) -- GRAPPLE
	UF:AddRaidDebuff(true, 162497, 8, true) -- ONTHEHUNT
	UF:AddRaidDebuff(true, 159202, 5) -- FLAME JET

	-- Twin Ogron
	UF:AddRaidDebuff(true, 158026, 6) 		-- ENFEEBLINGROAR
	UF:AddRaidDebuff(true, 158241, 5) 		-- BLAZE
	UF:AddRaidDebuff(true, 155569, 8) 		-- INJURED
	UF:AddRaidDebuff(true, 167200, 7) 		-- ARCANEWOUND
	UF:AddRaidDebuff(true, 167186, 7) 		-- ARCANEBASH
	UF:AddRaidDebuff(true, 159709, 6) 		-- WEAKENEDDEFENSES 159709 167179
	UF:AddRaidDebuff(true, 163374, 4, true) -- ARCANEVOLATILITY

	-- Ko'ragh
	UF:AddRaidDebuff(true, 161242, 4) -- CAUSTICENERGY
	UF:AddRaidDebuff(true, 161358, 4) -- SUPPRESSION FIELD
	UF:AddRaidDebuff(true, 162184, 6) -- EXPELMAGICSHADOW
	UF:AddRaidDebuff(true, 162186, 6) -- EXPELMAGICARCANE
	UF:AddRaidDebuff(true, 161411, 6) -- EXPELMAGICFROST
	UF:AddRaidDebuff(true, 163472, 4) -- DOMINATINGPOWER
	UF:AddRaidDebuff(true, 162185, 7) -- EXPELMAGICFEL

	-- Tectus
	UF:AddRaidDebuff(true, 162892, 5) -- INFESTINGSPORES--PETRIFICATION

	-- Brackenspore
	UF:AddRaidDebuff(true, 163242, 5, true) -- INFESTINGSPORES
	UF:AddRaidDebuff(true, 163590, 5) 		-- CREEPINGMOSS
	UF:AddRaidDebuff(true, 163241, 7) 		-- ROT
	UF:AddRaidDebuff(true, 163240, 5, true) -- ROT2
	UF:AddRaidDebuff(true, 159220, 4) 		-- NECROTICBREATH
	UF:AddRaidDebuff(true, 160179, 6) 		-- MINDFUNGUS
	UF:AddRaidDebuff(true, 159972, 6, true) -- FLESHEATER

	-- Imperator Mar'gok
	UF:AddRaidDebuff(true, 156238, 4) 		-- BRANDED  156238 163990 163989 163988
	UF:AddRaidDebuff(true, 156467, 5) 		-- DESTRUCTIVERESONANCE  156467 164075 164076 164077
	UF:AddRaidDebuff(true, 157349, 5) 		-- FORCENOVA  157349 164232 164235 164240
	UF:AddRaidDebuff(true, 158609, 4) 		-- MARKOFCHAOS  158605 164176 164178 164191
	UF:AddRaidDebuff(true, 156238, 5, true) -- Arcane Wrath

	UF:AddRaidDebuff(true, 157763, 4) 		-- FIXATE
	UF:AddRaidDebuff(true, 158553, 6, true) -- CRUSHARMOR
end

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

-- Hellfire Citadel
UF["raiddebuffs"]["instances"]["Hellfire Citadel"] = function()
	-- Hellfire Assault
	UF:AddRaidDebuff(true, 184369, 5) -- Howling Axe (Target)
	UF:AddRaidDebuff(true, 180079, 5, true) -- Felfire Munitions
	UF:AddRaidDebuff(true, 184238, 5) -- Cower!
	UF:AddRaidDebuff(true, 184243, 5) -- Slam (Tank - stacks)

	-- Iron Reaver
	UF:AddRaidDebuff(true, 179897, 5) -- Blitz
	UF:AddRaidDebuff(true, 185978, 5) -- Firebomb Vulnerability
	UF:AddRaidDebuff(true, 182373, 5) -- Flame Vulnerability
	UF:AddRaidDebuff(true, 182074, 6) -- Immolation
	UF:AddRaidDebuff(true, 182280, 5, true) -- Artillery
	UF:AddRaidDebuff(true, 182001, 5, true) -- Unstable Orb

	-- Kormrok
	UF:AddRaidDebuff(true, 181306, 5) --Explosive Burst
	UF:AddRaidDebuff(true, 181321, 5) --Fel Touch
	UF:AddRaidDebuff(true, 187122, 5, true) -- Primal Energies
	UF:AddRaidDebuff(true, 187819, 5) -- Crush
	UF:AddRaidDebuff(true, 181345, 5) -- Foul Crush

	-- Hellfire High Council
	UF:AddRaidDebuff(true, 184358, 9, true) -- Fel Rage
	UF:AddRaidDebuff(true, 184360, 9, true) -- Fel Rage
	UF:AddRaidDebuff(true, 184449, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 185065, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 184450, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 185066, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 184676, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 184652, 5) -- Reap
	UF:AddRaidDebuff(true, 184355, 8, true) -- Bloodboil
	UF:AddRaidDebuff(true, 190553, 8, true) -- Bloodboil

	-- Kilrogg Deadeye
	UF:AddRaidDebuff(true, 182159, 6, true) --Fel Corruption
	UF:AddRaidDebuff(true, 182428, 6, true) --Fel Corruption
	UF:AddRaidDebuff(true, 184551, 6, true) --Fel Corruption
	UF:AddRaidDebuff(true, 181488, 5) -- Vision of Death
	UF:AddRaidDebuff(true, 188929, 5, true) -- Heart Seeker (Target)
	UF:AddRaidDebuff(true, 180389, 5) -- Heart Seeker (DoT)

	-- Gorefiend
	UF:AddRaidDebuff(true, 179867, 5, true) -- Gorefiend's Corruption
--	UF:AddRaidDebuff(true, 181295, 5) -- Digest
--	UF:AddRaidDebuff(true, 179978, 6, true) -- Touch of Doom
--	UF:AddRaidDebuff(true, 179977, 5, true) -- Touch of Doom
	UF:AddRaidDebuff(true, 179864, 5, true) -- Shadow of Death
	UF:AddRaidDebuff(true, 179909, 8) -- Shared Fate (self root)
	UF:AddRaidDebuff(true, 179908, 8) -- Shared Fate (other players root)

	-- Shadow-Lord Iskar
	UF:AddRaidDebuff(true, 179202, 8, true) --Eye of Anzu
	UF:AddRaidDebuff(true, 181957, 5) -- Phantasmal Winds
	UF:AddRaidDebuff(true, 182323, 5) -- Phantasmal Wounds
	UF:AddRaidDebuff(true, 182325, 5) -- Phantasmal Wounds
	UF:AddRaidDebuff(true, 185239, 5) -- Radiance of Anzu
--	UF:AddRaidDebuff(true, 185510, 5) -- Dark Bindings
	UF:AddRaidDebuff(true, 182600, 8) -- Fel Fire
	UF:AddRaidDebuff(true, 181753, 9, true) -- Fel Bomb

-- Soulbound Construct (Socrethar)
	UF:AddRaidDebuff(true, 189531, 5) -- Soulbane (Trash)
	UF:AddRaidDebuff(true, 182038, 5) -- Shattered Defenses
	UF:AddRaidDebuff(true, 182635, 5) -- Shattered Defences
	UF:AddRaidDebuff(true, 188666, 5) -- Eternal Hunger (Add fixate, Mythic only)
	UF:AddRaidDebuff(true, 180415, 5) -- Fel Prison
	UF:AddRaidDebuff(true, 185185, 5) -- Fel Prison
	UF:AddRaidDebuff(true, 189627, 5, true) -- Volatile Fel Orb fixate
	UF:AddRaidDebuff(true, 184124, 5) -- Gift of the Man'ari (Fel Dominator)
	UF:AddRaidDebuff(true, 184239, 5) -- Shadow Word: Agony (Sargerei Shadowcaller)

-- Tyrant Velhari
	UF:AddRaidDebuff(true, 180166, 6) -- Touch of Harm
	UF:AddRaidDebuff(true, 185237, 5) -- Touch of Harm
	UF:AddRaidDebuff(true, 185238, 5) -- Touch of Harm
	UF:AddRaidDebuff(true, 180128, 6) -- Edict of Condemnation
	UF:AddRaidDebuff(true, 185241, 5) -- Edict of Condemnation
	UF:AddRaidDebuff(true, 180526, 5) -- Font of Corruption

-- Fel Lord Zakuun
	UF:AddRaidDebuff(true, 181653, 5) -- Fel Crystals (Too Close)
	UF:AddRaidDebuff(true, 179428, 5) -- Rumbling Fissure (Soak)
	UF:AddRaidDebuff(true, 179407, 5) -- Disembodied (Player in Shadow Realm)
	UF:AddRaidDebuff(true, 182008, 4, true) -- Latent Energy
	UF:AddRaidDebuff(true, 189030, 9)       -- Befouled
	UF:AddRaidDebuff(true, 181508, 6)       --Seed of Destruction

-- Xhul'horac
	UF:AddRaidDebuff(true, 188208, 7) -- Ablaze
	UF:AddRaidDebuff(true, 186073, 5) -- Felsinged
	UF:AddRaidDebuff(true, 186407, 5) -- Fel Surge
	UF:AddRaidDebuff(true, 186490, 6, true) -- Chains of Fel
	UF:AddRaidDebuff(true, 186500, 5, true) -- Chains of Fel
	UF:AddRaidDebuff(true, 186063, 5) -- Wasting Void
	UF:AddRaidDebuff(true, 186333, 5) -- Void Surge
	UF:AddRaidDebuff(true, 186546, 6) -- Black Hole

-- Mannoroth
	UF:AddRaidDebuff(true, 181275, 5) -- Curse of the Legion
	UF:AddRaidDebuff(true, 181099, 5) -- Mark of Doom
	UF:AddRaidDebuff(true, 181597, 6) -- Mannoroth's Gaze
	UF:AddRaidDebuff(true, 182006, 6) -- Empowered Mannoroth's Gaze
	UF:AddRaidDebuff(true, 181841, 5) -- Shadowforce
	UF:AddRaidDebuff(true, 182088, 5) -- Empowered Shadowforce
	UF:AddRaidDebuff(true, 186362, 5, true) -- Wrath of Guldan
	UF:AddRaidDebuff(true, 186348, 5, true) -- Wrath of Guldan
	UF:AddRaidDebuff(true, 186374, 5, true) -- Wrath of Guldan
    UF:AddRaidDebuff(true, 186350, 4) -- Gripping Shadows

-- Archimonde
	UF:AddRaidDebuff(true, 184964, 5) -- Shackled Torment
--	UF:AddRaidDebuff(true, 186123, 5) -- Wrought Chaos
--	UF:AddRaidDebuff(true, 185014, 5) -- Focused Chaos
	UF:AddRaidDebuff(true, 182879, 5, true) -- Doomfire Fixate
	UF:AddRaidDebuff(true, 183586, 5) -- Doomfire
	UF:AddRaidDebuff(true, 186952, 5) -- Nether Banish
	UF:AddRaidDebuff(true, 189891, 5) -- Nether Tear
	UF:AddRaidDebuff(true, 183634, 5) -- Shadowfel Burst
	UF:AddRaidDebuff(true, 189895, 5, true) -- Void Star Fixate
	UF:AddRaidDebuff(true, 190049, 5) -- Nether Corruption
	UF:AddRaidDebuff(true, 183963, 4, true) -- Light of the Naaru
end

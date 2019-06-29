local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

--Uldir
UF["raiddebuffs"]["instances"]["Uldir"] = function()
	-- enable, spell, priority, secondary, pulse, flash

	-- Taloc
	UF:AddRaidDebuff(true, 270290, 5) -- Blood Storms 
	UF:AddRaidDebuff(true, 271222, 5) -- Plasma Discharge 
	UF:AddRaidDebuff(true, 271296, 5) -- Cudgel of Gore 

	-- MOTHER
	UF:AddRaidDebuff(true, 267787, 5) -- Sanitizing Strike 
	UF:AddRaidDebuff(true, 268198, 5) -- Clinging Corruption 
	UF:AddRaidDebuff(true, 267821, 5) -- Defense Grids 

	-- Fetid Devourer
	UF:AddRaidDebuff(true, 262313, 5) -- Malodorous Miasma 
	UF:AddRaidDebuff(true, 262314, 5) -- Putrid Paroxysm 

	-- Zek'voz, herald of N'zoth
	UF:AddRaidDebuff(true, 265264, 5) -- Void Lash 
	UF:AddRaidDebuff(true, 265646, 5) -- Will of the Corruptor 
	UF:AddRaidDebuff(true, 265360, 5) -- Roiling Deceit 
	UF:AddRaidDebuff(true, 267334, 5) -- Orb of Corruption 
	UF:AddRaidDebuff(true, 265662, 5) -- Corruptor's Pact 
	UF:AddRaidDebuff(true, 265451, 5) -- Surging Darkness 

	-- Vectis
	UF:AddRaidDebuff(true, 265143, 6) -- Omega Vector 
	UF:AddRaidDebuff(true, 265127, 8, true) -- Lingering Infection
	UF:AddRaidDebuff(true, 265178, 5) -- Evolving Affliction 
	UF:AddRaidDebuff(true, 265206, 6) -- Immunosuppression 
	UF:AddRaidDebuff(true, 266948, 5) -- Plague Bomb 
	UF:AddRaidDebuff(true, 265212, 6, nil, nil, true) -- Gestate 

	-- Zul, Reborn
	UF:AddRaidDebuff(true, 274195, 5) -- Corrupted Blood 
	UF:AddRaidDebuff(true, 274358, 5) -- Rupturing Blood 
	UF:AddRaidDebuff(true, 274363, 5) -- Ruptured Blood 
	UF:AddRaidDebuff(true, 273365, 5) -- Dark Revelation 
	UF:AddRaidDebuff(true, 274271, 6) -- Deathwish 

	-- Mythrax the Unraveler
	UF:AddRaidDebuff(true, 272336, 5, true) -- Annihilation (stacks)
	UF:AddRaidDebuff(true, 273282, 6) -- Essence Shear (Tank)
	UF:AddRaidDebuff(true, 272536, 6) -- Imminent Ruin 
	UF:AddRaidDebuff(true, 272407, 6) -- Oblivion Sphere (charmed)

	-- G'huun
	UF:AddRaidDebuff(true, 263372, 5) -- Power Matrices 
	UF:AddRaidDebuff(true, 263503, 5) -- Reorigination Blasts 
	UF:AddRaidDebuff(true, 267409, 5) -- Dark Bargain 
	UF:AddRaidDebuff(true, 270447, 5) -- Growing Corruption 
	UF:AddRaidDebuff(true, 263236, 5) -- Blood Feast 
	UF:AddRaidDebuff(true, 263334, 5) -- Putrid Blood 
	UF:AddRaidDebuff(true, 267700, 5) -- Gaze of G'huun 

end

-- Battle for Dazar'alor
UF["raiddebuffs"]["instances"]["Battle of Dazar'alor"] = function()
	UF:AddRaidDebuff(true, 289384, 5) --Savage Swipe
	UF:AddRaidDebuff(true, 287437, 5) --Frozen Beam
	UF:AddRaidDebuff(true, 287294, 5) --Blizzard
	UF:AddRaidDebuff(true, 286740, 5) --Light's Fury
	UF:AddRaidDebuff(true, 285250, 5) --Sundering Slam
	UF:AddRaidDebuff(true, 289645, 5) --Polymorph
	UF:AddRaidDebuff(true, 289578, 5) --Lit Torch
	UF:AddRaidDebuff(true, 287325, 5) --Comet Storm
	UF:AddRaidDebuff(true, 289772, 5) --Impale
	UF:AddRaidDebuff(true, 285292, 5) --Frozen Tides
	UF:AddRaidDebuff(true, 285280, 5) --Searing Waves
	UF:AddRaidDebuff(true, 287147, 5) --Dread Reaping
	UF:AddRaidDebuff(true, 284573, 5) --Tailwinds
	UF:AddRaidDebuff(true, 253562, 5) --Wildfire
	UF:AddRaidDebuff(true, 289917, 5, true) --Bwonsamdi's Pact
	UF:AddRaidDebuff(true, 289418, 5) --Predator's Gaze
	UF:AddRaidDebuff(true, 287295, 5) --Chilled
	UF:AddRaidDebuff(true, 289937, 5) --Thundering Slam
	UF:AddRaidDebuff(true, 289514, 5) --Molten Ground
	UF:AddRaidDebuff(true, 289512, 5) --Molten Punch
	UF:AddRaidDebuff(true, 289373, 5) --Lacerating Pounce
	UF:AddRaidDebuff(true, 287456, 5) --Frost Nova
	UF:AddRaidDebuff(true, 287556, 5) --Soul Barrage
	UF:AddRaidDebuff(true, 289484, 5) --Burning Bite
	UF:AddRaidDebuff(true, 289918, 5) --Bwonsamdi's Bargain

	-- Champions
	UF:AddRaidDebuff(true, 283617, 5) --Wave of Light
	UF:AddRaidDebuff(true, 283651, 6, nil, nil, true) --Blinding Faith

	-- Grong
	UF:AddRaidDebuff(true, 282010, 5) --Shattered
	UF:AddRaidDebuff(true, 285875, 5) --Rending Bite
	UF:AddRaidDebuff(true, 289307, 5) --Bestial Throw Target
	UF:AddRaidDebuff(true, 283069, 5) --Megatomic Fire
	UF:AddRaidDebuff(true, 289292, 5) --Bestial Throw
	UF:AddRaidDebuff(true, 285998, 5) --Ferocious Roar
	UF:AddRaidDebuff(true, 285671, 5) --Crushed
	UF:AddRaidDebuff(true, 285659, 5) --Apetagonizer Core
	UF:AddRaidDebuff(true, 289412, 5) --Bestial Impact

	-- Jadefire Masters
	UF:AddRaidDebuff(true, 284374, 5) --Magma Trap
	UF:AddRaidDebuff(true, 282037, 5) --Rising Flames
	UF:AddRaidDebuff(true, 286503, 5) --Beam
	UF:AddRaidDebuff(true, 288151, 5) --Tested
	UF:AddRaidDebuff(true, 284089, 5) --Successful Defense
	UF:AddRaidDebuff(true, 285632, 5) --Stalking
	UF:AddRaidDebuff(true, 287747, 5) --Force Orb
	UF:AddRaidDebuff(true, 286988, 7) --Searing Embers
	UF:AddRaidDebuff(true, 284453, 5, true) --Chi-Ji's Song
	UF:AddRaidDebuff(true, 286369, 5, true) --Chi-Ji's Song
	UF:AddRaidDebuff(true, 288051, 5) --Dragon's Breath

	-- Oppulence
	UF:AddRaidDebuff(true, 284556, 8, true) -- Shadow-Touched buff
	UF:AddRaidDebuff(true, 284573, 7, true) -- Tailwinds buff
	UF:AddRaidDebuff(true, 290654, 7, true) -- Soothing Breeze buff
	UF:AddRaidDebuff(true, 284470, 7, nil, true) -- Hex of Lethargy

	-- Conclave
	UF:AddRaidDebuff(true, 282135, 7) -- Crawling Hex
	UF:AddRaidDebuff(true, 282447, 7) -- Kimbul's Wrath
	UF:AddRaidDebuff(true, 282592, 7, true) -- Bleeding Wounds (debuff from Kimbul's Wrath)
	UF:AddRaidDebuff(true, 285878, 7, nil, true) -- Mind Wipe

	-- King
	UF:AddRaidDebuff(true, 285213, 9, true) -- Caress of Death (immune to healing)
	UF:AddRaidDebuff(true, 285195, 5) -- Deathly withering
	UF:AddRaidDebuff(true, 288449, 6) -- Deaths Door
	UF:AddRaidDebuff(true, 286742, 8) -- Necrotic Smash (tank)
	
	-- Mekka'torque
	UF:AddRaidDebuff(true, 286646, 8) -- Gigavolt charge
	UF:AddRaidDebuff(true, 287891, 8) -- Sheep Shrapnel
	UF:AddRaidDebuff(true, 289699, 8, true) -- Electroshock Amplification (tanks)
	UF:AddRaidDebuff(true, 284168, 8, true) -- Shrunk!
	
	-- Stonewall
	UF:AddRaidDebuff(true, 284106, 8) -- Crackling lightning - Sister Katherine
	UF:AddRaidDebuff(true, 284360, 8) -- Sea Storm
	UF:AddRaidDebuff(true, 284405, 8, true) -- Tempting song -  Brother Joseph
	UF:AddRaidDebuff(true, 285350, 8, nil, nil, true) -- Storm's wail - P2
	UF:AddRaidDebuff(true, 284997, 8, true) -- Kelp Wrapped Fists (tank - dispell near add) - P2

	-- Jaina
	UF:AddRaidDebuff(true, 287993, 5, true) --Chilling Touch
	UF:AddRaidDebuff(true, 288394, 5, true) --Warmth
	UF:AddRaidDebuff(true, 285253, 5) --Ice Shard
	UF:AddRaidDebuff(true, 288169, 5) --Howling Winds	
	UF:AddRaidDebuff(true, 287490, 5) --Frozen Solid
	UF:AddRaidDebuff(true, 288297, 5) --Arctic Ground
	UF:AddRaidDebuff(true, 287365, 5) --Searing Pitch
	UF:AddRaidDebuff(true, 287626, 5) --Grasp of Frost
	UF:AddRaidDebuff(true, 289220, 5) --Heart of Frost
	UF:AddRaidDebuff(true, 288212, 5, nil, nil, true) --Broadside
	UF:AddRaidDebuff(true, 285254, 5, nil, nil, true) --Avalanche
	UF:AddRaidDebuff(true, 288374, 5) --Siegebreaker Blast
	UF:AddRaidDebuff(true, 288038, 5) --Marked Target
	UF:AddRaidDebuff(true, 288434, 5) --Hand of Frost
	UF:AddRaidDebuff(true, 287199, 5) --Ring of Ice
end

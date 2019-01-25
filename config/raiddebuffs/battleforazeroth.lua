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
	-- Oppulence
	UF:AddRaidDebuff(true, 284556, 8, true) -- Shadow-Touched buff
	UF:AddRaidDebuff(true, 284573, 7, true) -- Tailwinds buff
	UF:AddRaidDebuff(true, 290654, 7, true) -- Soothing Breeze buff
	UF:AddRaidDebuff(true, 284470, 7, nil, true) -- Hex of Lethargy

	-- Conclave
	UF:AddRaidDebuff(true, 282135, 7) -- Crawling Hex
	UF:AddRaidDebuff(true, 282447, 7, true) -- Kimbul's Wrath
	UF:AddRaidDebuff(true, 285878, 7, nil, true) -- Mind Wipe
end

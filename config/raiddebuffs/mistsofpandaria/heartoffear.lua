local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Heart of Fear

UF["raiddebuffs"]["instances"]["Heart of Fear"] = function()
	-- Imperial Vizier Zor'lok
	UF:AddRaidDebuff(true, 122760, 6) -- Exhale
	UF:AddRaidDebuff(true, 123812, 6) -- Pheromones of Zeal
	UF:AddRaidDebuff(true, 122740, 6) -- Convert
	UF:AddRaidDebuff(true, 122706, 6, true) -- Noise Cancelling

	-- Blade Lord Ta'yak
	UF:AddRaidDebuff(true, 122949, 6) -- Unseen Strike
	UF:AddRaidDebuff(true, 123474, 6) -- Overwhelming Assault
	UF:AddRaidDebuff(true, 124783, 6) -- Storm Unleashed
	UF:AddRaidDebuff(true, 123175, 8, true) -- Wind Step

	-- Garalon
	UF:AddRaidDebuff(true, 123081, 6) -- Pungency
	UF:AddRaidDebuff(true, 123120, 6) -- Pheromone Trail
	UF:AddRaidDebuff(true, 122835, 6, true) -- Pheromones

	-- Wind Lord Mel'jarak
	UF:AddRaidDebuff(true, 121881, 6) -- Amber Prison
	UF:AddRaidDebuff(true, 122055, 6) -- Residue
	UF:AddRaidDebuff(true, 122064, 6) -- Corrosive Resin

	-- Amber-Shaper Un'sok
	UF:AddRaidDebuff(true, 121949, 6) -- Parasitic Growth
	UF:AddRaidDebuff(true, 122784, 6) -- Reshape Life
	UF:AddRaidDebuff(true, 122064, 6) -- Corrosive Resin
	UF:AddRaidDebuff(true, 122504, 6) -- Burning Amber

	-- Grand Empress Shek'zeer
	UF:AddRaidDebuff(true, 123788, 8) -- Cry of Terror
	UF:AddRaidDebuff(true, 123707, 6) -- Eyes of the Empress
	UF:AddRaidDebuff(true, 124097, 6) -- Sticky Resin
	UF:AddRaidDebuff(true, 124777, 6) -- Poison Bomb
	UF:AddRaidDebuff(true, 124862, 6) -- Visions of Demise: Target
	UF:AddRaidDebuff(true, 124863, 4) -- Visions of Demise
	UF:AddRaidDebuff(true, 124849, 3) -- Consuming Terror
	UF:AddRaidDebuff(true, 124821, 6, true) -- Poison-Drenched Armor
	UF:AddRaidDebuff(true, 123184, 6, true) -- Dissonance
	UF:AddRaidDebuff(true, 126122, 6, true) -- Dissonance
	UF:AddRaidDebuff(true, 125390, 8, true) -- Fixate
end

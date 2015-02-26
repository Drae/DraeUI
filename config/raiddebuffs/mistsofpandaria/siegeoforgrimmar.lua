local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Siege of Orgrimmar

-- enable, id, priority, secondaryicon, noicon, nocolour

UF["raiddebuffs"]["instances"]["Siege of Orgrimmar"] = function()
	-- Immerseus
	UF:AddRaidDebuff(true, 143436, 1) -- Corrosive Blast (tanks)
	UF:AddRaidDebuff(true, 143460, 6) -- Sha Pool (Heroic Only)
	UF:AddRaidDebuff(true, 143459, 5, true) -- Sha Residue
	UF:AddRaidDebuff(true, 143524, 4, true) -- Purified Residue
	UF:AddRaidDebuff(true, 143574, 3, true) -- Swelling Corruption (Heroic Only)

	-- Fallen Protectors
	UF:AddRaidDebuff(true, 143239, 4) -- Noxious Poison
	UF:AddRaidDebuff(true, 143023, 3) -- Corrupted Brew (slows)
	UF:AddRaidDebuff(true, 143434, 9) -- Shadow Word:Bane (Dispell)
	UF:AddRaidDebuff(true, 143959, 4) -- Defiled Ground
	UF:AddRaidDebuff(true, 144396, 5) -- Vengeful Strikes
	UF:AddRaidDebuff(true, 147383, 4) -- Debilitation (Heroic Only)
	UF:AddRaidDebuff(true, 144007, 4) -- Residual Burn (Heroic Only)
	UF:AddRaidDebuff(true, 143301, 2) -- Gouge
	UF:AddRaidDebuff(true, 143564, 3) -- Meditative Field
	UF:AddRaidDebuff(true, 143198, 5) -- Garotte
	UF:AddRaidDebuff(true, 144176, 2) -- Lingering Anguish
	UF:AddRaidDebuff(true, 143840, 8, true) -- Mark of Anguish
	UF:AddRaidDebuff(true, 143292, 5, true) -- Fixate
	UF:AddRaidDebuff(true, 144176, 5, true) -- Shadow Weakness

	-- Norushen
	UF:AddRaidDebuff(true, 146124, 2) -- Self Doubt (tanks)
	UF:AddRaidDebuff(true, 144850, 5) -- Test of Reliance (Healing)
	UF:AddRaidDebuff(true, 144851, 5) -- Test of Confidence (Tanking)
	UF:AddRaidDebuff(true, 144849, 5) -- Test of Serenity (DPS)
	UF:AddRaidDebuff(true, 146022, 1, true) -- Purified (0 Corruption)

	-- Sha of Pride
	UF:AddRaidDebuff(true, 144358, 2) -- Wounded Pride (tanks)
	UF:AddRaidDebuff(true, 144843, 3) -- Overcome
	UF:AddRaidDebuff(true, 144351, 6) -- Mark of Arrogance
	UF:AddRaidDebuff(true, 146822, 6) -- Projection
	UF:AddRaidDebuff(true, 146817, 5) -- Aura of Pride
	UF:AddRaidDebuff(true, 144774, 2) -- Reaching Attacks (tanks)
	UF:AddRaidDebuff(true, 144636, 5) -- Corrupted Prison
	UF:AddRaidDebuff(true, 145215, 7) -- Banishment (Heroic)
	UF:AddRaidDebuff(true, 147207, 4) -- Weakened Resolve (Heroic)
	UF:AddRaidDebuff(true, 144574, 6) -- Corrupted Prison
	UF:AddRaidDebuff(true, 144364, 3) -- Power of the Titans
	UF:AddRaidDebuff(true, 146594, 5, true) -- Gift of the Titans

	-- Galakras
	UF:AddRaidDebuff(true, 146902, 2) -- Poison Tipped blades
	UF:AddRaidDebuff(true, 146992, 6, true) -- Flames of Galakrond
	UF:AddRaidDebuff(true, 147029, 6, true) -- Flames of Galakrond (2)?

	-- Iron Juggernaut
	UF:AddRaidDebuff(true, 144467, 2) -- Ignite Armor
	UF:AddRaidDebuff(true, 144459, 5) -- Laser Burn
	UF:AddRaidDebuff(true, 144498, 5) -- Napalm Oil
	UF:AddRaidDebuff(true, 144918, 5) -- Cutter Laser
	UF:AddRaidDebuff(true, 146325, 6, true) -- Cutter Laser Target

	-- Kor'kron Dark Shaman
	UF:AddRaidDebuff(true, 144089, 6) -- Toxic Mist
	UF:AddRaidDebuff(true, 144215, 2) -- Froststorm Strike (Tank only)
	UF:AddRaidDebuff(true, 143990, 2) -- Foul Geyser (Tank only)
	UF:AddRaidDebuff(true, 144304, 2) -- Rend
	UF:AddRaidDebuff(true, 144330, 6, true) -- Iron Prison (Heroic)

	-- General Nazgrim
	UF:AddRaidDebuff(true, 143638, 6) -- Bonecracker
	UF:AddRaidDebuff(true, 143431, 6) -- Magistrike (Dispell)
	UF:AddRaidDebuff(true, 143494, 2) -- Sundering Blow (Tanks)
	UF:AddRaidDebuff(true, 143480, 5, true) -- Assassin's Mark
	UF:AddRaidDebuff(true, 143882, 6, true)  -- Hunter's Mark

	-- Malkorok
	UF:AddRaidDebuff(true, 142990, 7) -- Fatal Strike (Tank debuff)
	UF:AddRaidDebuff(true, 142913, 6) -- Displaced Energy (Dispell)
	UF:AddRaidDebuff(true, 143919, 5) -- Languish (Heroic)
	UF:AddRaidDebuff(true, 142863, 6, true) -- Shield - Red
	UF:AddRaidDebuff(true, 142864, 6, true) -- Shield - Orange
	UF:AddRaidDebuff(true, 142865, 6, true) -- Shield - Green

	-- Spoils of Pandaria
	UF:AddRaidDebuff(true, 145685, 2) -- Unstable Defensive System
	UF:AddRaidDebuff(true, 144853, 3) -- Carnivorous Bite
	UF:AddRaidDebuff(true, 145218, 4) -- Harden Flesh
	UF:AddRaidDebuff(true, 145230, 1) -- Forbidden Magic
	UF:AddRaidDebuff(true, 146217, 4) -- Keg Toss
	UF:AddRaidDebuff(true, 146235, 4) -- Breath of Fire
	UF:AddRaidDebuff(true, 145523, 4) -- Animated Strike
	UF:AddRaidDebuff(true, 142983, 6) -- Torment (the new Wrack)
	UF:AddRaidDebuff(true, 145715, 3) -- Blazing Charge
	UF:AddRaidDebuff(true, 145747, 5) -- Bubbling Amber
	UF:AddRaidDebuff(true, 146289, 4) -- Mass Paralysis
	UF:AddRaidDebuff(true, 145987, 5, true) -- Set to Blow

	-- Thok the Bloodthirsty
	UF:AddRaidDebuff(true, 143766, 2) -- Panic (tanks)
	UF:AddRaidDebuff(true, 143773, 2) -- Freezing Breath (tanks)
	UF:AddRaidDebuff(true, 143452, 1) -- Bloodied
	UF:AddRaidDebuff(true, 146589, 5) -- Skeleton Key (tanks)
	UF:AddRaidDebuff(true, 143791, 5) -- Corrosive Blood
	UF:AddRaidDebuff(true, 143777, 8) -- Frozen Solid (tanks)
	UF:AddRaidDebuff(true, 143780, 4) -- Acid Breath
	UF:AddRaidDebuff(true, 143800, 5) -- Icy Blood
	UF:AddRaidDebuff(true, 143428, 4) -- Tail Lash
	UF:AddRaidDebuff(true, 143445, 6, true) -- Fixate

	-- Siegecrafter Blackfuse
	UF:AddRaidDebuff(true, 144236, 4) -- Pattern Recognition
	UF:AddRaidDebuff(true, 144466, 5) -- Magnetic Crush
	UF:AddRaidDebuff(true, 143856, 6) -- Superheated
	UF:AddRaidDebuff(true, 143385, 8) -- Electrostatic Charge (tank)
	UF:AddRaidDebuff(true, 143828, 6, true) -- Locked On

	-- Paragons of the Klaxxi
	UF:AddRaidDebuff(true, 143617, 5) -- Blue Bomb
	UF:AddRaidDebuff(true, 143701, 5) -- Whirling (stun)
	UF:AddRaidDebuff(true, 142808, 6) -- Fiery Edge
	UF:AddRaidDebuff(true, 143610, 5) -- Red Drum
	UF:AddRaidDebuff(true, 142931, 2) -- Exposed Veins
	UF:AddRaidDebuff(true, 143735, 6) -- Caustic Amber
	UF:AddRaidDebuff(true, 146452, 5) -- Resonating Amber
	UF:AddRaidDebuff(true, 142929, 2) -- Tenderizing Strikes
	UF:AddRaidDebuff(true, 142797, 5) -- Noxious Vapors
	UF:AddRaidDebuff(true, 143939, 5) -- Gouge
	UF:AddRaidDebuff(true, 143275, 2) -- Hewn
	UF:AddRaidDebuff(true, 143768, 2) -- Sonic Projection
	UF:AddRaidDebuff(true, 143279, 2) -- Genetic Alteration
	UF:AddRaidDebuff(true, 143339, 6) -- Injection
	UF:AddRaidDebuff(true, 142649, 4) -- Devour
	UF:AddRaidDebuff(true, 146556, 6) -- Pierce
	UF:AddRaidDebuff(true, 143979, 2) -- Vicious Assault
	UF:AddRaidDebuff(true, 143607, 5) -- Blue Sword
	UF:AddRaidDebuff(true, 143614, 5) -- Yellow Drum
	UF:AddRaidDebuff(true, 143612, 5) -- Blue Drum
	UF:AddRaidDebuff(true, 143615, 5) -- Red Bomb
	UF:AddRaidDebuff(true, 143974, 2) -- Shield Bash
	UF:AddRaidDebuff(true, 143373, 5) -- Gene Splice (Mutate: Amber Scorpion)
	UF:AddRaidDebuff(true, 148589, 6) -- Faulty Mutation (Heroic)
	UF:AddRaidDebuff(true, 142533, 6, true) -- Toxin: Red
	UF:AddRaidDebuff(true, 142532, 6, true) -- Toxin: Blue
	UF:AddRaidDebuff(true, 142534, 6, true) -- Toxin: Yellow
	UF:AddRaidDebuff(true, 142671, 8, true) -- Mesmerize

	-- Garrosh Hellscream
	UF:AddRaidDebuff(true, 147554, 5) -- Blood of Y'Shaarj (Trash)
	UF:AddRaidDebuff(true, 144582, 4) -- Hamstring
	UF:AddRaidDebuff(true, 145183, 2) -- Gripping Despair (tanks)
	UF:AddRaidDebuff(true, 145195, 5) -- Empowere Gripping Despair
	UF:AddRaidDebuff(true, 144762, 4) -- Desecrated
	UF:AddRaidDebuff(true, 145071, 5) -- Touch of Y'Sharrj
	UF:AddRaidDebuff(true, 148718, 4) -- Fire Pit
	UF:AddRaidDebuff(true, 148994, 6, true) -- Faith (Intermission dmg reduc)
	UF:AddRaidDebuff(true, 147209, 7, true) -- Malice (Heroic)
	UF:AddRaidDebuff(true, 147235, 5) -- Malicious Blast (heroic - Malice)
end

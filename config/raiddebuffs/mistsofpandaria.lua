local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Mogu'shan Vaults
UF["raiddebuffs"]["instances"]["Mogu'shan Vaults"] = function()
	-- enable, spell, priority, secondary, pulse, flash

	-- Stone Guard
	UF:AddRaidDebuff(true, 130395, 6) -- Jasper Chains: Stacks
	UF:AddRaidDebuff(true, 130404, 3) -- Jasper Chains [NOTE: This is what was causing dmg in the logs]
	UF:AddRaidDebuff(true, 130774, 6) -- Amethyst Pool
	UF:AddRaidDebuff(true, 116281, 3) -- Cobalt Mine Blast (dispellable)
	UF:AddRaidDebuff(true, 125206, 6, true) -- Rend Flesh: Tank only

	-- Feng The Accursed
	UF:AddRaidDebuff(true, 131788, 6) -- Lightning Lash
	UF:AddRaidDebuff(true, 116040, 3) -- Epicenter
	UF:AddRaidDebuff(true, 116942, 6) -- Flaming Spear
	UF:AddRaidDebuff(true, 116784, 3) -- Wildfire Spark
	UF:AddRaidDebuff(true, 131790, 6) -- Arcane Shock: Stack
	UF:AddRaidDebuff(true, 102464, 3) -- Arcane Shock: AOE
	UF:AddRaidDebuff(true, 116417, 4) -- Arcane Resonance
	UF:AddRaidDebuff(true, 116364, 6) -- Arcane Velocity
	UF:AddRaidDebuff(true, 116374, 3) -- Lightning Charge: Stun effect
	UF:AddRaidDebuff(true, 131792, 6, true) -- Shadowburn: Tank only: Stacks: HEROIC ONLY

	-- Gara'jal the Spiritbinder
	UF:AddRaidDebuff(true, 117723, 3) -- Frail Soul: HEROIC ONLY
	UF:AddRaidDebuff(true, 122151, 3, true) -- Voodoo Doll
	UF:AddRaidDebuff(true, 116260, 6, true) -- Crossed Over [NOTE: Putting this incase events fire between both realms]

	-- The Spirit Kings
	UF:AddRaidDebuff(true, 118047, 3) -- Pillage
	UF:AddRaidDebuff(true, 118135, 8) -- Pinned Down
	UF:AddRaidDebuff(true, 118047, 3) -- Pillage: Target
	UF:AddRaidDebuff(true, 118163, 3) -- Robbed Blind
	UF:AddRaidDebuff(true, 118303, 3, true) -- Undying Shadows:Fixate

	-- Elegon
	UF:AddRaidDebuff(true, 117949, 7) -- Closed circuit (dispellable)
	UF:AddRaidDebuff(true, 117945, 3) -- Arcing Energy
	UF:AddRaidDebuff(true, 117878, 6, true) -- Overcharged

	-- Will of the Emperor
	UF:AddRaidDebuff(true, 116525, 3) -- Focused Assault
	UF:AddRaidDebuff(true, 116778, 3) -- Focused Defense
	UF:AddRaidDebuff(true, 117485, 6) -- Impeding Thrust
	UF:AddRaidDebuff(true, 116550, 4) -- Energizing Smash
	UF:AddRaidDebuff(true, 116829, 3) -- Focused Energy
end

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

-- Terrace of Endless Spring
UF["raiddebuffs"]["instances"]["Terrace of Endless Spring"] = function()
	-- Protector Kaolan
	UF:AddRaidDebuff(true, 117519, 7, true) -- Touch of Sha
	UF:AddRaidDebuff(true, 111850, 3) -- Lightning Prison: Targeted
	UF:AddRaidDebuff(true, 117436, 3) -- Lightning Prison: Stunned
	UF:AddRaidDebuff(true, 118191, 6, true) -- Corrupted Essence
	UF:AddRaidDebuff(true, 117986, 6) -- Defiled Ground: Stacks
	UF:AddRaidDebuff(true, 117353, 7, true) -- Overwhelming corruption

	-- Tsulong
	UF:AddRaidDebuff(true, 122768, 3) -- Dread Shadows
	UF:AddRaidDebuff(true, 122777, 5) -- Nightmares (dispellable)
	UF:AddRaidDebuff(true, 122752, 6) -- Shadow Breath
	UF:AddRaidDebuff(true, 122789, 6) -- Sunbeam
	UF:AddRaidDebuff(true, 123012, 8, true) -- Terrorize: 5% (dispellable)
	UF:AddRaidDebuff(true, 123011, 8, true) -- Terrorize: 10% (dispellable)
	UF:AddRaidDebuff(true, 122858, 6) -- Bathed in Light

	-- Lei Shi
	UF:AddRaidDebuff(true, 123121, 4) -- Spray
	UF:AddRaidDebuff(true, 123705, 3, true) -- Scary Fog

	-- Sha of Fear
	UF:AddRaidDebuff(true, 119414, 6) -- Breath of Fear
	UF:AddRaidDebuff(true, 129147, 3, true) -- Onimous Cackle
	UF:AddRaidDebuff(true, 119983, 4) -- Dread Spray
	UF:AddRaidDebuff(true, 120669, 3) -- Naked and Afraid
	UF:AddRaidDebuff(true, 75683, 6) -- Waterspout
	UF:AddRaidDebuff(true, 120629, 7, true) -- Huddle in Terror
	UF:AddRaidDebuff(true, 132608, 7, true) -- Huddle in Terror
	UF:AddRaidDebuff(true, 120394, 6) -- Eternal Darkness
	UF:AddRaidDebuff(true, 119086, 4) -- Penetrating Bolt
	UF:AddRaidDebuff(true, 120268, 6, true) -- Champion of the Light
end

-- Throne of Thunder
UF["raiddebuffs"]["instances"]["Throne of Thunder"] = function()
	-- Jin'rokh the Breaker
	UF:AddRaidDebuff(true, 137399, 6) -- Focused Lightning fixate
	UF:AddRaidDebuff(true, 138732, 5) -- Ionization
	UF:AddRaidDebuff(true, 138349, 2) -- Static Wound (tank only)
	UF:AddRaidDebuff(true, 137371, 2) -- Thundering Throw (tank only)
	UF:AddRaidDebuff(true, 138006, 4, true) -- Electrified Waters
	UF:AddRaidDebuff(true, 138002, 4, true) -- Fluidity

	--Horridon
	UF:AddRaidDebuff(true, 136769, 6) -- Charge
	UF:AddRaidDebuff(true, 136708, 3) -- Stone Gaze
	UF:AddRaidDebuff(true, 136723, 5) -- Sand Trap
	UF:AddRaidDebuff(true, 136587, 5) -- Venom Bolt Volley (dispellable)
	UF:AddRaidDebuff(true, 136710, 5) -- Deadly Plague (disease)
	UF:AddRaidDebuff(true, 136670, 4) -- Mortal Strike
	UF:AddRaidDebuff(true, 136573, 6) -- Frozen Bolt (Debuff used by frozen orb)
	UF:AddRaidDebuff(true, 136512, 5) -- Hex of Confusion
	UF:AddRaidDebuff(true, 136719, 6) -- Blazing Sunlight
	UF:AddRaidDebuff(true, 136654, 4) -- Rending Charge
	UF:AddRaidDebuff(true, 136767, 6, true) -- Triple Puncture (tanks only)
	UF:AddRaidDebuff(true, 140946, 4, true) -- Dire Fixation (Heroic Only)

	--Council of Elders
	UF:AddRaidDebuff(true, 137084, 3) -- Body Heat
	UF:AddRaidDebuff(true, 137641, 6) -- Soul Fragment (Heroic only)
	UF:AddRaidDebuff(true, 136878, 5) -- Ensnared
	UF:AddRaidDebuff(true, 136857, 6) -- Entrapped (Dispell)
	UF:AddRaidDebuff(true, 137650, 5) -- Shadowed Soul
	UF:AddRaidDebuff(true, 137972, 6) -- Twisted Fate (Heroic only)
	UF:AddRaidDebuff(true, 136860, 5) -- Quicksand
	UF:AddRaidDebuff(true, 137359, 6, true) -- Shadowed Loa Spirit fixate target
	UF:AddRaidDebuff(true, 136922, 6, true) -- Frostbite

	--Tortos
	UF:AddRaidDebuff(true, 134030, 6) -- Kick Shell
	UF:AddRaidDebuff(true, 134920, 6) -- Quake Stomp
	UF:AddRaidDebuff(true, 136751, 6) -- Sonic Screech
	UF:AddRaidDebuff(true, 136753, 2) -- Slashing Talons (tank only)
	UF:AddRaidDebuff(true, 137633, 5, true) -- Crystal Shell (heroic only)
	UF:AddRaidDebuff(true, 140701, 8, true) -- Crystal Shell: Full Capacity! (heroic only)

	--Megaera
	UF:AddRaidDebuff(true, 139822, 6) -- Cinder (Dispell)
	UF:AddRaidDebuff(true, 134396, 6) -- Consuming Flames (Dispell)
	UF:AddRaidDebuff(true, 137731, 5) -- Ignite Flesh
	UF:AddRaidDebuff(true, 136892, 6) -- Frozen Solid
	UF:AddRaidDebuff(true, 139909, 5) -- Icy Ground
	UF:AddRaidDebuff(true, 137746, 6) -- Consuming Magic
	UF:AddRaidDebuff(true, 139843, 4) -- Artic Freeze
	UF:AddRaidDebuff(true, 139840, 4) -- Rot Armor
	UF:AddRaidDebuff(true, 140179, 6) -- Suppression (stun)

	--Ji-Kun
	UF:AddRaidDebuff(true, 138309, 4) -- Slimed
	UF:AddRaidDebuff(true, 138319, 5) -- Feed Pool
	UF:AddRaidDebuff(true, 140571, 3) -- Feed Pool
	UF:AddRaidDebuff(true, 134372, 3) -- Screech
	UF:AddRaidDebuff(true, 139168, 9, true) -- Gentle, Yet Firm (Golden Egg)

	--Durumu the Forgotten
	UF:AddRaidDebuff(true, 133767, 2) -- Serious Wound (Tank only)
	UF:AddRaidDebuff(true, 136932, 6) -- Force of Will
	UF:AddRaidDebuff(true, 133795, 4) -- Life Drain
	UF:AddRaidDebuff(true, 133732, 5) -- Infrared Light (the stacking red debuff)
	UF:AddRaidDebuff(true, 133677, 5) -- Blue Rays (the stacking blue debuff)
	UF:AddRaidDebuff(true, 133738, 5) -- Bright Light (the stacking yellow debuff)
	UF:AddRaidDebuff(true, 133737, 6) -- Bright Light (The one that says you are actually in a beam)
	UF:AddRaidDebuff(true, 133675, 6) -- Blue Rays (The one that says you are actually in a beam)
	UF:AddRaidDebuff(true, 134626, 6) -- Lingering Gaze
	UF:AddRaidDebuff(true, 133597, 8, true) -- Dark Parasite
	UF:AddRaidDebuff(true, 133768, 8, true) -- Arterial Cut (tank only)

	--Primordius
	UF:AddRaidDebuff(true, 140546, 6) -- Fully Mutated
	UF:AddRaidDebuff(true, 136181, 4) -- Impared Eyesight (Harmful)
	UF:AddRaidDebuff(true, 136183, 4) -- Dulled Synapses (Harmful)
	UF:AddRaidDebuff(true, 136185, 4) -- Fragile Bones (Harmful)
	UF:AddRaidDebuff(true, 136187, 4) -- Clouded Mind (Harmful)
	UF:AddRaidDebuff(true, 136050, 2) -- Malformed Blood(Tank Only)
	UF:AddRaidDebuff(true, 136184, 3, true) -- Thick Bones (Helpful)
	UF:AddRaidDebuff(true, 136186, 3, true) -- Clear Mind (Helpful)
	UF:AddRaidDebuff(true, 136182, 3, true) -- Improved Synapses (Helpful)
	UF:AddRaidDebuff(true, 136180, 3, true) -- Keen Eyesight (Helpful)

	--Dark Animus
	UF:AddRaidDebuff(true, 138659, 6) -- Touch of the Animus
	UF:AddRaidDebuff(true, 138609, 8) -- Matter Swap
	UF:AddRaidDebuff(true, 138691, 4) -- Anima Font
	UF:AddRaidDebuff(true, 136962, 5) -- Anima Ring
	UF:AddRaidDebuff(true, 138480, 6) -- Crimson Wake Fixate
	UF:AddRaidDebuff(true, 138569, 2, true) -- Explosive Slam (tank only)

	--Iron Qon
	UF:AddRaidDebuff(true, 136193, 6) -- Arcing Lightning
	UF:AddRaidDebuff(true, 135147, 2) -- Dead Zone
	UF:AddRaidDebuff(true, 135145, 6) -- Freeze
	UF:AddRaidDebuff(true, 136520, 5) -- Frozen Blood
	UF:AddRaidDebuff(true, 137669, 3) -- Storm Cloud
	UF:AddRaidDebuff(true, 137668, 5) -- Burning Cinders
	UF:AddRaidDebuff(true, 137654, 5) -- Rushing Winds
	UF:AddRaidDebuff(true, 136577, 4) -- Wind Storm
	UF:AddRaidDebuff(true, 136192, 4) -- Lightning Storm
	UF:AddRaidDebuff(true, 134647, 5, true) -- Scorched
	UF:AddRaidDebuff(true, 134691, 5, true) -- Impale (tank only)

	--Twin Consorts
	UF:AddRaidDebuff(true, 137440, 6) -- Icy Shadows
	UF:AddRaidDebuff(true, 137417, 6) -- Flames of Passion
	UF:AddRaidDebuff(true, 138306, 5) -- Serpent's Vitality
	UF:AddRaidDebuff(true, 137408, 2) -- Fan of Flames (tank only)
	UF:AddRaidDebuff(true, 137360, 6) -- Corrupted Healing (tanks and healers only?)
	UF:AddRaidDebuff(true, 136722, 6) -- Slumber Spores
	UF:AddRaidDebuff(true, 137375, 3, true) -- Beast of Nightmares

	--Lei Shen
	UF:AddRaidDebuff(true, 135695, 6) -- Static Shock
	UF:AddRaidDebuff(true, 136295, 6) -- Overcharged
	UF:AddRaidDebuff(true, 136543, 6) -- Ball Lightning
	UF:AddRaidDebuff(true, 134821, 6) -- Discharged Energy
	UF:AddRaidDebuff(true, 136326, 6) -- Overcharge
	UF:AddRaidDebuff(true, 137176, 6) -- Overloaded Circuits
	UF:AddRaidDebuff(true, 136853, 6) -- Lightning Bolt
	UF:AddRaidDebuff(true, 135153, 6) -- Crashing Thunder
	UF:AddRaidDebuff(true, 136914, 2) -- Electrical Shock
	UF:AddRaidDebuff(true, 135001, 2) -- Maim
	UF:AddRaidDebuff(true, 135000, 2, true) -- Decapitate (Tank only)

	-- Ra den
	UF:AddRaidDebuff(true, 138308, 6) -- Unstable Vita
	UF:AddRaidDebuff(true, 138372, 5, true) -- Vita Sensitivity
end

-- Siege of Orgrimmar
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
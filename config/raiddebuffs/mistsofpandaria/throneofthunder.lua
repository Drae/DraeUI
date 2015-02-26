local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

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

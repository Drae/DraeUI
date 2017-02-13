local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Emerald Nightmare
local zoneid = 1094
UF["raiddebuffs"]["instances"]["The Emerald Nightmare"] = function()

	-- Nythendra
	UF:AddRaidDebuff(true, 221028, 2) -- Unstable Decay (Trash)
	UF:AddRaidDebuff(true, 204504, 2) -- Infested
	UF:AddRaidDebuff(true, 203045, 5) -- Infested Ground (standing in pool)
	UF:AddRaidDebuff(true, 203096, 6) -- Rot (AoE people around you)
	UF:AddRaidDebuff(true, 204463, 6) -- Volatile Rot (exploding tank)
	UF:AddRaidDebuff(true, 203646, 5) -- Burst of Corruption

	-- Ursoc
	UF:AddRaidDebuff(true, 197943, 7) -- Overwhelm (tank debuff, stacks)
	UF:AddRaidDebuff(true, 198006, 7) -- Focused Gaze (fixate)
	UF:AddRaidDebuff(true, 198108, 1, true) -- Momentum (debuff)
	UF:AddRaidDebuff(true, 197980, 2) -- Nightmarish Cacophony (fear)
	UF:AddRaidDebuff(true, 205611, 4) -- Miasma (standing in)

	-- Dragons of Nightmare
	UF:AddRaidDebuff(true, 203110, 3) -- Slumbering Nightmare (stun)
	UF:AddRaidDebuff(true, 203102, 2) -- Mark of Ysondre (dot, stacks)
	UF:AddRaidDebuff(true, 207681, 4, true) -- Nightmare Bloom (standing in)
	UF:AddRaidDebuff(true, 204731, 1) -- Wasting Dread (debuff)
	UF:AddRaidDebuff(true, 203770, 9, nil, true) -- Defiled Vines (root, magic)
	UF:AddRaidDebuff(true, 203125, 2) -- Mark of Emeriss (dot, stacks)
	UF:AddRaidDebuff(true, 203787, 5) -- Volatile Infection (AoE dot)
	UF:AddRaidDebuff(true, 203086, 2) -- Mark of Lethon (dot, stacks)
	UF:AddRaidDebuff(true, 204044, 4) -- Shadow Burst (dot, stacks)
	UF:AddRaidDebuff(true, 203121, 2) -- Mark of Taerar (dot, stacks)
	UF:AddRaidDebuff(true, 205341, 6) -- Seeping Fog (dot, sleep, magic)
	UF:AddRaidDebuff(false, 204078, 2) -- Bellowing Roar (fear)
	UF:AddRaidDebuff(true, 214543, 1) -- Collapsing Nightmare (debuff)

	-- Elerethe Renferal
	UF:AddRaidDebuff(true, 215307, 6, true) -- Web of Pain (link)
	UF:AddRaidDebuff(true, 215460, 5) -- Necrotic Venom (dot, drops pools)
	UF:AddRaidDebuff(true, 213124, 4) -- Venomous Pool (standing in pool)
	UF:AddRaidDebuff(true, 210850, 3) -- Twisting Shadows (dot)
	UF:AddRaidDebuff(true, 215582, 3) -- Raking Talons (tank debuff, stacks)
	UF:AddRaidDebuff(true, 218519, 1) -- Wind Burn (debuff, stacks)
	UF:AddRaidDebuff(true, 210228, 2) -- Venomous Spiderling - Dripping Fangs (dot, stacks)

	-- Ily'gnoth
	UF:AddRaidDebuff(true, 212886, 4) -- Nightmare Corruption (standing in pool)
	UF:AddRaidDebuff(true, 215845, 1) -- Dispersed Spores (dot)
	UF:AddRaidDebuff(true, 210099, 7, true) -- Fixate (fixate)
	UF:AddRaidDebuff(true, 209469, 8) -- (dot, stacks, magic)
	UF:AddRaidDebuff(true, 209471, 1) -- Nightmare Explosion (dot, stacks)
	UF:AddRaidDebuff(true, 210984, 3) -- Eye of Fate (tank debuff, stacks)
	UF:AddRaidDebuff(true, 208697, 2) -- Mind Flay (dot)
	UF:AddRaidDebuff(true, 208929, 6) -- Spew Corruption (dot, drops pools)
	UF:AddRaidDebuff(true, 215128, 5) -- Cursed Blood (dot, weak bomb)

	-- Cenarius
	UF:AddRaidDebuff(true, 210279, 2, true) -- Creeping Nightmares (debuff, stacks)
	UF:AddRaidDebuff(true, 210315, 8, nil, true) -- Nightmare Brambles (dot, root, magic)
	UF:AddRaidDebuff(true, 213162, 5) -- Nightmare Blast (tank debuff, stacks)
	UF:AddRaidDebuff(false, 226821, 4) -- Desiccating Stomp (melee debuff, stacks)
	UF:AddRaidDebuff(true, 211507, 6) -- Nightmare Javelin (dot, magic)
	UF:AddRaidDebuff(false, 211471, 5) -- Scorned Touch (dot, spreads)
	UF:AddRaidDebuff(false, 211989, 5) -- Unbound Touch (buff, spreads)
	UF:AddRaidDebuff(true, 214529, 5) -- Spear of Nightmares (tank debuff, stacks)

	-- Xavius
	UF:AddRaidDebuff(true, 206005, 1, true) -- Dream Simulacrum (buff)
	UF:AddRaidDebuff(true, 207409, 6) -- Madness (mind control)
	UF:AddRaidDebuff(true, 206651, 8) -- Darkening Soul (dot, magic)
	UF:AddRaidDebuff(true, 211802, 7, nil, true) -- Nightmare Blades (fixate)
	UF:AddRaidDebuff(true, 205771, 9, nil, true) -- Tormenting Fixation (fixate)
	UF:AddRaidDebuff(true, 209158, 8) -- Blackening Soul (dot, magic)
	UF:AddRaidDebuff(true, 205612, 2) -- Blackened? (debuff)
	UF:AddRaidDebuff(true, 210451, 6) -- Bonds of Terror (link)
	UF:AddRaidDebuff(true, 208385, 4) -- Tainted Discharge (standing in)
	UF:AddRaidDebuff(true, 211634, 4) -- The Infinite Dark (standing in?)

end

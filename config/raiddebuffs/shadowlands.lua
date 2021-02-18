
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Highmaul
UF["raiddebuffs"]["instances"]["Castle Nathria"] = function()
	-- enable, spell, priority, secondary, pulse, flash

	-- Shriekwing
	UF:AddRaidDebuff(true, 328897, 6) -- Exsanguinated
	UF:AddRaidDebuff(true, 340324, 6) -- Sanguine Ichor
	UF:AddRaidDebuff(true, 342077, 6) -- Scent of Blood

	-- Huntsman Altimor
	UF:AddRaidDebuff(true, 335304, 6, true) -- Sinseeker
	UF:AddRaidDebuff(true, 334852, 6) -- Petrifying Howl
	UF:AddRaidDebuff(true, 334971, 6) -- Jagged Claws
	UF:AddRaidDebuff(true, 335113, 6) -- Huntsman's Mark
	UF:AddRaidDebuff(true, 334893, 6) -- Stone Shards
	UF:AddRaidDebuff(true, 334708, 6) -- Deathly Roar
	UF:AddRaidDebuff(true, 334945, 6) -- Vicious Lunge
	UF:AddRaidDebuff(true, 334960, 6) -- Vicious Wound

	-- Sun King's Salvation Satiated
	UF:AddRaidDebuff(true, 339251, 6) -- Drained Soul
	UF:AddRaidDebuff(true, 325442, 6) -- Vanquished
	UF:AddRaidDebuff(true, 326456, 6) -- Burning Remnants
	UF:AddRaidDebuff(true, 326430, 6) -- Lingering Embers
	UF:AddRaidDebuff(true, 341475, 6) -- Crimson Flurry
	UF:AddRaidDebuff(true, 328479, 6) -- Eyes on Target
	UF:AddRaidDebuff(true, 341473, 6) -- Crimson Flurry
	UF:AddRaidDebuff(true, 328579, 6) -- Smoldering Remnants
	UF:AddRaidDebuff(true, 333002, 6) -- Vulgar Brand
	UF:AddRaidDebuff(true, 328889, 6) -- Greater Castigation

	-- Artificer Xy'mox
	UF:AddRaidDebuff(true, 340533, 6) -- Arcane Vulnerability
	UF:AddRaidDebuff(true, 340870, 6) -- Aura of Dread
	UF:AddRaidDebuff(true, 340860, 6) -- Withering Touch
	UF:AddRaidDebuff(true, 325236, 6) -- Glyph of Destruction
	UF:AddRaidDebuff(true, 328468, 6) -- Dimensional Tear
	UF:AddRaidDebuff(true, 327902, 6, true) -- Fixate

	-- Hungering Destroyer
	UF:AddRaidDebuff(true, 329298, 6, true) -- Gluttonous Miasma
	UF:AddRaidDebuff(true, 334228, 6) -- Volatile Ejection

	-- Lady Inerva Darkvein
	UF:AddRaidDebuff(true, 331573, 6) -- Unconscionable Guilt
	UF:AddRaidDebuff(true, 340477, 6) -- Concentrate Anima
	UF:AddRaidDebuff(true, 324982, 6) -- Shared Suffering
	UF:AddRaidDebuff(true, 325713, 6) -- Lingering Anima
	UF:AddRaidDebuff(true, 341746, 9, true)  --

	-- The Council of Blood
	UF:AddRaidDebuff(true, 327610, 6) -- Evasive Lunge
	--GridStatusRaidDebuff:DebuffId(zoneid, 334909, 702, 5, 5, nil, true) -- Oppressive Atmosphere
	UF:AddRaidDebuff(true, 346690, 6) -- Duelist's Riposte
	UF:AddRaidDebuff(true, 331636, 6) -- Dark Recital
	UF:AddRaidDebuff(true, 346651, 6) -- Drain Essence
	UF:AddRaidDebuff(true, 330848, 6) -- Wrong Moves
	UF:AddRaidDebuff(true, 327619, 6) -- Waltz of Blood

	-- Sludgefist
	UF:AddRaidDebuff(true, 332443, 6) -- Crumbling Foundation
	UF:AddRaidDebuff(true, 335293, 6, true) -- Chain Link
	UF:AddRaidDebuff(true, 342419, 6) -- Chain Them!
	UF:AddRaidDebuff(true, 335361, 6) -- Stonequake
	UF:AddRaidDebuff(true, 331209, 6) -- Hateful Gaze
	UF:AddRaidDebuff(true, 332572, 6) -- Falling Rubble
	UF:AddRaidDebuff(true, 335295, 6) -- Shattering Chain

	-- Stone Legion Generals
	UF:AddRaidDebuff(true, 333913, 6) -- Wicked Laceration
	--GridStatusRaidDebuff:DebuffId(zoneid, 342425, 902, 6, 6, nil, true) -- Stone Fist
	--GridStatusRaidDebuff:DebuffId(zoneid, 344655, 903, 6, 6, true) -- Reverberating Vulnerability
	--GridStatusRaidDebuff:DebuffId(zoneid, 343881, 904, 6, 6, nil, true) -- Serrated Tear
	--GridStatusRaidDebuff:DebuffId(zoneid, 343063, 905, 6, 6, true) -- Stone Spike
	--GridStatusRaidDebuff:DebuffId(zoneid, 334771, 906, 6, 6, true) -- Heart Hemorrhage
	UF:AddRaidDebuff(true, 333377, 6) -- Wicked Mark
	--GridStatusRaidDebuff:DebuffId(zoneid, 334765, 908, 6, 6, true) -- Heart Rend
	UF:AddRaidDebuff(true, 344502, 6) -- Unstable Footing
	UF:AddRaidDebuff(true, 332406, 5) -- Anima Infusion
	--GridStatusRaidDebuff:DebuffId(zoneid, 339690, 911, 6, 6, true) -- Crystalize
	--GridStatusRaidDebuff:DebuffId(zoneid, 343895, 912, 6, 6, nil, true) -- Soultaint
	--GridStatusRaidDebuff:DebuffId(zoneid, 339693, 913, 5, 5, true) -- Crystalline Burst
	UF:AddRaidDebuff(true, 334498, 6) -- Seismic Upheaval
	UF:AddRaidDebuff(true, 342735, 6) -- Ravenous Feast

	-- Sire Denathrius
	UF:AddRaidDebuff(true, 329181, 6) -- Wracking Pain
	UF:AddRaidDebuff(true, 329906, 6) -- Carnage
	--GridStatusRaidDebuff:DebuffId(zoneid, 326699, 1003, 6, 6, nil, true) -- Burden of Sin
	--GridStatusRaidDebuff:DebuffId(zoneid, 332585, 1004, 6, 6, nil, true) -- Scorn
	UF:AddRaidDebuff(true, 329785, 6) -- Crimson Chorus
	--GridStatusRaidDebuff:DebuffId(zoneid, 332797, 1006, 6, 6, true) -- Fatal Finesse
	UF:AddRaidDebuff(true, 329951, 6) -- Impale
	UF:AddRaidDebuff(true, 327796, 6) -- Night Hunter
	UF:AddRaidDebuff(true, 332619, 6) -- Shattering Pain
	UF:AddRaidDebuff(true, 335873, 6) -- Rancor
	UF:AddRaidDebuff(true, 327842, 6) -- Touch of the Night
	--GridStatusRaidDebuff:DebuffId(zoneid, 326851, 1012, 6, 6, true) -- Blood Price
	UF:AddRaidDebuff(true, 328276, 5) -- March of the Penitent
	UF:AddRaidDebuff(true, 327992, 6) -- Desolation
end

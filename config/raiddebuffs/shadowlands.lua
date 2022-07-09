
local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

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

-- Sepulcher
UF["raiddebuffs"]["instances"]["Sepulcher of the First Ones"] = function()
	-- enable, spell, priority, secondary, pulse, flash

	-- Vigilant Guardian
	UF:AddRaidDebuff(true, 360458, 7, true) -- Unstable Core
	UF:AddRaidDebuff(true, 360414, 5, true) -- Pneumatic Impact (tank)
	UF:AddRaidDebuff(true, 367571, 6) -- Sear (heroic)
	UF:AddRaidDebuff(true, 364447, 6) -- Dissonance (tank)
	UF:AddRaidDebuff(true, 360202, 5) -- Spike of Creation
	UF:AddRaidDebuff(true, 364881, 5) -- Matter Dissolution

	-- Skolex, the Insatiable Ravener
	UF:AddRaidDebuff(true, 359778, 5) -- Ephemera Dust
	UF:AddRaidDebuff(true, 360098, 5) -- Warp Sickness
	UF:AddRaidDebuff(true, 366070, 5) -- Volatile Residue
	UF:AddRaidDebuff(true, 364522, 7) -- Devouring Blood
	UF:AddRaidDebuff(true, 359976, 5) -- Riftmaw

	-- Artificer Xy'mox
	UF:AddRaidDebuff(true, 363413, 5) -- Genesis Rings
	UF:AddRaidDebuff(true, 365752, 5) -- Ancient Exhaust
	UF:AddRaidDebuff(true, 365801, 5) -- Relic Collapse
	UF:AddRaidDebuff(true, 363114, 5) -- Genesis Supernova
	UF:AddRaidDebuff(true, 365682, 5) -- Massive Blast
	UF:AddRaidDebuff(true, 364030, 5) -- Debilitating Ray

	-- Dausegne, the Fallen Oracle
	UF:AddRaidDebuff(true, 361966, 5) -- Infused Strikes
	UF:AddRaidDebuff(true, 361751, 5) -- Disintegration Halo
	UF:AddRaidDebuff(true, 364289, 4) -- Disintegration Halo

	-- Prototype Pantheon
	UF:AddRaidDebuff(true, 360687, 5, nil, true) -- Runecarvers Deathtouch
	UF:AddRaidDebuff(true, 361067, 5, true) -- Bastion's Ward (negates Runecarvers)
	UF:AddRaidDebuff(true, 360259, 5) -- Gloom Bolt
	UF:AddRaidDebuff(true, 365041, 5) -- Windswept  Wings
	UF:AddRaidDebuff(true, 362352, 5) -- Pinned
	UF:AddRaidDebuff(true, 361784, 4) -- Touch of the Night
	UF:AddRaidDebuff(true, 362383, 5) -- Anima Bolt
	UF:AddRaidDebuff(true, 361689, 5) -- Wracking Pain
	UF:AddRaidDebuff(true, 361608, 5) -- Burden of Sin
	UF:AddRaidDebuff(true, 364867, 5) -- Sinful Projection

	-- Lihuvim, Principal Architect
	UF:AddRaidDebuff(true, 360159, 5) -- Unstable Mote
	UF:AddRaidDebuff(true, 363681, 5) -- Deconstructing Blast
	UF:AddRaidDebuff(true, 368024, 5) -- Kinetic Resonance
	UF:AddRaidDebuff(true, 368025, 5) -- Sundering Resonance
	UF:AddRaidDebuff(true, 364092, 5) -- Degenerate
	UF:AddRaidDebuff(true, 366012, 5) -- Terminal Mote
	UF:AddRaidDebuff(true, 362447, 4) -- Instability

	-- Halondrus the Reclaimer
	UF:AddRaidDebuff(true, 368961, 5) -- Charge Exposure
	UF:AddRaidDebuff(true, 365294, 5) -- Charge Exposure
	UF:AddRaidDebuff(true, 360114, 5) -- Ephemeral Fissure
	UF:AddRaidDebuff(true, 361597, 5) -- Ephemeral Eruption
	UF:AddRaidDebuff(true, 368529, 5) -- Eternity Overdrive

	-- Anduin Wrynn
	UF:AddRaidDebuff(true, 368913, 4) -- Force of Will
	UF:AddRaidDebuff(true, 362055, 5, true) -- Lost Soul
	UF:AddRaidDebuff(true, 365445, 5) -- Scarred Soul
	UF:AddRaidDebuff(true, 364031, 6) -- Gloom
	UF:AddRaidDebuff(true, 365293, 7, nil, true) -- Befouled Barrier
	UF:AddRaidDebuff(true, 366849, 6) -- Domination Word Pain
	UF:AddRaidDebuff(true, 363024, 6) -- Necrotic Detonation
	UF:AddRaidDebuff(true, 363020, 5) -- Necrotic Claws
	UF:AddRaidDebuff(true, 363028, 5) -- Unraveling Frenzy
	UF:AddRaidDebuff(true, 368428, 5) -- Purging Light

	-- Lords of Dread
	UF:AddRaidDebuff(true, 360284, 6) -- Anguishing Strike (tank - stacks)
	UF:AddRaidDebuff(true, 359963, 6) -- Opened Veins (tank)
	UF:AddRaidDebuff(true, 360241, 7) -- Unsettling Dreams (sleep - dispell)
	UF:AddRaidDebuff(true, 360148, 5, true) -- Bursting Dread (clears Cloud of Carrion)
	UF:AddRaidDebuff(true, 360008, 7, true) -- Cloud of Carrion
	UF:AddRaidDebuff(true, 364985, 8) -- Biting Wounds (from above - stacks)
	UF:AddRaidDebuff(true, 360300, 5) -- Swarm of Decay
	UF:AddRaidDebuff(true, 360304, 5) -- Swarm of Darkness

	-- Rygelon
	UF:AddRaidDebuff(true, 361548, 6, nil, true) -- Dark Eclipse
	UF:AddRaidDebuff(true, 361462, 5, true) -- Collapsing Quasar Field
	UF:AddRaidDebuff(true, 362172, 5) -- Corrupted Wound (tank)
	UF:AddRaidDebuff(true, 362081, 6) -- Cosmic Ejection (heroic)
	UF:AddRaidDebuff(true, 364386, 5) -- Gravitational Collapse

	-- The Jailer
	UF:AddRaidDebuff(true, 366381, 5) -- Arcane Vulnerability
	UF:AddRaidDebuff(true, 366703, 5) -- Azerite Radiation
	UF:AddRaidDebuff(true, 362075, 6) -- Domination
	UF:AddRaidDebuff(true, 362631, 5) -- Chains of Oppression
	UF:AddRaidDebuff(true, 363893, 5) -- Martyrdom
	UF:AddRaidDebuff(true, 363886, 5) -- Imprisonment
	UF:AddRaidDebuff(true, 362194, 5) -- Suffering
	UF:AddRaidDebuff(true, 362192, 4) -- Relentless Misery
	UF:AddRaidDebuff(true, 366665, 5) -- Unholy Eruption
	UF:AddRaidDebuff(true, 359868, 5) -- Shattering Blast
	UF:AddRaidDebuff(true, 366777, 5) -- Consumed Azerite
	UF:AddRaidDebuff(true, 360425, 5) -- Unholy Ground
	UF:AddRaidDebuff(true, 366285, 5) -- Rune of Compulsion
	UF:AddRaidDebuff(true, 365153, 5) -- Dominating Will
	UF:AddRaidDebuff(true, 365219, 5) -- Chains of Anguish
	UF:AddRaidDebuff(true, 365385, 6) -- Cry of Loathing
	UF:AddRaidDebuff(true, 365174, 5) -- Defile
end

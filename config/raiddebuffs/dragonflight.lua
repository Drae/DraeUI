local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- Highmaul
UF["raiddebuffs"]["instances"]["Vault of the Incarnate"] = function()
	-- enable, spell, priority, secondary, pulse, flash

	-- "Eranog"
	UF:AddRaidDebuff(true, 370597, 5) -- kill-order
	UF:AddRaidDebuff(true, 371059, 5) -- melting-armor
	UF:AddRaidDebuff(true, 371955, 5) -- rising-heat
	UF:AddRaidDebuff(true, 370410, 5) -- pulsing-flames
	UF:AddRaidDebuff(true, 394906, 6) -- Burning Wound
	UF:AddRaidDebuff(true, 396023, 5) -- Incinerating Roar
	UF:AddRaidDebuff(true, 390715, 6) -- Flamerift
	UF:AddRaidDebuff(true, 370648, 5) -- Lava Flow

	-- "Terros"
	UF:AddRaidDebuff(true, 376276, 5) -- concussive-slam
	UF:AddRaidDebuff(true, 382776, 5) -- awakened-earth
	UF:AddRaidDebuff(true, 381576, 5) -- seismic-assault
	UF:AddRaidDebuff(true, 382458, 5) -- Resonant Aftermath
	UF:AddRaidDebuff(true, 386352, 6) -- Rock Blast

	-- "The Primal Council"
	UF:AddRaidDebuff(true, 371591, 5) -- frost-tomb
	UF:AddRaidDebuff(true, 371857, 5) -- shivering-lance
	UF:AddRaidDebuff(true, 371624, 5) -- conductive-mark
	UF:AddRaidDebuff(true, 372056, 5) -- crush
	UF:AddRaidDebuff(true, 374792, 5) -- faultline
	UF:AddRaidDebuff(true, 372027, 5) -- slashing-blaze
	UF:AddRaidDebuff(true, 375091, 7) -- Meteor Axe
	UF:AddRaidDebuff(true, 371836, 5) -- Primal Blizzard
	UF:AddRaidDebuff(true, 371514, 5) -- Scorched Ground

	-- "Sennarth, the Cold Breath"
	UF:AddRaidDebuff(true, 372736, 5) -- permafrost
	UF:AddRaidDebuff(true, 372648, 5) -- pervasive-cold
	UF:AddRaidDebuff(true, 373817, 5) -- chilling-aura
	UF:AddRaidDebuff(true, 372129, 5) -- web-blast
	UF:AddRaidDebuff(true, 372044, 5) -- wrapped-in-webs
	UF:AddRaidDebuff(true, 372082, 5) -- enveloping-webs
	UF:AddRaidDebuff(true, 371976, 5) -- chilling-blast
	UF:AddRaidDebuff(true, 372030, 5) -- sticky-webbing
	UF:AddRaidDebuff(true, 372055, 5) -- Icy Ground
	UF:AddRaidDebuff(true, 373048, 6) -- Suffocating Webs

	-- "Dathea, Ascended"
	UF:AddRaidDebuff(true, 378095, 5) -- crushing-atmosphere
	UF:AddRaidDebuff(true, 377819, 5) -- lingering-slash
	UF:AddRaidDebuff(true, 374900, 5) -- microburst
	UF:AddRaidDebuff(true, 376802, 5) -- razor-winds
	UF:AddRaidDebuff(true, 375580, 5) -- zephyr-slam
	UF:AddRaidDebuff(true, 390449, 5) -- Thunderbolt
	UF:AddRaidDebuff(true, 391686, 6) -- Conductive Mark
	UF:AddRaidDebuff(true, 388290, 5) -- Cyclone

	-- "Kurog Grimtotem"
	UF:AddRaidDebuff(true, 374864, 5) -- primal-break
	UF:AddRaidDebuff(true, 372158, 5) -- sundering-strike
	UF:AddRaidDebuff(true, 373681, 5) -- biting-chill
	UF:AddRaidDebuff(true, 373487, 5) -- lightning-crash
	UF:AddRaidDebuff(true, 372514, 5) -- frost-bite
	UF:AddRaidDebuff(true, 372517, 5) -- frozen-solid
	UF:AddRaidDebuff(true, 377780, 5) -- skeletal-fractures
	UF:AddRaidDebuff(true, 374623, 5) -- frost-binds
	UF:AddRaidDebuff(true, 374554, 5) -- lava-pool
	UF:AddRaidDebuff(true, 391022, 5) -- Frigid Torrent
	UF:AddRaidDebuff(true, 391056, 6) -- Enveloping Earth
	UF:AddRaidDebuff(true, 396109, 5) -- Frost Dominance
	UF:AddRaidDebuff(true, 396106, 5) -- Flame Dominance
	UF:AddRaidDebuff(true, 396085, 5) -- Earth Dominance
	UF:AddRaidDebuff(true, 396113, 5) -- Storm Dominance
	UF:AddRaidDebuff(true, 374554, 5) -- Magma Pool
	UF:AddRaidDebuff(true, 376063, 5) -- Flame Bolt
	UF:AddRaidDebuff(true, 391696, 5) -- Lethal Current
	UF:AddRaidDebuff(true, 374023, 5) -- Searing Carnage
	UF:AddRaidDebuff(true, 372458, 6) -- Absolute Zero
	UF:AddRaidDebuff(true, 390920, 5) -- Shocking Burst

	-- "Broodkeeper Diurna"
	UF:AddRaidDebuff(true, 378782, 5) -- mortal-wounds
	UF:AddRaidDebuff(true, 375829, 5) -- clutchwatchers-rage
	UF:AddRaidDebuff(true, 378787, 5) -- crushing-stoneclaws
	UF:AddRaidDebuff(true, 375871, 5) -- wildfire
	UF:AddRaidDebuff(true, 376266, 5) -- burrowing-strike
	UF:AddRaidDebuff(true, 375575, 5) -- flame-sentry
	UF:AddRaidDebuff(true, 375475, 5) -- rending-bite
	UF:AddRaidDebuff(true, 375457, 5) -- chilling-tantrum
	UF:AddRaidDebuff(true, 375653, 5) -- static-jolt
	UF:AddRaidDebuff(true, 376392, 5) -- disoriented
	UF:AddRaidDebuff(true, 375876, 5) -- icy-shards
	UF:AddRaidDebuff(true, 375430, 5) -- sever-tendon
	UF:AddRaidDebuff(true, 375889, 5) -- Greatstaff's Wrath
	UF:AddRaidDebuff(true, 380483, 5) -- Empowered Greatstaff's Wrath
	UF:AddRaidDebuff(true, 388717, 6) -- Icy Shroud
	UF:AddRaidDebuff(true, 375620, 6) -- Ionizing Charge
	UF:AddRaidDebuff(true, 388920, 6) -- Frozen Shroud
	UF:AddRaidDebuff(true, 375487, 6) -- Cauterizing Flashflames
	UF:AddRaidDebuff(true, 376260, 5) -- Tremors
	UF:AddRaidDebuff(true, 375716, 5) -- Ice Barrage

	-- "Raszageth the Storm-Eater"
	UF:AddRaidDebuff(true, 381615, 5, true) -- static-charge
	UF:AddRaidDebuff(true, 377594, 5) -- lightning-breath
	UF:AddRaidDebuff(true, 381249, 5) -- electrifying-presence
	UF:AddRaidDebuff(true, 395906, 5) -- Electrified Jaws
	UF:AddRaidDebuff(true, 391285, 6) -- Thunderstruck Armor
	UF:AddRaidDebuff(true, 388115, 5) -- Lightning Devastation
	UF:AddRaidDebuff(true, 394576, 5, true) -- Positive Charge
	UF:AddRaidDebuff(true, 394579, 10) -- Negative Charge
	UF:AddRaidDebuff(true, 394582, 5) -- Focused Charge
	UF:AddRaidDebuff(true, 394583, 6) -- Scattered Charge
	UF:AddRaidDebuff(true, 377467, 5) -- Fulminating Charge
	UF:AddRaidDebuff(true, 390911, 5) -- Lingering Charge
	UF:AddRaidDebuff(true, 395929, 5) -- Storm's Spite
	UF:AddRaidDebuff(true, 377662, 5) -- Static Field
	UF:AddRaidDebuff(true, 388659, 6) -- Tempest Wing
	UF:AddRaidDebuff(true, 377612, 5) -- Hurricane Wing
	UF:AddRaidDebuff(true, 381442, 5) -- Lightning Strike
	UF:AddRaidDebuff(true, 390763, 7) -- Thunderous Energy
	UF:AddRaidDebuff(true, 380573, 5) -- Ball Lightning
end

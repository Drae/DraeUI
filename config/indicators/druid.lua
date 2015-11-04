--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["DRUID"] = {
	auras = {
		-- Common
		["dispel_magic"] 	= { debuff = "Magic",	pr = 80, mine = false, color = { r = 0.2, g = 0.6, b = 1.0 } },
		["dispel_disease"] 	= { debuff = "Disease",	pr = 70, mine = false, color = { r = 0.6, g = 0.4, b = 0   } },
		["dispel_poison"] 	= { debuff = "Poison",	pr = 60, mine = false, color = { r = 0,   g = 0.6, b = 1.0 } },
		["dispel_curse"] 	= { debuff = "Curse",	pr = 50, mine = false, color = { r = 0.6, g = 0,   b = 1.0 } },
		["buff_feigndeath"]	= { buff = "Feign Death", pr = 50, mine = false, text = "FEIGN" },

		-- Stats
		["buff_markofthewild"] 				= { buff = "Mark of the Wild",   		  pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Stats
		["buff_blessingofkings"] 			= { buff = "Blessing of Kings",   		  pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Stats (Paladin)
		["buff_legacyoftheemperor"] 		= { buff = "Legacy of the Emperor",   	  pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Stats (Monk)
		["buff_embraceoftheshalespider"] 	= { buff = "Embrace of the Shale Spider", pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Stats (Hunter - Shale Spider)

		-- Spell Haste
		["buff_moonkinaura"] 	= { buff = "Moonkin Aura",   pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Spell Haste
		["buff_shadowform"] 	= { buff = "Shadowform",   	 pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Spell Haste (Priest)
		["buff_elementaloath"] 	= { buff = "Elemental Oath", pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Spell Haste (Shaman)

		-- Crit
		["buff_leaderofthepack"] 		= { buff = "Leader of the Pack",   		pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },  -- Crit
		["buff_arcanebrilliance"] 		= { buff = "Arcane Brilliance",   		pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },  -- Spell Power + Crit (Mage)
		["buff_dalaranbrilliance"]		= { buff = "Dalaran Brilliance",		pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },  -- Spell Power + Crit (Mage)
		["buff_legacyofthewhitetiger"] 	= { buff = "Legacy of the White Tiger", pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },  -- Crit (Monk)
		["buff_bellowingroar"] 			= { buff = "Bellowing Roar",   			pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },  -- Crit (Hunter - Hydra)
		["buff_furioushowl"] 			= { buff = "Furious Howl",   			pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },  -- Crit (Hunter - Wolf)
		["buff_terrifyingroar"] 		= { buff = "Terrifying Roar",   		pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },  -- Crit (Hunter - Devilsaur)
		["buff_fearlessroar "] 			= { buff = "Fearless Roar ",   			pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },  -- Crit (Hunter - Quilen)
		["buff_stillwater"] 			= { buff = "Still Water",   			pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },  -- Crit (Hunter - Wavestrider)

		-- Specific
		["buff_rejuvenation"] 	= { buff = "Rejuvenation", 	pr = 7, mine = true,  color = { r = 0.8, g = 0.8, b = 0.8 } },
		["buff_wildgrowth"] 	= { buff = "Wild Growth", 	pr = 7, mine = true,  color = { r = 0.60, g = 0.20, b = 0.80 } },
		["buff_lifebloom"] 		= { buff = "Lifebloom", 	pr = 7, mine = true,  color = { [1] = { r = 0.90, g = 0.00, b = 0.00 },
																							[2] = { r = 0.90, g = 0.75, b = 0.00 },
																							[3] = { r = 0.00, g = 0.90, b = 0.00 } } },
		["buff_regrowth"] 		= { buff = "Regrowth", 		pr = 7, mine = true,  color = { r = 0, g = 0.4, b = 0.9 } },
	},

	statusmap = {
		["Border"] = {
			["dispel_magic"] = true,
			["dispel_disease"] = true,
			["dispel_poison"] = true,
			["dispel_curse"] = true,
			["status_raiddebuff"] = true,
		},

		["CENTERICON"] = {
			["dispel_magic"] = true,
			["dispel_disease"] = true,
			["dispel_poison"] = true,
			["dispel_curse"] = true,
			["status_raiddebuff"] = true,
		},

		["BOTTOMICON"] = {
			["status_raiddebuff2"] = true,
		},

		["TOPLEFT"] = {
			["status_aggro"] = true,
		},

		["TOPRIGHT"] = {
			["status_incheal"] = true,
		},

		["BOTTOM"] = {
            ["status_res"] = true,
		},

		["Text2"] = {
			["buff_feigndeath"] = true,
		},

		["BOTTOMRIGHT"] = {
			["buff_blessingofkings"] = true,
			["buff_markofthewild"] = true,
			["buff_legacyoftheemperor"] = true,
			["buff_embraceoftheshalespider"] = true,
		},

		["BOTTOMRIGHTL"] = {
			["buff_moonkinaura"] = true,
			["buff_shadowform"] = true,
			["buff_elementaloath"] = true,
		},

		["BOTTOMRIGHTT"] = {
			["buff_legacyofthewhitetiger"] = true,
			["buff_leaderofthepack"] = true,
			["buff_arcanebrilliance"] = true,
			["buff_dalaranbrilliance"] = true,
			["buff_bellowingroar"] = true,
			["buff_furioushowl"] = true,
			["buff_terrifyingroar"] = true,
			["buff_fearlessroar"] = true,
			["buff_stillwater"] = true,
		},

		["TOP"] = {
			["buff_rejuvenation"] = true,
		},

		["TOPL"] = {
			["buff_wildgrowth"] = true,
		},

		["TOPR"] ={
			["buff_lifebloom"] = true,
		},

		["RIGHT"] = {
			["buff_regrowth"] = true,
		},
	}
}


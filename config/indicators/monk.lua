--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["MONK"] = {
	auras = {
		-- Common
		["buff_resurrecting"] = { buff = "Resurrecting", pr = 50, mine = false, color = { r = 0, g = 1.0, b = 0.0 } },
		["buff_soulstone"]  = { buff = "Soulstone", pr = 55, mine = false, color = { r = 1.0, g = 0,   b = 0.4 } },
		["dispel_magic"] 	= { debuff = "Magic",	pr = 80, mine = false, color = { r = 0.2, g = 0.6, b = 1.0} },
		["dispel_disease"] 	= { debuff = "Disease",	pr = 70, mine = false, color = { r = 0.6, g = 0.4, b = 0} },
		["dispel_poison"] 	= { debuff = "Poison",	pr = 60, mine = false, color = { r = 0, g = 0.6, b = 1.0} },
		["dispel_curse"] 	= { debuff = "Curse",	pr = 50, mine = false, color = { r = 0.6, g = 0, b = 1.0} },
		["buff_feigndeath"]	= { buff = "Feign Death", pr = 50, mine = false, text = "FEIGN" },

		-- Stats
		["buff_legacyoftheemperor"]			= { buff = "Legacy of the Emperor",  		pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 }},
		["buff_blessingofkings"]			= { buff = "Blessing of Kings",  			pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 }}, -- Paladin
		["buff_markofthewild"]				= { buff = "Mark of the Wild",  			pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 }}, -- Druid
		["buff_embraceoftheshalespider"]	= { buff = "Embrace of the Shale Spider", 	pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 }}, -- Hunter - Shale Spider

		-- Crit
		["buff_legacyofthewhitetiger"]		= { buff = "Legacy of the White Tiger",  	pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 }},
		["buff_leaderofthepack"]			= { buff = "Leader of the Pack",  			pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 }}, -- Druid
		["buff_arcanebrilliance"]			= { buff = "Arcane Brilliance",  			pr = 60, mine = false, color = { r = 0, g = 0.4, b = 1.0 }}, -- Mage
		["buff_dalarabrilliance"]			= { buff = "Dalaran Brilliance",  			pr = 60, mine = false, color = { r = 0, g = 0.4, b = 1.0 }}, -- Mage
		["buff_bellowingroar"]				= { buff = "Bellowing Roar",  				pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 }}, -- Hunter - Hydra
		["buff_furioushowl"]				= { buff = "Furious Howl",  				pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 }}, -- Hunter - Wolf
		["buff_terrifyingroar"]				= { buff = "Terrifying Roar",  				pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 }}, -- Hunter - Devilsaur
		["buff_fearlessroar"]				= { buff = "Fearless Roar",  				pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 }}, -- Hunter - Quilen
		["buff_stillwater"]					= { buff = "Still Water",  					pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 }}, -- Hunter - Wavestrider

		-- Specific
		["buff_renewingmist"]				= { buff = "Renewing Mist", 				pr = 60, mine = true, color = { r = 0, g = 1, b = 0 }},
		["buff_envelopingmist"]				= { buff = "Enveloping Mist", 				pr = 80, mine = true, color = { r = 0.15, g = 0.87, b = 0.64} },
		["buff_lifecocoon"]					= { buff = "Life Cocoon", 					pr = 70, mine = true, color = { r = 1.0, g = 0, b = 1.0 }},
		["buff_tigerslust"]					= { buff = "Tiger's Lust", 					pr = 80, mine = true, color = { r = 0.7, g = 0.7, b = 0.7 }},
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
            ["buff_resurrecting"] = true,
            ["buff_soulstone"] = true,
		},

		["Text2"] = {
			["buff_feigndeath"] = true,
		},

		["BOTTOMRIGHT"] = {
			["buff_legacyoftheemperor"]	= true,
			["buff_blessingofkings"] = true,
			["buff_markofthewild"] = true,
			["buff_embraceoftheshalespider"] = true,
		},

		["BOTTOMRIGHTL"] = {
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
			["buff_renewingmist"] = true,
		},

		["TOPR"] = {
			["buff_envelopingmist"] = true,
		},

		["LEFT"] = {
			["status_dmgred"] = true,
		},

		["LEFTB"] = {
			["buff_lifecocoon"] = true,
		},

		["LEFTT"] = {
			["buff_tigerslust"]	= true,
		},
	}
}

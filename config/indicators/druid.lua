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
		},

		["BOTTOMRIGHTL"] = {
		},

		["BOTTOMRIGHTT"] = {
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


--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["HUNTER"] = {
	auras = {
		-- Common
		["dispel_magic"] 		= { debuff = "Magic",	pr = 80, mine = false, color = { r = 0.2, g = 0.6, b = 1.0} },
		["dispel_disease"] 		= { debuff = "Disease",	pr = 70, mine = false, color = { r = 0.6, g = 0.4, b = 0} },
		["dispel_poison"] 		= { debuff = "Poison",	pr = 60, mine = false, color = { r = 0,   g = 0.6, b = 1.0} },
		["dispel_curse"] 		= { debuff = "Curse",	pr = 50, mine = false, color = { r = 0.6, g = 0,   b = 1.0} },
		["buff_feigndeath"]		= { buff = "Feign Death", pr = 50, mine = false, text = "FEIGN" },

		-- Specific
		["buff_misdirection"] 	= { buff = "Misdirection",   pr = 5, mine = false, color = { r = 0, g = 0.4, b = 0.9 } },
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

        ["LEFT"] = {
            ["status_dmgred"] = true,
        },

		["TOP"] = {
			["buff_misdirection"] = true
		},

		["BOTTOMRIGHT"] = {
		},
	}
}

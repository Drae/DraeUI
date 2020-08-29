--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["MONK"] = {
	auras = {
		-- Common
		["dispel_magic"] = {debuff = "Magic", pr = 80, mine = false, color = {r = 0.2, g = 0.6, b = 1.0}},
		["dispel_disease"] = {debuff = "Disease", pr = 70, mine = false, color = {r = 0.6, g = 0.4, b = 0}},
		["dispel_poison"] = {debuff = "Poison", pr = 60, mine = false, color = {r = 0, g = 0.6, b = 1.0}},
		["dispel_curse"] = {debuff = "Curse", pr = 50, mine = false, color = {r = 0.6, g = 0, b = 1.0}},
		["buff_feigndeath"] = {buff = "Feign Death", pr = 50, mine = false, text = "FEIGN"},
		-- Specific
		["buff_renewingmist"] = {buff = "Renewing Mist", pr = 60, mine = true, color = {r = 0, g = 1, b = 0}},
		["buff_envelopingmist"] = {buff = "Enveloping Mist", pr = 80, mine = true, color = {r = 0.15, g = 0.87, b = 0.64}},
		["buff_essencefont"] = {buff = "Essence Font", pr = 80, mine = true, color = {r = 0.15, g = 0.57, b = 0.84}},
		["buff_lifecocoon"] = {buff = "Life Cocoon", pr = 70, mine = true, color = {r = 1.0, g = 0, b = 1.0}},
		["buff_tigerslust"] = {buff = "Tiger's Lust", pr = 80, mine = true, color = {r = 0.7, g = 0.7, b = 0.7}}
	},
	statusmap = {
		["Border"] = {
			["dispel_magic"] = true,
			["dispel_disease"] = true,
			["dispel_poison"] = true,
			["dispel_curse"] = true,
			["status_raiddebuff"] = true
		},

		["CENTERICON"] = {
			["dispel_magic"] = true,
			["dispel_disease"] = true,
			["dispel_poison"] = true,
			["dispel_curse"] = true,
			["status_raiddebuff"] = true
		},

        ["BOTTOMICON"] = {
            ["status_raiddebuff2"] = true,
        },

		["TOPLEFT"] = {
			["status_aggro"] = true
		},

		["TOPRIGHT"] = {
			["status_incheal"] = true
		},

		["BOTTOM"] = {
			["status_res"] = true
		},

		["Text2"] = {
			["buff_feigndeath"] = true
		},

		["BOTTOMRIGHT"] = {},

		["BOTTOMRIGHTL"] = {},

		["TOPL"] = {
			["buff_envelopingmist"] = true
		},

		["TOP"] = {
			["buff_renewingmist"] = true
		},

		["TOPR"] = {
			["buff_essencefont"] = true
		},

		["LEFT"] = {
			["status_dmgred"] = true
		},

		["LEFTT"] = {
			["buff_lifecocoon"] = true
		},

		["LEFTB"] = {
			["buff_tigerslust"] = true
		}
	}
}

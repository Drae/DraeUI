--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["MONK"] = {
	auras = {
        -- Common

		-- Specific
		["buff_renewingmist"] 	= { buff = "Renewing Mist", 	mine = true, color = { 0.0,  g = 1.0,  b = 0.0  } },
		["buff_envelopingmist"] = { buff = "Enveloping Mist", 	mine = true, color = { 0.15, g = 0.87, b = 0.64 } },
		["buff_essencefont"] 	= { buff = "Essence Font", 		mine = true, color = { 0.15, g = 0.57, b = 0.84 } },
		["buff_lifecocoon"] 	= { buff = "Life Cocoon", 		mine = true, color = { 1.0,  g = 0.0,  b = 1.0  } },
		["buff_tigerslust"] 	= { buff = "Tiger's Lust", 		mine = true, color = { 0.7,  g = 0.7,  b = 0.7  } }
	},

	statusmap = {
		["TEXT2"] = {
			["alert_afk"] 		= 95,
			["alert_dc"] 		= 95,
			["alert_ghost"]		= 92,
			["alert_feign"] 	= 90,
			["alert_dead"] 		= 90,
			["alert_charmed"] 	= 85,
			["unit_vehicle"] 	= 81,
			["unit_health"] 	= 80,
		},

        ["BORDER"] = {
            ["status_raiddebuff_one"] 	= 90,
            ["status_dispell"] 			= 80,
        },

        ["CENTERICON"] = {
            ["status_raiddebuff_one"] 	= 90,
            ["status_dispell"] 			= 80,
        },

        ["BOTTOMICON"] = {
            ["status_raiddebuff_two"] = 90,
        },

        ["TOPLEFT"] = {
        },

        ["TOPRIGHT"] = {
            ["status_incheal"] = 90,
        },

		["TOPRIGHTL"] = {
			["buff_renewingmist"] = 80
		},

        ["TOPRIGHTB"] = {
			["buff_envelopingmist"] = 80
        },

        ["BOTTOM"] = {
            ["status_summon"] 	= 70,
            ["status_res"] 		= 80,
        },

        ["TOP"] = {
            ["status_aggro"] = 90,
        },

        ["TOPL"] = {
        },

        ["TOPR"] = {
        },

        ["BOTTOMRIGHT"] = {
			["buff_lifecocoon"] = 80
        },

        ["BOTTOMRIGHTL"] = {
			["buff_tigerslust"] = 80
        },

        ["BOTTOMRIGHTT"] = {
        },

        ["BOTTOMLEFT"] = {
        },

        ["LEFT"] = {
        },

        ["LEFTB"] = {
        },

        ["RIGHT"] = {
			["buff_essencefont"] = 80
        },

		["RIGHTT"] = {
		}
    }
}

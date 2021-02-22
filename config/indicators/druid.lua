--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))

T.defaults.class["DRUID"] = {
	auras = {
		["buff_rejuvenation"] 	= { buff = "Rejuvenation", 	mine = true,  color = { 0.8, 0.8, 0.8 } },
		["buff_wildgrowth"] 	= { buff = "Wild Growth", 	mine = true,  color = { 0.6, 0.2, 0.8 } },
		["buff_lifebloom"] 		= { buff = "Lifebloom", 	mine = true,  color = { 0.9, 0,   0   } },
		["buff_regrowth"] 		= { buff = "Regrowth", 		mine = true,  color = { 0,   0.4, 0.9 } },
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
			["buff_rejuvenation"] = 80,
		},

        ["TOPRIGHTB"] = {
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
        },

        ["BOTTOMRIGHTL"] = {
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
			["buff_lifebloom"] = 70,
        },

		["RIGHTT"] = {
			["buff_regrowth"] = 80,
		}
    }
}


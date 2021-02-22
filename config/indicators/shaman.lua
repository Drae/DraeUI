--[[


--]]
local DraeUI = select(2, ...)

DraeUI.defaults.class["SHAMAN"] = {
    auras = {
        ["buff_riptide"]     			= { buff = "Riptide", 				mine = true, color = { 0.0, 1.0, 0.7 } },
        ["buff_earthshield"]   			= { buff = "Earth Shield", 			mine = true, color = { 1.0, 0.6, 0.0 } },
        ["buff_lightningshield"]		= { buff = "Lightning Shield", 		mine = true, color = { 0.0, 0.6, 1.0 } },
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
            ["buff_riptide"] = 80,
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
            ["buff_earthshield"] = 90,
            ["buff_lightningshield"] = 80,
        },

		["RIGHTT"] = {
		}
    }
}

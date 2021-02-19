--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["PALADIN"] = {
    auras = {
		-- debuff = "name", mine = "show only my spells|true,false", color="r,g,b(,a)"

        -- Common

		-- Specific
        ["debuff_forbearance"]            	= { debuff = "Forbearance", 				mine = false, color = { 1.0, 0.0, 0.0 } },

        ["buff_concentrationaura"]     		= { buff = "Concentration Aura",     		mine = true,  color = { 0.8, 0.2, 0.0 } },
        ["buff_devotionaura"]     			= { buff = "Devotion Aura",     			mine = true,  color = { 0.8, 0.3, 0.0 } },
        ["buff_crusaderaura"]     			= { buff = "Crusader Aura",     			mine = true,  color = { 0.8, 0.4, 0.0 } },
        ["buff_retributionaura"]     		= { buff = "Retribution Aura",     			mine = true,  color = { 0.8, 0.5, 0.0 } },
        ["buff_blessingofprotection"]      	= { buff = "Blessing of Protection",   	    mine = false, color = { 0.0, 0.2, 0.9 } },
        ["buff_blessingofspellwarding"]     = { buff = "Blessing of Spellwarding",      mine = false, color = { 0.0, 0.2, 0.7 } },
        ["buff_blessingoffreedom"]          = { buff = "Blessing of Freedom",   	    mine = false, color = { 0.7, 0.7, 0.7 } },
        ["buff_blessingofsacrifice"]        = { buff = "Blessing of Sacrifice",   	    mine = false, color = { 1.0, 0.0, 1.0 } },
        ["buff_bestowfaith"]                = { buff = "Bestow Faith", 				    mine = true,  color = { 1.0, 0.8, 0.0 } },
        ["buff_beaconoflight"]           	= { buff = "Beacon of Light",   			mine = true,  color = { 1.0, 0.7, 0.0 } },
        ["buff_beaconoffaith"]           	= { buff = "Beacon of Faith",   			mine = true,  color = { 1.0, 0.6, 0.0 } },
        ["buff_beaconofvirtue"]          	= { buff = "Beacon of Virtue",   			mine = true,  color = { 1.0, 0.4, 0.0 } },
        ["buff_glimmeroflight"]             = { buff = "Glimmer of Light",     	        mine = true,  color = { 0.0, 1.0, 0.5 } }
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
            ["buff_glimmeroflight"] = 80,
		},

        ["TOPRIGHTB"] = {
            ["buff_bestowfaith"] = 80,
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
            ["buff_blessingofprotection"] 	= 90,
            ["buff_blessingofspellwarding"] = 80,
        },

        ["BOTTOMRIGHTL"] = {
            ["buff_blessingoffreedom"] = 80,
        },

        ["BOTTOMRIGHTT"] = {
            ["buff_blessingofsacrifice"] = 80,
        },

        ["BOTTOMLEFT"] = {
            ["debuff_forbearance"] = 90,
        },

        ["LEFT"] = {
        },

        ["LEFTB"] = {
			["status_stagger"] = 80,
        },

        ["RIGHT"] = {
            ["buff_beaconoflight"] 	= 60,
            ["buff_beaconoffaith"] 	= 60,
            ["buff_beaconofvirtue"] = 60,
        },

		["RIGHTT"] = {
            ["buff_retributionaura"] 	= 60,
            ["buff_crusaderaura"] 		= 60,
            ["buff_concentrationaura"] 	= 60,
            ["buff_devotionaura"] 		= 60,
		}
    }
}

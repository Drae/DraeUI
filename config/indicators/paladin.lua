--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["PALADIN"] = {
    auras = {
        -- Common
        ["dispel_magic"] 	= { debuff = "Magic",	pr = 80, mine = false, color = { r = 0.2, g = 0.6, b = 1.0 } },
        ["dispel_disease"] 	= { debuff = "Disease",	pr = 70, mine = false, color = { r = 0.6, g = 0.4, b = 0 } },
        ["dispel_poison"] 	= { debuff = "Poison",	pr = 60, mine = false, color = { r = 0, g = 0.6, b = 1.0 } },
        ["dispel_curse"] 	= { debuff = "Curse",	pr = 50, mine = false, color = { r = 0.6, g = 0, b = 1.0 } },
        ["buff_feigndeath"]	= { buff = "Feign Death", pr = 50, mine = false, text = "FEIGN" },

        -- Specific
        ["buff_auraofmercy"]     			= { buff = "Aura of Mercy",     			pr = 50, mine = true, color = { r = 1.0, g = 0, b = 0.7 } },
        ["buff_auraofsacrifice"]     		= { buff = "Aura of Sacrifice",     		pr = 50, mine = true, color = { r = 1.0, g = 0, b = 0.7 } },
        ["buff_devotionaura"]     			= { buff = "Devotion Aura",     			pr = 50, mine = true, color = { r = 1.0, g = 0, b = 0.7 } },

        ["buff_greaterblessingofkings"]     = { buff = "Greater Blessing of Kings",     pr = 50, mine = true, color = { r = 0.8, g = 0.8, b = 0.8} },
        ["buff_greaterblessingofwisdom"]    = { buff = "Greater Blessing of Wisdom",    pr = 50, mine = true, color = { r = 0.8, g = 0.0, b = 0.4} },

        ["buff_blessingrotection"]        	= { buff = "Blessing of Protection",   	    pr = 90, mine = false, color = { r = 0, g = 0.25, b = 0.9 } },
        ["buff_blessingoffreedom"]          = { buff = "Blessing of Freedom",   	    pr = 80, mine = false, color = { r = 0.7, g = 0.7, b = 0.7} },
        ["buff_blessingofsacrifice"]        = { buff = "Blessing of Sacrifice",   	    pr = 70, mine = false, color = { r = 1.0, g = 0, b = 1.0 } },
        ["buff_blessingofsalvation"]        = { buff = "Blessing of Salvation",   	    pr = 60, mine = false, color = { r = 0, g = 0.8, b = 0 } },
        ["buff_blessingofspellwarding"]     = { buff = "Blessing of Spellwarding",      pr = 85, mine = false, color = { r = 0, g = 0.8, b = 0.5 } },

        ["buff_bestowfaith"]                = { buff = "Bestow Faith", 				    pr = 60, mine = true, color = { r = 1.0, g = 0.8, b = 0 } },
        ["buff_sacreddawn"]           		= { buff = "Sacred Dawn",			    	pr = 80, mine = true, color = { r = 1.0, g = 1.0, b = 1.0 }, flash = true },
        ["buff_beaconoflight"]           	= { buff = "Beacon of Light",   			pr = 40, mine = true, color = { r = 1.0, g = 0.8, b = 0 } },
        ["buff_beaconoffaith"]           	= { buff = "Beacon of Faith",   			pr = 40, mine = true, color = { r = 1.0, g = 0.6, b = 0 } },
        ["buff_beaconofvirtue"]          	= { buff = "Beacon of Virtue",   			pr = 40, mine = true, color = { r = 1.0, g = 0.8, b = 0.2 } },

        ["debuff_forbearance"]            	= { debuff = "Forbearance", 				pr = 60, mine = false, color = { r = 1.0, g = 0, b = 0 } },
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

        ["TOP"] = {
            ["buff_bestowfaith"] = true,
        },

        ["TOPL"] = {
        },

        ["TOPR"] = {
            ["buff_auraofmercy"] = true,
            ["buff_auraofsacrifice"] = true,
            ["buff_devotionaura"] = true,
        },

        ["BOTTOMRIGHT"] = {
            ["buff_greaterblessingofkings"] = true,
        },

        ["BOTTOMRIGHTL"] = {
            ["buff_greaterblessingofwisdom"] = true,
        },

        ["BOTTOMRIGHTT"] = {
        },

        ["BOTTOMLEFT"] = {
            ["debuff_forbearance"] = true,
        },

        ["LEFTT"] = {
            ["buff_sacreddawn"] = true,
        },

        ["LEFT"] = {
            ["status_dmgred"] = true,
        },

        ["LEFTB"] = {
            ["buff_blessingoffreedom"] = true,
            ["buff_blessingofprotection"] = true,
            ["buff_blessingofsacrifice"] = true,
            ["buff_blessingofsalvation"] = true,
            ["buff_blessingofspellwarding"] = true,
        },

        ["RIGHT"] = {
            ["buff_beaconoflight"] = true,
            ["buff_beaconoffaith"] = true,
            ["buff_beaconofvirtue"] = true,
        },
    }
}

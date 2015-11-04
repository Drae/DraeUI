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

        -- Stats
        ["buff_blessingofkings"]         	= { buff = "Blessing of Kings",   			pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8} },
        ["buff_markofthewild"]          	= { buff = "Mark of the Wild",   			pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8} }, -- Druid
        ["buff_legacyoftheemperor"]     	= { buff = "Legacy of the Emperor",   		pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8} }, -- Monk
        ["buff_embraceoftheshalespider"]	= { buff = "Embrace of the Shale Spider",   pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8} }, -- Hunter - Shale Spider

        -- Mastery
        ["buff_blessingofmight"]         	= { buff = "Blessing of Might",   			pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },
        ["buff_graceofair"]              	= { buff = "Grace of Air",   				pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 } }, -- Shaman
        ["buff_spiritbeastblessing"]    	= { buff = "Spirit Beast Blessing",   		pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 } }, -- Hunter - Spirit Beast
        ["buff_roarofcourage"]           	= { buff = "Roar of Courage",   			pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 } }, -- Hunter - Cat

        -- Specific
        ["buff_handofprotection"]        	= { buff = "Hand of Protection",   			pr = 90, mine = false, color = { r = 0, g = 0.25, b = 0.9 } },
        ["buff_handoffreedom"]          	= { buff = "Hand of Freedom",   			pr = 80, mine = false, color = { r = 0.7, g = 0.7, b = 0.7} },
        ["buff_handofsacrifice"]         	= { buff = "Hand of Sacrifice",   			pr = 70, mine = false, color = { r = 1.0, g = 0, b = 1.0 } },
        ["buff_handofsalvation"]         	= { buff = "Hand of Salvation",   			pr = 60, mine = false, color = { r = 0, g = 0.8, b = 0 } },
        ["buff_handofpurity"] 		    	= { buff = "Hand of Purity",   				pr = 70, mine = false, color = { r = 0, g = 0.8, b = 0.5 } },
        ["buff_beaconoflight"]           	= { buff = "Beacon of Light",   			pr = 40, mine = true, color = { r = 1.0, g = 0.8, b = 0 } },
        ["buff_beaconoffaith"]           	= { buff = "Beacon of Faith",   			pr = 40, mine = true, color = { r = 1.0, g = 0.6, b = 0 } },
        ["buff_eternalflame"]             	= { buff = "Eternal Flame",   				pr = 80, mine = true,  color = { r = 1.0, g = 0.7, b = 0 } },
        ["buff_sacredshield"]             	= { buff = "Sacred Shield",   				pr = 80, mine = false, color = { r = 1.0, g = 0.7, b = 0 } },

        ["debuff_forbearance"]            	= { debuff = "Forbearance", 				pr = 60, mine = false, color = { r = 1.0, g = 0, b = 0 } },
        ["debuff_savedbythelight"]			= { debuff = "Recently Saved by the Light",	pr = 70, mine = false, color = { r = 1.0, g = 0.7, b = 0 } },
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
            ["buff_blessingofmight"] = true,
            ["buff_graceofair"] = true,
            ["buff_spiritbeastblessing"] = true,
            ["buff_roarofcourage"] = true,
        },

        ["BOTTOMLEFT"] = {
            ["debuff_forbearance"] = true,
            ["debuff_savedbythelight"] = true,
        },

        ["LEFT"] = {
            ["status_dmgred"] = true,
        },

        ["LEFTB"] = {
            ["buff_handoffreedom"] = true,
            ["buff_handofprotection"] = true,
            ["buff_handofsacrifice"] = true,
            ["buff_handofsalvation"] = true,
            ["buff_handofpurity"] = true,
        },

        ["TOP"] = {
            ["buff_eternalflame"] = true,
        },

        ["TOPR"] = {
            ["status_ih"] = true,
        },

        ["TOPL"] = {
            ["buff_sacredshield"] = true,
        },

        ["RIGHT"] = {
            ["buff_beaconoflight"] = true,
            ["buff_beaconoffaith"] = true,
        },
    }
}

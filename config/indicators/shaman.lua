--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["SHAMAN"] = {
	auras = {
		-- Common
		["dispel_magic"] 	= { debuff = "Magic",	pr = 80, mine = false, color = { r = 0.2, g = 0.6, b = 1.0} },
		["dispel_disease"] 	= { debuff = "Disease",	pr = 70, mine = false, color = { r = 0.6, g = 0.4, b = 0} },
		["dispel_poison"] 	= { debuff = "Poison",	pr = 60, mine = false, color = { r = 0, g = 0.6, b = 1.0} },
		["dispel_curse"] 	= { debuff = "Curse",	pr = 50, mine = false, color = { r = 0.6, g = 0, b = 1.0} },
		["buff_feigndeath"]	= { buff = "Feign Death", pr = 50, mine = false, text = "FEIGN" },

		-- Mastery
		["buff_graceofair"]              	= { buff = "Grace of Air",   				pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },
		["buff_blessingofmight"]         	= { buff = "Blessing of Might",   			pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 } }, -- Paladin
		["buff_spiritbeastblessing"]    	= { buff = "Spirit Beast Blessing",   		pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 } }, -- Hunter - Spirit Beast
		["buff_roarofcourage"]           	= { buff = "Roar of Courage",   			pr = 50, mine = false, color = { r = 0, g = 0.4, b = 1.0 } }, -- Hunter - Cat

		-- Attack speed
		["buff_unholyaura"] 		= { buff = "Unholy Aura", 			pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },
		["buff_swiftbladescunning"]	= { buff = "Swiftblade's Cunning", 	pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } }, -- Rogue
		["buff_unleashedrage"] 		= { buff = "Unleashed Rage", 		pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } }, -- Shaman
		["buff_cacklinghowl"] 		= { buff = "Cackling Howl", 		pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } }, -- Hunter - Hyena
		["buff_serpentsswiftness"] 	= { buff = "Serpent's Swiftness", 	pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } }, -- Hunter - Wind Serpent

		-- Attack power
		["buff_elementaloath"] 	= { buff = "Elemental Oath", pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } },
		["buff_moonkinaura"] 	= { buff = "Moonkin Aura",   pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } }, -- Druid
		["buff_shadowform"] 	= { buff = "Shadowform",   	 pr = 5, mine = false, color = { r = 0.4, g = 0.8, b = 0.4 } }, -- Priest

		-- Specific
		["buff_ancestralfortitude"] = { buff = "Ancestral Fortitude", pr = 5, mine = false, color = { r = 0.1, g = 0.5, b = 0.8 } },
		["buff_riptide"] 	 		= { buff = "Riptide", 			  pr = 6, mine = true,  color = { r = 0.0, g = 0.4, b = 0.8 } },
		["buff_earthliving"] 		= { buff = "Earth Living", 		  pr = 6, mine = true,  color = { r = 0.0, g = 0.8, b = 0.2 } },
		["buff_earthshield"] 		= { buff = "Earth Shield", 		  pr = 5, mine = false, color = { [1]  = { r = 0.0, g = 0.0, b = 0.0 },
																									  [2]  = { r = 0.1, g = 0.1, b = 0.1 },
																									  [3]  = { r = 0.2, g = 0.2, b = 0.2 },
																									  [4]  = { r = 0.3, g = 0.3, b = 0.3 },
																									  [5]  = { r = 0.4, g = 0.4, b = 0.4 },
																									  [6]  = { r = 0.5, g = 0.5, b = 0.5 },
																									  [7]  = { r = 0.6, g = 0.6, b = 0.6 },
																									  [8]  = { r = 0.7, g = 0.7, b = 0.7 },
																									  [9]  = { r = 0.8, g = 0.8, b = 0.8 },
																									  [10] = { r = 1.0, g = 1.0, b = 1.0} } },
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
			["buff_unholyaura"] = true,
			["buff_swiftbladescunning"] = true,
			["buff_unleashedrage"] = true,
			["buff_cacklinghowl"] = true,
			["buff_serpentsswiftness"] = true,
		},

		["BOTTOMRIGHTL"] = {
			["buff_graceofair"] = true,
			["buff_blessingofmight"] = true,
			["buff_spiritbeastblessing"] = true,
			["buff_roarofcourage"] = true,
		},

		["BOTTOMRIGHTT"] = {
			["buff_elementaloath"] = true,
			["buff_moonkinaura"] = true,
			["buff_shadowform"] = true,
		},

		["TOP"] = {
			["buff_earthshield"] = true,
		},

		["TOPL"] = {
			["buff_riptide"] = true,
		},

		["TOPR"] = {
			["buff_earthliving"] = true,
		},

		["RIGHT"] = {
			["buff_ancestralfortitude"] = true,
		},
	}
}

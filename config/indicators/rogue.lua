--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["ROGUE"] = {
	auras = {
		-- Common
		["dispel_magic"] 	= { debuff = "Magic",	pr = 80, mine = false, color = { r = 0.2, g = 0.6, b = 1.0} },
		["dispel_disease"] 	= { debuff = "Disease",	pr = 70, mine = false, color = { r = 0.6, g = 0.4, b = 0} },
		["dispel_poison"] 	= { debuff = "Poison",	pr = 60, mine = false, color = { r = 0, g = 0.6, b = 1.0} },
		["dispel_curse"] 	= { debuff = "Curse",	pr = 50, mine = false, color = { r = 0.6, g = 0, b = 1.0} },
		["buff_feigndeath"]	= { buff = "Feign Death", pr = 50, mine = false, text = "FEIGN" },

		-- Attack speed
		["buff_swiftbladescunning"]	= { buff = "Swiftblade's Cunning", 	pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } }, -- Attack Speed (Rogue)
		["buff_unholyaura"] 		= { buff = "Unholy Aura", 			pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } }, -- Attack Speed
		["buff_unleashedrage"] 		= { buff = "Unleashed Rage", 		pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } }, -- Attack Speed (Shaman)
		["buff_cacklinghowl"] 		= { buff = "Cackling Howl", 		pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } }, -- Attack Speed (Hunter - Hyena)
		["buff_serpentsswiftness"] 	= { buff = "Serpent's Swiftness", 	pr = 50, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } }, -- Attack Speed (Hunter - Wind Serpent)

		-- Specific
		["buff_tricksofthetrade"] = { buff = "Tricks of the Trade", pr = 1, mine = false, color = { r = 1.0, g = 0.8, b = 0.0 } },
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

		["TOP"] = {
			["buff_tricksofthetrade"] = true,
		},
	}
}

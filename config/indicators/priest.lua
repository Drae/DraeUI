--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["PRIEST"] = {
	auras = {
		-- Common
		["buff_resurrecting"] = { buff = "Resurrecting", pr = 50, mine = false, color = { r = 0, g = 1.0, b = 0.0 } },
		["buff_soulstone"]  = { buff = "Soulstone", pr = 55, mine = false, color = { r = 1.0, g = 0,   b = 0.4 } },
		["dispel_magic"] 	= { debuff = "Magic",	pr = 80, mine = false, color = { r = 0.2, g = 0.6, b = 1.0} },
		["dispel_disease"] 	= { debuff = "Disease",	pr = 70, mine = false, color = { r = 0.6, g = 0.4, b = 0} },
		["dispel_poison"] 	= { debuff = "Poison",	pr = 60, mine = false, color = { r = 0, g = 0.6, b = 1.0} },
		["dispel_curse"] 	= { debuff = "Curse",	pr = 50, mine = false, color = { r = 0.6, g = 0, b = 1.0} },
		["buff_feigndeath"]	= { buff = "Feign Death", pr = 50, mine = false, text = "FEIGN" },

		-- Stamina
		["buff_powerwordfortitude"] = { buff = "Power Word: Fortitude", pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Stamina
		["buff_bloodpact"] 			= { buff = "Blood Pact",   			pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Stamina (Warlock)
		["buff_commandingshout"] 	= { buff = "Commanding Shout",   	pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Stamina (Warrior)
		["buff_qirajifortitude"] 	= { buff = "Qiraji Fortitude",   	pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Stamina (Hunter - Qiraji)

		-- Spell haste
		["buff_shadowform"] 	= { buff = "Shadowform",   	 pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Spell Haste
		["buff_moonkinaura"] 	= { buff = "Moonkin Aura",   pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Spell Haste (Druid)
		["buff_elementaloath"] 	= { buff = "Elemental Oath", pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Spell Haste (Shaman)

		-- Specific
		["buff_painsuppression"] = { buff = "Pain Suppression", pr = 6, mine = false, color = { r = 1.0, g = 1.0, b = 1.0 } },
		["debuff_weakenedsoul"]  = { debuff = "Weakened Soul",  pr = 6, mine = false, color = { r = 1.0, g = 0, b = 0.0 } },
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
            ["buff_resurrecting"] = true,
            ["buff_soulstone"] = true,
		},

		["Text2"] = {
			["buff_feigndeath"] = true,
		},

		["BOTTOMRIGHT"] = {
			["buff_powerwordfortitude"] = true,
			["buff_bloodpact"] = true,
			["buff_commandingshout"] = true,
			["buff_qirajifortitude"] = true,
		},

		["BOTTOMRIGHTL"] = {
			["buff_shadowform"] = true,
			["buff_moonkinaura"] = true,
			["buff_elementaloath"] = true,
		},

		["BOTTOMLEFT"] = {
			["debuff_weakenedsoul"] = true,
		},

		["LEFT"] = {
			["buff_painsuppression"] = true,
		},
	}
}

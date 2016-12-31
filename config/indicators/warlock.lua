--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["WARLOCK"] = {
	auras = {
		-- Common
		["dispel_magic"] 	= { debuff = "Magic",	pr = 80, mine = false, color = { r = 0.2, g = 0.6, b = 1.0} },
		["dispel_disease"] 	= { debuff = "Disease",	pr = 70, mine = false, color = { r = 0.6, g = 0.4, b = 0} },
		["dispel_poison"] 	= { debuff = "Poison",	pr = 60, mine = false, color = { r = 0, g = 0.6, b = 1.0} },
		["dispel_curse"] 	= { debuff = "Curse",	pr = 50, mine = false, color = { r = 0.6, g = 0, b = 1.0} },
		["buff_feigndeath"]	= { buff = "Feign Death", pr = 50, mine = false, text = "FEIGN" },

		-- Spell power
		["buff_darkintent"] 		= { buff = "Dark Intent", 		 pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Spell Power (Warlock)
		["buff_arcanebrilliance"]  	= { buff = "Arcane Brilliance",  pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Spell Power + Crit
		["buff_dalaranbrilliance"] 	= { buff = "Dalaran Brilliance", pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Spell Power + Crit
		["buff_burningwrath"] 		= { buff = "Burning Wrath", 	 pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Spell Power (Shaman)
		["buff_stillwater"] 		= { buff = "Still Water", 		 pr = 5, mine = false, color = { r = 0.8, g = 0.8, b = 0.8 } },  -- Spell Power (Hunter - Wavestrider)

		-- Stamina
		["buff_bloodpact"] 			= { buff = "Blood Pact",   			pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Stamina (Warlock)
		["buff_powerwordfortitude"] = { buff = "Power Word: Fortitude", pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Stamina
		["buff_commandingshout"] 	= { buff = "Commanding Shout",   	pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Stamina (Warrior)
		["buff_qirajifortitude"] 	= { buff = "Qiraji Fortitude",   	pr = 5, mine = false, color = { r = 0, g = 0.4, b = 1.0 } },  -- Stamina (Hunter - Qiraji)
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
			["buff_darkintent"] = true,
			["buff_arcanebrilliance"] = true,
			["buff_dalaranbrilliance"] = true,
			["buff_burningwrath"] = true,
			["buff_stillwater"] = true,
		},

		["BOTTOMRIGHTL"] = {
			["buff_bloodpact"] = true,
			["buff_powerwordfortitude"] = true,
			["buff_commandingshout"] = true,
			["buff_qirajifortitude"] = true,
		},

	}
}

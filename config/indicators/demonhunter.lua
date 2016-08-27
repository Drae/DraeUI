--[[


--]]
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

P["DEMONHUNTER"] = {
	auras = {
		-- Common
		["dispel_magic"] 	= { debuff = "Magic",	pr = 80, mine = false, color = { r = 0.2, g = 0.6, b = 1.0} },
		["dispel_disease"] 	= { debuff = "Disease",	pr = 70, mine = false, color = { r = 0.6, g = 0.4, b = 0} },
		["dispel_poison"] 	= { debuff = "Poison",	pr = 60, mine = false, color = { r = 0, g = 0.6, b = 1.0} },
		["dispel_curse"] 	= { debuff = "Curse",	pr = 50, mine = false, color = { r = 0.6, g = 0, b = 1.0} },
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
		},

		["BOTTOMRIGHT"] = {
		},

		["BOTTOMRIGHTL"] = {
		},
	}
}

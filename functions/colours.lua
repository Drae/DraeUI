--[[

--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

--[[

--]]
oUF.colors.power["MANA"] 				= { 0,    0.56, 1.0  }
oUF.colors.power["RAGE"] 				= { 0.69, 0.31, 0.31 }
oUF.colors.power["FOCUS"] 				= { 0.71, 0.43, 0.27 }
oUF.colors.power["ENERGY"] 				= { 0.65, 0.63, 0.35 }
oUF.colors.power["RUNES"] 				= { 0.55, 0.57, 0.61 }
oUF.colors.power["RUNIC_POWER"] 		= { 0,    0.82, 1.0  }

oUF.colors.power[0] = oUF.colors.power["MANA"] -- AdditionalPower

oUF.colors.reaction[2] = { 1.0, 0,   0 }
oUF.colors.reaction[4] = { 1.0, 1.0, 0 }
oUF.colors.reaction[5] = { 0,   1.0, 0 }

oUF.colors.charmed 		= { 1.0, 0,   0.4 }
oUF.colors.disconnected = { 0.9, 0.9, 0.9 }
oUF.colors.tapped 		= { 0.6, 0.6, 0.6 }

oUF.colors.runes = {
	{ 0.77, 0.12, 0.23 };
	{ 0.40, 0.80, 0.10 };
	{ 0.00, 0.40, 0.70 };
	{ 0.80, 0.10, 1.00 };
}

oUF.colors.debuffTypes = {
	["Magic"]	= { 0.2, 0.6, 1.0 },
	["Curse"]	= { 0.6, 0.0, 1.0 },
	["Disease"]	= { 0.6, 0.4, 0.0 },
	["Poison"]	= { 0.0, 0.6, 0.0 },
}

--[[

--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

--[[

--]]

oUF.colors.power["ENERGY"]	    = {1, 	 0.96, 0.41 }
oUF.colors.power["FOCUS"] 		= {1, 	 0.50, 0.25 }
oUF.colors.power["FURY"] 		= {0.79, 0.26, 0.99, atlas = '_DemonHunter-DemonicFuryBar' }
oUF.colors.power["INSANITY"] 	= {0.4,  0,    0.8,  atlas = '_Priest-InsanityBar' }
oUF.colors.power["LUNAR_POWER"] = {0.3,  0.52, 0.9,  atlas = '_Druid-LunarBar' }
oUF.colors.power["MAELSTROM"] 	= {0, 	 0.5,  1, 	 atlas = '_Shaman-MaelstromBar' }
oUF.colors.power["MANA"] 		= {0, 	 0.56, 1.0 }
oUF.colors.power["PAIN"] 		= {1, 	 0.61, 0, 	 atlas = '_DemonHunter-DemonicPainBar' }
oUF.colors.power["RAGE"] 		= {0.78, 0.25, 0.25 }
oUF.colors.power["RUNIC_POWER"] = {0, 	 0.82, 1 }
oUF.colors.power["ALT_POWER"] 	= {0.2,  0.4,  0.8 }

oUF.colors.reaction[2] = { 1.0, 0,   0 }
oUF.colors.reaction[4] = { 1.0, 1.0, 0 }
oUF.colors.reaction[5] = { 0,   1.0, 0 }

oUF.colors.charmed 		= { 1.0, 0,   0.4 }
oUF.colors.disconnected = { 0.9, 0.9, 0.9 }
oUF.colors.tapped 		= { 0.6, 0.6, 0.6 }

oUF.colors.debuffTypes = {
	["Magic"]	= { 0.2, 0.6, 1.0 },
	["Curse"]	= { 0.6, 0.0, 1.0 },
	["Disease"]	= { 0.6, 0.4, 0.0 },
	["Poison"]	= { 0.0, 0.6, 0.0 },
}

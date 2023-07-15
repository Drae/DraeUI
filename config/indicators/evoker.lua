--[[


--]]
local DraeUI = select(2, ...)

DraeUI.class["EVOKER"] = {
    auras = {
        ["buff_blessingofthebronze"] 	= { buff = "Blessing of the Bronze",		mine = true,  color = { 0.8, 0.5, 0.0 } },
    },

    statusmap = {
		["RIGHTT"] = {
            ["buff_blessingofthebronze"] 	= 60,
		}
	}
}

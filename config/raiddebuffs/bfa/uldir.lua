local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Nighthold
UF["raiddebuffs"]["instances"]["Uldir"] = function()
	local zoneid = 0

	-- enable, spell, priority, secondary, pulse, flash

	UF:AddRaidDebuff(true, 244410, 8, true) -- ???????????

end

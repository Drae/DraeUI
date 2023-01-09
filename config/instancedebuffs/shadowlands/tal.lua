local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Tazavesh, the Veiled Market"] = function()
	--An Affront of Challengers
	UF:AddRaidDebuff(true, 333231, 5) --Searing Death


end

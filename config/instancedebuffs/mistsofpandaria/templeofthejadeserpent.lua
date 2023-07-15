local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Temple of the Jade Serpent"] = function()
	--Trash
	UF:AddRaidDebuff(true, 118714, 6) --Purified Water
	UF:AddRaidDebuff(true, 110125, 6) --Shattered Resolve
	UF:AddRaidDebuff(true, 128051, 6) --Serrated Slash
	UF:AddRaidDebuff(true, 114826, 6) --Songbird Serenade
	UF:AddRaidDebuff(true, 110099, 6) --Shadows of Doubt
	UF:AddRaidDebuff(true, 397911, 6) --Touch of Ruin

	--Wise Mari
	UF:AddRaidDebuff(true, 115167, 6) --
	UF:AddRaidDebuff(true, 143459, 6) --

	--Lorewalker Stonestep

	--Liu Flameheart
	UF:AddRaidDebuff(true, 106823, 6) --
	UF:AddRaidDebuff(true, 106841, 6) --
	UF:AddRaidDebuff(true, 107045, 6) --

	--Sha of Doubt
	UF:AddRaidDebuff(true, 106113, 6) --
end

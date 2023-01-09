local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- Auchindoun

UF["raiddebuffs"]["instances"]["Halls of Valor"] = function()
	UF:AddRaidDebuff(true, 199050, 6) --Mortal Hew
	UF:AddRaidDebuff(true, 199652, 6) --Sever
	UF:AddRaidDebuff(true, 198944, 6) --Breach Armor
	UF:AddRaidDebuff(true, 215430, 6) --Thunderstrike
	UF:AddRaidDebuff(true, 199674, 6) --Wicked Dagger
	UF:AddRaidDebuff(true, 199818, 6) --Crackle
	UF:AddRaidDebuff(true, 198959, 6) --Etch
	UF:AddRaidDebuff(true, 193702, 6) --Infernal Flames

	--Hymdall
	UF:AddRaidDebuff(true, 193092, 6) --Bloodletting Sweep

	--Fenryr
	UF:AddRaidDebuff(true, 196497, 6) --Ravenous Leap

	--God-King Skovald
	UF:AddRaidDebuff(true, 193660, 6) --Felblaze Rush

	--Odyn
end

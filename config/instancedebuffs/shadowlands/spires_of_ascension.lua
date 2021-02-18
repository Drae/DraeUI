local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Spires of Ascension"] = function()
	--Trash
	UF:AddRaidDebuff(true, 328453, 5) --Oppression
	UF:AddRaidDebuff(true, 317661, 5) --Insidious Venom
	UF:AddRaidDebuff(true, 328434, 5) --Intimidated
	UF:AddRaidDebuff(true, 317963, 5) --Burden of Knowledge
	UF:AddRaidDebuff(true, 327648, 5) --Internal Strife
	UF:AddRaidDebuff(true, 323744, 5) --Pounce
	UF:AddRaidDebuff(true, 328331, 5) --Forced Confession
	UF:AddRaidDebuff(true, 323739, 5) --Residual Impact

	--Kin-Tara
	UF:AddRaidDebuff(true, 327481, 5) --Dark Lance
	UF:AddRaidDebuff(true, 331251, 5) --Deep Connection
	UF:AddRaidDebuff(true, 324662, 5) --Ionized Plasma

	--Ventunax
	UF:AddRaidDebuff(true, 324154, 5) --Dark Stride

	--Oryphrion
	UF:AddRaidDebuff(true, 323195, 5) --Purifying Blast

	--Devos, Paragon of Doubt
	UF:AddRaidDebuff(true, 322818, 5) --Lost Confidence
	UF:AddRaidDebuff(true, 322817, 5) --Lingering Doubt
end

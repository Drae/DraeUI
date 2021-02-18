local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Sanguine Depths"] = function()
	--Kryxis the Voracious
	--UF:AddRaidDebuff(true, 340880, 5) --Prideful

	--Executor Tarvold
	UF:AddRaidDebuff(true, 328494, 5) --Sintouched Anima
	UF:AddRaidDebuff(true, 322554, 5) --Castigate
	UF:AddRaidDebuff(true, 323573, 5) --Residue

	--Grand Protector Beryllia
	UF:AddRaidDebuff(true, 328593, 5) --Agonize
	UF:AddRaidDebuff(true, 325885, 5) --Anguished Cries
	UF:AddRaidDebuff(true, 325254, 5) --Iron Spikes

	--General Kaal
	UF:AddRaidDebuff(true, 331415, 5) --Wicked Gash
	UF:AddRaidDebuff(true, 323845, 5) --Wicked Rush
end

local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Theater of Pain"] = function()
	--An Affront of Challengers
	UF:AddRaidDebuff(true, 333231, 5) --Searing Death
	UF:AddRaidDebuff(true, 326892, 5) --Fixate
	UF:AddRaidDebuff(true, 320069, 5) --Mortal Strike
	UF:AddRaidDebuff(true, 333540, 5) --Opportunity Strikes
	UF:AddRaidDebuff(true, 320248, 5) --Genetic Alteration
	UF:AddRaidDebuff(true, 320180, 5) --Noxious Spores

	--Gorechop
	UF:AddRaidDebuff(true, 323406, 5) --Jagged Gash
	UF:AddRaidDebuff(true, 323130, 5) --Coagulating Ooze
	UF:AddRaidDebuff(true, 321768, 4) --On the Hook
	UF:AddRaidDebuff(true, 323750, 5) --Vile Gas

	--Xav the Unfallen
	UF:AddRaidDebuff(true, 331606, 4) --Oppressive Banner
	UF:AddRaidDebuff(true, 320102, 4) --Blood and Glory
	UF:AddRaidDebuff(true, 332670, 4) --Glorious Combat

	--Kul'tharok"
	UF:AddRaidDebuff(true, 319567, 5) --Grasping Hands
	UF:AddRaidDebuff(true, 319626, 5) --Phantasmal Parasite
	UF:AddRaidDebuff(true, 319539, 5) --Soulless

	--Mordretha, the Endless Empress
	UF:AddRaidDebuff(true, 323825, 5) --Grasping Rift
	UF:AddRaidDebuff(true, 324449, 5) --Manifest Death
	UF:AddRaidDebuff(true, 323831, 5) --Death Grasp
end

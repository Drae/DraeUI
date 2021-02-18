local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["The Necrotic Wake"] = function()
	-- Trash
	UF:AddRaidDebuff(true, 334749, 5) --Drain Fluids
	UF:AddRaidDebuff(true, 327399, 6, true) -- Share Agony (Nar'zudah)
	UF:AddRaidDebuff(true, 338357, 8) -- Tenderize

	--Blightbone
	UF:AddRaidDebuff(true, 320631, 5) --Carrion Eruption
	UF:AddRaidDebuff(true, 320717, 5) --Blood Hunger
	UF:AddRaidDebuff(true, 320596, 5) --Heaving Retch
	UF:AddRaidDebuff(true, 320646, 5) --Fetid Gas

	--Amarth, the Harvester
	UF:AddRaidDebuff(true, 320170, 5) --Necrotic Bolt
	UF:AddRaidDebuff(true, 328664, 5) --Chilled
	UF:AddRaidDebuff(true, 333492, 5) --Necrotic Ichor
	UF:AddRaidDebuff(true, 333489, 5) --Necrotic Breath
	UF:AddRaidDebuff(true, 333633, 5, true) --Tortured Echoes

	--Surgeon Stitchflesh
	UF:AddRaidDebuff(true, 333485, 5) --Disease Cloud
	UF:AddRaidDebuff(true, 320200, 5) --Stitchneedle
	UF:AddRaidDebuff(true, 322681, 5) --Meat Hook
	UF:AddRaidDebuff(true, 320366, 5) --Embalming Ichor
	UF:AddRaidDebuff(true, 343556, 6, true) --Morbid Fixation
	UF:AddRaidDebuff(true, 338610, 6, true) -- Morbid Fixation

	--Nalthor the Rimebinder
	UF:AddRaidDebuff(true, 328181, 4) --Frigid Cold
	UF:AddRaidDebuff(true, 321755, 5) --Icebound Aegis
	UF:AddRaidDebuff(true, 320788, 5) --Frozen Binds
	UF:AddRaidDebuff(true, 322274, 5) --Enfeeble
	UF:AddRaidDebuff(true, 328212, 5) --Razorshard Ice
	UF:AddRaidDebuff(true, 321894, 5, true) --Dark Exile
end

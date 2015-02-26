local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Bloodmaul Slag Mines

UF["raiddebuffs"]["instances"]["Bloodmaul Slag Mines"] = function()
	-- Slave Watcher Crushto
	UF:AddRaidDebuff(true, 153679, 6) -- Earth Crush
	UF:AddRaidDebuff(true, 150745, 6) -- Crushing Leap
	UF:AddRaidDebuff(true, 150807, 6) -- Traumatic Strike

	-- Forgemaster Gog'duh/Magmolatus
	UF:AddRaidDebuff(true, 150011, 6) -- Magma Barrage
	UF:AddRaidDebuff(true, 149975, 6) -- Dancing Flames
	UF:AddRaidDebuff(true, 149997, 6) -- Firestorm
	UF:AddRaidDebuff(true, 150032, 6) -- Withering Flames
	UF:AddRaidDebuff(true, 150034, 6) -- Choking Ashes causedby Withering Flames
	UF:AddRaidDebuff(true, 150011, 6) -- Magma Barrage

	-- Roltall
	UF:AddRaidDebuff(true, 167739, 6, true) -- Scorching Aura

	-- Gug'rokk
	UF:AddRaidDebuff(true, 150784, 6, true) -- Magma Eruption
end

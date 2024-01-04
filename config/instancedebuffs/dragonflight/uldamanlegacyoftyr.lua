local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Uldaman: Legacy of Tyr"] = function()
	-- The Lost Dwarves
	UF:AddRaidDebuff(true, 377825, 5) --burning-pitch
	UF:AddRaidDebuff(true, 375286, 5) --searing-cannonfire

	-- Bromach
	UF:AddRaidDebuff(true, 369660, 5) --tremor

	-- Sentinel Talondras
	UF:AddRaidDebuff(true, 372652, 5) --resonating-orb

	-- Emberon
	UF:AddRaidDebuff(true, 369110, 5) --unstable-embers
	UF:AddRaidDebuff(true, 369025, 5) --fire-wave

	-- Chrono-Lord Deios
	UF:AddRaidDebuff(true, 376325, 5) --eternity-zone
	UF:AddRaidDebuff(true, 377405, 5) --time-sink
end

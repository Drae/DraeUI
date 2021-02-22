local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- Shadowmoon Burial Grounds

UF["raiddebuffs"]["instances"]["Shadowmoon Burial Grounds"] = function()
	-- Sadana Bloodfury
	UF:AddRaidDebuff(true, 153240, 6, true) -- Daggerfall
	UF:AddRaidDebuff(true, 162652, 5, true) -- Lunar parity (buff)

	-- Nhallish
	UF:AddRaidDebuff(true, 153692, 5) -- Necrotic Pitch
	UF:AddRaidDebuff(true, 152979, 5, true) -- Soul Shred
	UF:AddRaidDebuff(true, 153033, 5, true) -- Returned Soul

	-- Bonemaw
	UF:AddRaidDebuff(true, 153692, 5) -- Necrotic Pitch

	-- Ner'zhul
	UF:AddRaidDebuff(true, 154442, 5, true) -- Malevonence
end

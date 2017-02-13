local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Auchindoun

UF["raiddebuffs"]["instances"]["Auchindoun"] = function()
	-- Trash
	UF:AddRaidDebuff(true, 157168, 6, true) -- Fixate (Abyssal)

	-- Vigilant Kaathar
	UF:AddRaidDebuff(true, 152954, 6) -- Sanctified Strike

	-- Nyami
	UF:AddRaidDebuff(true, 155327, 6, true) -- Soul Vessel
	UF:AddRaidDebuff(true, 154477, 6) -- Shadow Word: Pain
	UF:AddRaidDebuff(true, 154218, 6) -- Arbiter's Hammer
	UF:AddRaidDebuff(true, 176931, 6) -- Crusader Strike

	-- Azzakel
	UF:AddRaidDebuff(true, 153727, 6) -- Fel Lash
	UF:AddRaidDebuff(true, 153392, 6) -- Curtain of Flame
	UF:AddRaidDebuff(true, 154018, 6) -- Conflagration
	UF:AddRaidDebuff(true, 153500, 6) -- Fel Pool

	-- Terongor
	UF:AddRaidDebuff(true, 156921, 6, true) -- Seed of Malevonence
	UF:AddRaidDebuff(true, 156921, 6) -- Drain Life
	UF:AddRaidDebuff(true, 156842, 6) -- Corruption
	UF:AddRaidDebuff(true, 156964, 6) -- Immolate
	UF:AddRaidDebuff(true, 156857, 6) -- Rain of Fire
	UF:AddRaidDebuff(true, 164841, 6) -- Curse of Exhaustion
end

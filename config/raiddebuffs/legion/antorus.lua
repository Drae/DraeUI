local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Nighthold
UF["raiddebuffs"]["instances"]["Antorus, the Burning Throne"] = function()
	local zoneid = 1188

	-- enable, spell, priority, secondary, pulse, flash

	-- Worldbreaker
	UF:AddRaidDebuff(true, 244410, 8, true) -- Decimation

	-- Doggies
	UF:AddRaidDebuff(true, 248815, 8) -- Enflamed
	UF:AddRaidDebuff(true, 244071, 9, nil, true) -- Weight of Darkness
	UF:AddRaidDebuff(true, 244086, 9, nil, true) -- Molten Touch
	UF:AddRaidDebuff(true, 254747, 9) -- Burning Maw
	UF:AddRaidDebuff(true, 254760, 9) -- Corrupting Maw

	-- Antoran High Command
	UF:AddRaidDebuff(true, 244172, 8) -- Psychic Assault (pod debuff)
	UF:AddRaidDebuff(true, 253290, 5) -- Entropic Blast (mine explosion)

	-- Portal Keeper
	UF:AddRaidDebuff(true, 244016, 7) -- Reality Tear (tanks)
	UF:AddRaidDebuff(true, 244709, 7) -- Fiery Detonation
	UF:AddRaidDebuff(true, 244926, 7) -- Fel Silk Wrap
	UF:AddRaidDebuff(true, 245040, 7) -- Corrupt

	-- Imonar
	UF:AddRaidDebuff(true, 247552, 7) -- Sleep Canister
	UF:AddRaidDebuff(true, 247716, 7, nil, true) -- Charged Blast

	-- Kin'garoth
	UF:AddRaidDebuff(true, 254919, 7) -- Forging Strike

	-- Eonar

	-- Varimathras
	UF:AddRaidDebuff(true, 243961, 8, true) 		-- Misery (prevents healing)
	UF:AddRaidDebuff(true, 244042, 8) 				-- Marked Pray
	UF:AddRaidDebuff(true, 243974, 8, nil, true) 	-- Torment of Shadows (prevents healing)
	UF:AddRaidDebuff(true, 243979, 8) 				-- Torment of Fel (heroic)
	UF:AddRaidDebuff(true, 244093, 8, nil, true) 	-- Necrotic Embrace (heroic)

	-- Coven
	UF:AddRaidDebuff(true, 244899, 7, true) -- Fiery Strike (tank)
	UF:AddRaidDebuff(true, 245586, 7) 		-- Chilled Blood
	UF:AddRaidDebuff(true, 253752, 6) 		-- Sense of Dread (stacks)
	UF:AddRaidDebuff(true, 250095, 6) 		-- Machinations of Aman'Thul
	UF:AddRaidDebuff(true, 245518, 8) 		-- Flash Freeze (tanks)
	UF:AddRaidDebuff(true, 253429, 8) 		-- Fulminating Pulse (heroic)

	-- Aggramar

	-- Argus the unmaker
	UF:AddRaidDebuff(true, 251570, 8, true) -- Soul Bomb
	UF:AddRaidDebuff(true, 250669, 7) -- Soulburst

end

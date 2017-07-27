local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Nighthold
UF["raiddebuffs"]["instances"]["Tomb of Sargeras"] = function()
	local zoneid = 1147

	-- enable, spell, priority, secondary, pulse, flash

	-- Goroth
	UF:AddRaidDebuff(true, 230345, 6) -- Crashing Comet
	UF:AddRaidDebuff(true, 231363, 6) -- Burning Armor
	UF:AddRaidDebuff(true, 233279, 7, true) -- Shattering Star

	-- Demonic Inquisition
	UF:AddRaidDebuff(true, 233430, 5) -- Ubearable Torment
	UF:AddRaidDebuff(true, 233983, 6) -- Echoing Anguish

	-- Harjatan
	UF:AddRaidDebuff(true, 231998, 6) -- Jagged Abrasion
	UF:AddRaidDebuff(true, 231729, 6) -- Aqueous Burst
	UF:AddRaidDebuff(true, 231768, 5) -- Drenching Waters (from above)
	UF:AddRaidDebuff(true, 231770, 5, true) -- Drenched

	-- Sisters of the Moon
	UF:AddRaidDebuff(true, 236550, 7) -- Discorporate (tank healing reduced)
	UF:AddRaidDebuff(true, 239264, 7) -- Lunar Fire (tank - stacking)
	UF:AddRaidDebuff(true, 233263, 6) -- Embrace of the Eclipse (absorb shield)
	UF:AddRaidDebuff(true, 234996, 5, true) -- Umbra Suffusion (stacking incr. other damage)
	UF:AddRaidDebuff(true, 234995, 5, true) -- Lunar Suffusion (stacking incr. other damage)
	UF:AddRaidDebuff(true, 236603, 8, nil, nil, true) -- Rapid Shot (target healing reqd)
	UF:AddRaidDebuff(true, 236519, 8, nil, nil, true) -- Moon Burn (target healing reqd)
	UF:AddRaidDebuff(true, 236712, 8, nil, nil, true) -- Lunar Beacon (target healing reqd)
	UF:AddRaidDebuff(true, 236541, 8, nil, nil, true) -- Twilight Glaive (target healing reqd)

	-- The Desolate Host
	UF:AddRaidDebuff(true, 236072, 6) -- Wailing Souls
	UF:AddRaidDebuff(true, 235989, 6) -- Tormented Cries
	UF:AddRaidDebuff(true, 236361, 6) -- Spirit Chains (BoF peeps)
	UF:AddRaidDebuff(true, 236449, 7, true) -- Soulbind (players need to stack)
	UF:AddRaidDebuff(true, 235933, 8, true) -- Spear of Anguish
	UF:AddRaidDebuff(true, 236135, 8, true) -- Wither (switch realms)
	UF:AddRaidDebuff(true, 236515, 8, nil, nil, true) -- Shattering Scream

	-- Mistress Sassz'ine
	UF:AddRaidDebuff(true, 230959, 6) -- Concealing Murk
	UF:AddRaidDebuff(true, 232722, 6) -- Slicing Tornado
	UF:AddRaidDebuff(true, 234621, 6) -- Devouring Maw
	UF:AddRaidDebuff(true, 230201, 6) -- Burden of Pain
	UF:AddRaidDebuff(true, 230276, 8) -- Jaws from the deep (heroic)
	UF:AddRaidDebuff(true, 232913, 6, true) -- Befouling Ink
	UF:AddRaidDebuff(true, 232754, 8, true) -- Thundering Shock
	UF:AddRaidDebuff(true, 230358, 7, nil, nil, true) -- Thundering Shock

	-- Maiden of Vigilance
	UF:AddRaidDebuff(true, 235117, 6) -- Unstable Soul
	UF:AddRaidDebuff(true, 235534, 6) -- Creator's Grace
	UF:AddRaidDebuff(true, 235538, 6) -- Demon's Vigor
	UF:AddRaidDebuff(true, 234891, 6) -- Wrath of the Creators
	UF:AddRaidDebuff(true, 235569, 6) -- Hammer of Creation
	UF:AddRaidDebuff(true, 235573, 6) -- Hammer of Obliteration

	-- Fallen Avatar
	UF:AddRaidDebuff(true, 239058, 6) -- Touch of Sargeras
	UF:AddRaidDebuff(true, 239739, 6) -- Dark Mark
	UF:AddRaidDebuff(true, 234059, 6) -- Unbound Chaos
	UF:AddRaidDebuff(true, 240213, 6) -- Chaos Flames
	UF:AddRaidDebuff(true, 236604, 6) -- Shadowy Blades
	UF:AddRaidDebuff(true, 236494, 6) -- Desolate

	-- Kil'jaeden
	UF:AddRaidDebuff(true, 238999, 6) -- Darkness of a Thousand Souls
	UF:AddRaidDebuff(true, 239155, 7) -- Gravity Squeeze
	UF:AddRaidDebuff(true, 234295, 6) -- Armageddon Rain
	UF:AddRaidDebuff(true, 240908, 6) -- Armageddon Blast
	UF:AddRaidDebuff(true, 239932, 8) -- Felclaws
	UF:AddRaidDebuff(true, 240911, 6) -- Armageddon Hail

end

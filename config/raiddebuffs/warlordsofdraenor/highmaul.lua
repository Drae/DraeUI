local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Highmaul

UF["raiddebuffs"]["instances"]["Highmaul"] = function()
	-- The Butcher
	UF:AddRaidDebuff(true, 156152, 5, true) -- GUSHINGWOUNDS
	UF:AddRaidDebuff(true, 156151, 6) 		-- THETENDERIZER
	UF:AddRaidDebuff(true, 156143, 5, true) -- THECLEAVER
	UF:AddRaidDebuff(true, 163046, 5) 		-- PALEVITRIOL

	-- Kargath Bladefist
	UF:AddRaidDebuff(true, 159113, 5) -- IMPALE
	UF:AddRaidDebuff(true, 159178, 6) -- OPENWOUNDS
	UF:AddRaidDebuff(true, 159213, 7) -- MONSTERSBRAWL
	UF:AddRaidDebuff(true, 158986, 8, true) -- BERSERKERRUSH
	UF:AddRaidDebuff(true, 159410, 5) -- MAULINGBREW
	UF:AddRaidDebuff(true, 160521, 6) -- VILEBREATH
	UF:AddRaidDebuff(true, 159386, 5) -- IRONBOMB
	UF:AddRaidDebuff(true, 159188, 5) -- GRAPPLE
	UF:AddRaidDebuff(true, 162497, 8, true) -- ONTHEHUNT
	UF:AddRaidDebuff(true, 159202, 5) -- FLAME JET

	-- Twin Ogron
	UF:AddRaidDebuff(true, 158026, 6) 		-- ENFEEBLINGROAR
	UF:AddRaidDebuff(true, 158241, 5) 		-- BLAZE
	UF:AddRaidDebuff(true, 155569, 8) 		-- INJURED
	UF:AddRaidDebuff(true, 167200, 7) 		-- ARCANEWOUND
	UF:AddRaidDebuff(true, 167186, 7) 		-- ARCANEBASH
	UF:AddRaidDebuff(true, 159709, 6) 		-- WEAKENEDDEFENSES 159709 167179
	UF:AddRaidDebuff(true, 163374, 4, true) -- ARCANEVOLATILITY

	-- Ko'ragh
	UF:AddRaidDebuff(true, 161242, 4) -- CAUSTICENERGY
	UF:AddRaidDebuff(true, 161358, 4) -- SUPPRESSION FIELD
	UF:AddRaidDebuff(true, 162184, 6) -- EXPELMAGICSHADOW
	UF:AddRaidDebuff(true, 162186, 6) -- EXPELMAGICARCANE
	UF:AddRaidDebuff(true, 161411, 6) -- EXPELMAGICFROST
	UF:AddRaidDebuff(true, 163472, 4) -- DOMINATINGPOWER
	UF:AddRaidDebuff(true, 162185, 7) -- EXPELMAGICFEL

	-- Tectus
	UF:AddRaidDebuff(true, 162892, 5) -- INFESTINGSPORES--PETRIFICATION

	-- Brackenspore
	UF:AddRaidDebuff(true, 163242, 5, true) -- INFESTINGSPORES
	UF:AddRaidDebuff(true, 163590, 5) 		-- CREEPINGMOSS
	UF:AddRaidDebuff(true, 163241, 7) 		-- ROT
	UF:AddRaidDebuff(true, 163240, 5, true) -- ROT2
	UF:AddRaidDebuff(true, 159220, 4) 		-- NECROTICBREATH
	UF:AddRaidDebuff(true, 160179, 6) 		-- MINDFUNGUS
	UF:AddRaidDebuff(true, 159972, 6, true) -- FLESHEATER

	-- Imperator Mar'gok
	UF:AddRaidDebuff(true, 156238, 4) 		-- BRANDED  156238 163990 163989 163988
	UF:AddRaidDebuff(true, 156467, 5) 		-- DESTRUCTIVERESONANCE  156467 164075 164076 164077
	UF:AddRaidDebuff(true, 157349, 5) 		-- FORCENOVA  157349 164232 164235 164240
	UF:AddRaidDebuff(true, 158605, 4) 		-- MARKOFCHAOS  158605 164176 164178 164191
	UF:AddRaidDebuff(true, 157763, 4) 		-- FIXATE
	UF:AddRaidDebuff(true, 158553, 6, true) -- CRUSHARMOR
end

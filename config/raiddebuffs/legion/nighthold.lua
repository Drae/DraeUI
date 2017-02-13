local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Nighthold
UF["raiddebuffs"]["instances"]["The Nighthold"] = function()
	local zoneid = 1088

	-- enable, spell, priority, secondary, pulse, flash

	-- Skorpyron
	UF:AddRaidDebuff(true, 204766, 5) -- Energy Surge (non-dispellable, stacks) (DMG + Debuff)
	UF:AddRaidDebuff(true, 214657, 5) -- Acidic Fragments (non-dispellable) (DMG + Debuff)
	UF:AddRaidDebuff(true, 214662, 5) -- Volatile Fragments (non-dispellable) (DMG + Debuff)
	UF:AddRaidDebuff(true, 211659, 5, true) -- Arcane Tether - tanking debuff
	UF:AddRaidDebuff(true, 204471, 5) -- Focused Blast (non-dispellable) (Frontal Cone AoE)

	-- Chronomatic Anomaly
	UF:AddRaidDebuff(true, 206607, 5) -- Chronometric Particles (non-dispellable, stacks) (Stacking DoT)
	UF:AddRaidDebuff(true, 206609, 5) -- Time Release (non-dispellable) (heal absorb)
	UF:AddRaidDebuff(true, 219964, 6) -- Time Release - Green
	UF:AddRaidDebuff(true, 219965, 7) -- Time Release - Yellow
	UF:AddRaidDebuff(true, 219966, 8) -- Time Release - Red
	UF:AddRaidDebuff(true, 212099, 5) -- Temporal Charge (non-dispellable) (DoT)

	-- Trilliax
	UF:AddRaidDebuff(true, 206482, 4) -- Arcane Seepage (non-dispellable) (Ground AoE)
	UF:AddRaidDebuff(true, 206641, 6) -- Arcane Slash (non-dispellable) (stacks)
	UF:AddRaidDebuff(true, 206788, 5) -- Toxic Slice (non-dispellable) (DMG + Debuff Stacking DoT)
	UF:AddRaidDebuff(true, 214573, 5, true) -- Stuffed (heroic+)
	UF:AddRaidDebuff(true, 208910, 6, true) -- Arcing Bonds
	UF:AddRaidDebuff(true, 207502, 6) -- Succulent Feast (shield) - buff??
	UF:AddRaidDebuff(true, 214582, 4) -- Sterilize - buff??

	-- Spellblade Aluriel
	UF:AddRaidDebuff(true, 212492, 5) -- Annihilate (non-dispellable) (DMG + Tank Debuff)
	UF:AddRaidDebuff(true, 212587, 5, true) -- Mark of Frost
	UF:AddRaidDebuff(true, 213166, 5, true) -- Searing Brand
	UF:AddRaidDebuff(true, 213083, 5) -- Frozen Tempest (non-dispellable) (DoT)

	-- Star Augur Etraeus
	UF:AddRaidDebuff(true, 214167, 5, true) -- Gravitational Pull (tank debuff)
	UF:AddRaidDebuff(true, 206404, 8) 		-- P0 - Coronal Ejection - becomes one of the other ejections in later phases
	UF:AddRaidDebuff(true, 206585, 6) 		-- P1 - Absolute Zero
	UF:AddRaidDebuff(true, 206589, 5, true) -- P1 - Chilled (Heroic)
	UF:AddRaidDebuff(true, 206936, 7) 		-- P1 - Icy Ejection (non-dispellable, stacks) (DoT + Slow-to-Stun)
	UF:AddRaidDebuff(true, 206388, 8) 		-- P2 - Felburst (non-dispellable, stacks) (DMG + DoT)
	UF:AddRaidDebuff(true, 205649, 6) 		-- P2 - Fel Ejection (non-dispellable, stacks) (DMG + DoT)
	UF:AddRaidDebuff(true, 206965, 7) 		-- P3 - Voidburst (non-dispellable) (DoT)
	UF:AddRaidDebuff(true, 207143, 8) 		-- P3 - Void Ejection (non-dispellable) (DMG + DoT)

	-- High Botanist Tel'arn
	UF:AddRaidDebuff(true, 218502, 5) -- Recursive Strikes (non-dispellable, stacks) (Increases DMG Taken)
	UF:AddRaidDebuff(true, 219049, 5) -- Toxic Spores (non-dispellable) (Ground AoE)
	UF:AddRaidDebuff(true, 218424, 5) -- Parasitic Fetter (dispellable) (Root + Increaseing DMG)
	UF:AddRaidDebuff(true, 218807, 8, true) -- Call of Night

	-- Krosus
	UF:AddRaidDebuff(true, 208203, 5) -- Isolated Rage (non-dispellable) (Ground AoE Not Avoidable)

	-- Tichondrius
	UF:AddRaidDebuff(true, 206480, 5) -- Carrion Plague (non-dispellable) (DoT)
	UF:AddRaidDebuff(true, 213238, 5) -- Seeker Swarm (non-dispellable) (DMG + Adds Carrion Plague DoT)
	UF:AddRaidDebuff(true, 212795, 5) -- Brand of Argus (non-dispellable) (Explodes if players clump)
	UF:AddRaidDebuff(true, 208230, 5) -- Feast of Blood (non-dispellable) (Increases DMG Taken)
	UF:AddRaidDebuff(true, 216024, 5) -- Volatile Wound (non-dispellable, Stacks) (DMG + Increases Future DMG Taken)
	UF:AddRaidDebuff(true, 216040, 5) -- Burning Soul (dispellable) (DMG + Mana Drain + Explode on Dispell)

	-- Grand Magistrix Elisande
	UF:AddRaidDebuff(true, 209165, 5, true) -- Slow time
	UF:AddRaidDebuff(true, 209166, 5, true) -- Fast time
	UF:AddRaidDebuff(true, 209433, 5) -- Spanning Singularity  - pools
	UF:AddRaidDebuff(true, 225654, 5) -- Delphuric Beam
	UF:AddRaidDebuff(true, 211258, 5) -- Permeliative Torment
	UF:AddRaidDebuff(true, 209973, 8) -- Ablating Explosion - Tank debuff

	-- Gul'dan
	UF:AddRaidDebuff(true, 212568, 8, nil, true) -- Drain (dispellable) (Life Steal)
	UF:AddRaidDebuff(true, 206883, 5) -- Soul Vortex (non-dispellable, stacks) (AoE DMG + DoT)
	UF:AddRaidDebuff(true, 206222, 5, true) -- Bonds of Fel (non-dispellable) (chain + Slow + Explosion when seperated)
	UF:AddRaidDebuff(true, 206221, 7, true) -- Empowered Bonds of Fel (non-dispellable) (chain + Slow + Explosion when seperated)
	UF:AddRaidDebuff(true, 208672, 5) -- Carrion Wave (non-dispellable) (AoE DMG + Sleep)
	UF:AddRaidDebuff(true, 208903, 5) -- Burning Claws (non-dispellable) (ground AoE)
	UF:AddRaidDebuff(true, 208802, 5, nil, nil, true) -- Soul Corrosion (non-dispellable) (DMG + DoT)

end

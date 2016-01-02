local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Hellfire Citadel

UF["raiddebuffs"]["instances"]["Hellfire Citadel"] = function()
	-- Hellfire Assault
	UF:AddRaidDebuff(true, 184369, 5) -- Howling Axe (Target)
	UF:AddRaidDebuff(true, 180079, 5, true) -- Felfire Munitions
	UF:AddRaidDebuff(true, 184238, 5) -- Cower!
	UF:AddRaidDebuff(true, 184243, 5) -- Slam (Tank - stacks)

	-- Iron Reaver
	UF:AddRaidDebuff(true, 179897, 5) -- Blitz
	UF:AddRaidDebuff(true, 185978, 5) -- Firebomb Vulnerability
	UF:AddRaidDebuff(true, 182373, 5) -- Flame Vulnerability
	UF:AddRaidDebuff(true, 182074, 6) -- Immolation
	UF:AddRaidDebuff(true, 182280, 5, true) -- Artillery
	UF:AddRaidDebuff(true, 182001, 5, true) -- Unstable Orb

	-- Kormrok
	UF:AddRaidDebuff(true, 181306, 5) --Explosive Burst
	UF:AddRaidDebuff(true, 181321, 5) --Fel Touch
	UF:AddRaidDebuff(true, 187122, 5, true) -- Primal Energies
	UF:AddRaidDebuff(true, 187819, 5) -- Crush
	UF:AddRaidDebuff(true, 181345, 5) -- Foul Crush

	-- Hellfire High Council
	UF:AddRaidDebuff(true, 184358, 9, true) -- Fel Rage
	UF:AddRaidDebuff(true, 184360, 9, true) -- Fel Rage
	UF:AddRaidDebuff(true, 184449, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 185065, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 184450, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 185066, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 184676, 5) -- Mark of the Necromancer
	UF:AddRaidDebuff(true, 184652, 5) -- Reap
	UF:AddRaidDebuff(true, 184355, 8, true) -- Bloodboil
	UF:AddRaidDebuff(true, 190553, 8, true) -- Bloodboil

	-- Kilrogg Deadeye
	UF:AddRaidDebuff(true, 182159, 6, true) --Fel Corruption
	UF:AddRaidDebuff(true, 182428, 6, true) --Fel Corruption
	UF:AddRaidDebuff(true, 184551, 6, true) --Fel Corruption
	UF:AddRaidDebuff(true, 181488, 5) -- Vision of Death
	UF:AddRaidDebuff(true, 188929, 5, true) -- Heart Seeker (Target)
	UF:AddRaidDebuff(true, 180389, 5) -- Heart Seeker (DoT)

	-- Gorefiend
	UF:AddRaidDebuff(true, 179867, 5, true) -- Gorefiend's Corruption
--	UF:AddRaidDebuff(true, 181295, 5) -- Digest
--	UF:AddRaidDebuff(true, 179978, 6, true) -- Touch of Doom
--	UF:AddRaidDebuff(true, 179977, 5, true) -- Touch of Doom
	UF:AddRaidDebuff(true, 179864, 5, true) -- Shadow of Death
	UF:AddRaidDebuff(true, 179909, 8) -- Shared Fate (self root)
	UF:AddRaidDebuff(true, 179908, 8) -- Shared Fate (other players root)

	-- Shadow-Lord Iskar
	UF:AddRaidDebuff(true, 179202, 8, true) --Eye of Anzu
	UF:AddRaidDebuff(true, 181957, 5) -- Phantasmal Winds
	UF:AddRaidDebuff(true, 182323, 5) -- Phantasmal Wounds
	UF:AddRaidDebuff(true, 182325, 5) -- Phantasmal Wounds
	UF:AddRaidDebuff(true, 185239, 5) -- Radiance of Anzu
--	UF:AddRaidDebuff(true, 185510, 5) -- Dark Bindings
	UF:AddRaidDebuff(true, 182600, 8) -- Fel Fire
	UF:AddRaidDebuff(true, 181753, 9, true) -- Fel Bomb

-- Soulbound Construct (Socrethar)
	UF:AddRaidDebuff(true, 189531, 5) -- Soulbane (Trash)
	UF:AddRaidDebuff(true, 182038, 5) -- Shattered Defenses
	UF:AddRaidDebuff(true, 182635, 5) -- Shattered Defences
	UF:AddRaidDebuff(true, 188666, 5) -- Eternal Hunger (Add fixate, Mythic only)
	UF:AddRaidDebuff(true, 180415, 5) -- Fel Prison
	UF:AddRaidDebuff(true, 185185, 5) -- Fel Prison
	UF:AddRaidDebuff(true, 189627, 5, true) -- Volatile Fel Orb fixate
	UF:AddRaidDebuff(true, 184124, 5) -- Gift of the Man'ari (Fel Dominator)
	UF:AddRaidDebuff(true, 184239, 5) -- Shadow Word: Agony (Sargerei Shadowcaller)

-- Tyrant Velhari
	UF:AddRaidDebuff(true, 180166, 6) -- Touch of Harm
	UF:AddRaidDebuff(true, 185237, 5) -- Touch of Harm
	UF:AddRaidDebuff(true, 185238, 5) -- Touch of Harm
	UF:AddRaidDebuff(true, 180128, 6) -- Edict of Condemnation
	UF:AddRaidDebuff(true, 185241, 5) -- Edict of Condemnation
	UF:AddRaidDebuff(true, 180526, 5) -- Font of Corruption

-- Fel Lord Zakuun
	UF:AddRaidDebuff(true, 181653, 5) -- Fel Crystals (Too Close)
	UF:AddRaidDebuff(true, 179428, 5) -- Rumbling Fissure (Soak)
	UF:AddRaidDebuff(true, 179407, 5) -- Disembodied (Player in Shadow Realm)
	UF:AddRaidDebuff(true, 182008, 4, true) -- Latent Energy
	UF:AddRaidDebuff(true, 189030, 9)       -- Befouled
	UF:AddRaidDebuff(true, 181508, 6)       --Seed of Destruction

-- Xhul'horac
	UF:AddRaidDebuff(true, 188208, 7) -- Ablaze
	UF:AddRaidDebuff(true, 186073, 5) -- Felsinged
	UF:AddRaidDebuff(true, 186407, 5) -- Fel Surge
	UF:AddRaidDebuff(true, 186490, 6, true) -- Chains of Fel
	UF:AddRaidDebuff(true, 186500, 5, true) -- Chains of Fel
	UF:AddRaidDebuff(true, 186063, 5) -- Wasting Void
	UF:AddRaidDebuff(true, 186333, 5) -- Void Surge
	UF:AddRaidDebuff(true, 186546, 6) -- Black Hole

-- Mannoroth
	UF:AddRaidDebuff(true, 181275, 5) -- Curse of the Legion
	UF:AddRaidDebuff(true, 181099, 5) -- Mark of Doom
	UF:AddRaidDebuff(true, 181597, 6) -- Mannoroth's Gaze
	UF:AddRaidDebuff(true, 182006, 6) -- Empowered Mannoroth's Gaze
	UF:AddRaidDebuff(true, 181841, 5) -- Shadowforce
	UF:AddRaidDebuff(true, 182088, 5) -- Empowered Shadowforce
	UF:AddRaidDebuff(true, 186362, 5, true) -- Wrath of Guldan
	UF:AddRaidDebuff(true, 186348, 5, true) -- Wrath of Guldan
	UF:AddRaidDebuff(true, 186374, 5, true) -- Wrath of Guldan
    UF:AddRaidDebuff(true, 186350, 4) -- Gripping Shadows

-- Archimonde
	UF:AddRaidDebuff(true, 184964, 5) -- Shackled Torment
--	UF:AddRaidDebuff(true, 186123, 5) -- Wrought Chaos
--	UF:AddRaidDebuff(true, 185014, 5) -- Focused Chaos
	UF:AddRaidDebuff(true, 182879, 5, true) -- Doomfire Fixate
	UF:AddRaidDebuff(true, 183586, 5) -- Doomfire
	UF:AddRaidDebuff(true, 186952, 5) -- Nether Banish
	UF:AddRaidDebuff(true, 189891, 5) -- Nether Tear
	UF:AddRaidDebuff(true, 183634, 5) -- Shadowfel Burst
	UF:AddRaidDebuff(true, 189895, 5, true) -- Void Star Fixate
	UF:AddRaidDebuff(true, 190049, 5) -- Nether Corruption
	UF:AddRaidDebuff(true, 183963, 4, true) -- Light of the Naaru
end

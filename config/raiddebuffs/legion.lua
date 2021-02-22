local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- Emerald Nightmare
UF["raiddebuffs"]["instances"]["The Emerald Nightmare"] = function()
	local zoneid = 1094

	-- enable, spell, priority, secondary, pulse, flash

	-- Nythendra
	UF:AddRaidDebuff(true, 221028, 2) -- Unstable Decay (Trash)
	UF:AddRaidDebuff(true, 204504, 2) -- Infested
	UF:AddRaidDebuff(true, 203045, 5) -- Infested Ground (standing in pool)
	UF:AddRaidDebuff(true, 203096, 6) -- Rot (AoE people around you)
	UF:AddRaidDebuff(true, 204463, 6) -- Volatile Rot (exploding tank)
	UF:AddRaidDebuff(true, 203646, 5) -- Burst of Corruption

	-- Ursoc
	UF:AddRaidDebuff(true, 197943, 7) -- Overwhelm (tank debuff, stacks)
	UF:AddRaidDebuff(true, 198006, 7) -- Focused Gaze (fixate)
	UF:AddRaidDebuff(true, 198108, 1, true) -- Momentum (debuff)
	UF:AddRaidDebuff(true, 197980, 2) -- Nightmarish Cacophony (fear)
	UF:AddRaidDebuff(true, 205611, 4) -- Miasma (standing in)

	-- Dragons of Nightmare
	UF:AddRaidDebuff(true, 203110, 3) -- Slumbering Nightmare (stun)
	UF:AddRaidDebuff(true, 203102, 2) -- Mark of Ysondre (dot, stacks)
	UF:AddRaidDebuff(true, 207681, 4, true) -- Nightmare Bloom (standing in)
	UF:AddRaidDebuff(true, 204731, 1) -- Wasting Dread (debuff)
	UF:AddRaidDebuff(true, 203770, 9, nil, true) -- Defiled Vines (root, magic)
	UF:AddRaidDebuff(true, 203125, 2) -- Mark of Emeriss (dot, stacks)
	UF:AddRaidDebuff(true, 203787, 5) -- Volatile Infection (AoE dot)
	UF:AddRaidDebuff(true, 203086, 2) -- Mark of Lethon (dot, stacks)
	UF:AddRaidDebuff(true, 204044, 4) -- Shadow Burst (dot, stacks)
	UF:AddRaidDebuff(true, 203121, 2) -- Mark of Taerar (dot, stacks)
	UF:AddRaidDebuff(true, 205341, 6) -- Seeping Fog (dot, sleep, magic)
	UF:AddRaidDebuff(false, 204078, 2) -- Bellowing Roar (fear)
	UF:AddRaidDebuff(true, 214543, 1) -- Collapsing Nightmare (debuff)

	-- Elerethe Renferal
	UF:AddRaidDebuff(true, 215307, 6, true) -- Web of Pain (link)
	UF:AddRaidDebuff(true, 215460, 5) -- Necrotic Venom (dot, drops pools)
	UF:AddRaidDebuff(true, 213124, 4) -- Venomous Pool (standing in pool)
	UF:AddRaidDebuff(true, 210850, 3) -- Twisting Shadows (dot)
	UF:AddRaidDebuff(true, 215582, 3) -- Raking Talons (tank debuff, stacks)
	UF:AddRaidDebuff(true, 218519, 1) -- Wind Burn (debuff, stacks)
	UF:AddRaidDebuff(true, 210228, 2) -- Venomous Spiderling - Dripping Fangs (dot, stacks)

	-- Ily'gnoth
	UF:AddRaidDebuff(true, 212886, 4) -- Nightmare Corruption (standing in pool)
	UF:AddRaidDebuff(true, 215845, 1) -- Dispersed Spores (dot)
	UF:AddRaidDebuff(true, 210099, 7, true) -- Fixate (fixate)
	UF:AddRaidDebuff(true, 209469, 8) -- (dot, stacks, magic)
	UF:AddRaidDebuff(true, 209471, 1) -- Nightmare Explosion (dot, stacks)
	UF:AddRaidDebuff(true, 210984, 3) -- Eye of Fate (tank debuff, stacks)
	UF:AddRaidDebuff(true, 208697, 2) -- Mind Flay (dot)
	UF:AddRaidDebuff(true, 208929, 6) -- Spew Corruption (dot, drops pools)
	UF:AddRaidDebuff(true, 215128, 5) -- Cursed Blood (dot, weak bomb)

	-- Cenarius
	UF:AddRaidDebuff(true, 210279, 2, true) -- Creeping Nightmares (debuff, stacks)
	UF:AddRaidDebuff(true, 210315, 8, nil, true) -- Nightmare Brambles (dot, root, magic)
	UF:AddRaidDebuff(true, 213162, 5) -- Nightmare Blast (tank debuff, stacks)
	UF:AddRaidDebuff(false, 226821, 4) -- Desiccating Stomp (melee debuff, stacks)
	UF:AddRaidDebuff(true, 211507, 6) -- Nightmare Javelin (dot, magic)
	UF:AddRaidDebuff(false, 211471, 5) -- Scorned Touch (dot, spreads)
	UF:AddRaidDebuff(false, 211989, 5) -- Unbound Touch (buff, spreads)
	UF:AddRaidDebuff(true, 214529, 5) -- Spear of Nightmares (tank debuff, stacks)

	-- Xavius
	UF:AddRaidDebuff(true, 206005, 1, true) -- Dream Simulacrum (buff)
	UF:AddRaidDebuff(true, 207409, 6) -- Madness (mind control)
	UF:AddRaidDebuff(true, 206651, 8) -- Darkening Soul (dot, magic)
	UF:AddRaidDebuff(true, 211802, 7, nil, true) -- Nightmare Blades (fixate)
	UF:AddRaidDebuff(true, 205771, 9, nil, true) -- Tormenting Fixation (fixate)
	UF:AddRaidDebuff(true, 209158, 8) -- Blackening Soul (dot, magic)
	UF:AddRaidDebuff(true, 205612, 2) -- Blackened? (debuff)
	UF:AddRaidDebuff(true, 210451, 6) -- Bonds of Terror (link)
	UF:AddRaidDebuff(true, 208385, 4) -- Tainted Discharge (standing in)
	UF:AddRaidDebuff(true, 211634, 4) -- The Infinite Dark (standing in?)
end

-- Trial of Valor
UF["raiddebuffs"]["instances"]["Trial of Valor"] = function()
	local zoneid = 1114

	-- Odyn
	UF:AddRaidDebuff(true, 227959, 5) -- Storm of Justice
	UF:AddRaidDebuff(true, 227475, 5) -- Cleansing Flame
	UF:AddRaidDebuff(true, 192044, 5) -- Expel Light
	UF:AddRaidDebuff(true, 227781, 5) -- Glowing Fragment

	-- Guarm
	UF:AddRaidDebuff(true, 228226, 8) -- Flame Lick
	UF:AddRaidDebuff(true, 228246, 8) -- Frost Lick
	UF:AddRaidDebuff(false, 228250, 4) -- Shadow Lick
	UF:AddRaidDebuff(true, 227539, 3) -- Fiery Phlegm
	UF:AddRaidDebuff(true, 227566, 3) -- Salty Spittle
	UF:AddRaidDebuff(true, 227570, 3) -- Dark Discharge
	UF:AddRaidDebuff(true, 228794, 7, true) -- Flaming Volatile Foam
	UF:AddRaidDebuff(true, 228819, 7, true) -- Shadowy Volatile Foam
	UF:AddRaidDebuff(true, 228811, 7, true) -- Briney Volatile Foam

	-- Helya
	UF:AddRaidDebuff(true, 227903, 5) -- Orb of Corruption
	UF:AddRaidDebuff(true, 228058, 5) -- Orb of Corrosion
	UF:AddRaidDebuff(true, 228054, 7) -- Taint of the Sea
	UF:AddRaidDebuff(true, 193367, 5) -- Fetid Rot
	UF:AddRaidDebuff(true, 227982, 5) -- Bilewater Redox
	UF:AddRaidDebuff(true, 228519, 5) -- Anchor Slam
	UF:AddRaidDebuff(true, 202476, 5) -- Rabid
	UF:AddRaidDebuff(true, 232450, 5) -- Corrupted Axion
end

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
	UF:AddRaidDebuff(true, 206464, 8) 		-- P0 - Coronal Ejection - becomes one of the other ejections in later phases
	UF:AddRaidDebuff(true, 206585, 6) 		-- P1 - Absolute Zero
	UF:AddRaidDebuff(true, 206589, 5, true) -- P1 - Chilled (Heroic)
	UF:AddRaidDebuff(true, 206936, 7) 		-- P1 - Icy Ejection (non-dispellable, stacks) (DoT + Slow-to-Stun)
	UF:AddRaidDebuff(true, 206388, 6) 		-- P2 - Felburst (non-dispellable, stacks) (DMG + DoT)
	UF:AddRaidDebuff(true, 205649, 5)		-- P2 - Fel Ejection
	UF:AddRaidDebuff(true, 206399, 7) 		-- P2 - Felflame
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
	UF:AddRaidDebuff(true, 206847, 7, true) -- Parasitic Wound (mythic)
	UF:AddRaidDebuff(true, 221408, 5, true) -- Bulwark of Azzinoth (mythic)
	UF:AddRaidDebuff(true, 206506, 6, nil, nil, true) -- Severed Soul (tank absorb) (mythic)
	UF:AddRaidDebuff(true, 227040, 5) -- Severed  (mythic)
end

-- Tomb of Sargeras
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
	UF:AddRaidDebuff(true, 236449, 7) -- Soulbind (players need to stack)
	UF:AddRaidDebuff(true, 235933, 9, nil, nil, true) -- Spear of Anguish
	UF:AddRaidDebuff(true, 236135, 8, true, nil, true) -- Wither (switch realms)
	UF:AddRaidDebuff(true, 236515, 8, nil, true) -- Shattering Scream

	-- Mistress Sassz'ine
	UF:AddRaidDebuff(true, 230959, 6) -- Concealing Murk
	UF:AddRaidDebuff(true, 232722, 6) -- Slicing Tornado
	UF:AddRaidDebuff(true, 234621, 6) -- Devouring Maw
	UF:AddRaidDebuff(true, 230201, 6) -- Burden of Pain
	UF:AddRaidDebuff(true, 230276, 8) -- Jaws from the deep (heroic)
	UF:AddRaidDebuff(true, 232913, 6, true) -- Befouling Ink
	UF:AddRaidDebuff(true, 232754, 8, true) -- Thundering Shock
	UF:AddRaidDebuff(true, 230358, 7, nil, nil, true) -- Thundering Shock
	UF:AddRaidDebuff(true, 230384, 7, nil, nil, true) -- Consuming Hunger

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

-- Antorus
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

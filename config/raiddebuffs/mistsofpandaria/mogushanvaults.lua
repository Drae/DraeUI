local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Mogu'shan Vaults

UF["raiddebuffs"]["instances"]["Mogu'shan Vaults"] = function()
	-- Stone Guard
	UF:AddRaidDebuff(true, 130395, 6) -- Jasper Chains: Stacks
	UF:AddRaidDebuff(true, 130404, 3) -- Jasper Chains [NOTE: This is what was causing dmg in the logs]
	UF:AddRaidDebuff(true, 130774, 6) -- Amethyst Pool
	UF:AddRaidDebuff(true, 116281, 3) -- Cobalt Mine Blast (dispellable)
	UF:AddRaidDebuff(true, 125206, 6, true) -- Rend Flesh: Tank only

	-- Feng The Accursed
	UF:AddRaidDebuff(true, 131788, 6) -- Lightning Lash
	UF:AddRaidDebuff(true, 116040, 3) -- Epicenter
	UF:AddRaidDebuff(true, 116942, 6) -- Flaming Spear
	UF:AddRaidDebuff(true, 116784, 3) -- Wildfire Spark
	UF:AddRaidDebuff(true, 131790, 6) -- Arcane Shock: Stack
	UF:AddRaidDebuff(true, 102464, 3) -- Arcane Shock: AOE
	UF:AddRaidDebuff(true, 116417, 4) -- Arcane Resonance
	UF:AddRaidDebuff(true, 116364, 6) -- Arcane Velocity
	UF:AddRaidDebuff(true, 116374, 3) -- Lightning Charge: Stun effect
	UF:AddRaidDebuff(true, 131792, 6, true) -- Shadowburn: Tank only: Stacks: HEROIC ONLY

	-- Gara'jal the Spiritbinder
	UF:AddRaidDebuff(true, 117723, 3) -- Frail Soul: HEROIC ONLY
	UF:AddRaidDebuff(true, 122151, 3, true) -- Voodoo Doll
	UF:AddRaidDebuff(true, 116260, 6, true) -- Crossed Over [NOTE: Putting this incase events fire between both realms]

	-- The Spirit Kings
	UF:AddRaidDebuff(true, 118047, 3) -- Pillage
	UF:AddRaidDebuff(true, 118135, 8) -- Pinned Down
	UF:AddRaidDebuff(true, 118047, 3) -- Pillage: Target
	UF:AddRaidDebuff(true, 118163, 3) -- Robbed Blind
	UF:AddRaidDebuff(true, 118303, 3, true) -- Undying Shadows:Fixate

	-- Elegon
	UF:AddRaidDebuff(true, 117949, 7) -- Closed circuit (dispellable)
	UF:AddRaidDebuff(true, 117945, 3) -- Arcing Energy
	UF:AddRaidDebuff(true, 117878, 6, true) -- Overcharged

	-- Will of the Emperor
	UF:AddRaidDebuff(true, 116525, 3) -- Focused Assault
	UF:AddRaidDebuff(true, 116778, 3) -- Focused Defense
	UF:AddRaidDebuff(true, 117485, 6) -- Impeding Thrust
	UF:AddRaidDebuff(true, 116550, 4) -- Energizing Smash
	UF:AddRaidDebuff(true, 116829, 3) -- Focused Energy
end

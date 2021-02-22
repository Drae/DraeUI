local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

-- The Everbloom

UF["raiddebuffs"]["instances"]["The Everbloom"] = function()
	-- Ancient Protectors
	UF:AddRaidDebuff(true, 168187, 6) -- Venomous Charge
	UF:AddRaidDebuff(true, 167966, 6, true) -- Bramble Patch

	-- Archmage Sol
	UF:AddRaidDebuff(true, 166726, 6) -- Frozen Rain
	UF:AddRaidDebuff(true, 168895, 6) -- Frostbolt (stacks)

	-- Xeri'tac
	UF:AddRaidDebuff(true, 169376, 6) -- Venomous Sting
	UF:AddRaidDebuff(true, 169382, 6) -- Gaseous Volley

	-- Witherbark
	UF:AddRaidDebuff(true, 164294, 6, true) -- Unchecked Growth

	-- Yalnu
	UF:AddRaidDebuff(true, 169251, 6, true) -- Entanglement
end

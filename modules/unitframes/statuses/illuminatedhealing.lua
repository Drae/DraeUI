--[[
		Inspired by Grid, Aptcheka and others
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local I = UF:NewModule("StatusIH")

-- Localise a bunch of functions
local UnitBuff, GetSpellInfo, UnitIsVisible, UnitIsDeadOrGhost, UnitHealthMax = UnitBuff, GetSpellInfo, UnitIsVisible, UnitIsDeadOrGhost, UnitHealthMax
local floor, mmax = math.floor, math.max

--
SPELL_IH_NAME = GetSpellInfo(86273) -- Illuminated Healing

local IH = {
	color = { r = 0.84, g = 0.32, b = 0, a = 1.0 },
	colorFull = { r = 0.42, g = 0.76, b = 0.11, a = 1.0 },
	texture = "Interface\\Icons\\spell_holy_absolution",
	text = "Illuminated Healing",
	priority = 60,
	enable = true
}

--[[

--]]
local Update, UpdatePlayerMaxHealth
do
	local shieldRatio = 1/3
	local maxShield = 0
	local playerHealth = 0

	local UpdateShield = function()
		maxShield = floor(UnitHealthMax("player") * shieldRatio)
	end

	Update = function(self, event, unit)
		if (unit and self.unit ~= unit) then return end
		unit = unit or self.unit

		if (UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit)) then
			if (maxShield < 1) then
				UpdateShield()
			end

			local _, _, _, _, _, duration, expires, _, _, _, _, _, _, _, shield, _ = UnitBuff(unit, SPELL_IH_NAME, nil, "PLAYER")

			local start = expires and (expires - duration)

			if (not shield) then
				return self:LostStatus(unit, "status_ih")
			end

			local shieldFull = (shield >= maxShield)

			return self:GainedStatus(unit, "status_ih", IH.priority, shieldFull and IH.colorFull or IH.color, IH.texture, IH.text, shield, maxShield, start, duration, nil)
		end

		self:LostStatus(unit, "status_ih")
	end

	UpdatePlayerMaxHealth = function(self, event, unit)
		if (unit and self.unit ~= unit) then return end
		unit = unit or self.unit

		if (not UnitIsUnit(unit, "player")) then return end

		UpdateShield()

		for guid, frame in pairs(oUF.frames) do
			if (frame) then
				Update(frame, event, frame.unit or nil)
			end
		end
	end
end

local Enable = function(self)
	if (self.statuscache and T.playerClass == "PALADIN") then
		self:RegisterEvent("UNIT_MAXHEALTH", UpdatePlayerMaxHealth)
		self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Update)
		return true
	end
end

local Disable = function(self)
	if (self.statuscache and T.playerClass == "PALADIN") then
		self:UnregisterEvent("UNIT_MAXHEALTH", UpdatePlayerMaxHealth)
		self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Update)
	end
end

oUF:AddElement("StatusIH", Update, Enable, Disable)

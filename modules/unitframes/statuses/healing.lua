--[[
		Healing
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local I = UF:NewModule("StatusHealingInd")

--
local UnitIsVisible, UnitIsDeadOrGhost, UnitGetIncomingHeals = UnitIsVisible, UnitIsDeadOrGhost, UnitGetIncomingHeals

--
local priority = 50
local color = { r = 0, g = 1.0, b = 0, a = 1.0 }

--[[

--]]
local Update = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	if (UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit)) then
		local incoming = UnitGetIncomingHeals(unit) or 0

		if (incoming > 0) then
			return self:GainedStatus(unit, "status_incheal", priority, color)
		end
	end

	self:LostStatus(unit, "status_incheal")
end

local Enable = function(self)
	if (self.statuscache) then
		self:RegisterEvent("UNIT_HEAL_PREDICTION", Update)
		return true
	end
end

local Disable = function(self)
	if (self.statuscache) then
		self:UnregisterEvent("UNIT_HEAL_PREDICTION", Update)
	end
end

oUF:AddElement("StatusHealingInd", Update, Enable, Disable)

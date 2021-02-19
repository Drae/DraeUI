--[[
		Healing
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local Status = UF:NewModule("StatusHealingInd")

--
local UnitIsVisible, UnitIsDeadOrGhost, UnitGetIncomingHeals = UnitIsVisible, UnitIsDeadOrGhost, UnitGetIncomingHeals

--
local color = { 0.0, 1.0, 0.0 }

--[[

--]]
local Update = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	if (UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit)) then
		local incoming = UnitGetIncomingHeals(unit) or 0

		if (incoming > 0) then
			return self:GainedStatus("status_incheal", color)
		end
	end

	self:LostStatus("status_incheal")
end

local Enable = function(self)
	if (self.__is_grid) then
		self:RegisterEvent("UNIT_HEAL_PREDICTION", Update)
		return true
	end
end

local Disable = function(self)
	if (self.__is_grid) then
		self:UnregisterEvent("UNIT_HEAL_PREDICTION", Update)
	end
end

oUF:AddElement("StatusHealingInd", Update, Enable, Disable)

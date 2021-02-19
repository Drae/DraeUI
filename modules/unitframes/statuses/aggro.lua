--[[
		Aggro
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local Status = UF:NewModule("StatusAggro")

--
local UnitThreatSituation = UnitThreatSituation

--
local color = {
	[1]	= { 0.4, 1.0, 0.0 },
	[2]	= { 1.0, 0.6, 0.0 },
	[3]	= { 1.0, 0.0, 0.0 }
}

--[[

--]]
local Update = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local status = UnitThreatSituation(unit)

	if (status and status > 0) then
		self:GainedStatus("status_aggro", color[status])
	else
		self:LostStatus("status_aggro")
	end
end

local Enable = function(self)
	if (self.__is_grid) then
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", Update)
		return true
	end
end

local Disable = function(self)
	if (self.__is_grid) then
		self:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE", Update)
	end
end

oUF:AddElement("StatusAggro", Update, Enable, Disable)

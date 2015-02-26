--[[
		Aggro
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local I = UF:NewModule("StatusAggro")

--
local UnitThreatSituation, GetThreatStatusColor = UnitThreatSituation, GetThreatStatusColor

--
local priority = 50
local color = {
	[1]	= { r = 1.0, g = 1.0, b = 0.47 },
	[2]	= { r = 1.0, g = 0.6, b = 0    },
	[3]	= { r = 1.0, g = 0,   b = 0    }
}

--[[

--]]
local Update = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local status = UnitThreatSituation(unit)

	if (status and status > 0) then
		self:GainedStatus(unit, "status_aggro", priority, color[status])
	else
		self:LostStatus(unit, "status_aggro")
	end
end

local Enable = function(self)
	if (self.statuscache) then
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", Update)
		return true
	end
end

local Disable = function(self)
	if (self.statuscache) then
		self:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE", Update)
	end
end

oUF:AddElement("StatusAggro", Update, Enable, Disable)

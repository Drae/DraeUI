--[[
		Summon
--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")
local Status = UF:NewModule("StatusSummon")

-- sourced from Blizzard_APIDocumentation/IncomingSummonDocumentation.lua
local SUMMON_STATUS_NONE = Enum.SummonStatus.None or 0

--
local color = {
	[1]	= { 0.0, 0.2, 0.9 },
	[2]	= { 0.0, 0.9, 0.2 },
	[3]	= { 0.9, 0.2, 0.0 }
}

--[[

--]]
local Update = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local status = C_IncomingSummon.IncomingSummonStatus(unit)

	if (status ~= SUMMON_STATUS_NONE) then
		self:GainedStatus("status_summon", color[status])
	else
		self:LostStatus("status_summon")
	end
end

local Enable = function(self)
	if (self.__is_grid) then
		self:RegisterEvent('INCOMING_SUMMON_CHANGED', Update)
		return true
	end
end

local Disable = function(self)
	if (self.__is_grid) then
		self:UnregisterEvent('INCOMING_SUMMON_CHANGED', Update)
	end
end

oUF:AddElement("StatusSummon", Update, Enable, Disable)

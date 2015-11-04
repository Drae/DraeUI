--[[
		Ressurection
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local I = UF:NewModule("StatusRes")

local LibResInfo = LibStub("LibResInfo-1.0", true)
assert(LibResInfo, "ResInfo element requires LibResInfo-1.0")

--
local priority = 80
local color = {
	["CASTING"]	= { r = 1.0, g = 0.5, b = 0.0 },
	["MASSRES"]	= { r = 1.0, g = 0.85, b = 0.0 },
	["PENDING"]	= { r = 1.0, g = 1.0, b = 1.0 },
	["SELFRES"]	= { r = 1.0, g = 0,   b = 0.6 }
}

--[[

--]]
local Update = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local status, endTime, casterUnit, casterGUID = LibResInfo:UnitHasIncomingRes(unit)
	
	if (status) then
		self:GainedStatus(unit, "status_res", priority, color[status])
	else
		self:LostStatus(unit, "status_res")
	end
end

local Enable = function(self)
	if (self.statuscache) then
		return true
	end
end

local Disable = function(self)
	return true
end

oUF:AddElement("StatusRes", Update, Enable, Disable)

--
local function Callback(event, unit, guid)
	for i = 1, #oUF.objects do
		local frame = oUF.objects[i]
		if frame.unit and frame.statuscache then
			Update(frame, event, frame.unit)
		end
	end
end

LibResInfo.RegisterAllCallbacks("oUF_ResInfo", Callback, true)

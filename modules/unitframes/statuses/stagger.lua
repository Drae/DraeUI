--[[
		Inspired by Grid, Aptcheka and others
--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")
local Status = UF:NewModule("StatusStagger")

-- Localise a bunch of functions
local UnitDebuff, UnitIsVisible, UnitIsDeadOrGhost = UnitDebuff, UnitIsVisible, UnitIsDeadOrGhost

--
local spellID_severity = {
    [124273] = "heavy",
    [124274] = "moderate",
    [124275] = "light",
}

local stagger = {
	["heavy"] 	 = { 1.0, 1.0, 0.0 },
	["moderate"] = { 1.0, 0.5, 0.0 },
	["light"] 	 = { 0.0, 1.0, 0.0 },
}

--[[

--]]
local Update
do
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable

	Update = function(self, event, unit)
		if (unit and self.unit ~= unit) then return end
		unit = unit or self.unit

		local severity = nil

		if (UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit)) then
			local index = 1
			while (true) do
				local name, _, _, _, _, _, _, _, _, spellID = UnitDebuff(unit, index)

				if (not name) then break end

				severity = spellID_severity[spellID]

				if (severity) then
					self:GainedStatus("status_stagger", stagger[severity], nil, nil, nil, nil, nil, nil, nil, false, false, false)
					break
				end

				index = index + 1
			end
		end

		if (not severity) then
			self:LostStatus("status_stagger")
		end
	end
end

local Enable = function(self)
	if (self.__is_grid) then
		self:RegisterEvent("UNIT_AURA", Update)
		return true
	end
end

local Disable = function(self)
	if (self.__is_grid) then
		self:UnregisterEvent("UNIT_AURA", Update)
	end
end

oUF:AddElement("StatusStagger", Update, Enable, Disable)

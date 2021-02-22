--[[
		External damage cooldowns -or- self-non-buff proc cooldowns
--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")
local Status = UF:NewModule("StatusDefensives")

-- Localise a bunch of functions
local UnitBuff, UnitIsVisible, UnitIsDeadOrGhost = UnitBuff, UnitIsVisible, UnitIsDeadOrGhost

--
local colour = { r = 1.0, g = 1.0, b = 0.0 }

local cooldowns = {
	["DEATHKNIGHT"] = {
	},
	["DEMONHUNTER"] = {
		[1] = 209258, -- Last resort (cheat death)
	},
	["DRUID"] = {
		[1] = 61336, -- Survival Instincts
	},
	["HUNTER"] = {
	},
	["MAGE"] = {
	},
	["MONK"] = {
		[1] = 116849, -- Life Cocoon
	},
	["PALADIN"] = {
	},
	["PRIEST"] = {
		[1] = 33206, -- Pain Suppression
		[2] = 47788, -- Guardian Spirit
	},
	["ROGUE"] = {
	},
	["SHAMAN"] = {
	},
	["WARLOCK"] = {
	},
	["WARRIOR"] = {
	},
}


--[[

--]]
local Update = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local cooldownSeen = false

	if (UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit)) then
		-- scan for buffs

		local index = 1
		while (true) do
			local name, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, index)

			if (not name) then break end

			if (DraeUI.Contains(spellID, cooldowns)) then
				local start = expirationTime and (expirationTime - duration)

				self:GainedStatus("status_dmgred", colour, icon, nil, nil, nil, start, duration, count, false, false, true)
				cooldownSeen = true
				break
			end

			index = index + 1
		end
	end

	if (not cooldownSeen) then
		self:LostStatus("status_dmgred")
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

oUF:AddElement("StatusDmgReduction", Update, Enable, Disable)

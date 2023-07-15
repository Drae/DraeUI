--[[

--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")
local Status = UF:NewModule("StatusDispells")

-- Localise a bunch of functions
local UnitDebuff, UnitIsDeadOrGhost = UnitDebuff, UnitIsDeadOrGhost

-- List of spells which are blacklisted from appearing as dispellable debuffs
-- for whatever reason, e.g. already appearing as secondary raid debuffs
local blacklist = {
	[209858] = true,	-- Necrotic (M+)
	[240449] = true,	-- Grievous (M+)
	[340880] = true,	-- Prideful (SL - M+ - Season 1)
}

--
local Update
do
	local index, name, icon, stack, dtype, duration, expires, spell_id
	local currentDispell = {
		priority = 0,
		name = "",
		color = {nil, nil, nil, nil},
		icon = "",
		start = 0,
		duration = 0,
		stack = 0,
	}

	local dispellPriority = {
		["Magic"]	= 4,
		["Disease"]	= 3,
		["Poison"]	= 2,
		["Curse"]	= 1
	}

	Update = function(self, event, unit)
		if (unit and self.unit ~= unit) then return end
		unit = unit or self.unit

		if (UnitIsDeadOrGhost(unit)) then
			self:LostStatus("status_dispell")

			return
		end

		wipe(currentDispell)

		-- scan for debuffs
		index = 1
		while (true) do
			name, icon, stack, dtype, duration, expires, _, _, _, spell_id = UnitDebuff(unit, index)

			if (not name) then break end

			if (not blacklist[spell_id] and dtype and (not DraeUI.config["raidframes"].showOnlyDispellable or (UF.dispellClasses[DraeUI.playerClass] and UF.dispellClasses[DraeUI.playerClass][dtype]))) then
				-- no existing highest priority? higher priority? and not a secondary debuff displayed by the debuffs status?
				if (not currentDispell.priority or currentDispell.priority < dispellPriority[dtype]) then
					currentDispell.priority = dispellPriority[dtype]

					currentDispell.name 	= name
					currentDispell.color 	= oUF.colors.debuffTypes[dtype] and oUF.colors.debuffTypes[dtype] or {}
					currentDispell.icon 	= icon
					currentDispell.start 	= expires - duration
					currentDispell.duration = duration
					currentDispell.stack 	= stack
				end
			end

			index = index + 1
		end

		if (currentDispell.name) then
			-- unit, status, priority, color, texture, text, value, maxValue, start, duration, stack, notMine, pulse, flash
			self:GainedStatus("status_dispell", currentDispell.color, currentDispell.icon, nil, nil, nil, currentDispell.start, currentDispell.duration, currentDispell.stack)
		else
			self:LostStatus("status_dispell")
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

oUF:AddElement("StatusDispells", Update, Enable, Disable)

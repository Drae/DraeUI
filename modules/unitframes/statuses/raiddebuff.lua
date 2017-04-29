--[[
		Inspired by Grid, Aptcheka and others
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local I = UF:NewModule("StatusRaidDebuffs", "AceEvent-3.0")

--
local UnitAura, UnitIsVisible, UnitIsDeadOrGhost, GetSpellInfo = UnitAura, UnitIsVisible, UnitIsDeadOrGhost, GetSpellInfo
local twipe = table.wipe

--
local loadedDebuffZone
local loadedCommon

local debuff_list = {}

local priority = 99
local debuffTypeColor = {
	["Magic"] 	= { r = 0.2, g = 0.6, b = 1.0 },
	["Disease"] = { r = 0.6, g = 0.4, b = 0   },
	["Poison"] 	= { r = 0,   g = 0.6, b = 1.0 },
	["Curse"] 	= { r = 0.6, g = 0,   b = 1.0 }
}

--[[

--]]
local CommonDebuffs = function()
	if (loadedCommon) then return end

	-- Mythic+
	UF:AddRaidDebuff(true, 209858, 8, true) -- Necrotic Rot (affix)
	UF:AddRaidDebuff(true, 240449, 8, true) -- Grievous (M+)
	UF:AddRaidDebuff(true, 240443, 8, true) -- Burst (M+)

	loadedCommon = true
end

--[[

]]
UF.AddRaidDebuff = function(self, enable, spell, priority, secondary, pulse, flash)
	if type(spell) == "number" then
		name, _, icon = GetSpellInfo(spell)
		id = spell
	else
		name = spell
		order = 9999
	end

	if (not debuff_list[name]) then
		debuff_list[name] = {
			enable = enable or false,
			icon = icon or "",
			priority = priority or 1,
			secondary = secondary or false,
			pulse = pulse or false,
			flash = flash or false
		}
	end
end

local LoadZoneDebuffs = function()
	local zoneName, _ = GetInstanceInfo()

	if (loadedDebuffZone ~= zoneName) then
		loadedDebuffZone = nil

		local add = UF["raiddebuffs"].instances[zoneName] or nil

		if (add) then
			twipe(debuff_list)

			add()

			loadedDebuffZone = zoneName
			loadedCommon = false

			T.Print("Debuff indicators loaded for |cff00dd00" .. zoneName .. "|r")
		end

		-- Add general debuffs common across specs/classes/etc.
		CommonDebuffs()
	end
end

--[[

--]]
local Update = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	if (not UnitIsDeadOrGhost(unit)) then
		local d_name, d_icon, d_color, d_start, d_duration, d_count, d_pulse
		local d_name2, d_icon2, d_color2, d_start2, d_duration2, d_count2, d_pulse2

		local d_priority = 0
		local d_priority2 = 0

		local index = 1

		while (true) do
			local name, _, icon, count, dispelType, duration, expires, caster = UnitAura(unit, index, "HARMFUL")

			if (not name) then
				break
			end

			if (debuff_list[name]) then
				local debuff = debuff_list[name]

				if (debuff.enable) then
					if (not debuff.secondary and d_priority < debuff.priority) then
						d_priority = debuff.priority
						d_name = name
						d_icon = icon
						d_start = expires - duration
						d_duration = duration
						d_count = count
						d_color = dispelType and debuffTypeColor[dispelType] or nil
						d_pulse = debuff.pulse or nil
					end

					if (debuff.secondary and d_priority2 < debuff.priority) then
						d_priority2 = debuff.priority
						d_name2 = name
						d_icon2 = icon
						d_start2 = expires - duration
						d_duration2 = duration
						d_count2 = count
						d_color2 = dispelType and debuffTypeColor[dispelType] or nil
						d_pulse2 = debuff.pulse or nil
					end
				end
			end

			index = index + 1
		end

		if (d_name) then
			self:GainedStatus(unit, "status_raiddebuff", d_priority, d_color, d_icon, nil, nil, nil, d_start, d_duration, d_count, nil, d_pulse)
		else
			self:LostStatus(unit, "status_raiddebuff")
		end

		if (d_name2) then
			self:GainedStatus(unit, "status_raiddebuff2", d_priority2, d_color2, d_icon2, nil, nil, nil, d_start2, d_duration2, d_count2, nil, d_pulse2)
		else
			self:LostStatus(unit, "status_raiddebuff2")
		end
	else
		self:LostStatus(unit, "status_raiddebuff")
		self:LostStatus(unit, "status_raiddebuff2")
	end
end

local Enable = function(self)
	if (self.statuscache) then
		self:RegisterEvent("UNIT_AURA", Update)
		return true
	end
end

local Disable = function(self)
	if (self.statuscache) then
		self:UnregisterEvent("UNIT_AURA", Update)
	end
end

oUF:AddElement("StatusRaidDebuffs", Update, Enable, Disable)

--[[

--]]
I.OnEnable = function(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", LoadZoneDebuffs)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", LoadZoneDebuffs)
end

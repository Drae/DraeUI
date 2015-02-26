--[[
		Inspired by Grid, Aptcheka and others
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local I = UF:NewModule("StatusAuras")

-- Localise a bunch of functions
local UnitAura, UnitDebuff, GetSpellInfo, UnitIsVisible, UnitIsDeadOrGhost = UnitAura, UnitDebuff, GetSpellInfo, UnitIsVisible, UnitIsDeadOrGhost
local pairs = pairs

--
local buff_names = {}
local player_buff_names = {}
local debuff_names = {}

local buff_names_seen = {}
local player_buff_names_seen = {}
local debuff_names_seen = {}
local debuff_types_seen = {}

local buff_names_seen_prev = {}
local player_buff_names_seen_prev = {}
local debuff_names_seen_prev = {}
local debuff_types_seen_prev = {}

local debuff_types = {
	["Magic"] = "dispel_magic",
	["Disease"] = "dispel_disease",
	["Poison"] = "dispel_poison",
	["Curse"] = "dispel_curse",
}

--[[

--]]
local UpdateAuraList = function()
	wipe(buff_names)
	wipe(player_buff_names)
	wipe(debuff_names)

	wipe(buff_names_seen)
	wipe(player_buff_names_seen)
	wipe(debuff_names_seen)
	wipe(debuff_types_seen)

	wipe(buff_names_seen_prev)
	wipe(player_buff_names_seen_prev)
	wipe(debuff_names_seen_prev)
	wipe(debuff_types_seen_prev)

	for status, settings in pairs(T.dbClass["auras"]) do
		if (type(settings) == "table" and not settings.disable) then
			local name = settings.buff or settings.debuff

			if (name and not debuff_types[name]) then
				local isBuff = not not settings.buff

				if (isBuff) then
					if (settings.mine) then
						player_buff_names[name] = status
						player_buff_names_seen[name] = false
						player_buff_names_seen_prev[name] = false
					else
						buff_names[name] = status
						buff_names_seen[name] = false
						buff_names_seen_prev[name] = false
					end
				else
					debuff_names[name] = status
					debuff_names_seen[name] = false
					debuff_names_seen_prev[name] = false
				end
			elseif (debuff_types[name]) then
				debuff_types_seen[name] = false
				debuff_types_seen_prev[name] = false
			end
		end
	end
end

--[[

--]]
local UnitGainedBuff = function(self, unit, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	local status = buff_names[name]
	local settings = status and T.dbClass["auras"][status]

	if (not settings) then return end

	if (not settings.disable) then
		local start = expirationTime and (expirationTime - duration)
		local notMine = caster and caster ~= "player" and true or false

		self:GainedStatus(unit, status, settings.pr, settings.color, icon, settings.text, nil, nil, start, duration, count, notMine)
	else
		self:LostStatus(unit, status)
	end
end

local UnitLostBuff = function(self, unit, name)
	local status = buff_names[name]

	if (not T.dbClass["auras"][status]) then return end

	self:LostStatus(unit, status)
end

local UnitGainedPlayerBuff = function(self, unit, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	local status = player_buff_names[name]
	local settings = T.dbClass["auras"][status]

	if (not settings) then return end

	if (not settings.disable) then
		local start = expirationTime and (expirationTime - duration)

		self:GainedStatus(unit, status, settings.pr, settings.color, icon, settings.text, nil, nil, start, duration, count)
	else
		self:LostStatus(unit, status)
	end
end

local UnitLostPlayerBuff = function(self, unit, name)
	local status = player_buff_names[name]

	if (not T.dbClass["auras"][status]) then return end

	self:LostStatus(unit, status)
end

local UnitGainedDebuff = function(self, unit, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	local status = debuff_names[name]
	local settings = T.dbClass["auras"][status]

	if (not settings) then return end

	if (not settings.disable) then
		local start = expirationTime and (expirationTime - duration)

		self:GainedStatus(unit, status, settings.pr, settings.color, icon, settings.text, nil, nil, start, duration, count)
	else
		self:LostStatus(unit, status)
	end
end

local UnitLostDebuff = function(self, unit, name)
	local status = debuff_names[name]

	if (not T.dbClass["auras"][status]) then return end

	self:LostStatus(unit, status)
end

local UnitGainedDebuffType = function(self, unit, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	local status = debuffType and debuff_types[debuffType]
	local settings = T.dbClass["auras"][status]

	if (not settings) then return end

	if (not settings.disable and (UF.dispellClasses[T.playerClass][debuffType] or not T.db["raidframes"].showOnlyDispellable)) then
		local start = expirationTime and (expirationTime - duration)

		self:GainedStatus(unit, status, settings.pr, settings.color, icon, nil, nil, nil, start, duration, count)
	else
		self:LostStatus(unit, status)
	end
end

local UnitLostDebuffType = function(self, unit, name)
	local status = name and debuff_types[name]

	if (not T.dbClass["auras"][status]) then return end

	self:LostStatus(unit, status)
end

--[[

--]]
local ScanUnitAuras
do
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable

	ScanUnitAuras = function(self, event, unit)
		if (unit and self.unit ~= unit) then return end
		unit = unit or self.unit

		if (not UnitIsDeadOrGhost(unit)) then -- UnitIsVisible(unit) and
			-- scan for buffs
			for buff_name in pairs(buff_names) do
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(unit, buff_name, nil, "HELPFUL")

				if (name) then
					buff_names_seen[name] = true
					UnitGainedBuff(self, unit, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
				end
			end

			-- scan for buffs cast by the player
			for buff_name in pairs(player_buff_names) do
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(unit, buff_name, nil, "HELPFUL|PLAYER")

				if (name) then
					player_buff_names_seen[name] = true
					UnitGainedPlayerBuff(self, unit, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
				end
			end

			-- scan for debuffs
			for index = 1, 40 do
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitDebuff(unit, index)

				if (not name) then
					break
				end

				if (debuff_names[name]) then
					debuff_names_seen[name] = true
					UnitGainedDebuff(self, unit, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
				elseif (debuff_types[debuffType]) then
					debuff_types_seen[debuffType] = true
					UnitGainedDebuffType(self, unit, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
				end
			end
		end

		-- handle lost buffs
		for name in pairs(buff_names_seen_prev) do
			if (not buff_names_seen[name]) then
				UnitLostBuff(self, unit, name)
			else
				buff_names_seen[name] = false
				buff_names_seen_prev[name] = true
			end
		end

		for name in pairs(player_buff_names_seen_prev) do
			if (not player_buff_names_seen[name]) then
				UnitLostPlayerBuff(self, unit, name)
			else
				player_buff_names_seen[name] = false
				player_buff_names_seen_prev[name] = true
			end
		end

		-- handle lost debuffs
		for name in pairs(debuff_names_seen_prev) do
			if (not debuff_names_seen[name]) then
				UnitLostDebuff(self, unit, name)
			else
				debuff_names_seen[name] = false
				debuff_names_seen_prev[name] = true
			end
		end

		for debuffType in pairs(debuff_types_seen_prev) do
			if (not debuff_types_seen[debuffType]) then
				UnitLostDebuffType(self, unit, debuffType)
			else
				debuff_types_seen[debuffType] = false
				debuff_types_seen_prev[debuffType] = true
			end
		end
	end
end

local Enable = function(self)
	if (self.statuscache) then
		self:RegisterEvent("UNIT_AURA", ScanUnitAuras)
		return true
	end
end

local Disable = function(self)
	if (self.statuscache) then
		self:UnregisterEvent("UNIT_AURA", ScanUnitAuras)
	end
end

oUF:AddElement("StatusAuras", ScanUnitAuras, Enable, Disable)

--[[

--]]
I.OnEnable = function(self)
	UpdateAuraList()
end

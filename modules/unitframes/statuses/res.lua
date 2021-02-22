--[[
		Ressurection
--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")
local Roster = DraeUI:GetModule("Roster")
local Status = UF:NewModule("StatusRes", "AceEvent-3.0", "AceTimer-3.0")

--
local UnitGUID, UnitIsDeadOrGhost, UnitIsConnected, UnitCastingInfo, UnitHasIncomingResurrection, CombatLogGetCurrentEventInfo = UnitGUID, UnitIsDeadOrGhost, UnitIsConnected, UnitCastingInfo, UnitHasIncomingResurrection, CombatLogGetCurrentEventInfo

--
local has_soulstone 	= {}
local has_reincarnation = {}
local has_pending 		= {}
local is_dead			= {}
local is_ghost			= {}

local casting_single 	= {} -- table of casters casting single res spells and their targets
local casting_mass 		= {} -- table of caters casting mass res

--
local color = {
	["CASTING"]	= { 1.0, 0.5, 0.0 },
	["MASSRES"]	= { 1.0, 0.8, 0.0 },
	["PENDING"]	= { 1.0, 1.0, 1.0 },
	["SELFRES"]	= { 1.0, 0.0, 0.6 }
}

local SOULSTONE = GetSpellInfo(201060)
local REINCARNATION = GetSpellInfo(225080)
local RESSURECTING = GetSpellInfo(160029)
local RESURRECT_PENDING_TIME = 60
local RELEASE_PENDING_TIME = 360

local spells_singleres = {
	-- Class Abilities
	[2008]   = GetSpellInfo(2008),   -- Ancestral Spirit (Shaman)
	[7328]   = GetSpellInfo(7328),   -- Redemption (Paladin)
	[2006]   = GetSpellInfo(2006),   -- Resurrection (Priest)
    [20484]  = GetSpellInfo(20484),  -- Rebirth (Druid)
	[50769]  = GetSpellInfo(50769),  -- Revive (Druid)
	[115178] = GetSpellInfo(115178), -- Resuscitate (Monk)

	-- Items
	[8342]   = GetSpellInfo(8342),   -- Defibrillate (Goblin Jumper Cables)
	[22999]  = GetSpellInfo(22999),  -- Defibrillate (Goblin Jumper Cables XL)
	[54732]  = GetSpellInfo(54732),  -- Defibrillate (Gnomish Army Knife)
	[164729] = GetSpellInfo(164729), -- Defibrillate (Ultimate Gnomish Army Knife)
	[187777] = GetSpellInfo(187777), -- Reawaken (Brazier of Awakening)
    [265116] = GetSpellInfo(265116), -- Defibrillate (Unstable Temporal Time Shifter)
	[348477] = GetSpellInfo(348477), -- Disposable Spectrophasic Reanimator
}

local spells_massres = {
	[212036] = GetSpellInfo(212036), -- Mass Resurrection (Discipline/Holy Priest)
	[212040] = GetSpellInfo(212040), -- Revitalize (Restoration Druid)
	[212048] = GetSpellInfo(212048), -- Ancestral Vision (Restoration Shaman)
	[212051] = GetSpellInfo(212051), -- Reawaken (Mistweaver Monk)
	[212056] = GetSpellInfo(212056), -- Absolution (Holy Paladin)
}

--[[

--]]
local NewTable, RemTable
do
	local pool = {}

	NewTable = function()
		local t = next(pool)
		if (t) then
			pool[t] = nil
			return t
		end

		return {}
	end

	RemTable = function(t)
		pool[wipe(t)] = true
		return nil
	end
end

local Update = function(self, event, unit)
	-- Unit alive? dc'd? clear status
	if (not UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
		return self:LostStatus("status_res")
	end

	local guid = UnitGUID(unit)

	--
	local status, casterUnit, start_time, end_time

	if (has_pending[guid]) then
		end_time = has_pending[guid]
		status = (has_soulstone[guid] or has_reincarnation[guid]) and "SELFRES" or "PENDING"
	else
		for caster, data in pairs(casting_single) do
			if (data.target == guid) then
				if (not end_time or data.end_time < end_time) then
					status, casterUnit, start_time, end_time  = "CASTING", caster, data.start_time, data.end_time
				end
			end
		end

		for caster, data in pairs(casting_mass) do
			if (not end_time or data.end_time < end_time) then
				status, casterUnit, start_time, end_time  = "MASSRES", caster, data.start_time, data.end_time
			end
		end
	end

	if (not status) then
		return self:LostStatus("status_res")
	end

	local duration

	if (status == "PENDING") then
		start_time = end_time - 60
		duration = 60
	elseif (status == "SELFRES") then
		start_time = end_time - 360
		duration = 360
	else -- CASTING or MASSRES
		if (not casterUnit) then
			return self:LostStatus("status_res")
		end

		local caster = Roster:GetGuidToUnit(casterUnit) --oUF.frames.guid[casterUnit].unit

		_, _, _, start_time = UnitCastingInfo(caster)
		-- ignore instant casts
		if (not start_time) then
			return self:LostStatus("status_res")
		end

		start_time = start_time / 1000
		duration = end_time - start_time
	end

	-- self, status, color, texture, text, value, maxValue, start, duration, stack, notMine, pulse, flash
	self:GainedStatus("status_res", color[status], nil, nil, nil, nil, start_time, duration)
end

--[[

]]
local INCOMING_RESURRECT_CHANGED = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local guid = UnitGUID(unit)
	local hasRes = UnitHasIncomingResurrection(unit)

	if (hasRes) then
		local now = GetTime()

		for _, data in pairs(casting_single) do
			-- Found it!
			if (not data.target and data.start_time - now < 10) then
				data.target = guid

				Update(self, "ResCastStarted", unit)
				break
			end
		end
	else
		-- Check if unit previously had any resses.
		for caster, data in pairs(casting_single) do
			if (data.target == guid) then
				if (data.start_time) then
					casting_single[caster] = RemTable(data)

					Update(self, "ResCastCancelled", unit)
				else
					casting_single[caster] = RemTable(data)
					has_pending[guid] = nil

					Update(self, "ResCastFinished", unit)

					Status:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				end
			end
		end
	end
end

local UNIT_CONNECTION = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local guid = UnitGUID(unit)
	if (not guid) then return end

	if (not UnitIsConnected(unit)) then
		if (has_pending[unit]) then
			has_pending[guid] = nil

			Update(self, "ResExpired", unit)
		elseif (next(casting_mass)) then
			for _, data in pairs(casting_single) do
				if (data.target == guid) then
					return
				end
			end
		end
	end
end

local UNIT_FLAGS = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local guid = UnitGUID(unit)
	if (not guid) then return end

	local dead = UnitIsDead(unit)

	if (not dead) then
		-- Unit is not dead
		if (is_dead[guid]) then
			-- Unit was dead
			is_dead[guid] = nil

			if (has_pending[guid]) then
				-- Unit was pending
				is_ghost[guid] = nil
				has_pending[guid] = nil

				Update(self, "ResUsed", unit)
			elseif next(casting_mass) then
				for _, data in pairs(casting_single) do
					if (data.target == guid) then return end
				end

				-- Loop through all frames
				local frames = Roster:GetAllUnitFrames()
				for unit, frame in next, frames do
					Update(frame, "UnitUpdate", unit)
				end
			end
		elseif (has_pending[guid] or has_reincarnation[guid]) then
			-- Unit was pending
			has_pending[guid] = nil
			has_reincarnation[guid] = nil

			Update(self, "UnitUpdate", unit)
		end
	elseif (not is_dead[guid]) then
		-- Unit is dead
		is_dead[guid] = true

		if (has_soulstone[guid]) then
			local end_time = GetTime() + RELEASE_PENDING_TIME
			has_pending[guid] = end_time

			Update(self, "ResPending", unit)
		elseif (next(casting_mass)) then
			-- Loop through all frames
			local frames = Roster:GetAllUnitFrames()
			for unit, frame in next, frames do
				Update(frame, "UnitUpdate", unit)
			end
		end
	elseif (not is_ghost[guid] and UnitIsGhost(unit)) then
		is_ghost[guid] = true

		if has_pending[guid] then
			has_pending[guid] = nil

			Update(self, "ResExpired", unit)
		end
		-- No need to check next(casting_mass) and fire a UnitUpdate here
		-- since Mass Resurrection will still hit units who released.
	end
end

local UNIT_AURA = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local guid = UnitGUID(unit)
	if (not guid) then return end

	if (not is_dead[guid]) then
		local stoned = AuraUtil.FindAuraByName(SOULSTONE, unit)

		if (stoned ~= has_soulstone[guid]) then
			if (not stoned and UnitHealth(unit) <= 1) then return end

			has_soulstone[guid] = stoned
			Update(self, "ResPending", unit)
		end
	else
		local reincarnation = AuraUtil.FindAuraByName(REINCARNATION, unit)

		if (reincarnation ~= has_reincarnation[guid]) then
			local end_time = GetTime() + RELEASE_PENDING_TIME

			has_reincarnation[guid] = reincarnation
			has_pending[guid] = end_time

			Update(self, "ResPending", unit)
		else
			-- Rebirth, Raise Dead, Soulstone and Eternal Guardian leaves a debuff on the resurrected target
			local resurrecting, _, _, _, _, expires = AuraUtil.FindAuraByName(RESSURECTING, unit)

			if (resurrecting ~= has_pending[guid]) then
				has_pending[guid] = expires

				Update(self, "ResPending", unit)
			end
		end
	end
end

local UNIT_HEALTH = function(self, event, unit)
	if (unit and self.unit ~= unit) then return end
	unit = unit or self.unit

	local guid = UnitGUID(unit)
	if (not guid) then return end

	if (has_pending[guid] and not UnitIsDeadOrGhost(unit)) then
		has_pending[guid] = nil

		Update(self, "ResUsed", unit)

		self:UnregisterEvent(event, UNIT_HEALTH)
	end
end

local RESURRECT_REQUEST = function(self, event, caster_name)
	local caster = UnitGUID(caster_name)

	if (casting_mass[caster]) then
		local data = casting_mass[caster]

		if (data) then
			data.finished = true

			-- Loop through all frames
			local frames = Roster:GetAllUnitFrames()
			for unit, frame in next, frames do
				Update(frame, "MassResFinished", unit)
			end
		end
	end

	local target = UnitGUID("player") -- casterFromUnit["player"] will be nil in a raid
	local end_time = GetTime() + RESURRECT_PENDING_TIME
	has_pending[target] = end_time

	self:RegisterEvent("UNIT_HEALTH", UNIT_HEALTH)

	Update(self, "ResPending", "player")
end

Status.UNIT_SPELLCAST_START = function(self, event, unit, ...)
	local _, spell_id = ...

	local res_type = spells_massres[spell_id] and "mass" or spells_singleres[spell_id] and "single"
	if (not res_type) then return end

	local guid = UnitGUID(unit)
	if (not guid) then return end

	local _, _, _, start_time, end_time = UnitCastingInfo(unit)

	local data = NewTable()

	if (res_type == "mass") then
		data.start_time = start_time / 1000
		data.end_time = end_time / 1000

		casting_mass[guid] = data

		-- Loop through all frames
		local frames = Roster:GetAllUnitFrames()
		for unit, frame in next, frames do
			Update(frame, "MassResStarted", unit)
		end

		return
	else
		data.start_time = start_time / 1000
		data.end_time = end_time / 1000

		casting_single[guid] = data
	end
end

Status.UNIT_SPELLCAST_SUCCEEDED = function(self, event, unit, ...)
	local _, spell_id = ...

	local res_type = spells_massres[spell_id] and "mass" or spells_singleres[spell_id] and "single"
	if (not res_type) then return end

	local guid = UnitGUID(unit)
	if (not guid) then return end

	if (res_type == "mass") then
		local data = casting_mass[guid]

		if (data) then -- No START event for instant cast spells.
			casting_mass[guid] = RemTable(data)

			-- Loop through all frames
			local frames = Roster:GetAllUnitFrames()
			for unit, frame in next, frames do
				Update(frame, "MassResFinished", unit)
			end
		end
	else
		local data = casting_single[guid]

		if (data) then -- No START event for instant cast spells.
			-- Probably Soulstone precast on a live target.
			if (not data.target) then return	end

			data.finished = true -- Flag so STOP can ignore this.

			local target_frame = Roster:GetGuidToFrame(data.target) -- oUF.frames.guid[target]
			local target_unit = Roster:GetGuidToUnit(data.target) 	-- oUF.frames.guidToUnit[target]

			Update(target_frame, "ResCastFinished", target_unit)
		end
	end

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

Status.UNIT_SPELLCAST_STOP = function(self, event, unit, ...)
	local _, spell_id = ...

	local res_type = spells_massres[spell_id] and "mass" or spells_singleres[spell_id] and "single"
	if (not res_type) then return end

	local guid = UnitGUID(unit)
	if (not guid) then return end

	if (res_type == "mass") then
		local data = casting_mass[guid]
		if (not data) then return end -- already SUCCEEDED

		casting_mass[guid] = RemTable(data)

		if (data.finished) then return end

		-- Loop through all frames
		local frames = Roster:GetAllUnitFrames()
		for unit, frame in next, frames do
			Update(frame, "MassResCancelled", unit)
		end
	else
		local data = casting_single[guid]

		if (data) then
			casting_single[guid] = RemTable(data)

			-- no target = Probably Soulstone precast on a live target.
			-- finished = Cast finished. Don't fire a callback or unregister CLEU.
			if (data.finished or not data.target) then return end

			local target_frame = Roster:GetGuidToFrame(data.target) -- oUF.frames.guid[target]
			local target_unit = Roster:GetGuidToUnit(data.target) -- oUF.frames.guidToUnit[target]

			Update(target_frame, "ResCastCancelled", target_unit)
		end
	end

	-- Unregister CLEU if there are no casts:
	if (not next(casting_single) and not next(casting_mass)) then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end
Status.UNIT_SPELLCAST_INTERRUPTED = Status.UNIT_SPELLCAST_STOP

do
	local pending_timer

	local PendingRes = function(self, ...)
		if (not next(has_pending)) then
			Status:CancelTimer(pending_timer)
			pending_timer = nil
		end

		local now = GetTime()

		for guid, end_time in pairs(has_pending) do
			if (end_time - now <= 0.6) then -- It will expire before the next update.
				has_pending[guid] = nil

				local frame = Roster:GetGuidToFrame(guid) -- oUF.frames.guid[guid]
				local unit = Roster:GetGuidToUnit(guid) -- oUF.frames.guidToUnit[guid]

				Update(frame, "ResExpired", unit)
			end
		end
	end

	Status.COMBAT_LOG_EVENT_UNFILTERED = function(self, event)
		local _, sub_event, _, _, _, _, _, dest_guid = CombatLogGetCurrentEventInfo()
		if (sub_event ~= "SPELL_RESURRECT") then return end

		local dest_unit = Roster:GetGuidToUnit(dest_guid) -- oUF.frames.guidToUnit[dest_guid]
		if (not dest_unit) then return end

		local now = GetTime()
		local end_time = now + RESURRECT_PENDING_TIME

		has_pending[dest_guid] = end_time

		if (not pending_timer) then
			pending_timer = Status:ScheduleRepeatingTimer(PendingRes, 0.5)
		end

		local frame = Roster:GetUnitToFrame(dest_unit) -- oUF.frames.unit[dest_unit]

		Update(frame, "ResPending", dest_unit)

		-- Unregister CLEU if there are no casts:
		if (not next(casting_single) and not next(casting_mass)) then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
	end
end

--[[

]]
local Enable = function(self)
	if (self.__is_grid) then
		self:RegisterEvent("INCOMING_RESURRECT_CHANGED", INCOMING_RESURRECT_CHANGED)
		self:RegisterEvent("RESURRECT_REQUEST", RESURRECT_REQUEST, true)
		self:RegisterEvent("UNIT_AURA", UNIT_AURA)
		self:RegisterEvent("UNIT_CONNECTION", UNIT_CONNECTION)
		self:RegisterEvent("UNIT_FLAGS", UNIT_FLAGS)
		return true
	end
end

local Disable = function(self)
	if (self.__is_grid) then
		self:UnregisterEvent("INCOMING_RESURRECT_CHANGED", INCOMING_RESURRECT_CHANGED)
		self:UnregisterEvent("RESURRECT_REQUEST", RESURRECT_REQUEST)
		self:UnregisterEvent("UNIT_AURA", UNIT_AURA)
		self:UnregisterEvent("UNIT_CONNECTION", UNIT_CONNECTION)
		self:UnregisterEvent("UNIT_FLAGS", UNIT_FLAGS)

		return true
	end
end

oUF:AddElement("StatusRes", Update, Enable, Disable)

Status.OnEnable = function(self)
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
end

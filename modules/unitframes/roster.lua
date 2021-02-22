--[[


--]]
local DraeUI = select(2, ...)

local Roster = DraeUI:NewModule("Roster")

--
local UnitGUID, UnitName, UnitClass = UnitGUID, UnitName, UnitClass
local UNKNOWN = UNKNOWN
local select = select

--
local frames = {
	unit = {},	-- unit to frame
	guid = {}	-- guid to frame
}

local roster = {
	unit 	= {},	-- unit to guid
	guid 	= {},	-- guid to unit
	class	= {}	-- unit to UnitClass
}

--[[

]]
Roster.GetAllUnitFrames = function(self)
	return frames.unit
end

Roster.GetUnitToFrame = function(self, unit)
	return frames.unit[unit] and frames.unit[unit] or nil
end

Roster.GetGuidToFrame = function(self, guid)
	return frames.guid[guid] and frames.guid[guid] or nil
end

Roster.GetUnitToGuid = function(self, unit)
	return roster.unit[unit] and roster.unit[unit] or nil
end

Roster.GetGuidToUnit = function(self, guid)
	return roster.guid[guid] and roster.guid[guid] or nil
end

Roster.GetUnitClass = function(self, unit)
	return roster.class[unit] and roster.class[unit] or nil
end

--[[
	Hooks oUF PreUpdate of each raid header frame, this fires on creation and update,
	here a bunch of stuff is done specific to this frame inc. storing info about
	the related unit, it's guid, etc. and pre-generating indicator and status
	tables
--]]
Roster.UpdateRoster = function(frame, event)
	if (not frame.unit) then return end

	local guid = UnitGUID(frame.unit)
	if (not guid) then return end

	local unit = frame.unit
	local refUnit = unit:gsub("pet", "")

	-- "pet"
	if (refUnit == "") then
		refUnit = "player"
	end

	frames.unit[unit] = frame
	frames.guid[guid] = frame

	roster.unit[unit] = guid
	roster.guid[guid] = unit
	roster.class[unit] = UnitName(refUnit) ~= UNKNOWN and select(2, UnitClass(refUnit))
end

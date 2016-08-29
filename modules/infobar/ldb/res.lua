--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:GetModule("Infobar")
local RES = IB:NewModule("Res", "AceEvent-3.0", "AceTimer-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeRes", {
	type = "draeUI",
	icon = nil,
	label = "DraeRes",
})

local GetSpellInfo, GetSpellCharges = GetSpellInfo, GetSpellCharges
--[[

]]
local resAmount = 0
local inCombat = false
local redemption, feign = GetSpellInfo(27827), GetSpellInfo(5384)
local theDead = {}
local theRes = {}
local addResTimer, updateResTimer
local class

RES.UpdateTimer = function(self)
	local charges, maxCharges, started, duration = GetSpellCharges(20484) -- Rebirth
--		if (not charges) then return end

	local time = duration - (GetTime() - started)
	local min = floor(time / 60)
	local sec = mod(time, 60)

	if (next(theDead)) then
		for k, v in next, theDead do
			if (UnitBuff(k, redemption) or UnitBuff(k, feign) or UnitIsFeignDeath(k)) then -- The backup plan, you need one with Blizz
				theDead[k] = nil
			end
		end
	end

	LDB.text = format(charges == 0 and "|cffff0000%d|rres (%d:%02d)" or "|cff00ff00%d|rres (%d:%02d)", charges, min, sec)
end

RES.UpdateRes = function(self)
	local charges, maxCharges, started, duration = GetSpellCharges(20484) -- Rebirth

	if (charges) then
		if (not inCombat) then
			inCombat = true
			wipe(theDead)
			wipe(theRes)

			addResTimer = RES:ScheduleRepeatingTimer("UpdateTimer", 1)
			RES:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end

		if (charges ~= resAmount) then
			resAmount = charges
		end
	elseif inCombat and not charges then
		inCombat = false
		resAmount = 0

		RES:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		RES:CancelTimer(addResTimer)

		LDB.text = format("|cff00ff000|rres (0:00)")
	end
end

RES.ZONE_CHANGED_NEW_AREA = function(self)
	local _, instanceType = GetInstanceInfo()

	if (instanceType == "raid") then
		if (not inCombat) then
			self:CancelTimer(updateResTimer)
			self:CancelTimer(addResTimer)
		end

		updateResTimer = self:ScheduleRepeatingTimer("UpdateRes", 1.0)

		LDB.ShowPlugin = true
	else
		LDB.ShowPlugin = false
	end
end

local getPetOwner = function(pet, guid)
	if UnitGUID("pet") == guid then
		return UnitName("player") or "Unknown"
	end

	local owner
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			if UnitGUID(("raid%dpet"):format(i)) == guid then
				owner = ("raid%d"):format(i)
				break
			end
		end
	else
		for i = 1, GetNumSubgroupMembers() do
			if UnitGUID(("party%dpet"):format(i)) == guid then
				owner = ("party%d"):format(i)
				break
			end
		end
	end

	if owner then
		return UnitName(owner) or "Unknown"
	end

	return pet
end

RES.COMBAT_LOG_EVENT_UNFILTERED = function(self, ...)
	local _, _, event, _, sGuid, name, _, _, tarGuid, tarName = ...

	if (event == "SPELL_RESURRECT") then
		if spellId == 126393 then -- Eternal Guardian
			name = getPetOwner(name, sGuid)
		end

		theDead[tarName] = "br"
		theRes[tarName] = name

	-- Lots of lovely checks before adding someone to the deaths table
	elseif (event == "UNIT_DIED") then
		if (UnitIsPlayer(tarName) and UnitGUID(tarName) == tarGuid and not UnitIsFeignDeath(tarName) and not UnitBuff(tarName, redemption) and not UnitBuff(tarName, feign)) then
			theDead[tarName] = true
		end
	end
end

LDB.OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

	GameTooltip:ClearLines()

	GameTooltip:AddLine("Players Ressed:")
	GameTooltip:AddLine(" ")

	if (next(theRes)) then
		for tarName, name in pairs(theRes) do
			local class

			_, class = UnitClass(tarName)
			local t = class and RAID_CLASS_COLORS[class] or GRAY_FONT_COLOR -- Failsafe, rarely UnitClass can return nil

			_, class = UnitClass(name)
			local s = class and RAID_CLASS_COLORS[class] or GRAY_FONT_COLOR -- Failsafe, rarely UnitClass can return nil

			local shortName = name:gsub("%-.+", "*")
			local shortTarName = tarName:gsub("%-.+", "*")

			GameTooltip:AddDoubleLine(("|H%s|h|cFF%02x%02x%02x%s|r|h"):format(name, s.r * 255, s.g * 255, s.b * 255, shortName), ("by |H%s|h|cFF%02x%02x%02x%s|r|h"):format(tarName, t.r * 255, t.g * 255, t.b * 255, shortTarName))
		end
	else
		GameTooltip:AddLine("|cffffffffNone|r")
	end

	GameTooltip:Show()
end

LDB.OnLeave = function(self)
	GameTooltip:Hide()
end

RES.OnInitialize = function(self)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	self:ZONE_CHANGED_NEW_AREA()
end

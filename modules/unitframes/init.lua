--[[


--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:NewModule("UnitFrames", "AceEvent-3.0", "AceTimer-3.0")

--
local GetSpecialization, GetNumGroupMembers, GetRaidRosterInfo, InCombatLockdown = GetSpecialization, GetNumGroupMembers, GetRaidRosterInfo, InCombatLockdown
local pairs = pairs


-- Contains the raid headers
UF.raidHeaders = {}
UF.relPoint = ""

-- Functions for instance specific raid debuffs
UF.raiddebuffs = {
	instances = {}
}

local CheckSpec
do
	local healerClasses = {
		["DRUID"] = 4,
		["MONK"] = 2,
		["PALADIN"] = 1,
		["SHAMAN"] = 3
	}

	CheckSpec = function()
		local spec = GetSpecialization()

		if (UF.playerSpec == spec) then
			return
		end

		-- Base dispel capabilities for each class regardless of spec
		UF.dispellClasses = {}
		UF.dispellClasses = {
			["PRIEST"] = {
				["Disease"] = true,
				["Magic"] = true
			},
			["SHAMAN"] = {
				["Curse"] = true
			},
			["PALADIN"] = {
				["Poison"] = true,
				["Disease"] = true
			},
			["MAGE"] = {
				["Curse"] = true
			},
			["DRUID"] = {
				["Curse"] = true,
				["Poison"] = true
			},
			["MONK"] = {
				["Disease"] = true,
				["Poison"] = true
			}
		}

		-- All healer classes can dispell magic
		if (healerClasses[DraeUI.playerClass] and healerClasses[DraeUI.playerClass] == spec) then
			UF.dispellClasses[DraeUI.playerClass]["Magic"] = true
		end

		UF.playerSpec = spec
	end
end

--[[
		Local functions
--]]
local GetNumSubGroupsinRaid = function()
	local numRaidMembers = GetNumGroupMembers()
	local numSubGroups, maxInSubGroup, currentGroup = 1, 0, 0

	for i = 1, numRaidMembers do
		local groupNum = select(3, GetRaidRosterInfo(i))

		-- If we have no one in group 1 but people in groups 2 and 3
		-- we _still_ treat it as a > 10 man group, so this works fine
		if (groupNum and numSubGroups < groupNum) then
			numSubGroups = groupNum
		end

		if (currentGroup == groupNum) then
			maxInSubGroup = maxInSubGroup + 1
		else
			maxInSubGroup = 1
		end

		currentGroup = groupNum
	end

	return numSubGroups
end

local CreateRaidAnchor = function(header, numSubGroups)
	for i = numSubGroups, 1, -1 do
		if (DraeUI.db["raidframes"].position[i]) then
			header:SetPoint(unpack(DraeUI.db["raidframes"].position[i]))
			break
		end
	end
end

local getRelativePoint = function(point, horizontal)
	if (point == "TOPLEFT") then
		if (horizontal == "HORIZONTAL") then
			return "BOTTOMLEFT", 1, -1
		else
			return "TOPRIGHT", 1, -1
		end
	elseif (point == "TOPRIGHT") then
		if (horizontal == "HORIZONTAL") then
			return "BOTTOMRIGHT", -1, -1
		else
			return "TOPLEFT", -1, -1
		end
	elseif (point == "BOTTOMLEFT") then
		if (horizontal == "HORIZONTAL") then
			return "TOPLEFT", 1, 1
		else
			return "BOTTOMRIGHT", 1, 1
		end
	elseif (point == "BOTTOMRIGHT") then
		if (horizontal == "HORIZONTAL") then
			return "TOPRIGHT", -1, 1
		else
			return "BOTTOMLEFT", -1, 1
		end
	end
end

local getColumnAnchorPoint = function(point, horizontal)
	if (horizontal ~= "HORIZONTAL") then
		if (point == "TOPLEFT" or point == "BOTTOMLEFT") then
			return "LEFT"
		elseif (point == "TOPRIGHT" or point == "BOTTOMRIGHT") then
			return "RIGHT"
		end
	else
		if (point == "TOPLEFT" or point == "TOPRIGHT") then
			return "TOP"
		elseif (point == "BOTTOMLEFT" or point == "BOTTOMRIGHT") then
			return "BOTTOM"
		end
	end

	return point
end

--[[
		Spawn the frames
--]]
UF.OnEnable = function(self)
	CheckSpec()

	-- Invert the statusmap table so we have a list of statuses and the indicators
	-- to which they map
	do
		local inv = {}

		for indicator, statuses in pairs(DraeUI.dbClass.statusmap) do
			for status, priority in pairs(statuses) do
				if (not inv[status]) then
					inv[status] = {}
				end

				inv[status][indicator] = priority
			end
		end

		UF.inverted_statusmap = inv
	end

	-- Disable certain blizzard frames
	BuffFrame:Kill()
	TemporaryEnchantFrame:Kill()
	CompactRaidFrameContainer:Kill()
	CompactRaidFrameManager:Kill()

	-- Player
	oUF:SetActiveStyle("DraePlayer")
	oUF:Spawn("player", "DraePlayer"):SetPoint("CENTER", UIParent, DraeUI.db["frames"].playerXoffset, DraeUI.db["frames"].playerYoffset)

	-- Target
	oUF:SetActiveStyle("DraeTarget")
	oUF:Spawn("target", "DraeTarget"):SetPoint("CENTER", UIParent, DraeUI.db["frames"].targetXoffset, DraeUI.db["frames"].targetYoffset)

	-- Target of target
	oUF:SetActiveStyle("DraeTargetTarget")
	oUF:Spawn("targettarget", "DraeTargetTarget"):SetPoint("BOTTOMLEFT", "DraeTarget", "BOTTOMRIGHT", DraeUI.db["frames"].totXoffset, DraeUI.db["frames"].totYoffset)

	-- Focus
	oUF:SetActiveStyle("DraeFocus")
	oUF:Spawn("focus", "DraeFocus"):SetPoint("BOTTOMRIGHT", "DraeTarget", "TOPRIGHT", DraeUI.db["frames"].focusXoffset, DraeUI.db["frames"].focusYoffset)

	-- Focus target
	oUF:SetActiveStyle("DraeFocusTarget")
	oUF:Spawn("focustarget", "DraeFocusTarget"):SetPoint("LEFT", "DraeFocus", "RIGHT", DraeUI.db["frames"].focusTargetXoffset, DraeUI.db["frames"].focusTargetYoffset)

	-- Pet
	oUF:SetActiveStyle("DraePet")
	oUF:Spawn("pet", "DraePet"):SetPoint("BOTTOMRIGHT", "DraePlayer", "TOPRIGHT", DraeUI.db["frames"].petXoffset, DraeUI.db["frames"].petYoffset)

	-- Boss frames
	if (DraeUI.db["frames"].showBoss) then
		oUF:SetActiveStyle("DraeBoss")

		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			local frame = oUF:Spawn("boss" .. i, "DraeBoss" .. i)

			if (i == 1) then
				frame:SetPoint("LEFT", "DraeTarget", "LEFT", DraeUI.db["frames"].bossXoffset, DraeUI.db["frames"].bossYoffset)
			else
				frame:SetPoint("TOP", boss[i - 1], "BOTTOM", 0, -35)
			end

			boss[i] = frame
		end
	end

	-- Arena and arena prep frames
	if (DraeUI.db["frames"].showArena) then
		oUF:SetActiveStyle("DraeArena")

		local arena = {}

		for i = 1, 5 do
			local frame = oUF:Spawn("arena" .. i, "DraeArena" .. i)

			if (i == 1) then
				frame:SetPoint("LEFT", "DraeTarget", "LEFT", DraeUI.db["frames"].arenaXoffset, DraeUI.db["frames"].arenaYoffset)
			else
				frame:SetPoint("BOTTOM", arena[i - 1], "TOP", 0, 35)
			end

			arena[i] = frame
		end
	end

	--[[
		Raid and party frames
	--]]

	-- Setup orientation and determine relative points and directions for groups
	local xOffset, yOffset, point

	if (DraeUI.db["raidframes"].gridLayout == "HORIZONTAL") then
		if (DraeUI.db["raidframes"].gridGroupsAnchor == "TOPLEFT" or DraeUI.db["raidframes"].gridGroupsAnchor == "BOTTOMLEFT") then
			xOffset = DraeUI.db["raidframes"].padding
			yOffset = 0
			point = "LEFT"
		else
			xOffset = -DraeUI.db["raidframes"].padding
			yOffset = 0
			point = "RIGHT"
		end
	else
		if (DraeUI.db["raidframes"].gridGroupsAnchor == "TOPLEFT" or DraeUI.db["raidframes"].gridGroupsAnchor == "TOPRIGHT") then
			xOffset = 0
			yOffset = -DraeUI.db["raidframes"].padding
			point = "TOP"
		else
			xOffset = 0
			yOffset = DraeUI.db["raidframes"].padding
			point = "BOTTOM"
		end
	end

	local relPoint, xMult, yMult = getRelativePoint(DraeUI.db["raidframes"].gridGroupsAnchor, DraeUI.db["raidframes"].gridLayout)
	local colAnchor = getColumnAnchorPoint(DraeUI.db["raidframes"].gridGroupsAnchor, DraeUI.db["raidframes"].gridLayout)

	self.relPoint = relPoint

	oUF:SetActiveStyle("DraeRaid")

	local numSubGroups = GetNumSubGroupsinRaid()

	local visibility = "raid,party"

	-- Create raid headers
	for i = 1, NUM_RAID_GROUPS do
		local header =
			oUF:SpawnHeader("DraeRaid" .. i, nil, visibility,
			"showPlayer", true,
			"showRaid",	true,
			"oUF-initialConfigFunction",([[
				self:SetWidth(%d)
				self:SetHeight(%d)
			]]):format(DraeUI.db["raidframes"].width, DraeUI.db["raidframes"].height),
			"groupBy", "GROUP",
			"groupFilter", tostring(i),
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"initial-width", DraeUI.db["raidframes"].width,
			"initial-height", DraeUI.db["raidframes"].height,
			"xOffset", xOffset,
			"yOffset", yOffset,
			"point", point, -- RIGHT for growing right to left, LEFT for growing left to right
			"sortMethod", "NAME",
			"sortDir", "ASC", -- DESC for left to right, ASC for right to left
			"unitsPerColumn", 5,
			"maxColumns", 8,
			"columnAnchorPoint", colAnchor
		)

		if (i == 1) then
			header:SetAttribute("showParty", true)

			CreateRaidAnchor(header, numSubGroups)
		else
			if (DraeUI.db["raidframes"].gridLayout == "HORIZONTAL") then
				xMult = 0
			else
				yMult = 0
			end

			header:SetPoint(DraeUI.db["raidframes"].gridGroupsAnchor, self.raidHeaders[i - 1], relPoint, DraeUI.db["raidframes"].padding * xMult, DraeUI.db["raidframes"].padding * yMult)
		end

		self.raidHeaders[i] = header
	end

	if (DraeUI.db["raidframes"].showPets) then
		-- Force display of party and raid pets
		SetCVar("showPartyPets", 1)

		local headerPet =
			oUF:SpawnHeader("DraeRaidPet", "SecureGroupPetHeaderTemplate", visibility,
			"showPlayer", true,
			"showRaid",	true,
			"oUF-initialConfigFunction",
			([[
				self:SetWidth(%d)
				self:SetHeight(%d)
			]]):format(DraeUI.db["raidframes"].width, DraeUI.db["raidframes"].petHeight),
			"initial-width", DraeUI.db["raidframes"].width,
			"initial-height", DraeUI.db["raidframes"].petHeight,
			"xOffset", xOffset, -- +ve for right, -ve for left
			"yOffset", yOffset,
			"point", point, -- RIGHT for growing right to left, LEFT for growing left to right
			"sortMethod", "NAME",
			"sortDir", "ASC", -- DESC for left to right, ASC for right to left
			"unitsPerColumn", 5,
			"maxColumns", 8,
			"columnSpacing", DraeUI.db["raidframes"].padding,
			"columnAnchorPoint", colAnchor
		)

		self.raidHeaders["pet"] = headerPet
	end

	self:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("UNIT_PET")
end

--[[
		Dynamically change displayed group frames when in raid
		so pet frame is always above last displayed group
--]]
UF.UpdateRaidLayout = function(self)
	if (InCombatLockdown()) then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")

	local numSubGroups = GetNumSubGroupsinRaid()

	if (GetNumGroupMembers() > 0) then
		CreateRaidAnchor(self.raidHeaders[1], numSubGroups)

		-- This is NOT generic for the config anchorpoint!
		if (DraeUI.db["raidframes"].showPets) then
			self.raidHeaders["pet"]:SetPoint(DraeUI.db["raidframes"].gridGroupsAnchor, self.raidHeaders[numSubGroups], self.relPoint, 0, DraeUI.db["raidframes"].petOffset) -- Offset from the raid group
		end
	end
end

UF.PLAYER_ENTERING_WORLD = function(self)
	self:UpdateRaidLayout()
end
UF.PLAYER_REGEN_ENABLED = UF.PLAYER_ENTERING_WORLD
UF.GROUP_ROSTER_UPDATE = UF.PLAYER_ENTERING_WORLD
UF.UNIT_PET = UF.PLAYER_ENTERING_WORLD

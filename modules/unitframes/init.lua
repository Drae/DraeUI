--[[


--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:NewModule("UnitFrames", "AceEvent-3.0", "AceTimer-3.0")

--
local GetSpecialization, GetNumGroupMembers, GetRaidRosterInfo, InCombatLockdown = GetSpecialization, GetNumGroupMembers, GetRaidRosterInfo, InCombatLockdown
local pairs = pairs

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

		if (UF.playerSpec == spec) then return end

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
		Spawn the frames
--]]
UF.OnEnable = function(self)

	self.db = DraeUI.db
	self.dbClass = DraeUI.dbClass

	CheckSpec()

	-- Disable certain blizzard frames
	BuffFrame:Kill()
	DebuffFrame:Kill()
	CompactRaidFrameContainer:Kill()
	CompactRaidFrameManager:Kill()

	-- Player
	oUF:SetActiveStyle("DraePlayer")
	oUF:Spawn("player", "DraePlayer"):SetPoint("CENTER", UIParent, self.db.frames.playerXoffset, self.db.frames.playerYoffset)

	-- Target
	oUF:SetActiveStyle("DraeTarget")
	oUF:Spawn("target", "DraeTarget"):SetPoint("CENTER", UIParent, self.db.frames.targetXoffset, self.db.frames.targetYoffset)

	-- Target of target
	oUF:SetActiveStyle("DraeTargetTarget")
	oUF:Spawn("targettarget", "DraeTargetTarget"):SetPoint("BOTTOMLEFT", "DraeTarget", "BOTTOMRIGHT", self.db.frames.totXoffset, self.db.frames.totYoffset)

	-- Focus
	oUF:SetActiveStyle("DraeFocus")
	oUF:Spawn("focus", "DraeFocus"):SetPoint("BOTTOMRIGHT", "DraeTarget", "TOPRIGHT", self.db.frames.focusXoffset, self.db.frames.focusYoffset)

	-- Focus target
	oUF:SetActiveStyle("DraeFocusTarget")
	oUF:Spawn("focustarget", "DraeFocusTarget"):SetPoint("LEFT", "DraeFocus", "RIGHT", self.db.frames.focusTargetXoffset, self.db.frames.focusTargetYoffset)

	-- Pet
	oUF:SetActiveStyle("DraePet")
	oUF:Spawn("pet", "DraePet"):SetPoint("BOTTOMRIGHT", "DraePlayer", "TOPRIGHT", self.db.frames.petXoffset, self.db.frames.petYoffset)

	-- Boss frames
	if (self.db.frames.showBoss) then
		oUF:SetActiveStyle("DraeBoss")

		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			local frame = oUF:Spawn("boss" .. i, "DraeBoss" .. i)

			if (i == 1) then
				frame:SetPoint("LEFT", "DraeTarget", "LEFT", self.db.frames.bossXoffset, self.db.frames.bossYoffset)
			else
				frame:SetPoint("TOP", boss[i - 1], "BOTTOM", 0, -35)
			end

			boss[i] = frame
		end
	end

	-- Arena and arena prep frames
	if (self.db.frames.showArena) then
		oUF:SetActiveStyle("DraeArena")

		local arena = {}

		for i = 1, 5 do
			local frame = oUF:Spawn("arena" .. i, "DraeArena" .. i)

			if (i == 1) then
				frame:SetPoint("LEFT", "DraeTarget", "LEFT", self.db.frames.arenaXoffset, self.db.frames.arenaYoffset)
			else
				frame:SetPoint("BOTTOM", arena[i - 1], "TOP", 0, 35)
			end

			arena[i] = frame
		end
	end

	--[[
		Raid and party frames
	--]]
	do
		-- Set some vars, these are used for the raidheaders
		local raidHeaders = {}
		local relPoint, point, colAnchor
		local xOffset, yOffset, xMult, yMult

		local UpdateRaidLayout

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
				if (self.db.raidframes.position[i]) then
					header:SetPoint(unpack(self.db.raidframes.position[i]))
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

		UpdateRaidLayout = function()
			if (InCombatLockdown()) then
				return self:RegisterEvent("PLAYER_REGEN_ENABLED", UpdateRaidLayout)
			end
			self:UnregisterEvent("PLAYER_REGEN_ENABLED", UpdateRaidLayout)

			local curSubGroups = raidHeaders.__subgroups
			local numSubGroups = GetNumSubGroupsinRaid()

			if (curSubGroups ~= numSubGroups) then
				CreateRaidAnchor(raidHeaders[1], numSubGroups)

					-- This is NOT generic for the config anchorpoint!
				if (self.db.raidframes.showPets) then
					raidHeaders["pet"]:SetPoint(self.db.raidframes.gridGroupsAnchor, raidHeaders[numSubGroups], relPoint, 0, self.db.raidframes.petOffset) -- Offset from the raid group
				end

				raidHeaders.__subgroups = numSubGroups
			end
		end

		-- Setup orientation and determine relative points and directions for groups
		if (self.db.raidframes.gridLayout == "HORIZONTAL") then
			if (self.db.raidframes.gridGroupsAnchor == "TOPLEFT" or self.db.raidframes.gridGroupsAnchor == "BOTTOMLEFT") then
				xOffset = self.db.raidframes.padding
				yOffset = 0
				point = "LEFT"
			else
				xOffset = -self.db.raidframes.padding
				yOffset = 0
				point = "RIGHT"
			end
		else
			if (self.db.raidframes.gridGroupsAnchor == "TOPLEFT" or self.db.raidframes.gridGroupsAnchor == "TOPRIGHT") then
				xOffset = 0
				yOffset = -self.db.raidframes.padding
				point = "TOP"
			else
				xOffset = 0
				yOffset = self.db.raidframes.padding
				point = "BOTTOM"
			end
		end

		relPoint, xMult, yMult = getRelativePoint(self.db.raidframes.gridGroupsAnchor, self.db.raidframes.gridLayout)
		colAnchor = getColumnAnchorPoint(self.db.raidframes.gridGroupsAnchor, self.db.raidframes.gridLayout)

		local numSubGroups = GetNumSubGroupsinRaid()

		oUF:SetActiveStyle("DraeRaid")

		local visibility = "raid,party"

		-- Create raid headers
		for i = 1, NUM_RAID_GROUPS do
			local header =
				oUF:SpawnHeader("DraeRaid" .. i, nil, visibility,
				"showPlayer", true,
				"showParty", true,
				"showRaid",	true,
				"oUF-initialConfigFunction",([[
					self:SetWidth(%d)
					self:SetHeight(%d)
				]]):format(self.db.raidframes.width, self.db.raidframes.height),
				"groupBy", "GROUP",
				"groupFilter", tostring(i),
				"groupingOrder", "1,2,3,4,5,6,7,8",
				"initial-width", self.db.raidframes.width,
				"initial-height", self.db.raidframes.height,
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
				CreateRaidAnchor(header, numSubGroups)
			else
				if (self.db.raidframes.gridLayout == "HORIZONTAL") then
					xMult = 0
				else
					yMult = 0
				end

				header:SetPoint(self.db.raidframes.gridGroupsAnchor, raidHeaders[i - 1], relPoint, self.db.raidframes.padding * xMult, self.db.raidframes.padding * yMult)
			end

			raidHeaders[i] = header
		end

		if (self.db.raidframes.showPets) then
			-- Force display of party and raid pets
			SetCVar("showPartyPets", 1)

			local headerPet =
				oUF:SpawnHeader("DraeRaidPet", "SecureGroupPetHeaderTemplate", visibility,
				"showPlayer", true,
				"showParty", true,
				"showRaid",	true,
				"oUF-initialConfigFunction",
				([[
					self:SetWidth(%d)
					self:SetHeight(%d)
				]]):format(self.db.raidframes.width, self.db.raidframes.petHeight),
				"initial-width", self.db.raidframes.width,
				"initial-height", self.db.raidframes.petHeight,
				"xOffset", xOffset, -- +ve for right, -ve for left
				"yOffset", yOffset,
				"point", point, -- RIGHT for growing right to left, LEFT for growing left to right
				"sortMethod", "NAME",
				"sortDir", "ASC", -- DESC for left to right, ASC for right to left
				"unitsPerColumn", 5,
				"maxColumns", 8,
				"columnSpacing", self.db.raidframes.padding,
				"columnAnchorPoint", colAnchor
			)

			raidHeaders["pet"] = headerPet
		end
		self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateRaidLayout)
		self:RegisterEvent("GROUP_ROSTER_UPDATE", UpdateRaidLayout)
		self:RegisterEvent("UNIT_PET", UpdateRaidLayout)
	end

	self:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
end

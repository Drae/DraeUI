--[[
		Common event handling, specific events are handled
		in their local functions
--]]
local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

local Smoothing = LibStub("LibCutawaySmooth-1.0", true)

-- Local copies
local _G = _G
local UIParent, CreateFrame, UnitName, UnitClass = UIParent, CreateFrame, UnitName, UnitClass
local IsPVPTimerRunning, GetPVPTimer, UnitCanAttack = IsPVPTimerRunning, GetPVPTimer, UnitCanAttack
local UUnitReaction, UnitExists = UnitReaction, UnitExists
local UnitIsPlayer, GameTooltip, InCombatLockdown = UnitIsPlayer, GameTooltip, InCombatLockdown
local CancelUnitBuff, UnitIsFriend, GetShapeshiftFormID, DebuffTypeColor = CancelUnitBuff, UnitIsFriend, GetShapeshiftFormID, DebuffTypeColor
local UnitFrame_OnEnter, UnitFrame_OnLeave = UnitFrame_OnEnter, UnitFrame_OnLeave
local RAID_CLASS_COLORS, FACTION_BAR_COLORS = RAID_CLASS_COLORS, FACTION_BAR_COLORS
local select, upper, format, gsub, unpack, pairs, huge, insert = select, string.upper, string.format, string.gsub, unpack, pairs, math.huge, table.insert

--[[
		Local functions
--]]
local Menu = function(self)
	local cUnit = self.unit:gsub("(.)", upper, 1)

	if(_G[cUnit .. "FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cUnit .. "FrameDropDown"], "cursor", 0, 0)
	end
end

--[[
		General frame related functions
--]]
UF.CommonInit = function(self, noBg)
	self.menu = Menu -- Enable the menus

	-- Register for mouse clicks, for menu
	self:RegisterForClicks("AnyDown")
	self:SetAttribute("type2", "menu")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
end

UF.CommonPostInit = function(self, size, noRaidIcons)
	-- raid target icons for all frames
	if (not noRaidIcons) then
		local raidIcon = self.Health:CreateTexture(nil, "OVERLAY")
		raidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
		raidIcon:SetPoint("TOP", self.Power and self.Power or self.Health, "BOTTOM", 0, size / 2)
		raidIcon:SetSize(size, size)
		self.RaidTargetIndicator = raidIcon
	end

	self.SpellRange = {
		insideAlpha = 1.00,
		outsideAlpha = 0.5
	}
end

UF.CreateHealthBar = function(self, width, height, x, y, point, reverse)
	local hpborder = self:CreateTexture(nil, "BORDER", nil, 1)
	hpborder:SetSize(width + 4, height + 4)
	hpborder:SetPoint(point and "TOPRIGHT" or "TOPLEFT", self, point and "TOPRIGHT" or "TOPLEFT", x, y)
	hpborder:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	hpborder:SetVertexColor(0.05, 0.05, 0.05)

	local hpbg = self:CreateTexture(nil, "BORDER", nil, 0)
	hpbg:SetSize(width + 2, height + 2)
	hpbg:SetPoint("TOPLEFT", hpborder, "TOPLEFT", 1, -1)
	hpbg:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	hpbg:SetVertexColor(0, 0, 0)

	local hp = CreateFrame("StatusBar", nil, self)
	hp:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
	hp:SetReverseFill(reverse and true or false)
	hp:SetSize(width, height)
	hp:SetPoint("TOPLEFT", hpborder, "TOPLEFT", 2, -2)

	hp.hpborder = hpborder
	hp.hpbg = hpbg

	hp.colorClass = true
	hp.colorClassPet = false
	hp.colorHealth = true
	hp.colorDisconnected = true
	hp.colorTapping = true
	hp.colorReaction = true
	hp.frequentUpdates = true

	hp.PostUpdate = UF.PostUpdateHealth

	Smoothing:EnableBarAnimation(hp)

	return hp
end

UF.CreatePowerBar = function(self, width, height, point, reverse)
	local ppborder = self:CreateTexture(nil, "BORDER", nil, 1)
	ppborder:SetSize(width + 4, height + 4)
	ppborder:SetPoint(point and "TOPRIGHT" or "TOPLEFT", self.Health.hpborder, point and "BOTTOMRIGHT" or "BOTTOMLEFT", 0, 3)
	ppborder:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	ppborder:SetVertexColor(0.05, 0.05, 0.05)

	local ppbg = self:CreateTexture(nil, "BORDER", nil, 0)
	ppbg:SetSize(width + 2, height + 2)
	ppbg:SetPoint("TOPLEFT", ppborder, "TOPLEFT", 1, -1)
	ppbg:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	ppbg:SetVertexColor(0, 0, 0)

	local pp = CreateFrame("StatusBar", nil, self)
	pp:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
	pp:SetReverseFill(reverse and true or false)
	pp:SetSize(width, height)
	pp:SetPoint("TOPLEFT", ppborder, "TOPLEFT", 2, -2)

	pp.ppborder = ppborder
	pp.ppbg = ppbg

	pp.Override = UF.OverridePower
	pp.colorTapping = true
	pp.colorDisconnected = true
	pp.colorPower = true

	pp.__statusbartex = "Interface\\AddOns\\draeUI\\media\\statusbars\\striped"

	pp.frequentUpdates = true

	Smoothing:EnableBarAnimation(pp)

	return pp
end

UF.CreateAdditionalPower = function(self, width, height, point, reverse)
--[[	local ppborder = self:CreateTexture(nil, "BORDER", nil, 1)
	ppborder:SetSize(width + 4, height + 4)
	ppborder:SetPoint(point and "TOPRIGHT" or "TOPLEFT", self.Power.ppborder, point and "BOTTOMRIGHT" or "BOTTOMLEFT", 0, 3)
	ppborder:SetTexture("Interface\\BUTTONS\\WHITE8X8")

	local ppbg = self:CreateTexture(nil, "BORDER", nil, 0)
	ppbg:SetSize(width + 2, height + 2)
	ppbg:SetPoint("TOPLEFT", ppborder, "TOPLEFT", 1, -1)
	ppbg:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	ppbg:SetVertexColor(0, 0, 0)
]]
	local pp = CreateFrame("StatusBar", nil, self)
	pp:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
	pp:SetReverseFill(reverse and true or false)
	pp:SetSize(width, height)
	pp:SetPoint("TOPLEFT", ppborder, "TOPLEFT", 2, -2)

	pp.colorDisconnected = true
	pp.colorPower = true
	pp.frequentUpdates = true

	Smoothing:EnableBarAnimation(pp)

	return pp
end

-- Leader, PvP, Role, etc.
UF.FlagIcons = function(frame, reverse)
	-- Leader icon
	local leader = frame:CreateTexture(nil, "OVERLAY", 6)
	leader:SetPoint("CENTER", frame.Portrait and frame.Portrait or frame, reverse and "TOPLEFT" or "TOPRIGHT", 0, -5)
	leader:SetSize(16, 16)
	frame.LeaderIndicator = leader

	-- Assistant icon
	local assistant = frame:CreateTexture(nil, "OVERLAY", 6)
	assistant:SetPoint("CENTER", frame.Portrait and frame.Portrait or frame, reverse and "TOPLEFT" or "TOPRIGHT", 0, -5)
	assistant:SetSize(16, 16)
	frame.AssistantIndicator = assistant

	-- pvp icon
	local pvp = frame:CreateTexture(nil, "OVERLAY", nil, 6)
	pvp:SetSize(28, 28)
	pvp:SetPoint("CENTER", frame.Portrait and frame.Portrait or frame, reverse and "TOPRIGHT" or "TOPLEFT", 0, -8)
	frame.PvPIndicator = pvp

	-- Dungeon role
	local lfdRole = frame:CreateTexture(nil, "OVERLAY", 6)
	lfdRole:SetPoint("CENTER", frame.Portrait and frame.Portrait or frame, reverse and "BOTTOMRIGHT" or "BOTTOMLEFT", 0, 0)
	lfdRole:SetSize(16, 16)
	frame.GroupRoleIndicator = lfdRole
end

-- Aura handling
do
	local AuraOnEnter = function(self)
		if (not self:IsVisible()) then return end

		-- Add aura owner to tooltip if available - colour by class/reaction because it looks nice!
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetUnitAura(self.parent:GetParent().unit, self:GetID(), self.filter)

		if (self.caster and UnitExists(self.caster)) then
			local color

			if (UnitIsPlayer(self.caster)) then
				if (RAID_CLASS_COLORS[select(2, UnitClass(self.caster))]) then
					color = RAID_CLASS_COLORS[select(2, UnitClass(self.caster))]
				end
			else
				color = FACTION_BAR_COLORS[UnitReaction(self.caster, "player")]
			end

			GameTooltip:AddLine(("Cast by %s%s|r"):format(T.Hex(color.r, color.g, color.b), UnitName(self.caster)))
		end

		GameTooltip:Show()
	end

	local AuraOnLeave = function(self)
		GameTooltip:Hide()
	end

	local CreateAuraIcon = function(icons, index)
		local button = CreateFrame("Button", nil, icons)

		button:EnableMouse(true)
		button:RegisterForClicks("RightButtonUp")

		button:SetWidth(icons.size or 16)
		button:SetHeight(icons.size or 16)

		local border = CreateFrame("Frame", nil, button)
		border:SetPoint("TOPLEFT", button, -2, 2)
		border:SetPoint("BOTTOMRIGHT", button, 2, -2)
		border:SetFrameStrata("BACKGROUND")
		border:SetBackdrop {
			edgeFile = "Interface\\Buttons\\White8x8",
			tile = false,
			edgeSize = 2
		}
		border:SetBackdropBorderColor(0, 0, 0)
		button.border = border

		local icon = button:CreateTexture(nil, "BACKGROUND")
		icon:SetTexCoord(.1, .9, .1, .9)
		icon:SetAllPoints(button)
		button.icon = icon

		local overlay = button:CreateTexture(nil, "OVERLAY")
		button.overlay = overlay

		local cd = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
		cd:SetReverse(true)
		cd:SetAllPoints(button)
		button.cd = cd

		local count = button:CreateFontString(nil)
		count:SetFont(T["media"].font, T.db["general"].fontsize3, "THINOUTLINE")
		count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 7, -6)
		button.count = count

		local stealable = button:CreateTexture(nil, "OVERLAY")
		stealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
		stealable:SetPoint("TOPLEFT", icon, "TOPLEFT")
		stealable:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT")
		stealable:SetBlendMode("ADD")
		button.stealable = stealable

		button.parent = icons

		button:SetScript("OnEnter", AuraOnEnter)
		button:SetScript("OnLeave", AuraOnLeave)

		local unit = icons:GetParent().unit

		if (unit == "player") then
			button:SetScript("OnClick", function(self)
				if (InCombatLockdown()) then return end

				CancelUnitBuff(self.parent:GetParent().unit, self:GetID(), self.filter)
			end)
		end

		return button
	end

	local PostUpdateIcon = function(self, unit, icon, index)
		local color = DebuffTypeColor[icon.dtype]

		if (color) then
			icon.border:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			icon.border:SetBackdropBorderColor(0, 0, 0)
		end

		if (icon.debuff and icon.isEnemy and not icon.isPlayer) then
			icon.icon:SetDesaturated(true)
		else
			icon.icon:SetDesaturated(false)
		end
	end

	local CustomFilter = function(element, unit, button, name, _, _, _, dtype, duration, _, caster, _, _, spellid, _, isBossDebuff)
		button.isPlayer = (caster == "player" or caster == "vehicle" or caster == "pet")
		button.isFriendly = UnitCanAssist("player", unit)
		button.isEnemy = UnitCanAttack("player", unit)

		button.duration = (duration == 0) and huge or duration
		button.caster = caster
		button.dtype = dtype

		if (T.db["frames"].auras.blacklistAuraFilter[name]) then
			return false
		end

		--local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellid, "ENEMY_TARGET")

		--[[
				* All non-zero duration buffs on friendly targets (pre-filter affects this)
				* All buffs on enemy targets (pre-filter affects this)
				* Short term buffs on player/pet
		--]]
		if (button.filter == "HELPFUL") then
			if (unit ~= "player" and unit ~= "pet" and unit ~= "vehicle" and duration > 0) then
				if (T.db["frames"].auras.showBuffsOnFriends and button.isFriendly) then
					return true
				elseif (T.db["frames"].auras.showBuffsOnEnemies and button.isEnemy) then
					return true
				end
			elseif (T.db["frames"].auras.showBuffsOnMe and duration > 0 and duration <= 600) then
				return true
			end
		end

		--[[
				* All debuffs on friendly targets (pre-filter affects this)
				* My debuffs on enemy targets
				* All debuffs on player/pet (pre-filter affects this)
		--]]
		if (button.filter == "HARMFUL") then
			if (unit ~= "player" and unit ~= "pet" and unit ~= "vehicle") then
				if (T.db["frames"].auras.showDebuffsOnFriends and button.isFriendly) then
					return true
				elseif (T.db["frames"].auras.showDebuffsOnEnemies and button.isEnemy and button.isPlayer) then
					return true
				end
			elseif (T.db["frames"].auras.showDebuffsOnMe) then
				return true
			end
		end

		-- Filtered buffs/debuffs
		if (T.db["frames"].auras.filterType == "WHITELIST") then
			if (T.db["frames"].auras.whiteListFilter[element.filter == "HELPFUL" and "BUFF" or "DEBUFF"][name]) then
				return true
			end

			return false
		else
			if (T.db["frames"].auras.blackListFilter[element.filter == "HELPFUL" and "BUFF" or "DEBUFF"][name]) then
				return false
			end

			return true
		end

		return false
	end

	local CustomFilterLongBuffs = function(element, unit, button, name, _, _, _, dtype, duration, _, caster, _, _, spellid, _, isBossDebuff)
		button.isPlayer = (caster == "player" or caster == "vehicle" or caster == "pet")
		button.isFriendly = UnitCanAssist("player", unit)
		button.isEnemy = UnitCanAttack("player", unit)

		button.duration = (duration == 0) and huge or duration
		button.caster = caster
		button.dtype = dtype

		if (T.db["frames"].auras.blacklistAuraFilter[name]) then
			return false
		end

		if (button.filter == "HELPFUL") then
			if ((unit == "player" or unit == "vehicle") and (duration == 0 or duration > 600)) then
				return true
			end
		end

		return false
	end

	UF.AddDebuffs = function(self, point, relativeFrame, relativePoint, ofsx, ofsy, num, size, spacing, growthx, growthy)
		local debuffsPerRow = T.db["frames"].auras.debuffs_per_row[self.unit] or T.db["frames"].auras.debuffs_per_row["other"]

		local width = (spacing * debuffsPerRow) + (size * debuffsPerRow)
		local height = (spacing * (num / debuffsPerRow)) + (size * (num / debuffsPerRow))

		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
		debuffs:SetSize(width, height)

		debuffs.num = num
		debuffs.size = size
		debuffs.spacing	= spacing
		debuffs.initialAnchor = point
		debuffs["growth-x"] = growthx
		debuffs["growth-y"] = growthy
		debuffs.filter = "HARMFUL" -- Explicitly set the filter or the first customFilter call won"t work
		debuffs.showDebuffType = true

		debuffs.CustomFilter = CustomFilter
		debuffs.CreateIcon = CreateAuraIcon
		debuffs.PostUpdateIcon = PostUpdateIcon

		self.Debuffs = debuffs
	end

	UF.AddBuffs = function(self, point, relativeFrame, relativePoint, ofsx, ofsy, num, size, spacing, growthx, growthy)
		local buffsPerRow = T.db["frames"].auras.buffs_per_row[self.unit] or T.db["frames"].auras.buffs_per_row["other"]

		local width	= (spacing * buffsPerRow) + (size * buffsPerRow)
		local height = (spacing * (num / buffsPerRow)) + (size * (num / buffsPerRow))

		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
		buffs:SetSize(width, height)

		buffs.num = num
		buffs.size = size
		buffs.spacing = spacing
		buffs.initialAnchor = point
		buffs["growth-x"] = growthx
		buffs["growth-y"] = growthy
		buffs.filter = "HELPFUL" -- Explicitly set the filter or the first customFilter call won"t work
		buffs.showBuffType = true
		buffs.showStealableBuffs = T.playerClass == "MAGE" and T.db["frames"].showStealableBuffs or false

		buffs.CustomFilter = filter or CustomFilter
		buffs.CreateIcon = CreateAuraIcon
		buffs.PostUpdateIcon = PostUpdateIcon

		self.Buffs = buffs
	end

	UF.AddLongBuffs = function(self, point, relativeFrame, relativePoint, ofsx, ofsy)
		-- 16 per row, 2 rows, 24px size, 6px spacing
		local width	= 480
		local height = 60

		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
		buffs:SetSize(width, height)

		buffs.numDebuffs = 0

		buffs.numBuffs = 32
		buffs.size = 24
		buffs.spacing = 6
		buffs.initialAnchor = point
		buffs["growth-x"] = "LEFT"
		buffs["growth-y"] = "UP"
		buffs.filter = "HELPFUL" -- Explicitly set the filter or the first customFilter call won"t work
		buffs.showBuffType = true

		buffs.CustomFilter = CustomFilterLongBuffs
		buffs.CreateIcon = CreateAuraIcon
		buffs.PostUpdateIcon = PostUpdateIcon

		self.Auras = buffs
	end
end

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
local CreateFrame  = CreateFrame
local UnitName, UnitIsPlayer, UnitClass, UnitExists = UnitName, UnitIsPlayer, UnitClass, UnitExists
local GameTooltip, InCombatLockdown = GameTooltip, InCombatLockdown
local CancelUnitBuff, DebuffTypeColor = CancelUnitBuff, DebuffTypeColor
local UnitFrame_OnEnter, UnitFrame_OnLeave = UnitFrame_OnEnter, UnitFrame_OnLeave
local RAID_CLASS_COLORS, FACTION_BAR_COLORS = RAID_CLASS_COLORS, FACTION_BAR_COLORS
local select, upper, mhuge = select, upper, math.huge

--[[
		Local functions
--]]
local Menu = function(self)
	local cUnit = self.unit:gsub("(.)", upper, 1)

	if (_G[cUnit .. "FrameDropDown"]) then
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
		raidIcon:SetPoint("TOP", self.Health, "BOTTOM", 0, size / 2)
		raidIcon:SetSize(size, size)

		self.RaidTargetIndicator = raidIcon
	end

	self.SpellRange = {
		insideAlpha = 1.00,
		outsideAlpha = 0.5
	}
end

UF.CreateTargetArrow = function(frame)
	local arrow = frame:CreateTexture(nil, "BACKGROUND", nil, 0)
	arrow:SetSize(14, 30)
	arrow:SetPoint("RIGHT", frame, "LEFT", -7, 0)
	arrow:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\unitframe_right_arrow")
end

UF.CreateUnitFrameBackground = function(frame)
	local backdrop = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
	backdrop:SetPoint("TOPLEFT", frame.Health, "TOPLEFT", -2.5, 2.5)
	backdrop:SetFrameStrata("BACKGROUND")
	backdrop:SetBackdrop{bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = true}
	backdrop:SetBackdropColor(0, 0, 0, 1)

	if  (frame.unit ~= "player") then
		backdrop:SetPoint("BOTTOMRIGHT", frame.Power, "BOTTOMRIGHT", 2.25, -2.5)
	end

	frame.backdrop = backdrop
end

UF.CreateUnitFrameHighlight = function(frame)
	frame.backdrop.highlight = {}

	local highlightTop = frame.backdrop:CreateTexture(nil, "BACKGROUND")
	highlightTop:SetDrawLayer("BACKGROUND", -1)
	highlightTop:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\glow_horizontal")
	highlightTop:SetHeight(24)
	highlightTop:SetPoint("LEFT", frame.backdrop, "LEFT")
	highlightTop:SetPoint("RIGHT", frame.backdrop, "RIGHT")
	highlightTop:SetPoint("BOTTOM", frame.backdrop, "TOP", 0, -4)
	highlightTop:Hide()

	frame.backdrop.highlightTop = highlightTop

	local highlightBottom = frame.backdrop:CreateTexture(nil, "BACKGROUND")
	highlightBottom:SetDrawLayer("BACKGROUND", -1)
	highlightBottom:SetTexture("Interface\\AddOns\\draeUI\\media\\textures\\glow_horizontal")
	highlightBottom:SetTexCoord(0, 1, 1, 0)
	highlightBottom:SetHeight(24)
	highlightBottom:SetPoint("LEFT", frame.backdrop, "LEFT")
	highlightBottom:SetPoint("RIGHT", frame.backdrop, "RIGHT")
	highlightBottom:SetPoint("TOP", frame.backdrop, "BOTTOM", 0, 4)
	highlightBottom:Hide()

	frame.backdrop.highlightBottom = highlightBottom
end

UF.CreateHealthBar = function(frame, width, x, y, height)
	local hp = CreateFrame("StatusBar", nil, frame)
	hp:SetFrameStrata(frame:GetFrameStrata())
	hp:SetFrameLevel(frame:GetFrameLevel())
	hp:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped") --Q
	hp:SetSize(width, height or 7)
	hp:SetPoint(point and "TOPRIGHT" or "TOPLEFT", frame, point and "TOPRIGHT" or "TOPLEFT", x, y)

	hp.colorClass = true
	hp.colorClassPet = false
	hp.colorHealth = true
	hp.colorDisconnected = true
	hp.colorTapping = true
	hp.colorReaction = true

	hp.PostUpdate = UF.PostUpdateHealth

	frame.Health = hp

	Smoothing:EnableBarAnimation(hp)

	-- Total healing required to increase units health due to a heal absorb debuff/effect
	local healAbsorbBar = CreateFrame("StatusBar", nil, hp)
	healAbsorbBar:SetStatusBarTexture("Interface\\Buttons\\White8x8")
	healAbsorbBar:SetStatusBarColor(1.0, 0, 0, 0.33)
	healAbsorbBar:SetAllPoints()

	-- Total absorb/shields on target
	local absorbBar = CreateFrame("StatusBar", nil, hp)
	absorbBar:SetStatusBarTexture("Interface\\Buttons\\White8x8")
	absorbBar:SetWidth(width)
	absorbBar:SetStatusBarColor(1.0, 1.0, 1.0, 0.33)
	absorbBar:SetPoint("TOP")
	absorbBar:SetPoint("BOTTOM")
	absorbBar:SetPoint("LEFT", hp:GetStatusBarTexture(), "RIGHT")

	-- Damage (shields/absorbs) greater than health
	local overAbsorb = hp:CreateTexture(nil, "OVERLAY")
	overAbsorb:SetTexture("Interface\\Buttons\\White8x8")
	overAbsorb:SetVertexColor(1, 1, 1, 0.5) -- Always white
	overAbsorb:SetBlendMode("ADD")
	overAbsorb:SetPoint("TOP")
	overAbsorb:SetPoint("BOTTOM")
	overAbsorb:SetPoint("RIGHT")
	overAbsorb:SetWidth(3)
	overAbsorb:Hide()

	-- Healing absorb greater than health
	local overHealAbsorb = hp:CreateTexture(nil, "OVERLAY")
	overHealAbsorb:SetTexture("Interface\\Buttons\\White8x8")
	overHealAbsorb:SetVertexColor(1.0, 0, 0, 0.5)
	overHealAbsorb:SetBlendMode("ADD")
	overHealAbsorb:SetPoint("TOP")
	overHealAbsorb:SetPoint("BOTTOM")
	overHealAbsorb:SetPoint("LEFT")
	overHealAbsorb:SetWidth(3)
	overHealAbsorb:Hide()

	frame.HealthPrediction = {
		absorbBar = absorbBar,
		healAbsorbBar = healAbsorbBar,
		overAbsorb = overAbsorb,
		overHealAbsorb = overHealAbsorb,
		maxOverflow = 1.0,
	}
end

UF.CreatePowerBar = function(frame, width, height)
	local pp = CreateFrame("StatusBar", nil, frame)
	pp:SetFrameStrata(frame:GetFrameStrata())
	pp:SetFrameLevel(frame:GetFrameLevel())
	pp:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
	pp:SetSize(width, height or 3)
	pp:SetPoint("TOPLEFT", frame.Health, "BOTTOMLEFT", 0, -2.5)

	pp.Override = UF.OverridePower
	pp.colorTapping = true
	pp.colorDisconnected = true
	pp.colorPower = true

	pp.__bar_texture = "Interface\\AddOns\\draeUI\\media\\statusbars\\striped"

	Smoothing:EnableBarAnimation(pp)

	frame.Power = pp
end

UF.CreateAdditionalPower = function(frame, width, height)
	local ap = CreateFrame("StatusBar", nil, frame)
	ap:SetFrameStrata(frame:GetFrameStrata())
	ap:SetFrameLevel(frame:GetFrameLevel())
	ap:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
	ap:SetSize(width, height or 3)
	ap:SetPoint("TOPLEFT", frame.Power, "BOTTOMLEFT", 0, -2.5)

	ap.colorDisconnected = true
	ap.colorPower = true
	ap.PostVisibility = UF.AdditionalPowerPostVisibility

	Smoothing:EnableBarAnimation(ap)

	frame.AdditionalPower = ap
end

-- Totem bar
do
	local PostUpdateTotem = function(element)
		local shown = {}

		for index = 1, MAX_TOTEMS do
			local totem = element[index]

			if (totem:IsShown()) then
				totem:ClearAllPoints()
				totem:SetPoint('RIGHT', shown[#shown] or element.__owner, 'LEFT', -8, 0)
				table.insert(shown, totem)
			end
		end
	end

	UF.CreateTotemBar = function(self, point, anchor, relpoint, xOffset, yOffset)
		if (T.playerClass == "WARRIOR" or T.playerClass == "ROGUE" or T.playerClass == "PRIEST" or T.playerClass == "HUNTER") then return end

		local totem = CreateFrame("Frame", nil, self)
		totem:SetPoint(point, anchor, relpoint, xOffset, yOffset)
		totem:SetFrameLevel(12)

		local width, height	= T.db["frames"].auras.auraLrg or 24, T.db["frames"].auras.auraLrg or 24

		for i = 1, MAX_TOTEMS do
			local t = CreateFrame("Button", nil, self)
			t:SetWidth(width)
			t:SetHeight(height)

			local border = CreateFrame("Frame", nil, t, BackdropTemplateMixin and "BackdropTemplate")
			border:SetPoint("TOPLEFT", t, -2, 2)
			border:SetPoint("BOTTOMRIGHT", t, 2, -2)
			border:SetFrameStrata("BACKGROUND")
			border:SetBackdrop {
				edgeFile = "Interface\\Buttons\\White8x8",
				tile = false,
				edgeSize = 2
			}
			border:SetBackdropBorderColor(0, 0, 0)
			t.border = border

			local icon = t:CreateTexture(nil, "BACKGROUND")
			icon:SetAllPoints(t)
			icon:SetTexCoord(unpack(T.TexCoords))
			t.Icon = icon

			local cd = CreateFrame("Cooldown", nil, t)
			cd:SetAllPoints(t)
			cd:SetReverse(true)
			t.Cooldown = cd

			totem[i] = t
		end

		totem.PostUpdate = PostUpdateTotem

		self.Totems = totem
	end
end

-- Leader, PvP, Role, etc.
UF.FlagIcons = function(frame, reverse)
	-- pvp icon
	local pvp = frame:CreateTexture(nil, "OVERLAY", nil, 1)
	pvp:SetSize(48, 48)
	pvp:SetPoint("CENTER", frame, reverse and "LEFT" or "RIGHT", -12, 0)
	frame.PvPIndicator = pvp

	-- Leader icon
	local leader = frame:CreateTexture(nil, "OVERLAY", nil, 2)
	leader:SetPoint("CENTER", frame, reverse and "TOPLEFT" or "TOPRIGHT", -2, 2)
	leader:SetSize(16, 16)
	frame.LeaderIndicator = leader

	-- Assistant icon
	local assistant = frame:CreateTexture(nil, "OVERLAY", nil, 2)
	assistant:SetPoint("CENTER", frame, reverse and "TOPRIGHT" or "TOPLEFT", -2, 2)
	assistant:SetSize(16, 16)
	frame.AssistantIndicator = assistant

	-- Dungeon role
	local lfdRole = frame:CreateTexture(nil, "OVERLAY", nil, 2)
	lfdRole:SetPoint("CENTER", frame, reverse and "BOTTOMRIGHT" or "BOTTOMLEFT", 2, -2)
	lfdRole:SetSize(16, 16)
	frame.GroupRoleIndicator = lfdRole
end

-- Aura handling
do
	local AuraOnEnter = function(self)
		if (not self:IsVisible()) then
			return
		end

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

	local CreateAuraIconCore = function(icons, index)
		local button = CreateFrame("Button", icons:GetDebugName() .. "Button" .. index, icons)

		button:EnableMouse(true)

		button:SetWidth(icons.size or 16)
		button:SetHeight(icons.size or 16)

		local border = CreateFrame("Frame", icons:GetDebugName() .. "ButtonFrame" .. index, button, BackdropTemplateMixin and "BackdropTemplate")
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
		icon:SetTexCoord(unpack(T.TexCoords))
		icon:SetAllPoints(button)
		button.icon = icon

		local overlay = button:CreateTexture(nil, "OVERLAY")
		button.overlay = overlay

		local cd = CreateFrame("Cooldown", icons:GetDebugName() .. "ButtonCooldown" .. index, button, "CooldownFrameTemplate")
		cd:SetReverse(true)
		cd:SetAllPoints(button)
		button.cd = cd

		local count = button:CreateFontString(nil)
		count:SetFont(T["media"].font, T.db["general"].fontsize3, "THINOUTLINE")
		count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 7, -6)
		button.count = count

		button.parent = icons

		return button
	end

	local CreateAuraIcon = function(icons, index)
		local button = CreateAuraIconCore(icons,  index)

		button:RegisterForClicks("RightButtonUp")

		local stealable = button:CreateTexture(nil, "OVERLAY")
		stealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
		stealable:SetPoint("TOPLEFT", button, "TOPLEFT")
		stealable:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
		stealable:SetBlendMode("ADD")
		button.stealable = stealable

		button.parent = icons

		button:SetScript("OnEnter", AuraOnEnter)
		button:SetScript("OnLeave", AuraOnLeave)

		local unit = icons:GetParent().unit

		if (unit == "player") then
			button:SetScript(
				"OnClick",
				function(self)
					if (InCombatLockdown()) then
						return
					end

					CancelUnitBuff(self.parent:GetParent().unit, self:GetID(), self.filter)
				end
			)
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

	local CustomFilter = function(element, unit, button, name, _, _, dtype, duration, _, caster, _, _, spellid, _, isBossDebuff)
		button.isPlayer = (caster == "player" or caster == "vehicle" or caster == "pet")
		button.duration = (duration == 0) and mhuge or duration
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
			if (unit ~= "player" and unit ~= "pet" and unit ~= "vehicle") then
				return true
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
				return true
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

	local CustomFilterLongBuffs = function(element, unit, button, name, _, _, dtype, duration, _, caster, _, _, spellid, _, isBossDebuff)
		button.isPlayer = (caster == "player" or caster == "vehicle" or caster == "pet")
		button.duration = (duration == 0) and mhuge or duration
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
		debuffs.spacing = spacing
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

		local width = (spacing * buffsPerRow) + (size * buffsPerRow)
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

	do
		local PostUpdateWeaponEnchants = function(auras, unit)
			if (unit ~= "player") then return end

			local owner = auras.__owner
			local enchants = owner.WeaponEnchant

			local relativeFrame = auras[auras.visibleAuras]
			enchants:SetPoint("BOTTOMRIGHT", relativeFrame, "BOTTOMLEFT", enchants["offset-x"], enchants["offset-y"])
		end

		UF.AddLongBuffs = function(self, point, relativeFrame, relativePoint, ofsx, ofsy)
			-- 16 per row, 2 rows, 24px size, 6px spacing
			local width = 400
			local height = 70

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
			buffs.PostUpdate = PostUpdateWeaponEnchants

			self.Auras = buffs
		end

		-- Weapon enchants
		do
			local UpdateTooltip = function(self)
				if(GameTooltip:IsForbidden()) then return end

				GameTooltip:SetInventoryItem("player", self:GetID())
			end

			local OnEnter = function(self)
				if(GameTooltip:IsForbidden() or not self:IsVisible()) then return end

				GameTooltip:SetOwner(self, self:GetParent().__restricted and 'ANCHOR_CURSOR' or self:GetParent().tooltipAnchor)
				self:UpdateTooltip()
			end

			local OnLeave = function()
				if(GameTooltip:IsForbidden()) then return end

				GameTooltip:Hide()
			end

			local CreateWeaponEnchantIcon = function(icons, index)
				local button = CreateAuraIconCore(icons, index)

				button:SetScript('OnEnter', OnEnter)
				button:SetScript('OnLeave', OnLeave)

				button.UpdateTooltip = UpdateTooltip

				return button
			end

			UF.AddWeaponEnchants = function(self, ofsx, ofsy)
				-- 2 per row, 2 rows, 24px size, 6px spacing + space
				local width = 80
				local height = 70

				local enchants = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
				enchants:SetSize(width, height)

				enchants.size = 24
				enchants.spacing = 6
				enchants.initialAnchor = "BOTTOMRIGHT"
				enchants["growth-x"] = "LEFT"
				enchants["growth-y"] = "UP"
				enchants["offset-x"] = ofsx	-- offset from long buff auras
				enchants["offset-y"] = ofsy	-- offset from long buff auras

				enchants.CreateIcon = CreateWeaponEnchantIcon

				self.WeaponEnchant = enchants
			end
		end
	end
end

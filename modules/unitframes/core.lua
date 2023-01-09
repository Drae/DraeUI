--[[
		Common event handling, specific events are handled
		in their local functions
--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")

local Smoothing = LibStub("LibCutawaySmooth-1.0", true)

-- Local copies
local CreateFrame  = CreateFrame
local UnitName, UnitIsPlayer, UnitClass, UnitExists, UnitIsOwnerOrControllerOfUnit = UnitName, UnitIsPlayer, UnitClass, UnitExists, UnitIsOwnerOrControllerOfUnit
local GameTooltip, InCombatLockdown = GameTooltip, InCombatLockdown
local CancelUnitBuff, DebuffTypeColor = CancelUnitBuff, DebuffTypeColor
local UnitFrame_OnEnter, UnitFrame_OnLeave = UnitFrame_OnEnter, UnitFrame_OnLeave
local RAID_CLASS_COLORS, FACTION_BAR_COLORS = _G["RAID_CLASS_COLORS"], _G["FACTION_BAR_COLORS"]
local ToggleDropDownMenu = _G["ToggleDropDownMenu"]
local select, upper, mhuge = select, string.upper, math.huge

--[[
		Local functions
--]]
local Menu = function(self)
	local cUnit = self.unit:gsub("(.)", upper, 1)
print("",cUnit)
	if (_G[cUnit .. "FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cUnit .. "FrameDropDown"], "cursor", 0, 0)
	end
end

--[[
		General frame related functions
--]]
UF.CommonInit = function(self)
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
	hp:SetStatusBarTexture(DraeUI.media.statusbar) --Q
	hp:SetSize(width, height or 7)
	hp:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)

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
	pp:SetStatusBarTexture(DraeUI.media.statusbar)
	pp:SetSize(width, height or 3)
	pp:SetPoint("TOPLEFT", frame.Health, "BOTTOMLEFT", 0, -2.5)

	pp.Override = UF.OverridePower
	pp.colorTapping = true
	pp.colorDisconnected = true
	pp.colorPower = true

	pp.__bar_texture = DraeUI.media.statusbar

	Smoothing:EnableBarAnimation(pp)

	frame.Power = pp
end

UF.CreateAdditionalPower = function(frame, width, height)
	local ap = CreateFrame("StatusBar", nil, frame)
	ap:SetFrameStrata(frame:GetFrameStrata())
	ap:SetFrameLevel(frame:GetFrameLevel())
	ap:SetStatusBarTexture(DraeUI.media.statusbar)
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
				totem:SetPoint("RIGHT", shown[#shown] or element.__owner, "LEFT", -8, 0)
				table.insert(shown, totem)
			end
		end
	end

	UF.CreateTotemBar = function(self, point, anchor, relpoint, xOffset, yOffset)
		if (DraeUI.playerClass == "WARRIOR" or DraeUI.playerClass == "ROGUE" or DraeUI.playerClass == "PRIEST" or DraeUI.playerClass == "HUNTER") then return end

		local totem = CreateFrame("Frame", nil, self)
		totem:SetPoint(point, anchor, relpoint, xOffset, yOffset)
		totem:SetFrameLevel(12)

		local width, height	= DraeUI.db["frames"].auras.auraLrg or 24, DraeUI.db["frames"].auras.auraLrg or 24

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
			icon:SetTexCoord(unpack(DraeUI.db.general.texcoords))
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
		if (GameTooltip:IsForbidden() or not self:IsVisible()) then
			return
		end

		GameTooltip_SetDefaultAnchor(GameTooltip, self)

		-- Avoid parenting GameTooltip to frames with anchoring restrictions,
		-- otherwise it"ll inherit said restrictions which will cause issues with
		-- its further positioning, clamping, etc
--		GameTooltip:SetOwner(self, self:GetParent().__restricted and "ANCHOR_CURSOR" or self:GetParent().tooltipAnchor)

		if (self.caster and UnitExists(self.caster)) then
			local color

			if (UnitIsPlayer(self.caster)) then
				if (RAID_CLASS_COLORS[select(2, UnitClass(self.caster))]) then
					color = RAID_CLASS_COLORS[select(2, UnitClass(self.caster))]
				end
			else
				color = FACTION_BAR_COLORS[UnitReaction(self.caster, "player")]
			end

			GameTooltip:AddLine(("Cast by %s%s|r"):format(DraeUI.Hex(color.r, color.g, color.b), UnitName(self.caster)))
		end

		if(self.isHarmful) then
			GameTooltip:SetUnitDebuffByAuraInstanceID(self:GetParent().__owner.unit, self.auraInstanceID)
		else
			GameTooltip:SetUnitBuffByAuraInstanceID(self:GetParent().__owner.unit, self.auraInstanceID)
		end

		GameTooltip:Show()
	end

	local AuraOnLeave = function(self)
		GameTooltip:Hide()
	end

	local CreateAuraIconCore = function(element, index)
		local button = CreateFrame("Button", element:GetDebugName() .. "Button" .. index, element)

		button:EnableMouse(true)

		button:SetWidth(element.size or 16)
		button:SetHeight(element.size or 16)

		local border = CreateFrame("Frame", element:GetDebugName() .. "ButtonFrame" .. index, button, BackdropTemplateMixin and "BackdropTemplate")
		border:SetPoint("TOPLEFT", button, -2, 2)
		border:SetPoint("BOTTOMRIGHT", button, 2, -2)
		border:SetFrameStrata("BACKGROUND")
		border:SetBackdrop {
			edgeFile = "Interface\\Buttons\\WHITE8x8",
			tile = false,
			edgeSize = 2
		}
		border:SetBackdropBorderColor(0, 0, 0)
		button.Border = border

		local icon = button:CreateTexture(nil, "BACKGROUND")
		icon:SetTexCoord(unpack(DraeUI.db.general.texcoords))
		icon:SetAllPoints(button)
		button.Icon = icon

		local overlay = button:CreateTexture(nil, "OVERLAY")
		button.Overlay = overlay

		local cd = CreateFrame("Cooldown", element:GetDebugName() .. "ButtonCooldown" .. index, button, "CooldownFrameTemplate")
		cd:SetReverse(true)
		cd:SetAllPoints(button)
		button.Cooldown = cd

		local count = button:CreateFontString(nil)
		count:SetFont(DraeUI.media.font, DraeUI.db.general.fontsize3, "THINOUTLINE")
		count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 7, -6)
		button.Count = count

		button.parent = element

		return button
	end

	local CreateButton = function(element, index)
		local button = CreateAuraIconCore(element,  index)

		button:RegisterForClicks("RightButtonUp")

		local stealable = button:CreateTexture(nil, "OVERLAY")
		stealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
		stealable:SetPoint("TOPLEFT", button, "TOPLEFT")
		stealable:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
		stealable:SetBlendMode("ADD")
		button.Stealable = stealable

		button:SetScript("OnEnter", AuraOnEnter)
		button:SetScript("OnLeave", AuraOnLeave)

		return button
	end

	local PostUpdateButton = function(self, button, unit, data, position)
		local color = DebuffTypeColor[data.dispellName]

		if (color) then
			button.Border:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			button.Border:SetBackdropBorderColor(0, 0, 0)
		end

		if (button.debuff and button.isEnemy and not button.isPlayerAura) then
			button.Icon:SetDesaturated(true)
		else
			button.Icon:SetDesaturated(false)
		end
	end

	--[[
		Defines a custom filter that controls if the aura button should be shown.

		* self - the widget holding the aura buttons
		* unit - the unit on which the aura is cast (string)
		* data - [UnitAuraInfo](https://wowpedia.fandom.com/wiki/Struct_UnitAuraInfo) object (table)

		## Returns

		* show - indicates whether the aura button should be shown (boolean)
	--]]
	local CustomFilter = function(auras, unit, data)
		if (DraeUI.db["frames"].auras.blacklistAuraFilter[data.name]) then
			return false
		end

		--[[
				* All non-zero duration buffs on friendly targets (pre-filter affects this)
				* All buffs on enemy targets (pre-filter affects this)
				* Short term buffs on player/pet
		--]]
		if (auras.filter == "HELPFUL") then
			if (unit ~= "player" and unit ~= "pet" and unit ~= "vehicle") then
				return true
			elseif (DraeUI.db["frames"].auras.showBuffsOnMe and data.duration > 0 and data.duration <= 600) then
				return true
			end
		end

		--[[
				* All debuffs on friendly targets (pre-filter affects this)
				* My debuffs on enemy targets
				* All debuffs on player/pet (pre-filter affects this)
		--]]
		if (auras.filter == "HARMFUL") then
			if (unit ~= "player" and unit ~= "pet" and unit ~= "vehicle") then
				return true
			elseif (DraeUI.db["frames"].auras.showDebuffsOnMe) then
				return true
			end
		end

		-- Filtered buffs/debuffs
		if (DraeUI.db["frames"].auras.filterType == "WHITELIST") then
			if (DraeUI.db["frames"].auras.whiteListFilter[auras.filter == "HELPFUL" and "BUFF" or "DEBUFF"][data.name]) then
				return true
			end

			return false
		else
			if (DraeUI.db["frames"].auras.blackListFilter[auras.filter == "HELPFUL" and "BUFF" or "DEBUFF"][data.name]) then
				return false
			end

			return true
		end
	end

	local CustomFilterLongBuffs = function(auras, unit, data)
		if (DraeUI.db["frames"].auras.blacklistAuraFilter[data.name]) then
			return false
		end

		if (auras.filter == "HELPFUL") then
			if ((unit == "player" or unit == "vehicle") and (data.duration == 0 or data.duration > 600)) then
				return true
			end
		end

		return false
	end

	UF.AddDebuffs = function(self, point, relativeFrame, relativePoint, ofsx, ofsy, num, size, spacing, growthx, growthy)
		local debuffsPerRow = DraeUI.db["frames"].auras.debuffs_per_row[self.unit] or DraeUI.db["frames"].auras.debuffs_per_row["other"]

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

		debuffs.FilterAura = CustomFilter
		debuffs.CreateButton = CreateButton
		debuffs.PostUpdateButton = PostUpdateButton

		self.Debuffs = debuffs
	end

	UF.AddBuffs = function(self, point, relativeFrame, relativePoint, ofsx, ofsy, num, size, spacing, growthx, growthy)
		local buffsPerRow = DraeUI.db["frames"].auras.buffs_per_row[self.unit] or DraeUI.db["frames"].auras.buffs_per_row["other"]

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
		buffs.showStealableBuffs = DraeUI.playerClass == "MAGE" and DraeUI.db["frames"].showStealableBuffs or false

		buffs.FilterAura = CustomFilter
		buffs.CreateButton = CreateButton
		buffs.PostUpdateButton = PostUpdateButton

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


		local SetTooltip = function(button)
			if button:GetAttribute('index') then
				GameTooltip:SetUnitAura(button.header:GetAttribute('unit'), button:GetID(), button.filter)
			elseif button:GetAttribute('target-slot') then
				GameTooltip:SetInventoryItem('player', button:GetID())
			end
		end

		local Button_OnLeave = function()
			GameTooltip_Hide()
		end

		local Button_OnEnter = function(button)
			if (GameTooltip:IsForbidden() or not button:IsVisible()) then
				return
			end

			GameTooltip_SetDefaultAnchor(GameTooltip, button)

			-- Avoid parenting GameTooltip to frames with anchoring restrictions,
			-- otherwise it"ll inherit said restrictions which will cause issues with
			-- its further positioning, clamping, etc
			GameTooltip:SetOwner(button, button:GetParent().__restricted and "ANCHOR_CURSOR" or button:GetParent().tooltipAnchor)

			if button:GetAttribute('index') then
				GameTooltip:SetUnitAura(button.header:GetAttribute('unit'), button:GetID(), button.filter)
			elseif button:GetAttribute('target-slot') then
				GameTooltip:SetInventoryItem('player', button:GetID())
			end

			button.elapsed = 1 -- let the tooltip update next frame
		end

		local Button_OnShow = function(self)
			if self.enchantIndex then
				self.header.enchants[self.enchantIndex] = self
				self.header.elapsedEnchants = 1 -- let the enchant update next frame
			end
		end

		local Button_OnHide = function(self)
			if self.enchantIndex then
				self.header.enchants[self.enchantIndex] = nil
			else
				self.instant = true
			end
		end

		local UpdateIcon = function(child)
			child:SetSize(22, 22)
		end


		local ClearAuraTime = function(button)
			button.expiration = nil
			button.endTime = nil
			button.duration = nil
			button.modRate = nil
			button.timeLeft = nil

			button.Text:SetText("")
		end

		local UpdateTime = function(button, expiration, modRate)
			button.timeLeft = (expiration - GetTime()) / (modRate or 1)

			if button.timeLeft < 0.1 then
				ClearAuraTime(button, true)
			end
		end

		local SetAuraTime = function(button, expiration, duration, modRate)
			local oldEnd = button.endTime

			button.expiration = expiration
			button.endTime = expiration
			button.duration = duration
			button.modRate = modRate

			if oldEnd ~= button.endTime then
				button.nextUpdate = 0
			end

			UpdateTime(button, expiration, modRate)
			button.elapsed = 0 -- reset the timer for UpdateTime
		end

		local UpdateAura = function(button, index)
			local name, icon, count, debuffType, duration, expiration, _, _, _, _, _, _, _, _, modRate = UnitAura(button.header:GetAttribute("unit"), index, button.filter)
			if not name then return end

			button.Text:SetShown(true)
			button.Count:SetText(not count or count <= 1 and "" or count)
			button.Icon:SetTexture(icon)

			local dtype = debuffType or "none"

			if button.debuffType ~= dtype then
				local color = (button.filter == "HARMFUL" and _G.DebuffTypeColor[dtype])
				button:SetBackdropBorderColor(color.r, color.g, color.b)
				button.statusBar.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
				button.debuffType = dtype
			end

			if duration > 0 and expiration then
				SetAuraTime(button, expiration, duration, modRate)
			else
				ClearAuraTime(button)
			end
		end

		local UpdateTempEnchant = function(button, index, expiration)
			button.Text:SetShown(true)

			if expiration then
				button.Icon:SetTexture(GetInventoryItemTexture("player", index))

				local r, g, b
				local quality =  GetInventoryItemQuality("player", index)

				if quality and quality > 1 then
					r, g, b = GetItemQualityColor(quality)
				else
					r, g, b = 0, 0, 0
				end

				button:SetBackdropBorderColor(r, g, b)

				local remaining = (expiration * 0.001) or 0

				SetAuraTime(button, remaining + GetTime(), (remaining <= 3600 and remaining > 1800) and 3600 or (remaining <= 1800 and remaining > 600) and 1800 or 600)
			else
				ClearAuraTime(button)
			end
		end

		local Header_OnUpdate = function(header, elapsed)
			if header.elapsedSpells and header.elapsedSpells > 0.1 then
				local button, value = next(header.spells)

				while button do
					UpdateAura(button, value)

					header.spells[button] = nil
					button, value = next(header.spells)
				end

				header.elapsedSpells = 0
			else
				header.elapsedSpells = (header.elapsedSpells or 0) + elapsed
			end

			if header.elapsedEnchants and header.elapsedEnchants > 0.5 then
				local index, enchant = next(header.enchants)

				if index then
					local _, main, _, _, _, offhand, _, _, _, ranged = GetWeaponEnchantInfo()

					while enchant do
						UpdateTempEnchant(enchant, enchant:GetID(), (index == 1 and main) or (index == 2 and offhand) or (index == 3 and ranged))

						header.enchants[index] = nil
						index, enchant = next(header.enchants)
					end
				end

				header.elapsedEnchants = 0
			else
				header.elapsedEnchants = (header.elapsedEnchants or 0) + elapsed
			end
		end

		local CreateAuraButton = function(button)
			button.header = button:GetParent()

			local border = CreateFrame("Frame", nil, button, BackdropTemplateMixin and "BackdropTemplate")
			border:SetPoint("TOPLEFT", button, -2, 2)
			border:SetPoint("BOTTOMRIGHT", button, 2, -2)
			border:SetFrameStrata("BACKGROUND")
			border:SetBackdrop {
				edgeFile = "Interface\\Buttons\\WHITE8x8",
				tile = false,
				edgeSize = 2
			}
			border:SetBackdropBorderColor(0, 0, 0)
			button.Border = border

			local icon = button:CreateTexture(nil, "BACKGROUND")
			icon:SetTexCoord(unpack(DraeUI.db.general.texcoords))
			icon:SetAllPoints(button)
			button.Icon = icon

			local overlay = button:CreateTexture(nil, "OVERLAY")
			button.Overlay = overlay

			local cd = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
			cd:SetReverse(true)
			cd:SetAllPoints(button)
			button.Cooldown = cd

			local count = button:CreateFontString(nil)
			count:SetFont(DraeUI.media.font, DraeUI.db.general.fontsize3, "THINOUTLINE")
			count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 7, -6)
			button.Count = count

			button:SetScript("OnEnter", Button_OnEnter)
			button:SetScript("OnLeave", Button_OnLeave)

			UpdateIcon(button)
		end

		local UpdateAuraIcon = function(header)
			for i = 1, 40 do
				local child = header:GetAttribute("child" .. i);  -- gets the i'th automatically created button

				if (not child or not child:IsShown()) then
					return;  -- the player has fewer than 40 buffs
				end

				-- the 2nd parameter should accomodate the secure header"s sortMethod and sortDirection attributes, by using GetID()
				-- the 3rd parameter should match the secure header"s filter attribute, by using the same string
				local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura("player", child:GetID(), "HELPFUL");

				if (not child.Icon) then
					CreateAuraButton(child)
				end

				if (name) then
					child.Icon:SetTexture(icon);
					child.Icon:Show();

					if(duration > 0) then
						child.Cooldown:SetCooldown(expirationTime - duration, duration, timeMod)
						child.Cooldown:Show()
					else
						child.Cooldown:Hide()
					end

					if(child.Count) then child.Count:SetText(count > 1 and count or '') end
				else
					child.Icon:Hide();
				end
			end
		end

		-- Totally stolen from ElvUI because I"m lazy ... well, with some changes based on oUF
		UF.AddLongBuffs = function(point, relativeFrame, relativePoint, ofsx, ofsy)
			local name = "DraeUIPlayerLongBuffs"
			-- 16 per row, 2 rows, 24px size, 6px spacing
			local width = 400
			local height = 70

			local header = CreateFrame("Frame", name, _G.UIParent, "SecureAuraHeaderTemplate")

			header:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)

			header:SetClampedToScreen(true)
			header:UnregisterEvent("UNIT_AURA")
			-- we only need to watch player and vehicle
			header:RegisterUnitEvent("UNIT_AURA", "player", "vehicle")

			header:SetAttribute("template", "DraeUIPlayerLongAuraTemplate")
			header:SetAttribute("unit", "player")
			header:SetAttribute("filter", "HELPFUL")
			header:SetAttribute("consolidateDuration", -1)
			header:SetAttribute("includeWeapons", 1)
			header:SetAttribute("separateOwn", 1)
			header:SetAttribute("sortMethod", "TIME")
			header:SetAttribute("sortDirection", "+")
			header:SetAttribute("maxWraps", 2)
			header:SetAttribute("wrapAfter", 16)
			header:SetAttribute("point", "BOTTOMRIGHT")
			header:SetAttribute("minWidth", 30)
			header:SetAttribute("minHeight", 30)
			header:SetAttribute("xOffset", -30) -- (24 + 6) * -1
			header:SetAttribute("yOffset", 0)
			header:SetAttribute("wrapXOffset", 0)
			header:SetAttribute("wrapYOffset", 30) -- (24 + 6) * 1

			header.auraType = "buffs"
			header.filter = "HELPFUL"
			header.name = name
			header.enchants = {}
			header.spells = {}

			header.visibility = CreateFrame("Frame", nil, _G.UIParent, "SecureHandlerStateTemplate")
--			header.visibility:SetScript("OnUpdate", Header_OnUpdate) -- dont put this on the main frame
			header.visibility.frame = header

			-- use custom script that will only call hide when it needs to, this prevents spam to `SecureAuraHeader_Update`
			header.visibility:SetAttribute("_onstate-customVisibility", [[
				local header = self:GetFrameRef("AuraHeader")
				local hide, shown = newstate == 0, header:IsShown()
				if hide and shown then header:Hide() elseif not hide and not shown then header:Show() end
			]])

			RegisterAttributeDriver(header, "unit", "[vehicleui] vehicle; player")
			SecureHandlerSetFrameRef(header.visibility, "AuraHeader", header)
			RegisterStateDriver(header.visibility, "customVisibility", "[petbattle] 0;1")

			header:HookScript("OnEvent", UpdateAuraIcon)

			local index = 1
			local child = select(index, header:GetChildren())

			while child do
				child.auraType = header.auraType -- used to update cooldown text

				UpdateIcon(child)

				-- Blizzard bug fix, icons arent being hidden when you reduce the amount of maximum buttons
				-- maxWraps * wrapAfter
				if index > 16 and child:IsShown() then
					child:Hide()
				end

				index = index + 1
				child = select(index, header:GetChildren())
			end

--			if MasqueGroupBuffs and E.private.auras.buffsHeader and E.private.auras.masque.buffs then MasqueGroupBuffs:ReSkin() end
--			if MasqueGroupDebuffs and E.private.auras.debuffsHeader and E.private.auras.masque.debuffs then MasqueGroupDebuffs:ReSkin() end

			header:Show()
		end
	end
end

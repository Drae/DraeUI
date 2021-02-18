--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

--
local GameTooltip, CreateFrame = GameTooltip, CreateRaidAnchor
local GetWeaponEnchantInfo, UnitGUID, CombatLogGetCurrentEventInfo = GetWeaponEnchantInfo, UnitGUID, CombatLogGetCurrentEventInfo
local mfloor = math.floor

--
-- Durations of temporary enchants - assumed 60 mins unless in this table
local duration_exceptions = {
	[5386] = 600,	-- Fishing Lures - various (10 mins)
	[4264] = 600,	-- Glass Fishing Bobber (10 mins)
	[4225] = 900,	-- Heat treated fishing lure (15 mins)
	[3102] = 1800, 	-- Bloodboil poison (30 mins)
	[266] = 600,	-- Fishing Lures - various (10 mins)
	[265] = 600,	-- Fishing Lures - various (10 mins)
	[264] = 600,	-- Fishing Lures - various (10 mins)
	[263] = 600,	-- Fishing Lures - various (10 mins)
	[26] = 1800,	-- Frost Oil (30 mins)
	[25] = 1800,	-- Shadow Oil (30 mins)
}
--[[

--]]
local UpdateTooltip = function(self)
	if(GameTooltip:IsForbidden()) then return end

	GameTooltip:SetInventoryItem("player", self:GetID())
end

local OnEnter = function(self)
	if(GameTooltip:IsForbidden() or not self:IsVisible()) then return end

	-- Avoid parenting GameTooltip to frames with anchoring restrictions,
	-- otherwise it'll inherit said restrictions which will cause issues with
	-- its further positioning, clamping, etc
	GameTooltip:SetOwner(self, self:GetParent().__restricted and 'ANCHOR_CURSOR' or self:GetParent().tooltipAnchor)
	self:UpdateTooltip()
end

local OnLeave = function()
	if(GameTooltip:IsForbidden()) then return end

	GameTooltip:Hide()
end

local CreateIcon = function(element, index)
	local button = CreateFrame('Button', element:GetDebugName() .. 'Button' .. index, element)
	button:RegisterForClicks('RightButtonUp')

	local cd = CreateFrame('Cooldown', '$parentCooldown', button, 'CooldownFrameTemplate')
	cd:SetAllPoints()

	local icon = button:CreateTexture(nil, 'BORDER')
	icon:SetAllPoints()

	local countFrame = CreateFrame('Frame', nil, button)
	countFrame:SetAllPoints(button)
	countFrame:SetFrameLevel(cd:GetFrameLevel() + 1)

	local count = countFrame:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
	count:SetPoint('BOTTOMRIGHT', countFrame, 'BOTTOMRIGHT', -1, 0)

	local overlay = button:CreateTexture(nil, 'OVERLAY')
	overlay:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
	overlay:SetAllPoints()
	overlay:SetTexCoord(.296875, .5703125, 0, .515625)
	button.overlay = overlay

	button.UpdateTooltip = UpdateTooltip
	button:SetScript('OnEnter', OnEnter)
	button:SetScript('OnLeave', OnLeave)

	button.icon = icon
	button.count = count
	button.cd = cd

	--[[ Callback: Auras:PostCreateIcon(button)
	Called after a new aura button has been created.

	* self   - the widget holding the aura buttons
	* button - the newly created aura button (Button)
	--]]
	if (element.PostCreateIcon) then element:PostCreateIcon(button) end

	return button
end

local SetPosition =  function (element, from, to)
	local sizex = (element.size or 16) + (element['spacing-x'] or element.spacing or 0)
	local sizey = (element.size or 16) + (element['spacing-y'] or element.spacing or 0)
	local anchor = element.initialAnchor or 'BOTTOMLEFT'
	local growthx = (element['growth-x'] == 'LEFT' and -1) or 1
	local growthy = (element['growth-y'] == 'DOWN' and -1) or 1
	local cols = math.floor(element:GetWidth() / sizex + 0.5)

	for i = from, to do
		local button = element[i]

		-- Bail out if the to range is out of scope.
		if (not button) then break end
		local col = (i - 1) % cols
		local row = math.floor((i - 1) / cols)

		button:ClearAllPoints()
		button:SetPoint(anchor, element, anchor, col * sizex * growthx, row * sizey * growthy)
	end
end

local UpdateEnchants
do
	local weapon = {{}, {}}

	UpdateEnchants = function(self, event)
		local enchants = self.WeaponEnchant

		if (enchants) then
			local now = GetTime()

			weapon[1].state, weapon[1].expires, weapon[1].charges, weapon[1].id, weapon[2].state, weapon[2].expires, weapon[2].charges, weapon[2].id  = GetWeaponEnchantInfo()

			local visible = 0
			for index, data in ipairs(weapon) do
				if (data.state) then
					visible = visible + 1

					local position = visible
					local button = enchants[position]

					if (not button) then
						button = (enchants.CreateIcon or CreateIcon)(enchants, position)
						table.insert(enchants, button)
						enchants.createdIcons = enchants.createdIcons + 1
					end

					if (button.cd and not enchants.disableCooldown) then
						local expires = data.expires / 1000
						local duration = duration_exceptions[data.id] or 3600
						local start = now - (duration - expires)

						if (expires and expires > 0) then
							button.cd:SetCooldown(start, duration)
							button.cd:Show()
						else
							button.cd:Hide()
						end
					end

					if (button.icon) then button.icon:SetTexture(GetInventoryItemTexture("player", 16 + index - 1)) end
					if (button.count) then button.count:SetText(data.charges > 1 and data.charges) end

					local size = enchants.size or 16
					button:SetSize(size, size)

					button:EnableMouse(not enchants.disableMouse)
					button:SetID(16 + index - 1)
					button:Show()
				end
			end

			for i = visible + 1, #enchants do
				enchants[i]:Hide()
			end
		end

		if (enchants.createdIcons > enchants.anchoredIcons) then
			(enchants.SetPosition or SetPosition)(enchants, enchants.anchoredIcons + 1, enchants.createdIcons)
			enchants.anchoredIcons = enchants.createdIcons
		end
	end
end

local Update = function(self, event, unit)
	if (unit and self.unit ~= unit or self.unit ~= "player") then return end

	-- Need a small delay before actually calling the update function
	-- to allow the game client to do its server communication thing (I guess)
	C_Timer.After(0.5, function()
		UpdateEnchants(self, event)
	end)

	-- Assume no event means someone wants to re-anchor things. This is usually
	-- done by UpdateAllElements and :ForceUpdate.
	if (event == 'ForceUpdate' or not event) then
		local enchants = self.WeaponEnchant
		if (enchants) then
			(enchants.SetPosition or SetPosition)(enchants, 1, enchants.createdIcons)
		end
	end
end

local ForceUpdate = function(element)
	return Update(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
	if (self.WeaponEnchant and self.unit == "player") then
		self:RegisterEvent("UNIT_INVENTORY_CHANGED", Update)
		self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", Update, true)

		local enchants = self.WeaponEnchant
		if (enchants) then
			enchants.__owner = self
			-- check if there's any anchoring restrictions
			enchants.__restricted = not pcall(self.GetCenter, self)
			enchants.ForceUpdate = ForceUpdate

			enchants.createdIcons = enchants.createdIcons or 0
			enchants.anchoredIcons = 0
			enchants.tooltipAnchor = enchants.tooltipAnchor or 'ANCHOR_BOTTOMRIGHT'

			enchants:Show()
		end

		return true
	end
end

local Disable = function(self)
	if(self.WeaponEnchant) then
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED", Update)
	end
end

oUF:AddElement('WeaponEnchant', Update, Enable, Disable)

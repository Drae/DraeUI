--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:NewModule("Infobar", "AceEvent-3.0", "AceTimer-3.0")

-- Localise a bunch of functions
local _G = _G
local IsEncounterInProgress = IsEncounterInProgress
local pairs, ipairs, format, gupper, gsub, floor, ceil, abs, mmin, type, unpack = pairs, ipairs, string.format, string.upper, string.gsub, math.floor, math.ceil, math.abs, math.min, type, unpack
local tinsert = table.insert

-- Local variables
local cr, cg, cb = 1, 1, 1 -- Text colour

-- Containing frames for the infobar text
local infoBar = CreateFrame("Frame", nil, UIParent)
infoBar:SetFrameStrata("LOW")

local infoBarFPS = CreateFrame("Button", nil, infoBar)
local infoBarTextFPS
local infoBarMem = CreateFrame("Button", nil, infoBar)
local infoBarTextMem
local infoBarLatency = CreateFrame("Button", nil, infoBar)
local infoBarTextLatency
local infoBarDur = CreateFrame("Button", nil, infoBar)
local infoBarTextDur
local infoBarGold = CreateFrame("Button", nil, infoBar)
local infoBarTextGold
local infoBarGarrison = CreateFrame("Button", nil, infoBar)
local infoBarTextGarrison
local infoBarXP = CreateFrame("Button", nil, infoBar)
local infoBarTextXP
local infoBarRes = CreateFrame("Button", nil, infoBar)
local infoBarTextRes

--[[
		Calculation and display functions
--]]
local RepositionElements = function()
	local elements = { infoBarGold, infoBarGarrison, infoBarXP, infoBarRes }
	local elementsText = { infoBarTextGold, infoBarTextGarrison, infoBarTextXP, infoBarTextRes }
	local elementsOffsets = { 35, 35, 35, 0 }
	local startLeft = 320
	local width

	for i = 1, #elements do
		if (elements[i]:IsVisible() and elementsText[i]:GetText() ~= "" and elementsText[i]:GetText() ~= nil) then
			width = elementsText[i]:GetWidth()
			width = width + elementsOffsets[i]

			elements[i]:SetWidth(width - elementsOffsets[i])
		else
			width = 0
		end

		if (i <= #elements - 1) then
			elements[i + 1]:SetPoint("TOPLEFT", startLeft + width, 0)
			startLeft = startLeft + width
		end
	end
end

-- FPS
local UpdateFPS
do
	local timeFPS = 0
	local minFPS, maxFPS, avgFPS

	UpdateFPS = function()
		local framerate = floor(GetFramerate())

		timeFPS = timeFPS + 1

		if (timeFPS == 1) then
			minFPS = framerate
			maxFPS = framerate
			avgFPS = framerate
		else
			if (framerate < minFPS) then
				minFPS = framerate
			elseif (framerate > maxFPS) then
				maxFPS = framerate
			end

			avgFPS = (avgFPS * (timeFPS - 1) + framerate) / timeFPS
		end

		local r2, g2, b2 = T.ColorGradient(framerate / 60 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)
		infoBarTextFPS:SetFormattedText("|cff%02x%02x%02x%d|r|cff%02x%02x%02xfps|r   ", r2 * 255, g2 * 255, b2 * 255, framerate, cr * 255, cg * 255, cb * 255)
	end

	local TooltipFPS = function(self)
		GameTooltip:SetOwner(infoBarFPS, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", infoBarFPS, "BOTTOMLEFT", 0, -10)

		GameTooltip:AddLine("FPS", 1, 1, 1)

		GameTooltip:AddLine(" ")

		GameTooltip:AddDoubleLine("Minimum", format("%d", minFPS), 1, 1, 1)
		GameTooltip:AddDoubleLine("Maximum", format("%d", maxFPS), 1, 1, 1)
		GameTooltip:AddDoubleLine("Average", format("%d", avgFPS), 1, 1, 1)

		GameTooltip:Show()
	end

	-- Latency tooltip handling
	infoBarFPS:SetScript("OnEnter", function()
		TooltipFPS()
		tooltipRenew = IB:ScheduleRepeatingTimer(TooltipFPS, 1.0)
	end)
	infoBarFPS:SetScript("OnLeave", function()
		IB:CancelTimer(tooltipRenew)
		GameTooltip:Hide()
	end)
	infoBarFPS:SetScript("OnClick", function(self)
		timeFPS = 0
	end)
end

-- Latency
local TooltipLatency = function(self)
	GameTooltip:SetOwner(infoBarLatency, "ANCHOR_NONE")
	GameTooltip:Point("TOPLEFT", infoBarLatency, "BOTTOMLEFT", 0, -10)

	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()

	GameTooltip:AddLine("Latency", 1, 1, 1)

	GameTooltip:AddLine(" ")

	GameTooltip:AddDoubleLine("Latency - Home", format("%d ms", latencyHome), 1, 1, 1)
	GameTooltip:AddDoubleLine("Latency - World", format("%d ms", latencyWorld), 1, 1, 1)

	GameTooltip:AddDoubleLine("Bandwidth - In", format("%.2f kB/s", bandwidthIn), 1, 1, 1)
	GameTooltip:AddDoubleLine("Bandwidth - Out", format("%.2f kB/s", bandwidthOut), 1, 1, 1)

	GameTooltip:Show()
end

local UpdateLatency = function()
	local _, _, homeLatency, worldLatency = GetNetStats()

	local r2, g2, b2 = T.ColorGradient(homeLatency / 500 - 0.001, 0, 1, 0, 1, 1, 0, 0, 1, 0)
	local r3, g3, b3 = T.ColorGradient(worldLatency / 500 - 0.001, 0, 1, 0, 1, 1, 0, 0, 1, 0)
	infoBarTextLatency:SetFormattedText("|cff%02x%02x%02x%d|r|cff%02x%02x%02xms/|r|cff%02x%02x%02x%d|r|cff%02x%02x%02xms|r   ", r2 * 255, g2 * 255, b2 * 255, homeLatency, cr * 255, cg * 255, cb * 255, r3 * 255, g3 * 255, b3 * 255, worldLatency, cr * 255, cg * 255, cb * 255)
end

-- Calculate XP
local XPorRepChanged, TooltipXP
do
	local standings = {"hate", "host", "unfr", "neut", "frnd", "hon", "revd", "exal"}
	local curXP, maxXP, restedXP, repName, standingId, repMin, repMax, repValue, repId

	XPorRepChanged = function(self)
		local pct = 0
		local affix = ""

		if (C["infobar"].showXP and UnitLevel("player") < MAX_PLAYER_LEVEL and not IsXPUserDisabled()) then
			curXP, maxXP, restedXP = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
			if (maxXP and maxXP ~= 0) then
				pct = (curXP / maxXP) * 100

				affix = "xp" .. (restedXP and format("/|cff%02x%02x%02x%d|r|cff%02x%02x%02x%%rested|r", 0, 255, 0, restedXP / maxXP * 100, 255, 255, 255) or "")
			end
		elseif (C["infobar"].showReputation) then
			repName, standingId, repMin, repMax, repValue, repId = GetWatchedFactionInfo()
			if (repName ~= nil) then
				pct = (repValue - repMin) / (repMax - repMin) * 100

				affix = standings[standingId]
			end
		end

		if (affix ~= "") then
			local r1, g1, b1 = T.ColorGradient(pct / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)
			infoBarTextXP:SetFormattedText("|cff%02x%02x%02x%d|r|cff%02x%02x%02x%%%s|r", r1 * 255, g1 * 255, b1 * 255, pct, cr * 255, cg * 255, cb * 255, affix or "")
			infoBarXP:Show()
		else
			infoBarTextXP:SetText("")
			infoBarXP:Hide()
		end

		IB:SendMessage("INFOBAR_ELEMENT_SIZE_CHANGE")
	end

	TooltipXP = function(self)
		GameTooltip:SetOwner(infoBarXP, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", infoBarXP, "BOTTOMLEFT", 0, -10)

		if (C["infobar"].showXP and UnitLevel("player") < MAX_PLAYER_LEVEL and not IsXPUserDisabled()) then
			GameTooltip:AddLine("Experience", 1, 1, 1)
			GameTooltip:AddLine(" ")

			GameTooltip:AddDoubleLine("XP: ", format(" %d / %d (%d%%)", curXP, maxXP, curXP / maxXP * 100), 1, 1, 1)
			GameTooltip:AddDoubleLine("Remaining: ", format(" %d (%d%% - %d Bars)", maxXP - curXP, (maxXP - curXP) / maxXP * 100, 20 * (maxXP - curXP) / maxXP), 1, 1, 1)

			if (restedXP) then
				GameTooltip:AddDoubleLine("Rested: ", format("+%d (%d%%)", restedXP, restedXP / maxXP * 100), 1, 1, 1)
			end
		elseif (C["infobar"].showReputation and repName) then
			GameTooltip:AddLine("Reputation", 1, 1, 1)
			GameTooltip:AddLine(" ")

			local friendId, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(repId)

			GameTooltip:AddDoubleLine("Faction:", repName, 1, 1, 1)
			GameTooltip:AddDoubleLine(STANDING..":", friendId and friendTextLevel or _G["FACTION_STANDING_LABEL"..standingId], 1, 1, 1)
			GameTooltip:AddDoubleLine(REPUTATION..":", format("%d / %d (%d%%)", repValue - repMin, repMax - repMin, (repValue - repMin) / (repMax - repMin) * 100), 1, 1, 1)
		else
			return
		end

		GameTooltip:Show()
	end
end

-- Calculates minimum Durability
local DurabilityChanged, TooltipDurability
do
	local slotDurability = {}
	local slots = {"HeadSlot", "ShoulderSlot", "ChestSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "MainHandSlot", "SecondaryHandSlot"}
	local slotName = {
		["SecondaryHandSlot"] 	= "Offhand",
		["MainHandSlot"] 		= "Main Hand",
		["FeetSlot"] 			= "Boots",
		["LegsSlot"] 			= "Legs",
		["HandsSlot"] 			= "Gloves",
		["WristSlot"] 			= "Wrist",
		["WaistSlot"] 			= "Belt",
		["ChestSlot"] 			= "Chest",
		["ShoulderSlot"] 		= "Shoulders",
		["HeadSlot"] 			= "Helm",
	}

	local SLOTS = {}
	for _, slot in pairs(slots) do
		SLOTS[slot] = GetInventorySlotInfo(slot)
	end

	DurabilityChanged = function(self)
		local minDurability = 100

		for slot, invId in pairs(SLOTS) do
			local curDurability, maxDurablity = GetInventoryItemDurability(invId)

			if (curDurability) then
				local pctDurability = curDurability / maxDurablity * 100

				slotDurability[slot] = pctDurability

				if (maxDurablity and maxDurablity ~= 0) then
					minDurability = mmin(pctDurability, minDurability)
				end
			end
		end

		local r1, g1, b1 = T.ColorGradient(minDurability / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)
		infoBarTextDur:SetFormattedText("|cff%02x%02x%02x%d|r|cff%02x%02x%02x%%dur|r    ", r1 * 255, g1 * 255, b1 * 255, minDurability, cr * 255, cg * 255, cb * 255)
	end

	TooltipDurability = function(self)
		GameTooltip:SetOwner(infoBarDur, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", infoBarDur, "BOTTOMLEFT", 0, -10)

		GameTooltip:AddLine("Durability", 1, 1, 1)
		GameTooltip:AddLine(" ")

		for _, slot in ipairs(slots) do
			local pctDurability = slotDurability[slot]
			local name = slotName[slot]

			if (pctDurability) then
				GameTooltip:AddDoubleLine(name, format("%d%%", pctDurability), 1, 1, 1, T.ColorGradient(pctDurability / 100 - 0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0))
			end
		end

		GameTooltip:Show()
	end
end

-- Memory Tooltip
local UpdateMemory, TooltipMemory, ReShow
do
	local FormatMiliseconds = function(value)
		if (value < 1000) then
			return format("%dms", value)
		else
			value = value / 1000 -- now in seconds

			if (value >= 1 and value < 60) then
				return format("%.2fs", value)
			elseif (value >= 60 and value < 3600) then
				return format("%dm%s", floor(value / 60) % 60, value % 60)
			elseif (value >= 3600 and value < 86400) then
				return format("%dh%dm%ds", floor(value / 3600), floor(value / 60) % 60, value % 60)
			else
				return "OMFG"
			end
		end
	end

	-- Ordering
	local AddonCompare = function(a, b)
		return a.value > b.value
	end

	local NUM_ADDONS_TO_DISPLAY = 25
	local cpuProfiling = GetCVar("scriptProfile") == "1"
	local maxAddonsToShow = mmin(GetNumAddOns(), NUM_ADDONS_TO_DISPLAY)

	local topAddOns = {}
	local blizzMem

	for i = 1, GetNumAddOns() do
		topAddOns[i] = {
			name = "",
			value = 0
		}
	end

	local UpdateAddonMemCPUUse = function(watchCpu)
		if (watchCpu) then
			UpdateAddOnCPUUsage()
		else
			UpdateAddOnMemoryUsage()
		end
		
		local total = 0
		local i

		for i = 1, GetNumAddOns() do
			local value = (watchCpu and GetAddOnCPUUsage(i)) or GetAddOnMemoryUsage(i)
			local name = GetAddOnInfo(i)

			topAddOns[i].value = value
			topAddOns[i].name = name

			total = total + value
		end
		
		return total
	end
	
	UpdateMemory = function()
		-- Addon memory use excl. blizz
		local total = floor((UpdateAddonMemCPUUse() / 1024) + 0.5)
		
		local r2, g2, b2 = T.ColorGradient(total / 50 - 0.001, 0, 1, 0, 1, 1, 0, 0, 1, 0)
		infoBarTextMem:SetFormattedText("|cff%02x%02x%02x%d|r|cff%02x%02x%02xMB|r   ", r2 * 255, g2 * 255, b2 * 255, total, cr * 255, cg * 255, cb * 255)
	end
	
	TooltipMemory = function(self)
		local watchCpu = cpuProfiling and not IsShiftKeyDown() or false

		if (not watchCpu) then
			blizzMem = collectgarbage("count")
		end
		
		local total = UpdateAddonMemCPUUse()

		table.sort(topAddOns, AddonCompare)

		if (total > 0) then
			GameTooltip:SetOwner(infoBarMem, "ANCHOR_NONE")
			GameTooltip:Point("TOPLEFT", infoBarMem, "BOTTOMLEFT", 0, -10)

			if (not watchCpu) then
				GameTooltip:AddLine("Addon Memory Use", 1, 1, 1)
			else
				GameTooltip:AddLine("Addon CPU Use", 1, 1, 1)
			end

			GameTooltip:AddLine(" ")

			for i, addon in ipairs(topAddOns) do
				if (i > maxAddonsToShow or addon.value <= 0) then break end

				if (not watchCpu) then
					GameTooltip:AddDoubleLine(addon.name, T.MemFormat(addon.value), 1, 1, 1, T.ColorGradient(addon.value / total - 0.001, 0, 1, 0, 1, 1, 0, 1, 0, 0))
				else
					GameTooltip:AddDoubleLine(addon.name, FormatMiliseconds(addon.value), 1, 1, 1, T.ColorGradient(addon.value / total - 0.001, 0, 1, 0, 1, 1, 0, 1, 0, 0))
				end
			end

			GameTooltip:AddLine(" ")

			if (not watchCpu) then
				GameTooltip:AddDoubleLine("UI Memory usage", T.MemFormat(total), 1, 1, 1, T.ColorGradient(total / blizzMem - 0.001, 0, 1, 0, 1, 1, 0, 1, 0, 0))
				GameTooltip:AddDoubleLine("Total incl. Blizzard", T.MemFormat(blizzMem), 1, 1, 1, T.ColorGradient(blizzMem / (1024 * 100) - 0.001, 0, 1, 0, 1, 1, 0, 1, 0, 0))
			else
				GameTooltip:AddDoubleLine("Total CPU", FormatMiliseconds(total), 1, 1, 1, 1, 1, 1)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine("Hold Shift for Mem Use")
			end

			GameTooltip:Show()
		end
	end
end

local GoldChanged, GoldClicked, TooltipGold
do
	local profit, loss = 0, 0

	GoldChanged = function(arg1, arg2, arg3)
		T.dbGlobal.gold = T.dbGlobal.gold or {}
		T.dbGlobal.gold[T.playerRealm] = T.dbGlobal.gold[T.playerRealm] or {}
		local db = T.dbGlobal.gold

		local curMoney = GetMoney()
		local oldMoney = db[T.playerRealm][T.playerName] or curMoney
		local diffMoney = curMoney - oldMoney

		if (oldMoney > curMoney) then		-- Lost Money
			loss = loss - diffMoney
		else							-- Gained Moeny
			profit = profit + diffMoney
		end

		db[T.playerRealm][T.playerName] = curMoney

		infoBarTextGold:SetText(T.IntToGold(curMoney, true))

		IB:SendMessage("INFOBAR_ELEMENT_SIZE_CHANGE")
	end

	GoldClicked = function(self, btn)
		if (IsShiftKeyDown()) then
			if (btn == "LeftButton") then
				profit, loss = 0, 0
			else
				T.dbGlobal["gold"] = {}
				GoldChanged()
			end
			GameTooltip:Hide()
		else
			ToggleAllBags()
		end
	end

	TooltipGold = function()
		T.dbGlobal.gold = T.dbGlobal.gold or {}
		T.dbGlobal.gold[T.playerRealm] = T.dbGlobal.gold[T.playerRealm] or {}
		local db = T.dbGlobal.gold

		GameTooltip:SetOwner(infoBarMem, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", infoBarGold, "BOTTOMLEFT", 0, -10)

		GameTooltip:AddLine("This session:")

		GameTooltip:AddDoubleLine("Earned:", T.IntToGold(profit, true), 1, 1, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine("Spent:", T.IntToGold(loss, true), 1, 1, 1, 1, 1, 1)

		if profit < loss then
			GameTooltip:AddDoubleLine("Loss:", T.IntToGold(abs(profit - loss), true), 1, 0, 0, 1, 1, 1)
		elseif (profit - loss) > 0 then
			GameTooltip:AddDoubleLine("Profit:", T.IntToGold(profit - loss, true), 0, 1, 0, 1, 1, 1)
		end

		GameTooltip:AddLine" "

		local totalGold = 0
		GameTooltip:AddLine("This RealIB: ")

		for k, _ in pairs(db[T.playerRealm]) do
			if (db[T.playerRealm][k]) then
				GameTooltip:AddDoubleLine(k, T.IntToGold(db[T.playerRealm][k], true), 1, 1, 1, 1, 1, 1)

				totalGold = totalGold + db[T.playerRealm][k]
			end
		end

		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("Total: ", T.IntToGold(totalGold, true), 1, 1, 1, 1, 1, 1)

		for i = 1, MAX_WATCHED_TOKENS do
			local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
			if name and i == 1 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(CURRENCY)
			end
			if name and count then GameTooltip:AddDoubleLine(name, count, 1, 1, 1) end
		end

		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Hold Shift + Left Button to reset session")
		GameTooltip:AddLine("Hold Shift + Right Button to reset realm")

		GameTooltip:Show()
	end
end

local GarrisonChanged, TooltipGarrison
do
	local GARRISON_CURRENCY = 824
	local GARRISON_ICON = format("\124T%s:%d:%d:0:0:64:64:4:60:4:60\124t", select(3, GetCurrencyInfo(GARRISON_CURRENCY)), 16, 16)

	-- Ordering
	local AddonCompare = function(a, b)
		return a.timeLeft > b.timeLeft
	end
	
	TooltipGarrison = function()
		GameTooltip:SetOwner(infoBarGarrison, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", infoBarGarrison, "BOTTOMLEFT", 0, -10)
		
		local buildings = C_Garrison.GetBuildings();
		local numBuildings = #buildings
		local hasBuilding = false
		
		if (numBuildings > 0) then
			for i = 1, #buildings do
				local buildingID = buildings[i].buildingID;
				
				if (buildingID) then
					local name, _, _, shipmentsReady, shipmentsTotal = C_Garrison.GetLandingPageShipmentInfo(buildingID);
					
					if (name and shipmentsReady and shipmentsTotal) then
						if(hasBuilding == false) then
							GameTooltip:AddLine("Building(s) Report:")
							hasBuilding = true
						end

						GameTooltip:AddDoubleLine(name, format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal), 1, 1, 1)
					end
				end
			end
		end
		
		local inProgressMissions = C_Garrison.GetInProgressMissions()
		local numMissions = #inProgressMissions
		
		table.sort(inProgressMissions, AddonCompare)
		
		if (numMissions > 0) then
			if (numBuildings > 0) then
				GameTooltip:AddLine(" ")
			end
			
			GameTooltip:AddLine("Mission(s) Report:")
			
			for i = 1, numMissions do
				local mission = inProgressMissions[i]
				local r, g, b = 1, 1, 1
				
				if (mission.isRare) then
					r, g, b = 0.09, 0.51, 0.81
				end

				if (mission.timeLeft == "0 sec") then --may have localization issues here
					GameTooltip:AddDoubleLine(mission.name, COMPLETE, r, g, b, 0, 1, 0)
				else
					GameTooltip:AddDoubleLine(mission.name, mission.timeLeft, r, g, b)
				end
			end
		end		
		
		GameTooltip:Show()
	end
	
	GarrisonChanged = function()
		local _, numResources = GetCurrencyInfo(GARRISON_CURRENCY)
		infoBarTextGarrison:SetFormattedText("%s %s", GARRISON_ICON, numResources)
	end
end

local TooltipRes
do
	local resAmount = 0
	local inCombat = false
	local redemption, feign = GetSpellInfo(27827), GetSpellInfo(5384)
	local theDead = {}
	local theRes = {}
	local addResTimer, updateResTimer
	local class

	local UpdateTimer = function()
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

		infoBarTextRes:SetFormattedText(charges == 0 and "|cffff0000%d|rres (%d:%02d)" or "|cff00ff00%d|rres (%d:%02d)", charges, min, sec)
	end
		
	local UpdateResStatus = function()
		local charges, maxCharges, started, duration = GetSpellCharges(20484) -- Rebirth
		
		if (charges) then
			if (not inCombat) then
				inCombat = true
				wipe(theDead)
				wipe(theRes)
				
				addResTimer = IB:ScheduleRepeatingTimer(UpdateTimer, 1)
				IB:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			end
			
			if (charges ~= resAmount) then
				resAmount = charges
			end
		elseif inCombat and not charges then
			inCombat = false
			resAmount = 0
			
			IB:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			IB:CancelTimer(addResTimer)
			
			infoBarTextRes:SetFormattedText("|cff00ff000|rres (0:00)")
		end
	end	
	
	IB.ZONE_CHANGED_NEW_AREA = function(self)
		local _, instanceType = GetInstanceInfo()
		
		if (instanceType == "raid") then
			if (not inCombat) then 
				self:CancelTimer(updateResTimer)
				self:CancelTimer(addResTimer)
			end

			updateResTimer = self:ScheduleRepeatingTimer(UpdateResStatus, 0.1)
			
			infoBarRes:Show()
		else
			infoBarRes:Hide()
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
	
	IB.COMBAT_LOG_EVENT_UNFILTERED = function(self, ...)
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

	TooltipRes = function(self)
		GameTooltip:SetOwner(infoBarRes, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", infoBarRes, "BOTTOMLEFT", 0, -10)

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
end

local PlayerEnteringWorld = function(self)
	UpdateFPS()
	UpdateLatency()
	UpdateMemory()
	XPorRepChanged(self)
	DurabilityChanged(self)
	GoldChanged()
	GarrisonChanged()
	IB:ZONE_CHANGED_NEW_AREA()

	RepositionElements()
end

IB.OnEnable = function(self)
	infoBar:Size(T.screenWidth, 15)
	infoBar:SetPoint("TOPLEFT", 20, -20)

	-- FPS (1st)
	infoBarFPS:Size(60, 15)
	infoBarFPS:SetPoint("TOPLEFT", 0, 0)
	infoBarTextFPS = T.CreateFontObject(infoBarFPS, T.db["general"].fontsize1, T["media"].font, "LEFT", 0, 0)
	infoBarTextFPS:SetAllPoints()

	-- Mem info (2nd)
	infoBarMem:Size(60, 15)
	infoBarMem:SetPoint("TOPLEFT", 65, 0)
	infoBarTextMem = T.CreateFontObject(infoBarMem, T.db["general"].fontsize1, T["media"].font, "LEFT", 0, 0)
	infoBarTextMem:SetAllPoints()

	-- Latency (3rd)
	infoBarLatency:Size(100, 15)
	infoBarLatency:SetPoint("TOPLEFT", 130, 0)
	infoBarTextLatency = T.CreateFontObject(infoBarLatency, T.db["general"].fontsize1, T["media"].font, "LEFT", 0, 0)
	infoBarTextLatency:SetAllPoints()

	-- Durability info (4th)
	infoBarDur:Size(80, 15)
	infoBarDur:SetPoint("TOPLEFT", 235, 0)
	infoBarTextDur = T.CreateFontObject(infoBarDur, T.db["general"].fontsize1, T["media"].font, "LEFT", 0, 0)
	infoBarTextDur:SetAllPoints()

	-- Gold info (4th)
	infoBarGold:Size(200, 15)
	infoBarGold:SetPoint("TOPLEFT", 320, 0)
	infoBarTextGold = T.CreateFontObject(infoBarGold, T.db["general"].fontsize1, T["media"].font, "LEFT", 0, 0)

	-- Gold info (5th)
	infoBarGarrison:Size(200, 15)
	infoBarTextGarrison = T.CreateFontObject(infoBarGarrison, T.db["general"].fontsize1, T["media"].font, "LEFT", 0, 0)

	-- XP info (5th)
	infoBarXP:Size(100, 15)
	infoBarTextXP = T.CreateFontObject(infoBarXP, T.db["general"].fontsize1, T["media"].font, "LEFT", 0, 0)

	-- Res info (5th)
	infoBarRes:Size(100, 15)
	infoBarTextRes = T.CreateFontObject(infoBarRes, T.db["general"].fontsize1, T["media"].font, "LEFT", 0, 0)

	-- Schedule timers for the various updates
	self.timerFPS = self:ScheduleRepeatingTimer(UpdateFPS, 1.0)
	self.timerLatency = self:ScheduleRepeatingTimer(UpdateLatency, 10.0)
	self.timerMemory = self:ScheduleRepeatingTimer(UpdateMemory, 10.0)

	-- Register for various events
	self:RegisterEvent("MERCHANT_SHOW", DurabilityChanged)
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", DurabilityChanged)
	
	self:RegisterEvent("PLAYER_XP_UPDATE", XPorRepChanged)
	self:RegisterEvent("UPDATE_FACTION", XPorRepChanged)
	
	self:RegisterEvent("PLAYER_MONEY", GoldChanged)
	self:RegisterEvent("SEND_MAIL_MONEY_CHANGED", GoldChanged)
	self:RegisterEvent("SEND_MAIL_COD_CHANGED", GoldChanged)
	self:RegisterEvent("PLAYER_TRADE_MONEY", GoldChanged)
	self:RegisterEvent("TRADE_MONEY_CHANGED", GoldChanged)
	
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE", GarrisonChanged)
	self:RegisterEvent("GARRISON_LANDINGPAGE_SHIPMENTS", GarrisonChanged)
		
	self:RegisterMessage("INFOBAR_ELEMENT_SIZE_CHANGE", RepositionElements)

	-- Do things when we enter the world
	self:RegisterEvent("PLAYER_ENTERING_WORLD", PlayerEnteringWorld)

	local tooltipRenew

	-- Memory tooltip handling
	infoBarMem:RegisterForClicks("AnyDown")
	infoBarMem:SetScript("OnEnter", function()
		TooltipMemory()
		tooltipRenew = IB:ScheduleRepeatingTimer(TooltipMemory, 1.0)
	end)
	infoBarMem:SetScript("OnLeave", function()
		IB:CancelTimer(tooltipRenew)
		GameTooltip:Hide()
	end)
	infoBarMem:SetScript("OnClick", function(self, button, down)
		collectgarbage("collect")
		ResetCPUUsage()
		UpdateMemory()
	end)

	-- Latency tooltip handling
	infoBarLatency:SetScript("OnEnter", function()
		TooltipLatency()
		tooltipRenew = IB:ScheduleRepeatingTimer(TooltipLatency, 1.0)
	end)
	infoBarLatency:SetScript("OnLeave", function()
		IB:CancelTimer(tooltipRenew)
		GameTooltip:Hide()
	end)

	-- Durability tooltip handling
	infoBarDur:SetScript("OnEnter", function() TooltipDurability() end)
	infoBarDur:SetScript("OnLeave", function() GameTooltip:Hide() end)
	infoBarDur:SetScript("OnClick", function(self) ToggleCharacter("PaperDollFrame") end)

	-- Gold tooltip handling
	infoBarGold:RegisterForClicks("AnyDown")
	infoBarGold:SetScript("OnEnter", function() TooltipGold() end)
	infoBarGold:SetScript("OnLeave", function() GameTooltip:Hide() end)
	infoBarGold:SetScript("OnClick", GoldClicked)

	-- Garrison tooltip handling
	infoBarGarrison:SetScript("OnEnter", function() TooltipGarrison() end)
	infoBarGarrison:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- XP/Rep tooltip handling
	infoBarXP:SetScript("OnEnter", function() TooltipXP() end)
	infoBarXP:SetScript("OnLeave", function() GameTooltip:Hide() end)
	infoBarXP:SetScript("OnClick", function(self) ToggleCharacter("ReputationFrame") end)

	-- Res tooltip handling
	infoBarRes:SetScript("OnEnter", function() TooltipRes() end)
	infoBarRes:SetScript("OnLeave", function() GameTooltip:Hide() end)

	infoBarXP:Hide()
	infoBarRes:Hide()
end

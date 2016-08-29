--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:GetModule("Infobar")
local MEM = IB:NewModule("Mem", "AceEvent-3.0", "AceTimer-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeMem", {
	type = "draeUI",
	icon = nil,
	label = "DraeMem"
})

local pairs, ipairs, format, gupper, gsub, floor, ceil, abs, mmin, type, unpack = pairs, ipairs, string.format, string.upper, string.gsub, math.floor, math.ceil, math.abs, math.min, type, unpack
local tinsert = table.insert

--[[

]]
local NUM_ADDONS_TO_DISPLAY = 25
local topAddOns = {}
local blizzMem

local cpuProfiling = GetCVar("scriptProfile") == "1"
local maxAddonsToShow = mmin(GetNumAddOns(), NUM_ADDONS_TO_DISPLAY)

for i = 1, GetNumAddOns() do
	topAddOns[i] = {
		name = "",
		value = 0
	}
end

--[[

]]
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

MEM.UpdateMem = function(self)
	local total = floor((UpdateAddonMemCPUUse() / 1024) + 0.5)

	local r2, g2, b2 = T.ColorGradient(total / 50 - 0.001, 0, 1, 0, 1, 1, 0, 0, 1, 0)
	LDB.text = format("|cff%02x%02x%02x%d|r|cff%02x%02x%02xMB|r", r2 * 255, g2 * 255, b2 * 255, total, 255, 255, 255)
end

local TooltipMem = function(self)
	local watchCpu = cpuProfiling and not IsShiftKeyDown() or false

	if (not watchCpu) then
		blizzMem = collectgarbage("count")
	end

	local total = UpdateAddonMemCPUUse()

	table.sort(topAddOns, AddonCompare)

	if (total > 0) then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

		GameTooltip:ClearLines()

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

do
	local tooltipRenew

	LDB.OnEnter = function(self)
		TooltipMem(self)
		tooltipRenew = MEM:ScheduleRepeatingTimer(TooltipMem, 1.0, self)
	end

	LDB.OnLeave = function(self)
		MEM:CancelTimer(tooltipRenew)
		GameTooltip:Hide()
	end

	LDB.OnClick = function(self)
		collectgarbage("collect")
		ResetCPUUsage()

		MEM:UpdateMem()
	end
end

MEM.OnInitialize = function(self)
	-- FPS handling
	self.timerMEM = self:ScheduleRepeatingTimer("UpdateMem", 10.0)

	self:UpdateMem()
end

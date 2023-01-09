--[[

--]]
local DraeUI = select(2, ...)

local M = DraeUI:NewModule("Misc", "AceEvent-3.0", "AceTimer-3.0")

local UIErrorsFrame = _G.UIErrorsFrame
local interruptMsg = _G.INTERRUPTED .. " %s's \124cff71d5ff\124Hspell:%d\124h[%s]\124h\124r!"
local floor, format = math.floor, string.format

--[[

--]]
M.ErrorFrameToggle = function(self, event)
	if (event == "PLAYER_REGEN_DISABLED") then
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	else
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
	end
end

do
	local autoRepair = "PLAYER"

	M.MERCHANT_SHOW = function()
		if (IsShiftKeyDown() or not CanMerchantRepair()) then return end

		local cost, possible = GetRepairAllCost()
		local withdrawLimit = GetGuildBankWithdrawMoney()

		if (autoRepair == "GUILD" and (not CanGuildBankRepair() or cost > withdrawLimit)) then
			autoRepair = "PLAYER"
		end

		if (cost > 0) then
			if (possible) then
				RepairAllItems(autoRepair == "GUILD")
				local c, s, g = cost % 100, floor((cost % 10000) / 100), floor(cost / 10000)

				if (autoRepair == "GUILD") then
					DraeUI.Print("Your items have been repaired using guild bank funds for: "..GetCoinTextureString(cost, 13))
				else
					DraeUI.Print("Your items have been repaired using your own funds for: "..GetCoinTextureString(cost, 13))
				end
			else
				DraeUI.Print("You don't have enough money to repair!")
			end
		end
	end
end

--[[
		PLAYER_LOGIN
--]]
M.OnEnable = function(self)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "ErrorFrameToggle")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "ErrorFrameToggle")
	self:RegisterEvent("MERCHANT_SHOW")
end

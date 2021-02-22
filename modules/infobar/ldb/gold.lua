--[[


--]]
local DraeUI = select(2, ...)

local IB = DraeUI:GetModule("Infobar")
local COIN = IB:NewModule("Coin", "AceEvent-3.0", "AceTimer-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeCoin", {type = "draeUI", icon = nil, label = "DraeCoin"})

--[[

]]
local profit, loss = 0, 0

--[[

]]
COIN.UpdateCoin = function(self)
	DraeUI.dbGlobal["gold"] = DraeUI.dbGlobal["gold"] or {}
	DraeUI.dbGlobal["gold"][DraeUI.playerRealm] = DraeUI.dbGlobal["gold"][DraeUI.playerRealm] or {}
	local db = DraeUI.dbGlobal["gold"]

	local curMoney = GetMoney()
	local oldMoney = db[DraeUI.playerRealm][DraeUI.playerName] or curMoney
	local diffMoney = curMoney - oldMoney

	if (oldMoney > curMoney) then		-- Lost Money
		loss = loss - diffMoney
	else							-- Gained Moeny
		profit = profit + diffMoney
	end

	db[DraeUI.playerRealm][DraeUI.playerName] = curMoney

	LDB.text = DraeUI.IntToGold(curMoney, false)
end

LDB.OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

	GameTooltip:ClearLines()

	DraeUI.dbGlobal["gold"] = DraeUI.dbGlobal["gold"] or {}
	DraeUI.dbGlobal["gold"][DraeUI.playerRealm] = DraeUI.dbGlobal["gold"][DraeUI.playerRealm] or {}
	local db = DraeUI.dbGlobal["gold"]

	GameTooltip:AddLine("This session:")

	GameTooltip:AddDoubleLine("Earned:", DraeUI.IntToGold(profit, true), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine("Spent:", DraeUI.IntToGold(loss, true), 1, 1, 1, 1, 1, 1)

	if profit < loss then
		GameTooltip:AddDoubleLine("Loss:", DraeUI.IntToGold(abs(profit - loss), true), 1, 0, 0, 1, 1, 1)
	elseif (profit - loss) > 0 then
		GameTooltip:AddDoubleLine("Profit:", DraeUI.IntToGold(profit - loss, true), 0, 1, 0, 1, 1, 1)
	end

	GameTooltip:AddLine" "

	local totalGold = 0
	GameTooltip:AddLine("This Realm: ")

	for k, _ in pairs(db[DraeUI.playerRealm]) do
		if (db[DraeUI.playerRealm][k]) then
			GameTooltip:AddDoubleLine(k, DraeUI.IntToGold(db[DraeUI.playerRealm][k], true), 1, 1, 1, 1, 1, 1)

			totalGold = totalGold + db[DraeUI.playerRealm][k]
		end
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("Total: ", DraeUI.IntToGold(totalGold, true), 1, 1, 1, 1, 1, 1)

	local info
	for i = 1, MAX_WATCHED_TOKENS do
		info = C_CurrencyInfo.GetBackpackCurrencyInfo(i)
		if info ~= nil and info.name then
			if i == 1 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(CURRENCY)
			end

			if info.quantity then GameTooltip:AddDoubleLine(info.name, info.quantity, 1, 1, 1) end
		end
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("Hold Shift + Left Button to reset session")
	GameTooltip:AddLine("Hold Shift + Right Button to reset realm")

	GameTooltip:Show()
end

LDB.OnLeave = function(self)
	GameTooltip:Hide()
end

LDB.OnClick = function(self, btn)
	if (IsShiftKeyDown()) then
		if (btn == "LeftButton") then
			profit, loss = 0, 0
		else
			DraeUI.dbGlobal["gold"] = {}
		end

		GameTooltip:Hide()
	else
		ToggleAllBags()
	end
end

COIN.PlayerEnteringWorld = function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD", "PlayerEnteringWorld")

	self:UpdateCoin()
end

COIN.OnInitialize = function(self)
	self:RegisterEvent("PLAYER_MONEY", "UpdateCoin")
	self:RegisterEvent("SEND_MAIL_MONEY_CHANGED", "UpdateCoin")
	self:RegisterEvent("SEND_MAIL_COD_CHANGED", "UpdateCoin")
	self:RegisterEvent("PLAYER_TRADE_MONEY", "UpdateCoin")
	self:RegisterEvent("TRADE_MONEY_CHANGED", "UpdateCoin")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "PlayerEnteringWorld")
end

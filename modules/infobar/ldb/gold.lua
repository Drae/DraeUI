--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local IB = T:GetModule("Infobar")
local COIN = IB:NewModule("Coin", "AceEvent-3.0", "AceTimer-3.0")

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DraeCoin", {
	type = "draeUI",
	icon = nil,
	label = "DraeCoin",
})

--[[

]]
local profit, loss = 0, 0

--[[

]]
COIN.UpdateCoin = function(self)
	T.dbGlobal["gold"] = T.dbGlobal["gold"] or {}
	T.dbGlobal["gold"][T.playerRealm] = T.dbGlobal["gold"][T.playerRealm] or {}
	local db = T.dbGlobal["gold"]

	local curMoney = GetMoney()
	local oldMoney = db[T.playerRealm][T.playerName] or curMoney
	local diffMoney = curMoney - oldMoney

	if (oldMoney > curMoney) then		-- Lost Money
		loss = loss - diffMoney
	else							-- Gained Moeny
		profit = profit + diffMoney
	end

	db[T.playerRealm][T.playerName] = curMoney

	LDB.text = T.IntToGold(curMoney, false)
end

LDB.OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -10)

	GameTooltip:ClearLines()

	T.dbGlobal["gold"] = T.dbGlobal["gold"] or {}
	T.dbGlobal["gold"][T.playerRealm] = T.dbGlobal["gold"][T.playerRealm] or {}
	local db = T.dbGlobal["gold"]

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

LDB.OnLeave = function(self)
	GameTooltip:Hide()
end

LDB.OnClick = function(self, btn)
	if (IsShiftKeyDown()) then
		if (btn == "LeftButton") then
			profit, loss = 0, 0
		else
			T.dbGlobal["gold"] = {}
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

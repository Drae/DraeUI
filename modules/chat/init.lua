--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local CH = T:NewModule("Chat", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

T.Chat = CH

--Cache global variables
--Lua functions
local _G = _G
local wipe, time, difftime = wipe, time, difftime
local pairs, unpack, select, tostring, pcall, next, tonumber, type = pairs, unpack, select, tostring, pcall, next, tonumber, type
local tinsert, tremove, twipe, tconcat = table.insert, table.remove, table.wipe, table.concat
local gsub, find, gmatch, format, split = string.gsub, string.find, string.gmatch, string.format, string.split
local strlower, strsub, strlen, strupper, strtrim, strmatch = strlower, strsub, strlen, strupper, strtrim, strmatch
--WoW API / Variables

local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local LE_REALM_RELATION_SAME = LE_REALM_RELATION_SAME
local LFG_LIST_AND_MORE = LFG_LIST_AND_MORE
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local SOUNDKIT = SOUNDKIT
local UNKNOWN = UNKNOWN

--Variables that are only used in ChatFrame_MessageEventHandler
--Store them in a table as we would otherwise hit the "max 60 upvalues" limit
local GlobalStrings = {
	["AFK"] = AFK,
	["BN_INLINE_TOAST_BROADCAST"] = BN_INLINE_TOAST_BROADCAST,
	["BN_INLINE_TOAST_BROADCAST_INFORM"] = BN_INLINE_TOAST_BROADCAST_INFORM,
	["BN_INLINE_TOAST_FRIEND_PENDING"] = BN_INLINE_TOAST_FRIEND_PENDING,
	["CHAT_FILTERED"] = CHAT_FILTERED,
	["CHAT_IGNORED"] = CHAT_IGNORED,
	["CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE"] = CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE,
	["CHAT_RESTRICTED_TRIAL"] = CHAT_RESTRICTED_TRIAL,
	["CHAT_TELL_ALERT_TIME"] = CHAT_TELL_ALERT_TIME,
	["CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL"] = CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL,
	["DND"] = DND,
	["ERR_CHAT_PLAYER_NOT_FOUND_S"] = ERR_CHAT_PLAYER_NOT_FOUND_S,
	["ERR_FRIEND_OFFLINE_S"] = ERR_FRIEND_OFFLINE_S,
	["ERR_FRIEND_ONLINE_SS"] = ERR_FRIEND_ONLINE_SS,
	["PLAYER_LIST_DELIMITER"] = PLAYER_LIST_DELIMITER,
	["RAID_WARNING"] = RAID_WARNING,
}

local CreatedFrames = 0
local lines = {}
local lfgRoles = {}
local msgList, msgCount, msgTime = {}, {}, {}

local PLAYER_REALM = gsub(T.playerRealm,"[%s%-]","")
local PLAYER_NAME = T.playerName.."-"..PLAYER_REALM

local DEFAULT_STRINGS = {
	GUILD = "G",
	PARTY = "P",
	RAID = "R",
	OFFICER = "O",
	PARTY_LEADER = "PL",
	RAID_LEADER = "RL",
	INSTANCE_CHAT = "I",
	INSTANCE_CHAT_LEADER = "IL",
	PET_BATTLE_COMBAT_LOG = PET_BATTLE_COMBAT_LOG,
}

local hyperlinkTypes = {
	["item"] = true,
	["spell"] = true,
	["unit"] = true,
	["quest"] = true,
	["enchant"] = true,
	["achievement"] = true,
	["instancelock"] = true,
	["talent"] = true,
	["glyph"] = true,
	["currency"] = true,
}

local tabTexs = {
	"",
	"Selected",
	"Highlight"
}

local rolePaths = {
	TANK = [[|TInterface\AddOns\DraeUI\media\textures\tank.tga:15:15:0:0:64:64:2:56:2:56|t]],
	HEALER = [[|TInterface\AddOns\DraeUI\media\textures\healer.tga:15:15:0:0:64:64:2:56:2:56|t]],
	DAMAGER = [[|TInterface\AddOns\DraeUI\media\textures\dps.tga:15:15|t]]
}

CH.Keywords = {}
CH.ClassNames = {}

function CH:GetGroupDistribution()
	local inInstance, kind = IsInInstance()
	if inInstance and (kind == "pvp") then
		return "/bg "
	end
	if IsInRaid() then
		return "/ra "
	end
	if IsInGroup() then
		return "/p "
	end
	return "/s "
end

function CH:StyleChat(frame)
	local name = frame:GetName()

	_G[name.."TabText"]:SetFont(T["media"].font, 8, "THINOUTLINE")
	_G[name.."TabText"]:SetJustifyH("CENTER")

	if frame.styled then return end

	frame:SetFrameLevel(4)

	local id = frame:GetID()

	local tab = _G[name.."Tab"]
	local editbox = _G[name.."EditBox"]

	local tabHeight = tab:GetHeight()
	editbox.tabHeight = tabHeight

	for _, texName in pairs(tabTexs) do
		_G[tab:GetName()..texName.."Left"]:SetTexture(nil)
		_G[tab:GetName()..texName.."Middle"]:SetTexture(nil)
		_G[tab:GetName()..texName.."Right"]:SetTexture(nil)
	end

	tab.text = _G[name.."TabText"]

	if tab.conversationIcon then
		tab.conversationIcon:ClearAllPoints()
		tab.conversationIcon:SetPoint("RIGHT", tab.text, "LEFT", -1, 0)
	end

	frame:SetClampRectInsets(0,0,0,0)
	frame:SetClampedToScreen(false)
--	frame:StripTextures(true)
	_G[name.."ButtonFrame"]:Kill()

	--Work around broken SetAltArrowKeyMode API. Code from Prat
	local function OnArrowPressed(self, key)
		if #self.historyLines == 0 then
			return
		end

		if key == "DOWN" then
			self.historyIndex = self.historyIndex - 1

			if self.historyIndex < 1 then
				self.historyIndex = 0
				self:SetText("")
				return
			end
		elseif key == "UP" then
			self.historyIndex = self.historyIndex + 1

			if self.historyIndex > #self.historyLines then
				self.historyIndex = #self.historyLines
			end
		else
			return
		end
		self:SetText(self.historyLines[#self.historyLines - (self.historyIndex - 1)])
	end

	local a, b, c = select(6, editbox:GetRegions()) a:Kill() b:Kill() c:Kill()
	editbox:SetAltArrowKeyMode(CH.db.useAltKey)
	editbox:SetAllPoints(LeftChatDataPanel)
	self:SecureHook(editbox, "AddHistoryLine", "ChatEdit_AddHistory")
--	editbox:HookScript("OnTextChanged", OnTextChanged)

	--Work around broken SetAltArrowKeyMode API
	editbox.historyLines = self.db.ChatEditLog
	editbox.historyIndex = 0
	editbox:HookScript("OnArrowPressed", OnArrowPressed)
	editbox:Hide()

	for _, text in pairs(self.db.ChatEditLog) do
		editbox:AddHistoryLine(text)
	end

	hooksecurefunc("ChatEdit_UpdateHeader", function()
		local chatType = editbox:GetAttribute("chatType")
		if not chatType then return end

		local chanTarget = editbox:GetAttribute("channelTarget")
		local chanName = chanTarget and GetChannelName(chanTarget)
		if chanName and (chatType == "CHANNEL") then
			if chanName == 0 then
				editbox:SetBackdropBorderColor(unpack(T.media.bordercolor))
			else
				editbox:SetBackdropBorderColor(ChatTypeInfo[chatType..chanName].r,ChatTypeInfo[chatType..chanName].g,ChatTypeInfo[chatType..chanName].b)
			end
		else
			editbox:SetBackdropBorderColor(ChatTypeInfo[chatType].r,ChatTypeInfo[chatType].g,ChatTypeInfo[chatType].b)
		end
	end)

	if id ~= 2 then --Don"t add timestamps to combat log, they don"t work.
		--This usually taints, but LibChatAnims should make sure it doesn"t.
		frame.OldAddMessage = frame.AddMessage
		frame.AddMessage = CH.AddMessage
	end

	CreatedFrames = id
	frame.styled = true
end

function CH:AddMessage(msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
	local historyTimestamp --we need to extend the arguments on AddMessage so we can properly handle times without overriding
	if isHistory == "ElvUI_ChatHistory" then historyTimestamp = historyTime end

	local timeStamp = BetterDate(CH.dbGlobalChat.timeStampFormat, CH.timeOverride or time())
	timeStamp = timeStamp:gsub(" ", "")
	timeStamp = timeStamp:gsub("AM", " AM")
	timeStamp = timeStamp:gsub("PM", " PM")
	msg = "|cffB3B3B3["..timeStamp.."] |r"..msg

	self.OldAddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID)
end

function CH:UpdateSettings()
	for i = 1, CreatedFrames do
		local chat = _G[format("ChatFrame%d", i)]
		local name = chat:GetName()
		local editbox = _G[name.."EditBox"]
		editbox:SetAltArrowKeyMode(CH.db.useAltKey)
	end
end

local removeIconFromLine
do
	local raidIconFunc = function(x) x = x~="" and _G["RAID_TARGET_"..x]return x and ("{"..strlower(x).."}") or "" end
	local stripTextureFunc = function(x, y) return (x~="" and x) or (y~="" and y) or "" end
	local hyperLinkFunc = function(x, y) if x=="" then return y end end
	removeIconFromLine = function(text)
		text = gsub(text, "|TInterface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d+):0|t", raidIconFunc) --converts raid icons into {star} etc, if possible.
		text = gsub(text, "(%s?)|T.-|t(%s?)", stripTextureFunc) --strip any other texture out but keep a single space from the side(s).
		text = gsub(text, "(|?)|H.-|?|h(.-)|?|h", hyperLinkFunc) --strip hyperlink data only keeping the actual text.
		return text
	end
end

local function colorizeLine(text, r, g, b)
	local hexCode = T:RGBToHex(r, g, b)
	local hexReplacement = format("|r%s", hexCode)

	text = gsub(text, "|r", hexReplacement) --If the message contains color strings then we need to add message color hex code after every "|r"
	text = format("%s%s|r", hexCode, text) --Add message color

	return text
end

function CH:GetLines(frame)
	local index = 1
	for i = 1, frame:GetNumMessages() do
		local message, r, g, b = frame:GetMessageInfo(i)

		--Set fallback color values
		r = r or 1
		g = g or 1
		b = b or 1

		--Remove icons
		message = removeIconFromLine(message)

		--Add text color
		message = colorizeLine(message, r, g, b)

		lines[index] = message
		index = index + 1
	end

	return index - 1
end

function CH:OnEnter(frame)
	_G[frame:GetName().."Text"]:Show()

	if frame.conversationIcon then
		frame.conversationIcon:Show()
	end
end

function CH:OnLeave(frame)
	_G[frame:GetName().."Text"]:Hide()

	if frame.conversationIcon then
		frame.conversationIcon:Hide()
	end
end

function CH:SetupChatTabs(frame, hook)
	if hook and (not self.hooks or not self.hooks[frame] or not self.hooks[frame].OnEnter) then
		self:HookScript(frame, "OnEnter")
		self:HookScript(frame, "OnLeave")
	elseif not hook and self.hooks and self.hooks[frame] and self.hooks[frame].OnEnter then
		self:Unhook(frame, "OnEnter")
		self:Unhook(frame, "OnLeave")
	end
end

function CH:UpdateAnchors()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName.."EditBox"]

		if not frame then break end

		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT",  ChatFrame1, "TOPLEFT",  -5, frame.tabHeight - 5)
		frame:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 10, frame.tabHeight - 5)
	end

	CH:PositionChat(true)
end

function CH:UpdateChatTabs()
	local fadeUndockedTabs = false
	local fadeTabsNoBackdrop = false

	for i = 1, CreatedFrames do
		local chat = _G[format("ChatFrame%d", i)]
		local tab = _G[format("ChatFrame%sTab", i)]
		local id = chat:GetID()
		local isDocked = chat.isDocked
		local chatbg = format("ChatFrame%dBackground", i)

		if id > NUM_CHAT_WINDOWS then
			if select(2, tab:GetPoint()):GetName() ~= chatbg then
				isDocked = true
			else
				isDocked = false
			end
		end

		if not isDocked and chat:IsShown() then
			CH:SetupChatTabs(tab, false)
		else
			CH:SetupChatTabs(tab, false)
		end
	end
end

function CH:PositionChat(override)
	if ((InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then return end

--	if not self.db.lockPositions or T.private.chat.enable ~= true then return end

	local chat, chatbg, tab, id, isDocked
	local fadeUndockedTabs = false
	local fadeTabsNoBackdrop = false

	for i=1, CreatedFrames do
		local BASE_OFFSET = 60

		chat = _G[format("ChatFrame%d", i)]
		chatbg = format("ChatFrame%dBackground", i)
		id = chat:GetID()
		tab = _G[format("ChatFrame%sTab", i)]
		isDocked = chat.isDocked
		tab.isDocked = chat.isDocked
		tab.owner = chat

		if id > NUM_CHAT_WINDOWS then
			if select(2, tab:GetPoint()):GetName() ~= chatbg then
				isDocked = true
			else
				isDocked = false
			end
		end

		if not isDocked and chat:IsShown() then
			CH:SetupChatTabs(tab, false)
		else
			if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
				chat:ClearAllPoints()
				chat:SetPoint("BOTTOMLEFT", 5, 5) --"BOTTOMLEFT", UIParent,
				chat:SetSize(520, 180)

				--Pass a 2nd argument which prevents an infinite loop in our ON_FCF_SavePositionAndDimensions function
				if chat:GetLeft() then
					FCF_SavePositionAndDimensions(chat, true)
				end
			end

			if i > 2 then
				tab:SetParent(GeneralDockManagerScrollFrameChild)
			else
				tab:SetParent(GeneralDockManager)
			end

			if chat:IsMovable() then
				chat:SetUserPlaced(true)
			end

			CH:SetupChatTabs(tab, false)
		end
	end

	self.initialMove = true
end

function CH:PrintURL(url)
	return "|cFFFFFFFF[|Hurl:"..url.."|h"..url.."|h]|r "
end

function CH:FindURL(event, msg, ...)
	if not CH.db.url then
		return false, msg, ...
	end

	local text, tag = msg, strmatch(msg, "{(.-)}")
	if tag and ICON_TAG_LIST[strlower(tag)] then
		text = gsub(gsub(text, "(%S)({.-})", "%1 %2"), "({.-})(%S)", "%1 %2")
	end

	text = gsub(gsub(text, "(%S)(|c.-|H.-|h.-|h|r)", "%1 %2"), "(|c.-|H.-|h.-|h|r)(%S)", "%1 %2")
	-- http://example.com
	local newMsg, found = gsub(text, "(%a+)://(%S+)%s?", CH:PrintURL("%1://%2"))
	if found > 0 then return false, newMsg, ... end

	-- www.example.com
	newMsg, found = gsub(text, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", CH:PrintURL("www.%1.%2"))
	if found > 0 then return false, newMsg, ... end

	-- example@example.com
	newMsg, found = gsub(text, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", CH:PrintURL("%1@%2%3%4"))
	if found > 0 then return false, newMsg, ... end

	-- IP address with port 1.1.1.1:1
	newMsg, found = gsub(text, "(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)(:%d+)%s?", CH:PrintURL("%1.%2.%3.%4%5"))
	if found > 0 then return false, newMsg, ... end

	-- IP address 1.1.1.1
	newMsg, found = gsub(text, "(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", CH:PrintURL("%1.%2.%3.%4"))
	if found > 0 then return false, newMsg, ... end

	return false, msg, ...
end

local function SetChatEditBoxMessage(message)
	local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
	local editBoxShown = ChatFrameEditBox:IsShown()
	local editBoxText = ChatFrameEditBox:GetText()

	if not editBoxShown then
		ChatEdit_ActivateChat(ChatFrameEditBox)
	end

	if editBoxText and editBoxText ~= "" then
		ChatFrameEditBox:SetText("")
	end

	ChatFrameEditBox:Insert(message)
	ChatFrameEditBox:HighlightText()
end

local function HyperLinkedCPL(data)
	if strsub(data, 1, 3) == "cpl" then
		local chatID = strsub(data, 5)
		local chat = _G[format("ChatFrame%d", chatID)]

		if not chat then return end

		local scale = chat:GetEffectiveScale() --blizzard does this with `scale = UIParent:GetScale()`
		local cursorX, cursorY = GetCursorPosition()
		cursorX, cursorY = (cursorX / scale), (cursorY / scale)
		local _, lineIndex = chat:FindCharacterAndLineIndexAtCoordinate(cursorX, cursorY)

		if lineIndex then
			local visibleLine = chat.visibleLines and chat.visibleLines[lineIndex]
			local message = visibleLine and visibleLine.messageInfo and visibleLine.messageInfo.message

			if message and message ~= "" then
				message = gsub(message, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
				message = strtrim(removeIconFromLine(message))
				SetChatEditBoxMessage(message)
			end
		end

		return
	end
end

local function HyperLinkedSQU(data)
	if strsub(data, 1, 3) == "squ" then
		if not QuickJoinFrame:IsShown() then
			ToggleQuickJoinPanel()
		end

		local guid = strsub(data, 5)

		if guid and guid ~= "" then
			QuickJoinFrame:SelectGroup(guid)
			QuickJoinFrame:ScrollToGroup(guid)
		end

		return
	end
end

local function HyperLinkedURL(data)
	if strsub(data, 1, 3) == "url" then
		local currentLink = strsub(data, 5)

		if currentLink and currentLink ~= "" then
			SetChatEditBoxMessage(currentLink)
		end

		return
	end
end

local SetHyperlink = ItemRefTooltip.SetHyperlink
function ItemRefTooltip:SetHyperlink(data, ...)
	if strsub(data, 1, 3) == "cpl" then
		HyperLinkedCPL(data)
	elseif strsub(data, 1, 3) == "squ" then
		HyperLinkedSQU(data)
	elseif strsub(data, 1, 3) == "url" then
		HyperLinkedURL(data)
	else
		SetHyperlink(self, data, ...)
	end
end

local hyperLinkEntered
function CH:OnHyperlinkEnter(frame, refString)
	if InCombatLockdown() then return end

	local linkToken = strmatch(refString, "^([^:]+)")

	if hyperlinkTypes[linkToken] then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(refString)
		hyperLinkEntered = frame
		GameTooltip:Show()
	end
end

function CH:OnHyperlinkLeave(frame, refString)
	if hyperLinkEntered then
		HideUIPanel(GameTooltip)
		hyperLinkEntered = nil
	end
end

function CH:EnableHyperlink()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]

		if (not self.hooks or not self.hooks[frame] or not self.hooks[frame].OnHyperlinkEnter) then
			self:HookScript(frame, "OnHyperlinkEnter")
			self:HookScript(frame, "OnHyperlinkLeave")
			-- self:HookScript(frame, "OnMessageScrollChanged")
		end
	end
end

function CH:DisableHyperlink()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]

		if self.hooks and self.hooks[frame] and self.hooks[frame].OnHyperlinkEnter then
			self:Unhook(frame, "OnHyperlinkEnter")
			self:Unhook(frame, "OnHyperlinkLeave")
			-- self:Unhook(frame, "OnMessageScrollChanged")
		end
	end
end

function CH:ShortChannel()
	return format("|Hchannel:%s|h[%s]|h", self, DEFAULT_STRINGS[strupper(self)] or gsub(self, "channel:", ""))
end

local function getFirstToonClassColor(id)
	if not id then return end

	local bnetIDAccount, isOnline, numGameAccounts, client, Class, _
	local total = BNGetNumFriends()

	for i = 1, total do
		bnetIDAccount, _, _, _, _, _, _, isOnline = BNGetFriendInfo(i)

		if isOnline and (bnetIDAccount == id) then

			numGameAccounts = BNGetNumFriendGameAccounts(i)

			if numGameAccounts > 0 then
				for y = 1, numGameAccounts do
					_, _, client, _, _, _, _, Class = BNGetFriendGameAccountInfo(i, y)
					if (client == BNET_CLIENT_WOW) and Class and Class ~= "" then
						return Class --return the first toon"s class
					end
				end
			end

			break
		end
	end
end

function CH:GetBNFriendColor(name, id, useBTag)
	local _, _, battleTag, isBattleTagPresence, _, bnetIDGameAccount = BNGetFriendInfoByID(id)
	local BATTLE_TAG = battleTag and strmatch(battleTag,"([^#]+)")
	local TAG = (useBTag or CH.db.useBTagName) and BATTLE_TAG
	local Class

	if not bnetIDGameAccount then --dont know how this is possible
		local firstToonClass = getFirstToonClassColor(id)

		if firstToonClass then
			Class = firstToonClass
		else
			return TAG or name, isBattleTagPresence and BATTLE_TAG
		end
	end

	if not Class then
		_, _, _, _, _, _, _, Class = BNGetGameAccountInfo(bnetIDGameAccount)
	end

	if Class and Class ~= "" then --other non-english locales require this
		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if Class == v then Class = kbreak end end
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if Class == v then Class = kbreak end end
	end

	local CLASS = Class and Class ~= "" and gsub(strupper(Class),"%s","")
	local COLOR = CLASS and (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[CLASS] or RAID_CLASS_COLORS[CLASS])

	return (COLOR and format("|c%s%s|r", COLOR.colorStr, TAG or name)) or TAG or name, isBattleTagPresence and BATTLE_TAG
end

local PluginIconsCalls = {}
function CH:AddPluginIcons(func)
	tinsert(PluginIconsCalls, func)
end

function CH:GetPluginIcon(sender)
	local icon
	for i = 1, #PluginIconsCalls do
		icon = PluginIconsCalls[i](sender)
		if icon and icon ~= "" then break end
	end

	return icon
end

--Copied from FrameXML ChatFrame.lua and modified to add CUSTOM_CLASS_COLORS
function CH:GetColoredName(event, _, arg2, _, _, _, _, _, arg8, _, _, _, arg12)
	local chatType = strsub(event, 10)

	if ( strsub(chatType, 1, 7) == "WHISPER" ) then
		chatType = "WHISPER"
	end

	if ( strsub(chatType, 1, 7) == "CHANNEL" ) then
		chatType = "CHANNEL"..arg8
	end

	local info = ChatTypeInfo[chatType]

	--ambiguate guild chat names
	if (chatType == "GUILD") then
		arg2 = Ambiguate(arg2, "guild")
	else
		arg2 = Ambiguate(arg2, "none")
	end

	if ( arg12 and info and Chat_ShouldColorChatByClass(info) ) then
		local _, englishClass = GetPlayerInfoByGUID(arg12)

		if ( englishClass ) then
			local classColorTable = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[englishClass] or RAID_CLASS_COLORS[englishClass]
			if ( not classColorTable ) then
				return arg2
			end

			return format("\124cff%.2x%.2x%.2x", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255)..arg2.."\124r"
		end
	end

	return arg2
end

T.NameReplacements = {}
function CH:ChatFrame_MessageEventHandler(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, isHistory, historyTime, historyName, historyBTag)
	-- ElvUI Chat History Note: isHistory, historyTime, historyName, and historyBTag are passed from CH:DisplayChatHistory() and need to be on the end to prevent issues in other addons that listen on ChatFrame_MessageEventHandler.
	-- we also send isHistory and historyTime into CH:AddMessage so that we don"t have to override the timestamp.
	if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
		if (arg16) then
			-- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)
			return true
		end

		local historySavedName --we need to extend the arguments on CH.ChatFrame_MessageEventHandler so we can properly handle saved names without overriding
		if isHistory == "ElvUI_ChatHistory" then
			if historyBTag then arg2 = historyBTag end -- swap arg2 (which is a |k string) to btag name
			historySavedName = historyName
		end

		local type = strsub(event, 10)
		local info = ChatTypeInfo[type]

		local chatFilters = ChatFrame_GetMessageEventFilters(event)
		if chatFilters then
			local filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14
			for _, filterFunc in next, chatFilters do
				filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 = filterFunc(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
				if ( filter ) then
					return true
				elseif ( newarg1 ) then
					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14
				end
			end
		end

		arg2 = T.NameReplacements[arg2] or arg2

		local _, _, englishClass, _, _, _, name, realm = pcall(GetPlayerInfoByGUID, arg12)
		local coloredName = historySavedName or CH:GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
		local nameWithRealm -- we also use this lower in function to correct mobile to link with the realm as well

		--Cache name->class
		realm = (realm and realm ~= "") and gsub(realm,"[%s%-]","") -- also used similar to nameWithRealm except for emotes to link the realm
		if name and name ~= "" then
			CH.ClassNames[name:lower()] = englishClass
			nameWithRealm = (realm and name.."-"..realm) or name.."-"..PLAYER_REALM
			CH.ClassNames[nameWithRealm:lower()] = englishClass
		end

		local channelLength = strlen(arg4)
		local infoType = type
		if ( (type == "COMMUNITIES_CHANNEL") or ((strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and ((arg1 ~= "INVITE") or (type ~= "CHANNEL_NOTICE_USER"))) ) then
			if ( arg1 == "WRONG_PASSWORD" ) then
				local staticPopup = _G[StaticPopup_Visible("CHAT_CHANNEL_PASSWORD") or ""]
				if ( staticPopup and strupper(staticPopup.data) == strupper(arg9) ) then
					-- Don"t display invalid password messages if we"re going to prompt for a password (bug 102312)
					return
				end
			end

			local found = 0
			for index, value in pairs(self.channelList) do
				if ( channelLength > strlen(value) ) then
					-- arg9 is the channel name without the number in front...
					if ( ((arg7 > 0) and (self.zoneChannelList[index] == arg7)) or (strupper(value) == strupper(arg9)) ) then
						found = 1
						infoType = "CHANNEL"..arg8
						info = ChatTypeInfo[infoType]
						if ( (type == "CHANNEL_NOTICE") and (arg1 == "YOU_LEFT") ) then
							self.channelList[index] = nil
							self.zoneChannelList[index] = nil
						end
						break
					end
				end
			end
			if ( (found == 0) or not info ) then
				return true
			end
		end

		local chatGroup = Chat_GetChatCategory(type)
		local chatTarget
		if ( chatGroup == "CHANNEL" ) then
			chatTarget = tostring(arg8)
		elseif ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if(not(strsub(arg2, 1, 2) == "|K")) then
				chatTarget = strupper(arg2)
			else
				chatTarget = arg2
			end
		end

		if ( FCFManager_ShouldSuppressMessage(self, chatGroup, chatTarget) ) then
			return true
		end

		if ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if ( self.privateMessageList and not self.privateMessageList[strlower(arg2)] ) then
				return true
			elseif ( self.excludePrivateMessageList and self.excludePrivateMessageList[strlower(arg2)]
				and ( (chatGroup == "WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") or (chatGroup == "BN_WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") ) ) then
				return true
			end
		end

		if (self.privateMessageList) then
			-- Dedicated BN whisper windows need online/offline messages for only that player
			if ( (chatGroup == "BN_INLINE_TOAST_ALERT" or chatGroup == "BN_WHISPER_PLAYER_OFFLINE") and not self.privateMessageList[strlower(arg2)] ) then
				return true
			end

			-- HACK to put certain system messages into dedicated whisper windows
			if ( chatGroup == "SYSTEM") then
				local matchFound = false
				local message = strlower(arg1)
				for playerName, _ in pairs(self.privateMessageList) do
					local playerNotFoundMsg = strlower(format(GlobalStrings.ERR_CHAT_PLAYER_NOT_FOUND_S, playerName))
					local charOnlineMsg = strlower(format(GlobalStrings.ERR_FRIEND_ONLINE_SS, playerName, playerName))
					local charOfflineMsg = strlower(format(GlobalStrings.ERR_FRIEND_OFFLINE_S, playerName))
					if ( message == playerNotFoundMsg or message == charOnlineMsg or message == charOfflineMsg) then
						matchFound = true
						break
					end
				end

				if (not matchFound) then
					return true
				end
			end
		end

		if ( type == "SYSTEM" or type == "SKILL" or type == "CURRENCY" or type == "MONEY" or
			type == "OPENING" or type == "TRADESKILLS" or type == "PET_INFO" or type == "TARGETICONS" or type == "BN_WHISPER_PLAYER_OFFLINE") then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif (type == "LOOT") then
			-- Append [Share] hyperlink if this is a valid social item and you are the looter.
			-- arg5 contains the name of the player who looted
			if (C_Social.IsSocialEnabled() and UnitName("player") == arg5) then
				local itemID, creationContext = GetItemInfoFromHyperlink(arg1)
				if (itemID and C_Social.GetLastItem() == itemID) then
					arg1 = arg1 .. " " .. Social_GetShareItemLink(itemID, creationContext, true)
				end
			end
			self:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( strsub(type,1,7) == "COMBAT_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( strsub(type,1,6) == "SPELL_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( strsub(type,1,10) == "BG_SYSTEM_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( strsub(type,1,11) == "ACHIEVEMENT" ) then
			-- Append [Share] hyperlink
			if (arg12 == T.myguid and C_Social.IsSocialEnabled()) then
				local achieveID = GetAchievementInfoFromHyperlink(arg1)
				if (achieveID) then
					arg1 = arg1 .. " " .. Social_GetShareAchievementLink(achieveID, true)
				end
			end
			self:AddMessage(format(arg1, GetPlayerLink(arg2, ("[%s]"):format(coloredName))), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( strsub(type,1,18) == "GUILD_ACHIEVEMENT" ) then
			local message = format(arg1, GetPlayerLink(arg2, ("[%s]"):format(coloredName)))
			if (C_Social.IsSocialEnabled()) then
				local achieveID = GetAchievementInfoFromHyperlink(arg1)
				if (achieveID) then
					local isGuildAchievement = select(12, GetAchievementInfo(achieveID))
					if (isGuildAchievement) then
						message = message .. " " .. Social_GetShareAchievementLink(achieveID, true)
					end
				end
			end
			self:AddMessage(message, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( type == "IGNORED" ) then
			self:AddMessage(format(GlobalStrings.CHAT_IGNORED, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( type == "FILTERED" ) then
			self:AddMessage(format(GlobalStrings.CHAT_FILTERED, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( type == "RESTRICTED" ) then
			self:AddMessage(GlobalStrings.CHAT_RESTRICTED_TRIAL, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( type == "CHANNEL_LIST") then
			if(channelLength > 0) then
				self:AddMessage(format(_G["CHAT_"..type.."_GET"]..arg1, tonumber(arg8), arg4), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			else
				self:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif (type == "CHANNEL_NOTICE_USER") then
			local globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"]
			if ( not globalstring ) then
				globalstring = _G["CHAT_"..arg1.."_NOTICE"]
			end
			if not globalstring then
				GMError(("Missing global string for %q"):format("CHAT_"..arg1.."_NOTICE_BN"))
				return
			end
			if(arg5 ~= "") then
				-- TWO users in this notice (T.G. x kicked y)
				self:AddMessage(format(globalstring, arg8, arg4, arg2, arg5), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			elseif ( arg1 == "INVITE" ) then
				self:AddMessage(format(globalstring, arg4, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			else
				self:AddMessage(format(globalstring, arg8, arg4, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
			if ( arg1 == "INVITE" and GetCVarBool("blockChannelInvites") ) then
				self:AddMessage(GlobalStrings.CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif (type == "CHANNEL_NOTICE") then
			local globalstring
			if ( arg1 == "TRIAL_RESTRICTED" ) then
				globalstring = GlobalStrings.CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL
			else
				globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"]
				if ( not globalstring ) then
					globalstring = _G["CHAT_"..arg1.."_NOTICE"]
					if not globalstring then
						GMError(("Missing global string for %q"):format("CHAT_"..arg1.."_NOTICE"))
						return
					end
				end
			end
			local accessID = ChatHistory_GetAccessID(Chat_GetChatCategory(type), arg8)
			local typeID = ChatHistory_GetAccessID(infoType, arg8, arg12)
			self:AddMessage(format(globalstring, arg8, ChatFrame_ResolvePrefixedChannelName(arg4)), info.r, info.g, info.b, info.id, accessID, typeID, isHistory, historyTime)
		elseif ( type == "BN_INLINE_TOAST_ALERT" ) then
			local globalstring = _G["BN_INLINE_TOAST_"..arg1]
			if not globalstring then
				GMError(("Missing global string for %q"):format("BN_INLINE_TOAST_"..arg1))
				return
			end
			local message
			if ( arg1 == "FRIEND_REQUEST" ) then
				message = globalstring
			elseif ( arg1 == "FRIEND_PENDING" ) then
				message = format(GlobalStrings.BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites())
			elseif ( arg1 == "FRIEND_REMOVED" or arg1 == "BATTLETAG_FRIEND_REMOVED" ) then
				message = format(globalstring, arg2)
			elseif ( arg1 == "FRIEND_ONLINE" or arg1 == "FRIEND_OFFLINE" ) then
				local _, _, _, _, characterName, _, client = BNGetFriendInfoByID(arg13)
				if (client and client ~= "") then
					local _, _, battleTag = BNGetFriendInfoByID(arg13)
					characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client) or ""
					local characterNameText = BNet_GetClientEmbeddedTexture(client, 14)..characterName
					local linkDisplayText = ("[%s] (%s)"):format(arg2, characterNameText)
					local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0)
					message = format(globalstring, playerLink)
				else
					local linkDisplayText = ("[%s]"):format(arg2)
					local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0)
					message = format(globalstring, playerLink)
				end
			else
				local linkDisplayText = ("[%s]"):format(arg2)
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0)
				message = format(globalstring, playerLink)
			end
			self:AddMessage(message, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif ( type == "BN_INLINE_TOAST_BROADCAST" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveNewlines(RemoveExtraSpaces(arg1))
				local linkDisplayText = ("[%s]"):format(arg2)
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0)
				self:AddMessage(format(GlobalStrings.BN_INLINE_TOAST_BROADCAST, playerLink, arg1), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif ( type == "BN_INLINE_TOAST_BROADCAST_INFORM" ) then
			if ( arg1 ~= "" ) then
				self:AddMessage(GlobalStrings.BN_INLINE_TOAST_BROADCAST_INFORM, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		else
			local body

			if ( type == "WHISPER_INFORM" and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) ) then
				return
			end

			local showLink = 1
			if ( strsub(type, 1, 7) == "MONSTER" or strsub(type, 1, 9) == "RAID_BOSS") then
				showLink = nil
			else
				arg1 = gsub(arg1, "%%", "%%%%")
			end

			--Remove groups of many spaces
			arg1 = RemoveExtraSpaces(arg1)

			--ElvUI: Get class colored name for BattleNet friend
			if ( type == "BN_WHISPER" or type == "BN_WHISPER_INFORM" ) then
				coloredName = historySavedName or CH:GetBNFriendColor(arg2, arg13)
			end

			local playerLink
			local playerLinkDisplayText = coloredName
			local relevantDefaultLanguage = self.defaultLanguage
			if ( (type == "SAY") or (type == "YELL") ) then
				relevantDefaultLanguage = self.alternativeDefaultLanguage
			end
			local usingDifferentLanguage = (arg3 ~= "") and (arg3 ~= relevantDefaultLanguage)
			local usingEmote = (type == "EMOTE") or (type == "TEXT_EMOTE")

			if ( usingDifferentLanguage or not usingEmote ) then
				playerLinkDisplayText = ("[%s]"):format(coloredName)
			end

			local isCommunityType = type == "COMMUNITIES_CHANNEL"
			local playerName, lineID, bnetIDAccount = arg2, arg11, arg13
			if ( isCommunityType ) then
				local isBattleNetCommunity = bnetIDAccount ~= nil and bnetIDAccount ~= 0
				local messageInfo, clubId, streamId, clubType = C_Club.GetInfoFromLastCommunityChatLine()

				if (messageInfo ~= nil) then
					if ( isBattleNetCommunity ) then
						playerLink = GetBNPlayerCommunityLink(playerName, playerLinkDisplayText, bnetIDAccount, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					else
						playerLink = GetPlayerCommunityLink(playerName, playerLinkDisplayText, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					end
				else
					playerLink = playerLinkDisplayText
				end
			else
				if ( type == "TEXT_EMOTE" and realm ) then
					-- make sure emote has realm link correct
					playerName = playerName.."-"..realm
					playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
				elseif ( arg14 and nameWithRealm and nameWithRealm ~= playerName ) then
					-- make sure mobile has realm link correct
					playerName = nameWithRealm
					playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
				elseif ( type == "BN_WHISPER" or type == "BN_WHISPER_INFORM" ) then
					playerLink = GetBNPlayerLink(playerName, playerLinkDisplayText, bnetIDAccount, lineID, chatGroup, chatTarget)
				elseif ( type == "GUILD" and nameWithRealm and nameWithRealm ~= playerName ) then
					playerName = nameWithRealm
					playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
				else
					playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
				end
			end

			local message = arg1
			if ( arg14 ) then --isMobile
				message = ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)..message
			end

			-- Player Flags
			local pflag = ""
			if arg6 ~= "" then -- Blizzard Flags
				if arg6 == "GM" or arg6 == "DEV" then -- Blizzard Icon, this was sent by a GM or Dev.
					pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t"
				else -- Away/Busy
					pflag = _G["CHAT_FLAG_"..arg6] or ""
				end
			end

			-- LFG Role Flags
			local lfgRole = lfgRoles[playerName]
			if lfgRole and (type == "PARTY_LEADER" or type == "PARTY" or type == "RAID" or type == "RAID_LEADER" or type == "INSTANCE_CHAT" or type == "INSTANCE_CHAT_LEADER") then
				pflag = pflag..lfgRole
			end

			if ( usingDifferentLanguage ) then
				local languageHeader = "["..arg3.."] "
				if ( showLink and (arg2 ~= "") ) then
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..playerLink)
				else
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..arg2)
				end
			else
				if ( not showLink or arg2 == "" ) then
					if ( type == "TEXT_EMOTE" ) then
						body = message
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..arg2, arg2)
					end
				else
					if ( type == "EMOTE" ) then
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink)
					elseif ( type == "TEXT_EMOTE" and realm ) then
						-- make sure emote has realm link correct
						if info.colorNameByClass then
							body = gsub(message, arg2.."%-"..realm, pflag..playerLink:gsub("(|h|c.-)|r|h$","%1-"..realm.."|r|h"), 1)
						else
							body = gsub(message, arg2.."%-"..realm, pflag..playerLink:gsub("(|h.-)|h$","%1-"..realm.."|h"), 1)
						end
					elseif (type == "TEXT_EMOTE") then
						body = gsub(message, arg2, pflag..playerLink, 1)
					elseif (type == "GUILD_ITEM_LOOTED") then
						body = gsub(message, "$s", GetPlayerLink(arg2, playerLinkDisplayText))
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink)
					end
				end
			end

			-- Add Channel
			if (channelLength > 0) then
				body = "|Hchannel:channel:"..arg8.."|h["..ChatFrame_ResolvePrefixedChannelName(arg4).."]|h "..body
			end

			local accessID = ChatHistory_GetAccessID(chatGroup, chatTarget)
			local typeID = ChatHistory_GetAccessID(infoType, chatTarget, arg12 or arg13)
			if CH.db.shortChannels and type ~= "EMOTE" and type ~= "TEXT_EMOTE" then
				body = body:gsub("|Hchannel:(.-)|h%[(.-)%]|h", CH.ShortChannel)
				body = body:gsub("CHANNEL:", "")
				body = body:gsub("^(.-|h) ".."whispers", "%1")
				body = body:gsub("^(.-|h) ".."says", "%1")
				body = body:gsub("^(.-|h) ".."yells", "%1")
				body = body:gsub("<"..GlobalStrings.AFK..">", "[|cffFF0000".."AFK".."|r] ")
				body = body:gsub("<"..GlobalStrings.DND..">", "[|cffE7E716".."DND".."|r] ")
				body = body:gsub("^%["..GlobalStrings.RAID_WARNING.."%]", "[".."RW".."]")
			end
			self:AddMessage(body, info.r, info.g, info.b, info.id, accessID, typeID, isHistory, historyTime)
		end

		if ( isHistory ~= "ElvUI_ChatHistory" ) and ( type == "WHISPER" or type == "BN_WHISPER" ) then
			--BN_WHISPER FIXME
			ChatEdit_SetLastTellTarget(arg2, type)
			if ( self.tellTimer and (GetTime() > self.tellTimer) ) then
				PlaySound(SOUNDKIT.TELL_MESSAGE)
			end
			self.tellTimer = GetTime() + GlobalStrings.CHAT_TELL_ALERT_TIME
			--FCF_FlashTab(self)
			FlashClientIcon()
		end

		if ( isHistory ~= "ElvUI_ChatHistory" ) and ( not self:IsShown() ) then
			if ( (self == DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or (self ~= DEFAULT_CHAT_FRAME and info.flashTab) ) then
				if ( not CHAT_OPTIONS.HIDE_FRAME_ALERTS or type == "WHISPER" or type == "BN_WHISPER" ) then --BN_WHISPER FIXME
					if not FCFManager_ShouldSuppressMessageFlash(self, chatGroup, chatTarget) then
						FCF_StartAlertFlash(self) --This would taint if we were not using LibChatAnims
					end
				end
			end
		end

		return true
	end
end

function CH:ChatFrame_ConfigEventHandler(...)
	return ChatFrame_ConfigEventHandler(...)
end

function CH:ChatFrame_SystemEventHandler(...)
	return ChatFrame_SystemEventHandler(...)
end

function CH:ChatFrame_OnEvent(...)
	if CH:ChatFrame_ConfigEventHandler(...) then return end
	if CH:ChatFrame_SystemEventHandler(...) then return end
	if CH:ChatFrame_MessageEventHandler(...) then return end
end

function CH:FloatingChatFrame_OnEvent(...)
	CH:ChatFrame_OnEvent(...)
	FloatingChatFrame_OnEvent(...)
end

local function FloatingChatFrameOnEvent(...)
	CH:FloatingChatFrame_OnEvent(...)
end

function CH:SetupChat()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		local id = frame:GetID()
		local _, fontSize = FCF_GetChatWindowInfo(id)

		self:StyleChat(frame)

		frame:SetFont(T["media"].font, fontSize, "THINOUTLINE")--select(3, frame:GetFont()))--) --fontSize
		frame:SetShadowOffset(1, -1)
		frame:SetShadowColor(0, 0, 0, 0.2)

		frame:SetTimeVisible(100)
	end

	self:EnableHyperlink()

	GeneralDockManager:SetParent(LeftChatPanel)
	-- self:ScheduleRepeatingTimer("PositionChat", 1)
	self:PositionChat(true)

	if not self.HookSecured then
		self:SecureHook("FCF_OpenTemporaryWindow", "SetupChat")
		self.HookSecured = true
	end
end

local function PrepareMessage(author, message)
	return format("%s%s", strupper(author), message)
end

function CH:CHAT_MSG_CHANNEL(event, message, author, ...)
	local blockFlag = false
	local msg = PrepareMessage(author, message)

	-- ignore player messages
	if author == PLAYER_NAME then return CH.FindURL(self, event, message, author, ...) end
	if msgList[msg] and CH.db.throttleInterval ~= 0 then
		if difftime(time(), msgTime[msg]) <= CH.db.throttleInterval then
			blockFlag = true
		end
	end

	if blockFlag then
		return true
	else
		if CH.db.throttleInterval ~= 0 then
			msgTime[msg] = time()
		end

		return CH.FindURL(self, event, message, author, ...)
	end
end

function CH:CHAT_MSG_YELL(event, message, author, ...)
	local blockFlag = false
	local msg = PrepareMessage(author, message)

	if msg == nil then return CH.FindURL(self, event, message, author, ...) end

	-- ignore player messages
	if author == PLAYER_NAME then return CH.FindURL(self, event, message, author, ...) end
	if msgList[msg] and msgCount[msg] > 1 and CH.db.throttleInterval ~= 0 then
		if difftime(time(), msgTime[msg]) <= CH.db.throttleInterval then
			blockFlag = true
		end
	end

	if blockFlag then
		return true
	else
		if CH.db.throttleInterval ~= 0 then
			msgTime[msg] = time()
		end

		return CH.FindURL(self, event, message, author, ...)
	end
end

function CH:CHAT_MSG_SAY(event, message, author, ...)
	return CH.FindURL(self, event, message, author, ...)
end

function CH:AddLines(lines, ...)
	for i=select("#", ...),1,-1 do
	local x = select(i, ...)
		if x:GetObjectType() == "FontString" and not x:GetName() then
			tinsert(lines, x:GetText())
		end
	end
end

function CH:ChatEdit_OnEnterPressed(editBox)
	local chatType = editBox:GetAttribute("chatType")
	if not chatType then return end

	local chatFrame = editBox:GetParent()
	if chatFrame and (not chatFrame.isTemporary) and (ChatTypeInfo[chatType].sticky == 1) then
		editBox:SetAttribute("chatType", chatType)
	end
end

function CH:SetChatFont(dropDown, chatFrame, fontSize)
	if ( not chatFrame ) then
		chatFrame = FCF_GetCurrentChatFrame()
	end
	if ( not fontSize ) then
		fontSize = dropDown.value
	end

--	local _, fontSize = FCF_GetChatWindowInfo(id)
	chatFrame:SetFont(T["media"].font, fontSize, "THINOUTLINE")--select(3, frame:GetFont())) --fontSize
	chatFrame:SetShadowOffset(1, -1)
	chatFrame:SetShadowColor(0, 0, 0, 0.2)
end

function CH:ChatEdit_AddHistory(editBox, line)
	if find(line, "/rl") then return end

	if ( strlen(line) > 0 ) then
		for _, text in pairs(self.db.ChatEditLog) do
			if text == line then
				return
			end
		end

		tinsert(self.db.ChatEditLog, #self.db.ChatEditLog + 1, line)
		if #self.db.ChatEditLog > 20 then
			tremove(self.db.ChatEditLog, 1)
		end
	end
end

function CH:PET_BATTLE_CLOSE()
	if not self.db.autoClosePetBattleLog then
		return
	end

	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		if frame then
			local text = _G[frameName.."Tab"]:GetText()
			if strmatch(text, DEFAULT_STRINGS.PET_BATTLE_COMBAT_LOG) then
				FCF_Close(frame)
			end
		end
	end
end

function CH:UpdateFading()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		if frame then
			frame:SetFading(self.db.fade)
		end
	end
end

function CH:DisplayChatHistory()
	local data, d = self.db.ChatLog
	if not (data and next(data)) then return end

	if not GetPlayerInfoByGUID(T.playerGuid) then
		T:Delay(0.1, CH.DisplayChatHistory)
		return
	end

	CH.SoundPlayed = true
	for _, chat in pairs(CHAT_FRAMES) do
		for i=1, #data do
			d = data[i]
			if type(d) == "table" then
				for _, messageType in pairs(_G[chat].messageTypeList) do
					if gsub(strsub(d[50],10),"_INFORM","") == messageType then
						CH:ChatFrame_MessageEventHandler(_G[chat],d[50],d[1],d[2],d[3],d[4],d[5],d[6],d[7],d[8],d[9],d[10],d[11],d[12],d[13],d[14],d[15],d[16],d[17],"ElvUI_ChatHistory",d[51],d[52],d[53])
					end
				end
			end
		end
	end
	CH.SoundPlayed = nil
end

tremove(ChatTypeGroup["GUILD"], 2)
function CH:DelayGuildMOTD()
	local delay, checks, delayFrame, chat = 0, 0, CreateFrame("Frame")
	tinsert(ChatTypeGroup["GUILD"], 2, "GUILD_MOTD")
	delayFrame:SetScript("OnUpdate", function(df, elapsed)
		delay = delay + elapsed
		if delay < 5 then return end
		local msg = GetGuildRosterMOTD()
		if msg and strlen(msg) > 0 then
			for _, frame in pairs(CHAT_FRAMES) do
				chat = _G[frame]
				if chat and chat:IsEventRegistered("CHAT_MSG_GUILD") then
					CH:ChatFrame_SystemEventHandler(chat, "GUILD_MOTD", msg)
					chat:RegisterEvent("GUILD_MOTD")
				end
			end
			df:SetScript("OnUpdate", nil)
		else -- 5 seconds can be too fast for the API response. let"s try once every 5 seconds (max 5 checks).
			delay, checks = 0, checks + 1
			if checks >= 5 then
				df:SetScript("OnUpdate", nil)
			end
		end
	end)
end

function CH:SaveChatHistory(event, ...)
	if not self.db.ChatLog then return end
	local data = self.db.ChatLog

	local temp = {}
	for i = 1, select("#", ...) do
		temp[i] = select(i, ...) or false
	end

	if #temp > 0 then
		temp[50] = event
		temp[51] = time()

		local coloredName, battleTag
		if temp[13] > 0 then coloredName, battleTag = CH:GetBNFriendColor(temp[2], temp[13], true) end
		if battleTag then temp[53] = battleTag end -- store the battletag, only when the person is known by battletag, so we can replace arg2 later in the function
		temp[52] = coloredName or CH:GetColoredName(event, ...)

		tinsert(data, temp)
		while #data >= 128 do
			tremove(data, 1)
		end
	end
	temp = nil -- Destory!
end

function CH:FCF_SetWindowAlpha(frame, alpha)
	frame.oldAlpha = alpha or 1
end

function CH:CheckLFGRoles()
	local isInGroup, isInRaid = IsInGroup(), IsInRaid()
	local unit = isInRaid and "raid" or "party"
	local name, realm
	twipe(lfgRoles)
	if(not isInGroup) then return end

	local role = UnitGroupRolesAssigned("player")
	if(role) then
		lfgRoles[PLAYER_NAME] = rolePaths[role]
	end

	for i=1, GetNumGroupMembers() do
		if(UnitExists(unit..i) and not UnitIsUnit(unit..i, "player")) then
			role = UnitGroupRolesAssigned(unit..i)
			name, realm = UnitName(unit..i)

			if(role and name) then
				name = (realm and realm ~= "" and name.."-"..realm) or name.."-"..PLAYER_REALM
				lfgRoles[name] = rolePaths[role]
			end
		end
	end
end

function CH:ON_FCF_SavePositionAndDimensions(_, noLoop)
	if not noLoop then
		CH:PositionChat()
	end

	CH:UpdateChatTabs() --It was not done in PositionChat, so do it now
end

local FindURL_Events = {
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM",
	"CHAT_MSG_BN_INLINE_TOAST_BROADCAST",
	"CHAT_MSG_GUILD_ACHIEVEMENT",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_SAY",
	"CHAT_MSG_YELL",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_AFK",
	"CHAT_MSG_DND",
	"CHAT_MSG_COMMUNITIES_CHANNEL",
}

CH.OnInitialize = function(self)
	self.db = T.dbChar or {}
	self.db.ChatLog = self.db.ChatLog or {}
	self.db.ChatEditLog = self.db.ChatEditLog or {}

	self.dbGlobalChat = T.dbGlobal.chat or {}
end

CH.OnEnable = function(self)
	self:DelayGuildMOTD() --Keep this before `is Chat Enabled` check
--	self:UpdateFading()

	self:SecureHook("ChatEdit_OnEnterPressed")

	if WIM then
		WIM.RegisterWidgetTrigger("chat_display", "whisper,chat,w2w,demo", "OnHyperlinkClick", function(self) CH.clickedframe = self end)
		WIM.RegisterItemRefHandler("url", HyperLinkedURL)
		WIM.RegisterItemRefHandler("squ", HyperLinkedSQU)
		WIM.RegisterItemRefHandler("cpl", HyperLinkedCPL)
	end

	self:SecureHook("FCF_SetChatWindowFontSize", "SetChatFont")
	self:SecureHook("FCF_SavePositionAndDimensions", "ON_FCF_SavePositionAndDimensions")
	self:RegisterEvent("UPDATE_CHAT_WINDOWS", "SetupChat")
	self:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS", "SetupChat")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "CheckLFGRoles")
	self:RegisterEvent("PET_BATTLE_CLOSE")

	self:SetupChat()
	self:UpdateAnchors()
	self:UpdateChatTabs() --It was not done in PositionChat, so do it now

	GeneralDockManagerOverflowButton:ClearAllPoints()
	GeneralDockManagerOverflowButton:SetPoint("BOTTOMRIGHT", LeftChatTab, "BOTTOMRIGHT", -2, 2)
	hooksecurefunc(GeneralDockManagerScrollFrame, "SetPoint", function(self, point, anchor, attachTo, x, y)
		if anchor == GeneralDockManagerOverflowButton and x == 0 and y == 0 then
			self:SetPoint(point, anchor, attachTo, -2, -6)
		end
	end)

	for _, event in pairs(FindURL_Events) do
		ChatFrame_AddMessageEventFilter(event, CH[event] or CH.FindURL)
		local nType = strsub(event, 10)
		if nType ~= "AFK" and nType ~= "DND" and nType ~= "COMMUNITIES_CHANNEL" then
			self:RegisterEvent(event, "SaveChatHistory")
		end
	end

	self:DisplayChatHistory()

	ChatFrame1ButtonFrame:Kill()
	ChatFrameMenuButton:Kill() -- We have it on your CopyChatButton via right click

	QuickJoinToastButton:ClearAllPoints()
	QuickJoinToastButton:SetPoint("BOTTOMLEFT", _G["GeneralDockManager"], "TOPLEFT", 3, 75)

	ChatFrameChannelButton:ClearAllPoints()
	ChatFrameChannelButton:SetPoint("BOTTOMLEFT", _G["GeneralDockManager"], "TOPLEFT", 5, 44)
end


--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local CH = T:NewModule("Chat", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

T.Chat = CH

local CreatedFrames = 0
local lines = {}
local lfgRoles = {}
local msgList, msgCount, msgTime = {}, {}, {}
local good, maybe, filter, login = {}, {}, {}, false
local chatFilters = {}

local cvars = {
	["bnWhisperMode"] = true,
	["conversationMode"] = true,
	["whisperMode"] = true,
}

local len, gsub, find, sub, gmatch, format, random = string.len, string.gsub, string.find, string.sub, string.gmatch, string.format, math.random
local tinsert, tremove, tsort, twipe, tconcat = table.insert, table.remove, table.sort, table.wipe, table.concat

local PLAYER_NAME = T.playerName .. "-" .. T.playerRealm

local TIMESTAMP_FORMAT
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

local function ChatFrame_OnMouseScroll(frame, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			frame:ScrollToBottom()
		else
			for i = 1, 3 do
				frame:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			frame:ScrollToTop()
		else
			for i = 1, 3 do
				frame:ScrollUp()
			end
		end

		if T.dbGlobal["chat"].scrollDownInterval ~= 0 then
			if frame.ScrollTimer then
				CH:CancelTimer(frame.ScrollTimer, true)
			end

			frame.ScrollTimer = CH:ScheduleTimer("ScrollToBottom", T.dbGlobal["chat"].scrollDownInterval, frame)
		end
	end
end

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

	if frame.styled then return end

	frame:SetFrameLevel(4)

	local id = frame:GetID()

	local tab = _G[name.."Tab"]
	local editbox = _G[name.."EditBox"]
	local tabHeight = tab:GetHeight()

	for _, texName in pairs(tabTexs) do
		_G[tab:GetName()..texName.."Left"]:SetTexture(nil)
		_G[tab:GetName()..texName.."Middle"]:SetTexture(nil)
		_G[tab:GetName()..texName.."Right"]:SetTexture(nil)
	end

	hooksecurefunc(tab, "SetAlpha", function(t, alpha)
		if alpha ~= 1 and (not t.isDocked or GeneralDockManager.selected:GetID() == t:GetID()) then
			t:SetAlpha(1)
		elseif alpha < 0.6 then
			t:SetAlpha(0.6)
		end
	end)

	tab.text = _G[name.."TabText"]
	tab.text:SetFont(T["media"].font, 12, "OUTLINE")
	tab.text:SetJustifyH("CENTER")
	tab.text.GetWidth = tab.text.GetStringWidth

	if tab.conversationIcon then
		tab.conversationIcon:ClearAllPoints()
		tab.conversationIcon:Point("RIGHT", tab.text, "LEFT", -1, 0)
	end

	frame:SetClampRectInsets(0,0,0,0)
	frame:SetClampedToScreen(false)
	frame:StripTextures(true)
	_G[name.."ButtonFrame"]:Kill()

	editbox:SetAltArrowKeyMode(false)

	editbox:ClearAllPoints()
	editbox:Point("BOTTOMLEFT",  ChatFrame1, "TOPLEFT",  -5, tabHeight - 5)
	editbox:Point("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 10, tabHeight - 5)

	self:SecureHook(editbox, "AddHistoryLine", "ChatEdit_AddHistory")

	editbox:SetAlpha(0)
	hooksecurefunc("ChatEdit_DeactivateChat", function(self)
		editbox:SetAlpha(0)
	end)
	hooksecurefunc("ChatEdit_OnHide", function(self)
		editbox:SetAlpha(0)
	end)

	editbox:HookScript("OnTextChanged", function(self)
		local text = self:GetText()

		if InCombatLockdown() then
			local MIN_REPEAT_CHARACTERS = 5
			if (len(text) > MIN_REPEAT_CHARACTERS) then
			local repeatChar = true
			for i=1, MIN_REPEAT_CHARACTERS, 1 do
				if ( sub(text,(0-i), (0-i)) ~= sub(text,(-1-i),(-1-i)) ) then
					repeatChar = false
					break
				end
			end
				if ( repeatChar ) then
					self:Hide()
					return
				end
			end
		end

		if text:len() < 5 then
			if text:sub(1, 4) == "/tt " then
				local unitname, realm = UnitName("target")
				if unitname then unitname = gsub(unitname, " ", "") end
				if unitname and UnitRealmRelationship("target") ~= LE_REALM_RELATION_SAME then
					unitname = unitname .. "-" .. gsub(realm, " ", "")
				end
				ChatFrame_SendTell((unitname or "Invalid Target"), ChatFrame1)
			end

			if text:sub(1, 4) == "/gr " then
				self:SetText(CH:GetGroupDistribution() .. text:sub(5))
				ChatEdit_ParseText(self, 0)
			end
		end

		local new, found = gsub(text, "|Kf(%S+)|k(%S+)%s(%S+)|k", "%2 %3")
		if found > 0 then
			new = new:gsub("|", "")
			self:SetText(new)
		end
	end)

	for i, text in pairs(self.db.ChatEditHistory) do
		editbox:AddHistoryLine(text)
	end

	hooksecurefunc("ChatEdit_UpdateHeader", function()
		local type = editbox:GetAttribute("chatType")
		if ( type == "CHANNEL" ) then
			local id = GetChannelName(editbox:GetAttribute("channelTarget"))
			if id == 0 then
				editbox:SetBackdropBorderColor(0, 0, 0)
			else
				editbox:SetBackdropBorderColor(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
			end
		elseif type then
			editbox:SetBackdropBorderColor(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
		end
	end)

	if id ~= 2 then --Don't add timestamps to combat log, they don't work.
		--This usually taints, but LibChatAnims should make sure it doesn't.
		frame.OldAddMessage = frame.AddMessage
		frame.AddMessage = CH.AddMessage
	end

	hooksecurefunc("FCF_Tab_OnClick", function(self)
		local info = UIDropDownMenu_CreateInfo()
		info.text = "Copy Chat Contents"
		info.notCheckable = true
		info.func = CH.CopyChat
		info.arg1 = self
		UIDropDownMenu_AddButton(info)
	end)

	CreatedFrames = id
	frame.styled = true
end

local function removeIconFromLine(text)
	for i=1, 8 do
		text = gsub(text, "|TInterface\\TargetingFrame\\UI%-RaidTargetingIcon_"..i..":0|t", "{"..strlower(_G["RAID_TARGET_"..i]).."}")
	end
	text = gsub(text, "(|TInterface(.*)|t)", "")

	return text
end

function CH:GetLines(...)
	local index = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			local line = tostring(region:GetText())
			lines[index] = removeIconFromLine(line)
			index = index + 1
		end
	end
	return index - 1
end

function CH:CopyChat(frame)
	if not CopyChatFrame:IsShown() then
		local chatFrame = _G["ChatFrame" .. frame:GetID()]
		local numMessages = chatFrame:GetNumMessages()

		if (numMessages >= 1) then
			local GetMessageInfo = chatFrame.GetMessageInfo
			local text = GetMessageInfo(chatFrame, 1)

			for index = 2, numMessages do
				text = text .. "\n" .. GetMessageInfo(chatFrame, index)
			end

			CopyChatFrame:Show()
			CopyChatFrameEditBox:SetText(text)
		end
	else
		CopyChatFrame:Hide()
	end
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

local x = CreateFrame("Frame")
function CH:SetupChatTabs(frame, hook)
	if hook and (not self.hooks or not self.hooks[frame] or not self.hooks[frame].OnEnter) then
		self:HookScript(frame, "OnEnter")
		self:HookScript(frame, "OnLeave")
	elseif not hook and self.hooks and self.hooks[frame] and self.hooks[frame].OnEnter then
		self:Unhook(frame, "OnEnter")
		self:Unhook(frame, "OnLeave")
	end

	if not hook then
		_G[frame:GetName().."Text"]:Show()

		if frame.owner and frame.owner.button and GetMouseFocus() ~= frame.owner.button then
			frame.owner.button:SetAlpha(0.35)
		end
		if frame.conversationIcon then
			frame.conversationIcon:Show()
		end
	elseif GetMouseFocus() ~= frame then
		_G[frame:GetName().."Text"]:Hide()

		if frame.owner and frame.owner.button and GetMouseFocus() ~= frame.owner.button then
			frame.owner.button:SetAlpha(0)
		end

		if frame.conversationIcon then
			frame.conversationIcon:Hide()
		end
	end
end

function CH:UpdateAnchors()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName.."EditBox"]
		if not frame then break end
		if T.db.datatexts.leftChatPanel and T.db.chat.editBoxPosition == "BELOW_CHAT" then
			frame:SetAllPoints(LeftChatDataPanel)
		else
			frame:SetAllPoints(LeftChatTab)
		end
	end

	CH:PositionChat(true)
end

local function UpdateChatTabColor(hex, r, g, b)
	for i=1, CreatedFrames do
		_G["ChatFrame"..i.."TabText"]:SetTextColor(r, g, b)
	end
end

function CH:ScrollToBottom(frame)
	frame:ScrollToBottom()

	self:CancelTimer(frame.ScrollTimer, true)
end

function CH:PrintURL(url)
	return "|cFFFFFFFF[|Hurl:"..url.."|h"..url.."|h]|r "
end

function CH:FindURL(event, msg, ...)
	if (event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER") and CH.db.whisperSound ~= "None" and not CH.SoundPlayed then
		if (msg:sub(1,3) == "OQ,") then return false, msg, ... end
		PlaySoundFile(LSM:Fetch("sound", CH.db.whisperSound), "Master")
		CH.SoundPlayed = true
		CH.SoundTimer = CH:ScheduleTimer("ThrottleSound", 1)
	end

	local newMsg, found = gsub(msg, "(%a+)://(%S+)%s?", CH:PrintURL("%1://%2"))
	if found > 0 then return false, newMsg, ... end

	newMsg, found = gsub(msg, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", CH:PrintURL("www.%1.%2"))
	if found > 0 then return false, newMsg, ... end

	newMsg, found = gsub(msg, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", CH:PrintURL("%1@%2%3%4"))
	if found > 0 then return false, newMsg, ... end

	return false, msg, ...
end

local function URLChatFrame_OnHyperlinkShow(self, link, ...)
	CH.clickedframe = self
	if (link):sub(1, 3) == "url" then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		local currentLink = (link):sub(5)
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(currentLink)
		ChatFrameEditBox:HighlightText()
		return
	end

	ChatFrame_OnHyperlinkShow(self, link, ...)
end

local function WIM_URLLink(link)
	if (link):sub(1, 3) == "url" then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		local currentLink = (link):sub(5)
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(currentLink)
		ChatFrameEditBox:HighlightText()
		return
	end
end

do
	local hyperLinkEntered

	function CH:OnHyperlinkEnter(frame, refString)
		if InCombatLockdown() then return end

		local linkToken = refString:match("^([^:]+)")

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
end

function CH:EnableHyperlink()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		if (not self.hooks or not self.hooks[frame] or not self.hooks[frame].OnHyperlinkEnter) then
			self:HookScript(frame, "OnHyperlinkEnter")
			self:HookScript(frame, "OnHyperlinkLeave")
		end
	end
end

function CH:DisableHyperlink()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		if self.hooks and self.hooks[frame] and self.hooks[frame].OnHyperlinkEnter then
			self:Unhook(frame, "OnHyperlinkEnter")
			self:Unhook(frame, "OnHyperlinkLeave")
		end
	end
end

function CH:DisableChatThrottle()
	twipe(msgList) twipe(msgCount) twipe(msgTime)
end

function CH:ShortChannel()
	return format("|Hchannel:%s|h[%s]|h", self, DEFAULT_STRINGS[self:upper()] or self:gsub("channel:", ""))
end

function CH:AddMessage(msg, ...)
	if (T.dbGlobal["chat"].timeStampFormat and T.dbGlobal["chat"].timeStampFormat ~= "NONE" ) then
		local timeStamp = BetterDate(T.dbGlobal["chat"].timeStampFormat, CH.timeOverride or time())
		timeStamp = timeStamp:gsub(" ", "")
		timeStamp = timeStamp:gsub("AM", " AM")
		timeStamp = timeStamp:gsub("PM", " PM")
		msg = "|cffB3B3B3["..timeStamp.."] |r"..msg
		CH.timeOverride = nil
	end

	self.OldAddMessage(self, msg, ...)
end

function CH:GetBNFriendColor(name, id)
	local _, _, _, _, _, _, _, class = BNGetGameAccountInfo(id)
	if(not class or class == "") then
		local toonName, toonID
		for i=1, BNGetNumFriends() do
			_, presenceName, _, _, _, toonID = BNGetFriendInfo(i)
			if(toonID and presenceName == name) then
				_, _, _, _, _, _, _, class = BNGetGameAccountInfo(toonID)
				if(class) then
					break
				end
			end
		end
	end

	if(class) then
		for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
	end

	if(not class or not RAID_CLASS_COLORS[class]) then
		return name
	end


	if RAID_CLASS_COLORS[class] then
		return "|c"..RAID_CLASS_COLORS[class].colorStr..name.."|r"
	else
		return name
	end
end


function CH:GetPluginReplacementIcon(nameRealm)
	return
end

T.NameReplacements = {}
function CH:ChatFrame_MessageEventHandler(event, ...)
	if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...
		if (arg16) then
			-- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)
			return true
		end

		local type = strsub(event, 10)
		local info = ChatTypeInfo[type]
		--Twitter link test
		--arg1 = arg1 .. " " .. "|cffffd200|Hshareachieve:51:0|h|TInterface\\ChatFrame\\UI-ChatIcon-Share:18:18|t|h|r"
		local filter = false
		if ( chatFilters[event] ) then
			local newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14
			for _, filterFunc in next, chatFilters[event] do
				filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 = filterFunc(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
				if ( filter ) then
					return true
				elseif ( newarg1 ) then
					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14
				end
			end
		end

		arg2 = T.NameReplacements[arg2] or arg2

		--Check if arg12 is a valid GUID (sometimes it gets stored as hexadecimal in ElvUI chat history)
		local success, _, englishClass, _, _, _, name, realm = pcall(GetPlayerInfoByGUID, arg12)
		local coloredName = GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, (success and arg12 or nil), arg13, arg14)

		local channelLength = strlen(arg4)
		local infoType = type
		if ( (strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and ((arg1 ~= "INVITE") or (type ~= "CHANNEL_NOTICE_USER")) ) then
			if ( arg1 == "WRONG_PASSWORD" ) then
				local staticPopup = _G[StaticPopup_Visible("CHAT_CHANNEL_PASSWORD") or ""]
				if ( staticPopup and strupper(staticPopup.data) == strupper(arg9) ) then
					-- Don't display invalid password messages if we're going to prompt for a password (bug 102312)
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
		if ( chatGroup == "CHANNEL" or chatGroup == "BN_CONVERSATION" ) then
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
				and ( (chatGroup == "WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") or (chatGroup == "BN_WHISPER" and GetCVar("bnWhisperMode") ~= "popout_and_inline") ) ) then
				return true
			end
		elseif ( chatGroup == "BN_CONVERSATION" ) then
			if ( self.bnConversationList and not self.bnConversationList[arg8] ) then
				return true
			elseif ( self.excludeBNConversationList and self.excludeBNConversationList[arg8] and GetCVar("conversationMode") ~= "popout_and_inline") then
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
					local playerNotFoundMsg = strlower(format(ERR_CHAT_PLAYER_NOT_FOUND_S, playerName))
					local charOnlineMsg = strlower(format(ERR_FRIEND_ONLINE_SS, playerName, playerName))
					local charOfflineMsg = strlower(format(ERR_FRIEND_OFFLINE_S, playerName))
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
			self:AddMessage(arg1, info.r, info.g, info.b, info.id)
		elseif (type == "LOOT") then
			-- Append [Share] hyperlink if this is a valid social item and you are the looter.
			-- arg5 contains the name of the player who looted
			if (C_Social.IsSocialEnabled() and UnitName("player") == arg5) then
				local itemID, creationContext = GetItemInfoFromHyperlink(arg1)
				if (itemID and C_SocialGetLastItem() == itemID) then
					arg1 = arg1 .. " " .. Social_GetShareItemLink(itemID, creationContext, true)
				end
			end
			self:AddMessage(arg1, info.r, info.g, info.b, info.id)
		elseif ( strsub(type,1,7) == "COMBAT_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id)
		elseif ( strsub(type,1,6) == "SPELL_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id)
		elseif ( strsub(type,1,10) == "BG_SYSTEM_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id)
		elseif ( strsub(type,1,11) == "ACHIEVEMENT" ) then
			-- Append [Share] hyperlink
			if (arg12 == UnitGUID("player") and C_Social.IsSocialEnabled()) then
				local achieveID = GetAchievementInfoFromHyperlink(arg1)
				if (achieveID) then
					arg1 = arg1 .. " " .. Social_GetShareAchievementLink(achieveID, true)
				end
			end
			self:AddMessage(format(arg1, "|Hplayer:"..arg2.."|h".."["..coloredName.."]".."|h"), info.r, info.g, info.b, info.id)
		elseif ( strsub(type,1,18) == "GUILD_ACHIEVEMENT" ) then
			local message = format(arg1, "|Hplayer:"..arg2.."|h".."["..coloredName.."]".."|h")
			if (C_Social.IsSocialEnabled()) then
				local achieveID = GetAchievementInfoFromHyperlink(arg1)
				if (achieveID) then
					message = message .. " " .. Social_GetShareAchievementLink(achieveID, true)
				end
			end
			self:AddMessage(message, info.r, info.g, info.b, info.id)
		elseif ( type == "IGNORED" ) then
			self:AddMessage(format(Var.CHAT_IGNORED, arg2), info.r, info.g, info.b, info.id)
		elseif ( type == "FILTERED" ) then
			self:AddMessage(format(Var.CHAT_FILTERED, arg2), info.r, info.g, info.b, info.id)
		elseif ( type == "RESTRICTED" ) then
			self:AddMessage(Var.CHAT_RESTRICTED_TRIAL, info.r, info.g, info.b, info.id)
		elseif ( type == "CHANNEL_LIST") then
			if(channelLength > 0) then
				self:AddMessage(format(_G["CHAT_"..type.."_GET"]..arg1, tonumber(arg8), arg4), info.r, info.g, info.b, info.id)
			else
				self:AddMessage(arg1, info.r, info.g, info.b, info.id)
			end
		elseif (type == "CHANNEL_NOTICE_USER") then
			local globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"]
			if ( not globalstring ) then
				globalstring = _G["CHAT_"..arg1.."_NOTICE"]
			end

			if(strlen(arg5) > 0) then
				-- TWO users in this notice (E.G. x kicked y)
				self:AddMessage(format(globalstring, arg8, arg4, arg2, arg5), info.r, info.g, info.b, info.id)
			elseif ( arg1 == "INVITE" ) then
				self:AddMessage(format(globalstring, arg4, arg2), info.r, info.g, info.b, info.id)
			else
				self:AddMessage(format(globalstring, arg8, arg4, arg2), info.r, info.g, info.b, info.id)
			end
			if ( arg1 == "INVITE" and GetCVarBool("blockChannelInvites") ) then
				self:AddMessage(Var.CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE, info.r, info.g, info.b, info.id)
			end
		elseif (type == "CHANNEL_NOTICE") then
			local globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"]
			if( arg1 == "TRIAL_RESTRICTED" ) then
				globalstring = Var.CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL
			else
				if ( not globalstring ) then
					globalstring = _G["CHAT_"..arg1.."_NOTICE"]
				end
			end
			local accessID = ChatHistory_GetAccessID(Chat_GetChatCategory(type), arg8)
			local typeID = ChatHistory_GetAccessID(infoType, arg8, arg12)
			self:AddMessage(format(globalstring, arg8, arg4), info.r, info.g, info.b, info.id, false, accessID, typeID)
		elseif ( type == "BN_INLINE_TOAST_ALERT" ) then
			local globalstring = _G["BN_INLINE_TOAST_"..arg1]
			local message
			if ( arg1 == "FRIEND_REQUEST" ) then
				message = globalstring
			elseif ( arg1 == "FRIEND_PENDING" ) then
				message = format(Var.BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites())
			elseif ( arg1 == "FRIEND_REMOVED" or arg1 == "BATTLETAG_FRIEND_REMOVED" ) then
				message = format(globalstring, arg2)
			elseif ( arg1 == "FRIEND_ONLINE" or arg1 == "FRIEND_OFFLINE" ) then
				local _, accountName, battleTag, _, characterName, _, client = BNGetFriendInfoByID(arg13)
				if (client and client ~= "") then
					local _, _, battleTag = BNGetFriendInfoByID(arg13)
					characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client) or ""
					local characterNameText = BNet_GetClientEmbeddedTexture(client, 14)..characterName
					local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s] (%s)|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2, characterNameText)
					message = format(globalstring, playerLink)
				else
					local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2)
					message = format(globalstring, playerLink)
				end
			else
				local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2)
				message = format(globalstring, playerLink)
			end
			self:AddMessage(message, info.r, info.g, info.b, info.id)
		elseif ( type == "BN_INLINE_TOAST_BROADCAST" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveExtraSpaces(arg1)
				arg1 = RemoveNewlines(arg1)
				local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2)
				self:AddMessage(format(Var.BN_INLINE_TOAST_BROADCAST, playerLink, arg1), info.r, info.g, info.b, info.id)
			end
		elseif ( type == "BN_INLINE_TOAST_BROADCAST_INFORM" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveExtraSpaces(arg1)
				self:AddMessage(Var.BN_INLINE_TOAST_BROADCAST_INFORM, info.r, info.g, info.b, info.id)
			end
		else
			local body

			local _, fontHeight = FCF_GetChatWindowInfo(self:GetID())

			if ( fontHeight == 0 ) then
				--fontHeight will be 0 if it's still at the default (14)
				fontHeight = 14
			end

			-- Add AFK/DND flags
			local pflag = ""
			local pluginIcon = ""
			if(strlen(arg6) > 0) then
				if ( arg6 == "GM" ) then
					--If it was a whisper, dispatch it to the GMChat addon.
					if ( type == "WHISPER" ) then
						return
					end
					--Add Blizzard Icon, this was sent by a GM
					pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t "
				elseif ( arg6 == "DEV" ) then
					--Add Blizzard Icon, this was sent by a Dev
					pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t "
				elseif ( arg6 == "DND" or arg6 == "AFK") then
					pflag = (pflag or pluginIcon or "").._G["CHAT_FLAG_"..arg6]
				else
					pflag = _G["CHAT_FLAG_"..arg6]
				end
			else
				if not pflag and pluginIcon then
					pflag = pluginIcon
				end

				if(pflag == true) then
					pflag = ""
				end

				if(lfgRoles[arg2] and (type == "PARTY_LEADER" or type == "PARTY" or type == "RAID" or type == "RAID_LEADER" or type == "INSTANCE_CHAT" or type == "INSTANCE_CHAT_LEADER")) then
					pflag = lfgRoles[arg2]..(pflag or "")
				end
			end

			pflag = pflag or ""

			if ( type == "WHISPER_INFORM" and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) ) then
				return
			end

			local showLink = 1
			if ( strsub(type, 1, 7) == "MONSTER" or strsub(type, 1, 9) == "RAID_BOSS") then
				showLink = nil
			else
				arg1 = gsub(arg1, "%%", "%%%%")
			end

			-- Search for icon links and replace them with texture links.
			for tag in gmatch(arg1, "%b{}") do
				local term = strlower(gsub(tag, "[{}]", ""))
				-- If arg17 is true, don't convert to raid icons
				if ( not arg17 and ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
					arg1 = gsub(arg1, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t")
				elseif ( GROUP_TAG_LIST[term] ) then
					local groupIndex = GROUP_TAG_LIST[term]
					local groupList = "["
					for i=1, GetNumGroupMembers() do
						local name, rank, subgroup, level, class, classFileName = GetRaidRosterInfo(i)
						if ( name and subgroup == groupIndex ) then
							local classColorTable = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classFileName] or RAID_CLASS_COLORS[classFileName]
							if ( classColorTable ) then
								name = format("\124cff%.2x%.2x%.2x%s\124r", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255, name)
							end
							groupList = groupList..(groupList == "[" and "" or Var.PLAYER_LIST_DELIMITER)..name
						end
					end
					groupList = groupList.."]"
					arg1 = gsub(arg1, tag, groupList)
				end
			end

			--Remove groups of many spaces
			arg1 = RemoveExtraSpaces(arg1)

			local playerLink

			if ( type ~= "BN_WHISPER" and type ~= "BN_WHISPER_INFORM" ) then --Use this when 6.2.4 goes live
				playerLink = "|Hplayer:"..arg2..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h"
			else
				coloredName = CH:GetBNFriendColor(arg2, arg13)
				playerLink = "|HBNplayer:"..arg2..":"..arg13..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h"
			end

			local message = arg1
			if ( arg14 ) then	--isMobile
				message = ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)..message
			end

			local relevantDefaultLanguage = self.defaultLanguage
			if ( (type == "SAY") or (type == "YELL") ) then
				relevantDefaultLanguage = self.alternativeDefaultLanguage
			end
			if ( (strlen(arg3) > 0) and (arg3 ~= relevantDefaultLanguage) ) then
				local languageHeader = "["..arg3.."] "
				if ( showLink and (strlen(arg2) > 0) ) then
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..playerLink.."["..coloredName.."]".."|h")
				else
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..arg2)
				end
			else
				if ( not showLink or strlen(arg2) == 0 ) then
					if ( type == "TEXT_EMOTE" ) then
						body = message
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..arg2, arg2)
					end
				else
					if ( type == "EMOTE" ) then
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink..coloredName.."|h")
					elseif ( type == "TEXT_EMOTE") then
						body = gsub(message, arg2, pflag..playerLink..coloredName.."|h", 1)
					elseif (type == "GUILD_ITEM_LOOTED") then
						body = gsub(message, "$s", "|Hplayer:"..arg2.."|h".."["..coloredName.."]".."|h")
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink.."["..coloredName.."]".."|h")
					end
				end
			end

			-- Add Channel
			arg4 = gsub(arg4, "%s%-%s.*", "")
			if(channelLength > 0) then
				body = "|Hchannel:channel:"..arg8.."|h["..arg4.."]|h "..body
			end

			local accessID = ChatHistory_GetAccessID(chatGroup, chatTarget)
			local typeID = ChatHistory_GetAccessID(infoType, chatTarget, arg12 or arg13)
			if CH.db.shortChannels and type ~= "EMOTE" and type ~= "TEXT_EMOTE" then
				body = body:gsub("|Hchannel:(.-)|h%[(.-)%]|h", CH.ShortChannel)
				body = body:gsub('CHANNEL:', '')
				body = body:gsub("^(.-|h) "..L["whispers"], "%1")
				body = body:gsub("^(.-|h) "..L["says"], "%1")
				body = body:gsub("^(.-|h) "..L["yells"], "%1")
				body = body:gsub("<"..Var.AFK..">", "[|cffFF0000"..L["AFK"].."|r] ")
				body = body:gsub("<"..Var.DND..">", "[|cffE7E716"..L["DND"].."|r] ")
				body = body:gsub("%[BN_CONVERSATION:", '%[1'.."")
				body = body:gsub("^%["..Var.RAID_WARNING.."%]", '['..L["RW"]..']')
			end
			self:AddMessage(body, info.r, info.g, info.b, info.id, false, accessID, typeID)
		end

		if ( type == "WHISPER" or type == "BN_WHISPER" ) then
			--BN_WHISPER FIXME
			ChatEdit_SetLastTellTarget(arg2, type)
			if ( self.tellTimer and (GetTime() > self.tellTimer) ) then
				PlaySound("TellMessage")
			end
			self.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME
			--FCF_FlashTab(self)
		end

		if ( not self:IsShown() ) then
			if ( (self == DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or (self ~= DEFAULT_CHAT_FRAME and info.flashTab) ) then
				if ( not CHAT_OPTIONS.HIDE_FRAME_ALERTS or type == "WHISPER" or type == "BN_WHISPER" ) then	--BN_WHISPER FIXME
					if (not (type == "BN_CONVERSATION" and BNIsSelf(arg13))) then
						if (not FCFManager_ShouldSuppressMessageFlash(self, chatGroup, chatTarget) ) then
							--FCF_StartAlertFlash(self) THIS TAINTS<<<<<<<
							_G[self:GetName().."Tab"].glow:Show()
							_G[self:GetName().."Tab"]:SetScript("OnUpdate", CH.ChatTab_OnUpdate)
						end
					end
				end
			end
		end

		return true
	end
end

function CH:ChatTab_OnUpdate(elapsed)
	if self.glow:IsShown() then
		T:Flash(self.glow, 1)
	else
		T:StopFlash(self.glow)
		self:SetScript("OnUpdate", nil)
	end
end

function CH:ChatFrame_OnEvent(event, ...)
	if ( ChatFrame_ConfigEventHandler(self, event, ...) ) then
		return
	end
	if ( ChatFrame_SystemEventHandler(self, event, ...) ) then
		return
	end
	if ( CH.ChatFrame_MessageEventHandler(self, event, ...) ) then
		return
	end
end

function CH:FloatingChatFrame_OnEvent(event, ...)
	CH.ChatFrame_OnEvent(self, event, ...)
	FloatingChatFrame_OnEvent(self, event, ...)
end

function CH:SetupChat(event, ...)
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		local id = frame:GetID()

		self:StyleChat(frame)

		FCFTab_UpdateAlpha(frame)

		local _, fontSize = FCF_GetChatWindowInfo(id)
		frame:SetFont(T["media"].font, fontSize, "THINOUTLINE")--select(3, frame:GetFont()))--) --fontSize
		frame:SetShadowOffset(-0.75, 0.75)
		frame:SetShadowColor(0, 0, 0, 0.2)

		frame:SetTimeVisible(100)
		frame:SetFading(false) --self.db.fade)

		if not frame.scriptsSet then
			frame:SetScript("OnHyperlinkClick", URLChatFrame_OnHyperlinkShow)
			frame:SetScript("OnMouseWheel", ChatFrame_OnMouseScroll)

			if id > NUM_CHAT_WINDOWS then
				frame:SetScript("OnEvent", CH.FloatingChatFrame_OnEvent)
			elseif id ~= 2 then
				frame:SetScript("OnEvent", CH.ChatFrame_OnEvent)
			end

			hooksecurefunc(frame, "SetScript", function(f, script, func)
				if script == "OnMouseWheel" and func ~= ChatFrame_OnMouseScroll then
					f:SetScript(script, ChatFrame_OnMouseScroll)
				end
			end)
			frame.scriptsSet = true
		end

		if not _G[frameName.."Tab"].glow.anim then
			T:SetUpAnimGroup(_G[frameName.."Tab"].glow)
		end
	end

--	if self.db.hyperlinkHover then
		self:EnableHyperlink()
--	end

--	GeneralDockManager:SetParent(LeftChatPanel)
	self:ScheduleRepeatingTimer("PositionChat", 1)
	self:PositionChat(true)

	if not self.HookSecured then
		self:SecureHook("FCF_OpenTemporaryWindow", "SetupChat")
		self.HookSecured = true
	end
end

local function PrepareMessage(author, message)
	return author:upper() .. message
end

function CH:ChatThrottleHandler(event, ...)
	local arg1, arg2 = ...

	if arg2 ~= "" then
		local message = PrepareMessage(arg2, arg1)
		if msgList[message] == nil then
			msgList[message] = true
			msgCount[message] = 1
			msgTime[message] = time()
		else
			msgCount[message] = msgCount[message] + 1
		end
	end
end

local locale = GetLocale()
function CH:CHAT_MSG_CHANNEL(event, message, author, ...)
	local blockFlag = false
	local msg = PrepareMessage(author, message)

	-- ignore player messages
	if author == PLAYER_NAME then return CH.FindURL(self, event, message, author, ...) end
	if msgList[msg] and T.dbGlobal["chat"].throttleInterval ~= 0 then
		if difftime(time(), msgTime[msg]) <= T.dbGlobal["chat"].throttleInterval then
			blockFlag = true
		end
	end

	if blockFlag then
		return true
	else
		if T.dbGlobal["chat"].throttleInterval ~= 0 then
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
	if msgList[msg] and msgCount[msg] > 1 and T.dbGlobal["chat"].throttleInterval ~= 0 then
		if difftime(time(), msgTime[msg]) <= T.dbGlobal["chat"].throttleInterval then
			blockFlag = true
		end
	end

	if blockFlag then
		return true
	else
		if T.dbGlobal["chat"].throttleInterval ~= 0 then
			msgTime[msg] = time()
		end

		return CH.FindURL(self, event, message, author, ...)
	end
end

function CH:CHAT_MSG_SAY(event, message, author, ...)
	return CH.FindURL(self, event, message, author, ...)
end

function CH:ThrottleSound()
	self.SoundPlayed = nil
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
	local type = editBox:GetAttribute("chatType")
	local chatFrame = editBox:GetParent()
	if not chatFrame.isTemporary and ChatTypeInfo[type].sticky == 1 then
		if not T.dbGlobal["chat"].sticky then type = "SAY" end
		editBox:SetAttribute("chatType", type)
	end
end

function CH:SetChatFont(dropDown, frame, fontSize)
	if ( not frame ) then
		frame = FCF_GetCurrentChatFrame()
	end
	if ( not fontSize ) then
		fontSize = dropDown.value
	end

--	local _, fontSize = FCF_GetChatWindowInfo(id)
	frame:SetFont(T["media"].font, fontSize, "THINOUTLINE")--select(3, frame:GetFont())) --fontSize
	frame:SetShadowOffset(-0.75, 0.75)
	frame:SetShadowColor(0, 0, 0, 0.2)
end

function CH:ChatEdit_AddHistory(editBox, line)
	if line:find("/rl") then return end

	if ( strlen(line) > 0 ) then
		for i, text in pairs(self.db.ChatEditHistory) do
			if text == line then
				return
			end
		end

		tinsert(self.db.ChatEditHistory, #self.db.ChatEditHistory + 1, line)
		if #self.db.ChatEditHistory > 5 then
			tremove(self.db.ChatEditHistory, 1)
		end
	end
end

function CH:PET_BATTLE_CLOSE()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		if frame and _G[frameName.."Tab"]:GetText():match(PET_BATTLE_COMBAT_LOG) then
			FCF_Close(frame)
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
	local temp, data = {}
	for id, _ in pairs(self.db.ChatLog) do
		tinsert(temp, tonumber(id))
	end

	tsort(temp, function(a, b)
		return a < b
	end)

	for i = 1, #temp do
		data = self.db.ChatLog[tostring(temp[i])]

		if type(data) == "table" and data[20] ~= nil then
			CH.timeOverride = temp[i]
			CH.ChatFrame_MessageEventHandler(DEFAULT_CHAT_FRAME, data[20], unpack(data))
		end
	end
end

local function GetTimeForSavedMessage()
	local randomTime = select(2, ("."):split(GetTime() or "0."..random(1, 999), 2)) or 0
	return time().."."..randomTime
end

function CH:SaveChatHistory(event, ...)
	if self.db.throttleInterval ~= 0 and (event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL" or event == "CHAT_MSG_CHANNEL") then
		self:ChatThrottleHandler(event, ...)

		local message, author = ...
		local msg = PrepareMessage(author, message)
		if author ~= PLAYER_NAME and msgList[msg] then
			if difftime(time(), msgTime[msg]) <= T.dbGlobal["chat"].throttleInterval then
				return
			end
		end
	end

	local temp = {}
	for i = 1, select("#", ...) do
		temp[i] = select(i, ...) or false
	end

	if #temp > 0 then
	  temp[20] = event
	  local timeForMessage = GetTimeForSavedMessage()
	  self.db.ChatLog[timeForMessage] = temp

		local c, k = 0
		for id, data in pairs(self.db.ChatLog) do
			c = c + 1
			if (not k) or k > id then
				k = id
			end
		end

		if c > 128 then
			self.db.ChatLog[k] = nil
		end
	end
end

function CH:ChatFrame_AddMessageEventFilter (event, filter)
	assert(event and filter)

	if ( chatFilters[event] ) then
		-- Only allow a filter to be added once
		for index, filterFunc in next, chatFilters[event] do
			if ( filterFunc == filter ) then
				return
			end
		end
	else
		chatFilters[event] = {}
	end

	tinsert(chatFilters[event], filter)
end

function CH:ChatFrame_RemoveMessageEventFilter (event, filter)
	assert(event and filter)

	if ( chatFilters[event] ) then
		for index, filterFunc in next, chatFilters[event] do
			if ( filterFunc == filter ) then
				tremove(chatFilters[event], index)
			end
		end

		if ( #chatFilters[event] == 0 ) then
			chatFilters[event] = nil
		end
	end
end

function CH:FCF_SetWindowAlpha(frame, alpha, doNotSave)
	frame.oldAlpha = alpha or 1
end

do
	local stopScript = false

	hooksecurefunc(DEFAULT_CHAT_FRAME, "RegisterEvent", function(self, event)
		if event == "GUILD_MOTD" and not stopScript then
			self:UnregisterEvent("GUILD_MOTD")
		end
	end)

	local cachedMsg = GetGuildRosterMOTD()

	if cachedMsg == "" then
		cachedMsg = nil
	end

	function CH:DelayGMOTD()
		stopScript = true
		DEFAULT_CHAT_FRAME:RegisterEvent("GUILD_MOTD")

		local msg = cachedMsg or GetGuildRosterMOTD()
		if msg == "" then msg = nil end

		if msg then
			ChatFrame_SystemEventHandler(DEFAULT_CHAT_FRAME, "GUILD_MOTD", msg)
		end

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end

function CH:CheckLFGRoles()
	local isInGroup, isInRaid = IsInGroup(), IsInRaid()
	local unit = isInRaid and "raid" or "party"
	local name, realm
	twipe(lfgRoles)
	if(not isInGroup or not self.db.lfgIcons) then return end

	local role = UnitGroupRolesAssigned("player")
	if(role) then
		lfgRoles[PLAYER_NAME] = rolePaths[role]
	end

	for i=1, GetNumGroupMembers() do
		if(UnitExists(unit..i) and not UnitIsUnit(unit..i, "player")) then
			role = UnitGroupRolesAssigned(unit..i)
			name, realm = UnitName(unit..i)

			if(role and name) then
				name = realm and name.."-"..realm or name.."-"..T.playerRealm
				lfgRoles[name] = rolePaths[role]
			end
		end
	end
end




CH.PositionChat = function(self, override)
	if ((InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then return end

	for i = 1, CreatedFrames do
		local BASE_OFFSET = 60
		chat = _G[format("ChatFrame%d", i)]
		chatbg = format("ChatFrame%dBackground", i)
		button = _G[format("ButtonCF%d", i)]
		id = chat:GetID()
		tab = _G[format("ChatFrame%sTab", i)]
		point = GetChatWindowSavedPosition(id)
		isDocked = chat.isDocked
		tab.isDocked = chat.isDocked

		if id > NUM_CHAT_WINDOWS then
			point = point or select(1, chat:GetPoint())
			if select(2, tab:GetPoint()):GetName() ~= bg then
				isDocked = true
			else
				isDocked = false
			end
		end

		if (id ~= 2 and not (id > NUM_CHAT_WINDOWS)) then
			chat:ClearAllPoints()
			chat:Point("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 5, 5)
			chat:Size(450, 180)
			FCF_SavePositionAndDimensions(chat)
		end

		tab:SetParent(UIParent)
		chat:SetParent(UIParent)

		CH:SetupChatTabs(tab, true)

	end

	self.initialMove = true
end

CH.OnInitialize = function(self)
	self.db = T.dbChar

	self.db.ChatEditHistory = self.db.ChatEditHistory or {}
	self.db.ChatLog = self.db.ChatLog or {}
end

CH.OnEnable = function(self)
	self:UpdateFading()

	self:SecureHook("ChatEdit_OnEnterPressed")

	QuickJoinToastButton:Kill()
	ChatFrameMenuButton:Kill()

    if WIM then
      WIM.RegisterWidgetTrigger("chat_display", "whisper,chat,w2w,demo", "OnHyperlinkClick", function(self) CH.clickedframe = self end)
	  WIM.RegisterItemRefHandler("url", WIM_URLLink)
    end

	self:SecureHook("FCF_SetChatWindowFontSize", "SetChatFont")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "DelayGMOTD")
	self:RegisterEvent("UPDATE_CHAT_WINDOWS", "SetupChat")
	self:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS", "SetupChat")
	self:RegisterEvent("PET_BATTLE_CLOSE")

	self:SetupChat()
	self:PositionChat(true)

	self:RegisterEvent("GROUP_ROSTER_UPDATE", "CheckLFGRoles")

	self:RegisterEvent("CHAT_MSG_INSTANCE_CHAT", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_CHANNEL", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_EMOTE", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_GUILD", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_OFFICER", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_PARTY", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_PARTY_LEADER", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_RAID", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_RAID_LEADER", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_RAID_WARNING", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_SAY", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_WHISPER", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM", "SaveChatHistory")
	self:RegisterEvent("CHAT_MSG_YELL", "SaveChatHistory")

	--First get all pre-existing filters and copy them to our version of chatFilters using ChatFrame_GetMessageEventFilters
	for name, _ in pairs(ChatTypeGroup) do
		for i=1, #ChatTypeGroup[name] do
			local filterFuncTable = ChatFrame_GetMessageEventFilters(ChatTypeGroup[name][i])
			if filterFuncTable then
				chatFilters[ChatTypeGroup[name][i]] = {}

				for j=1, #filterFuncTable do
					local filterFunc = filterFuncTable[j]
					tinsert(chatFilters[ChatTypeGroup[name][i]], filterFunc)
				end
			end
		end
	end

	--CHAT_MSG_CHANNEL isn"t located inside ChatTypeGroup
	local filterFuncTable = ChatFrame_GetMessageEventFilters("CHAT_MSG_CHANNEL")
	if filterFuncTable then
		chatFilters["CHAT_MSG_CHANNEL"] = {}

		for j=1, #filterFuncTable do
			local filterFunc = filterFuncTable[j]
			tinsert(chatFilters["CHAT_MSG_CHANNEL"], filterFunc)
		end
	end

	--Now hook onto Blizzards functions for other addons
	self:SecureHook("ChatFrame_AddMessageEventFilter")
	self:SecureHook("ChatFrame_RemoveMessageEventFilter")
	self:SecureHook("FCF_SetWindowAlpha")

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", CH.CHAT_MSG_CHANNEL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", CH.CHAT_MSG_YELL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", CH.CHAT_MSG_SAY)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", CH.FindURL)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", CH.FindURL)

	local frame = CreateFrame("Frame", "CopyChatFrame", T.UIParent)
	tinsert(UISpecialFrames, "CopyChatFrame")
	frame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		edgeSize = 16, tileSize = 16, tile = true,
		insets = { left = 3, right = 3, top = 5, bottom = 3 }
	})
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:Size(700, 150)
	frame:Point('BOTTOM', T.UIParent, 'BOTTOM', 0, 3)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetResizable(true)
	frame:SetMinResize(350, 100)

	frame:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and not self.isMoving then
			self:StartMoving();
			self.isMoving = true;
		elseif button == "RightButton" and not self.isSizing then
			self:StartSizing();
			self.isSizing = true;
		end
	end)

	frame:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.isMoving then
			self:StopMovingOrSizing();
			self.isMoving = false;
		elseif button == "RightButton" and self.isSizing then
			self:StopMovingOrSizing();
			self.isSizing = false;
		end
	end)

	frame:SetScript("OnHide", function(self)
		if ( self.isMoving or self.isSizing) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			self.isSizing = false;
		end
	end)

	frame:SetFrameStrata("DIALOG")
	frame:Hide()

	local scrollArea = CreateFrame("ScrollFrame", "CopyChatScrollFrame", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
	scrollArea:SetScript("OnSizeChanged", function(self)
		CopyChatFrameEditBox:Width(self:GetWidth())
		CopyChatFrameEditBox:Height(self:GetHeight())
	end)

	local editBox = CreateFrame("EditBox", "CopyChatFrameEditBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:Width(scrollArea:GetWidth())
	editBox:Height(200)
	editBox:SetScript("OnEscapePressed", function() CopyChatFrame:Hide() end)
	scrollArea:SetScrollChild(editBox)
	CopyChatFrameEditBox:SetScript("OnTextChanged", function(self, userInput)
		if userInput then return end
		local _, max = CopyChatScrollFrameScrollBar:GetMinMaxValues()
		for i=1, max do
			ScrollFrameTemplate_OnMouseWheel(CopyChatScrollFrame, -1)
		end
	end)

	--Disable Blizzard
	InterfaceOptionsSocialPanelTimestampsButton:SetAlpha(0)
	InterfaceOptionsSocialPanelTimestampsButton:SetScale(0.000001)
	InterfaceOptionsSocialPanelTimestamps:SetAlpha(0)
	InterfaceOptionsSocialPanelTimestamps:SetScale(0.000001)

	InterfaceOptionsSocialPanelChatStyle:EnableMouse(false)
	InterfaceOptionsSocialPanelChatStyleButton:Hide()
	InterfaceOptionsSocialPanelChatStyle:SetAlpha(0)

	if (self.db.ChatLog) then
		self:DisplayChatHistory()
	end
end

--[[


--]]
local DraeUI = select(2, ...)

local Chat = DraeUI:NewModule("Chat", "AceEvent-3.0")

-- Localise a bunch of functions
local UIParent, ChatTypeInfo = UIParent, ChatTypeInfo
local tsort, wipe, random, smatch = table.sort, table.wipe, math.random, string.match
local CHAT_FRAMES, CHAT_FONT_HEIGHTS = CHAT_FRAMES, CHAT_FONT_HEIGHTS
local InCombatLockdown, PlaySoundFile, ShowUIPanel = InCombatLockdown, PlaySoundFile, ShowUIPanel
local GameTooltip, BattlePetTooltip = GameTooltip, BattlePetTooltip

--
local ChatEditOnEnterKey, OnHyperlinkEnter, OnHyperlinkLeave

--[[
	Startup
--]]

Chat.OnInitialize = function(self)
	self.db = DraeUI.db
	self.dbChar = DraeUI.dbChar
	self.dbChar.chatHistory = self.dbChar.chatHistory or {}

	self.media = DraeUI.media

	self:RegisterEvent("UPDATE_CHAT_WINDOWS", "RefreshChatFrames")
end

Chat.OnEnable = function(self)
	self:RefreshChatFrames()

	_G.ChatFrameMenuButton:Kill()
	self:HandleChatVoiceIcons()

	if (self.db.chat.saveHistory) then
		self:EnableChatHistory()
		self:RegisterEvent("CHAT_MSG_WHISPER")
		self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	end

	hooksecurefunc("ChatEdit_OnEnterPressed", ChatEditOnEnterKey)

    self:StickChannel("SAY", true)
    self:StickChannel("WHISPER", true)
    self:StickChannel("PARTY", true)
    self:StickChannel("GUILD", true)
    self:StickChannel("OFFICER", true)
    self:StickChannel("RAID", true)
    self:StickChannel("INSTANCE_CHAT", true)
    self:StickChannel("CHANNEL", true)

	for i in ipairs(CHAT_FRAMES) do
		local frame = _G["ChatFrame" .. i]

--		hooksecurefunc("OnHyperlinkEnter", OnHyperlinkEnter)
--		hooksecurefunc("OnHyperlinkLeave", OnHyperlinkLeave)

		if (self.db.chat.saveHistoryLines) then
			frame:SetMaxLines(self.db.chat.saveHistoryLines)
		end
	end
end

-- Register a pattern with the pattern matching engine
-- You can supply a priority 1 - 100. Default is 50
-- 1 = highest, 100 = lowest.
-- pattern = { pattern, matchfunc, priority, type}
--
-- Priorities arent used currently, they are to help with
-- collisions later on if there are alot of patterns
--
local PatternRegistry = { patterns = {}, sortedList = {}, sorted = true}

local RegisterPattern
do
	local function uuid()
		local template ='xyxxxxyx'

		return template:gsub('[xy]', function (c)
			local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
			return ('%x'):format(v)
		end)
	end

	RegisterPattern = function(pattern, who)
		local idx

		repeat
			idx = uuid()
		until PatternRegistry.patterns[idx] == nil

		PatternRegistry.patterns[idx] = pattern
		PatternRegistry.sortedList[#PatternRegistry.sortedList+1] = pattern
		PatternRegistry.sorted = false

		pattern.owner = who
		pattern.idx = idx

		return idx
	end
end

local function GetPattern(idx)
	return PatternRegistry.patterns[idx]
end

local RegisterMatch, MatchPatterns, ReplaceMatches
do
	local tokennum = 1

	do
		local matchTable = setmetatable({}, {
			__index = function(self, key)
				if type(rawget(self, key)) ~= "table" then
					rawset(self, key, {})
				end

				return rawget(self, key)
			end
		})

		function RegisterMatch(text, ptype)
			tokennum = tokennum + 1

			local token = "@##" .. tokennum .. "##@"

			local mt = matchTable[ptype or "FRAME"]
			mt[token] = text

			--   return text
			return token
		end
	end

	local MatchSort = function(a, b)
		local ap = a.priority or 50
		local bp = b.priority or 50

		return ap < bp
	end

	function MatchPatterns(m, ptype)
		local text = m.MESSAGE

		if type(m) == "string" then
			text = m
			m = nil
		end

		ptype = ptype or "FRAME"

		tokennum = 0

		if not PatternRegistry.sorted then
			table.sort(PatternRegistry.sortedList, MatchSort)

			PatternRegistry.sorted = true
		end

		-- Match and remove strings
		for _, v in ipairs(PatternRegistry.sortedList) do
			if text and ptype == (v.type or "FRAME") then

				if type(v.pattern) == "string" and (v.pattern):len() > 0 then
					if v.deformat then
						text = v.matchfunc(text)
					else
						if v.matchfunc ~= nil then
							text = text:gsub(v.pattern, function(...) local parms = {...} parms[#parms+1] = m return v.matchfunc(unpack(parms)) end)
						end
					end
				end
			end
		end

		return text
	end

	function ReplaceMatches(m, ptype)
		local text = m.MESSAGE
		if type(m) == "string" then
			text = m
			m = nil
		end

		-- Substitute them (or something else) back in
		local mt = MatchTable[ptype or "FRAME"]

		local k
		for t = tokennum, 1, -1 do
			k = "@##" .. tostring(t) .. "##@"

			if (mt[k]) then
				text = text:gsub(k, mt[k])
			end
			mt[k] = nil
		end

		return text
	end
end

--[[
	Hyperlink Hover
--]]
do
	local showingTooltip = false

	local linkTypes = {
		item = true,
		enchant = true,
		spell = true,
		quest = true,
		achievement = true,
		currency = true,
		battlepet = true,
	}

	OnHyperlinkEnter = function(frame, link, text)
		local t = smatch(link, "^(.-):")

		if (linkTypes[t]) then
			if (t == "battlepet") then
				showingTooltip = BattlePetTooltip
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
				_G.BattlePetToolTip_ShowLink(text)
			else
				showingTooltip = GameTooltip
				ShowUIPanel(GameTooltip)
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
				GameTooltip:SetHyperlink(link)
				GameTooltip:Show()
			end
		end
	end

	OnHyperlinkLeave = function(frame, link)
		if (showingTooltip) then
			showingTooltip:Hide()
			showingTooltip = false
		end
	end
end

--[[
	Chat frame buttons
--]]
do
	local channelButtons = {
		_G.ChatFrameChannelButton,
		_G.QuickJoinToastButton,
		_G.ChatFrameToggleVoiceDeafenButton,
		_G.ChatFrameToggleVoiceMuteButton
	}

	Chat.HandleChatFrameButtons = function(self, parent)
		for _, button in pairs(channelButtons) do
			button.Show = button.Hide
			button:SetParent(parent)
			button:Hide()
			button.SetPoint = function() end
		end
	end

	Chat.RepositionOverflowButton = function(self)
		_G.GeneralDockManagerOverflowButtonList:SetFrameStrata("LOW")
		_G.GeneralDockManagerOverflowButtonList:SetFrameLevel(5)
		_G.GeneralDockManagerOverflowButton:ClearAllPoints()
		_G.GeneralDockManagerOverflowButton:Hide()
		_G.GeneralDockManagerOverflowButton.Show = _G.GeneralDockManagerOverflowButton.Hide
--[[
		if (self.db.chat.pinVoiceButtons and not self.db.chat.hideVoiceButtons) then
			_G.GeneralDockManagerOverflowButton:SetPoint("RIGHT", channelButtons[(channelButtons[3]:IsShown() and 3) or 1], "LEFT", -4, 0)
		else
			_G.GeneralDockManagerOverflowButton:SetPoint("RIGHT", _G.GeneralDockManager, "RIGHT", -4, 0)
		end

		_G.GeneralDockManagerOverflowButton.SetPoint = function() end
]]
	end

	Chat.HandleChatVoiceIcons = function(self)
		if (self.db.chat.hideVoiceButtons) then
			for _, button in ipairs(channelButtons) do
				button:Hide()
			end
		elseif (self.db.chat.pinVoiceButtons) then
			for index, button in ipairs(channelButtons) do
				button:ClearAllPoints()

				if (index == 1) then
					button:SetPoint("BOTTOMLEFT", _G.GeneralDockManager, "TOPLEFT", -5, 20)
				else
					button:SetPoint("BOTTOMLEFT", channelButtons[index - 1], "TOPLEFT", -2, 5)
				end
			end

			channelButtons[3]:HookScript("OnShow", self.RepositionOverflowButton)
			channelButtons[3]:HookScript("OnHide", self.RepositionOverflowButton)
		else
	--		CH:CreateChatVoicePanel()
		end
	end
end

--[[
	Edit box
--]]
do
	local CreateEditbox = function(self, i)
		if (not self.frames[i]) then
			local parent = _G["ChatFrame" .. i .. "EditBox"]

			local frame = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate")
			frame:SetFrameStrata("DIALOG")
			frame:SetFrameLevel(parent:GetFrameLevel() - 1)
			frame:SetAllPoints(parent)
			frame:Hide()

			self.frames[i] = frame

			parent.lDrag = CreateFrame("Frame", nil, parent)
			parent.lDrag:SetWidth(15)
			parent.lDrag:SetPoint("TOPLEFT", parent, "TOPLEFT")
			parent.lDrag:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT")
			parent.lDrag.left = true

			parent.rDrag = CreateFrame("Frame", nil, parent)
			parent.rDrag:SetWidth(15)
			parent.rDrag:SetPoint("TOPRIGHT", parent, "TOPRIGHT")
			parent.rDrag:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")

			frame:SetBackdrop({})
		end
	end

	local AttachEditBox = function(self, attachPoint)
		for i = 1, #CHAT_FRAMES do
			local frame = _G["ChatFrame" .. i .. "EditBox"]
			local val = attachPoint or self.db.chat.editBox.attach

			frame:ClearAllPoints()

			local scrollbarWidth = frame.chatFrame.ScrollBar and frame.chatFrame.ScrollBar:GetWidth() or 0

			if (val == "TOP") then
				frame:SetPoint("BOTTOMLEFT", frame.chatFrame, "TOPLEFT", 0, 25)
				frame:SetPoint("BOTTOMRIGHT", frame.chatFrame, "TOPRIGHT", scrollbarWidth, 25)
			elseif (val == "BOTTOM") then
				frame:SetPoint("TOPLEFT", frame.chatFrame, "BOTTOMLEFT", 0, -10)
				frame:SetPoint("TOPRIGHT", frame.chatFrame, "BOTTOMRIGHT", scrollbarWidth, -10)
			end
		end
	end

	Chat.RefreshChatFrames = function(self)
		self.frames = {}

		for i, name in ipairs(CHAT_FRAMES) do
			-- ChatFrame
			local chat = _G[name]
			local chatName = chat:GetName()
			local chatID = chat:GetID()

			chat:SetFrameLevel(10)
			chat:SetClampRectInsets(0, 0, 0, 0)
			chat:SetClampedToScreen(false)
			chat:SetMovable(true)
			chat:SetUserPlaced(true)

			-- Is this chat frame the primary window in the chat dock manager?
			-- If so then reparent the dock manager and the associated buttons
			local docker = _G.GeneralDockManager.primary
			if (chat == docker) then
				_G.GeneralDockManager:SetParent(UIParent)

				self:HandleChatFrameButtons(UIParent)
			end

			-- Editbox
			local editBoxName = chatName.."EditBox"
			local editBox = _G[editBoxName]
			local editBoxHeader = _G[editBoxName .. "Header"]

			editBox:Hide()

			CreateEditbox(self, i)
			self.frames[i]:Show()

			-- Tabs
			local tabName = chatName.."Tab"
			local tabText = _G[tabName].Text
			local tab = _G[tabName]
			tab:StripTextures()

			-- Button Frame
			local btnFrame = _G[chatName .. "ButtonFrame"]
			local btnFrameBg = _G[chatName .. "ButtonFrameBackground"]
			btnFrame:StripTextures()

			-- Set Fonts
			chat:SetSpacing(4)
			chat:SetFont(self.media.font, 12.5, "THINOUTLINE")

			editBox:SetFont(self.media.font, 12.5, "THINOUTLINE")
			editBoxHeader:SetFont(self.media.font, 12.5, "THINOUTLINE")

			tabText:SetFont(self.media.fontSmall, 11.5, "THINOUTLINE")
		end

		AttachEditBox(self)
	end
end

--[[
	Sticky Channels
--]]
Chat.StickChannel  = function(self, channel, stickied)
	local cti = ChatTypeInfo[channel:upper()]

	if (cti) then
		cti.sticky = stickied and 1 or 0
	end
end

ChatEditOnEnterKey = function(self, input)
	local ctype = self:GetAttribute("chatType")
	local attr = (not DraeUI.db.chat.stickyEdit) and "SAY" or ctype
	local chat = self:GetParent()

	if (not chat.isTemporary and ChatTypeInfo[ctype].sticky) then
		self:SetAttribute("chatType", attr)
	end
end

--[[
	Chat History - currently resets between each reload so only last session is stored
--]]
do
	local MessageTimeStamp = function()
		local timestamp, current
		local actual = time()
		local estimate = GetTime()

		if (not estimate) then
			current = random(1, 999)
		else
			current = select(2, ("."):split(estimate, 2)) or 0
		end

		return ("%d.%d"):format(actual, current)
	end

	Chat.SaveChatHistory = function(self, event, ...)
		local temp_cache = {}

		for i = 1, select("#", ...) do
			temp_cache[i] = select(i, ...) or false
		end

		if (#temp_cache > 0) then
			temp_cache[20] = event
			local timestamp = MessageTimeStamp()
			local lineNum, lineID = 0

			self.dbChar.chatHistory[timestamp] = temp_cache

			for id, data in pairs(self.dbChar.chatHistory) do
				lineNum = lineNum + 1
				if ((not lineID) or lineID > id) then
					lineID = id
				end
			end

			if (lineNum > 128) then
				self.dbChar.chatHistory[lineID] = nil
			end
		end

		temp_cache = nil
	end

	local cache_sort = function(a, b)
		return a < b
	end

	Chat.EnableChatHistory = function(self)
		self:RegisterEvent("CHAT_MSG_CHANNEL", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_EMOTE", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_RAID_WARNING", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_SAY", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_YELL", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_WHISPER_INFORM", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_GUILD", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_OFFICER", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_PARTY", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_PARTY_LEADER", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_RAID", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_RAID_LEADER", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_INSTANCE_CHAT", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER", "SaveChatHistory")
		self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM", "SaveChatHistory")

		local temp_cache, data_cache = {}
		local count = 1

		for id, _ in pairs(self.dbChar.chatHistory) do
			temp_cache[count] = tonumber(id)
			count = count + 1
		end

		tsort(temp_cache, cache_sort)

		for i = 1, #temp_cache do
			local lineID = tostring(temp_cache[i])
			data_cache = self.dbChar.chatHistory[lineID]

			if (data_cache) then
				local GUID = data_cache[12]

				if ((type(data_cache) == "table") and data_cache[20] ~= nil and (GUID and type(GUID) == "string")) then
					if (not GUID:find("Player-")) then
						self.dbChar.chatHistory[lineID] = nil
					else
						_G.ChatFrame_MessageEventHandler(DEFAULT_CHAT_FRAME, data_cache[20], unpack(data_cache))
					end
				end
			end
		end

		temp_cache = nil
		data_cache = nil
		wipe(self.dbChar.chatHistory)
	end

	Chat.CHAT_MSG_WHISPER = function(self, event, ...)
		if (not InCombatLockdown() and self.media.sound1) then PlaySoundFile(self.media.sound1, self.db.chat.psst_channel or "Master") end

		if (self.db.chat.saveHistory) then
			self:SaveChatHistory(event, ...)
		end
	end
	Chat.CHAT_MSG_BN_WHISPER = Chat.CHAT_MSG_WHISPER
end

--[[
	Copy URI
--]]
do
	local Link, LinkwTLD

	local tlds = {
		ONION = true,
		-- Copied from http://data.iana.org/TLD/tlds-alpha-by-domain.txt
		--# Version 2008020401, Last Updated Tue Feb  5 09:07:01 2008 UTC
		AC = true,
		AD = true,
		AE = true,
		AERO = true,
		AF = true,
		AG = true,
		AI = true,
		AL = true,
		AM = true,
		AN = true,
		AO = true,
		AQ = true,
		AR = true,
		ARPA = true,
		AS = true,
		ASIA = true,
		AT = true,
		AU = true,
		AW = true,
		AX = true,
		AZ = true,
		BA = true,
		BB = true,
		BD = true,
		BE = true,
		BF = true,
		BG = true,
		BH = true,
		BI = true,
		BIZ = true,
		BJ = true,
		BM = true,
		BN = true,
		BO = true,
		BR = true,
		BS = true,
		BT = true,
		BV = true,
		BW = true,
		BY = true,
		BZ = true,
		CA = true,
		CAT = true,
		CC = true,
		CD = true,
		CF = true,
		CG = true,
		CH = true,
		CI = true,
		CK = true,
		CL = true,
		CM = true,
		CN = true,
		CO = true,
		COM = true,
		COOP = true,
		CR = true,
		CU = true,
		CV = true,
		CX = true,
		CY = true,
		CZ = true,
		DE = true,
		DJ = true,
		DK = true,
		DM = true,
		DO = true,
		DZ = true,
		EC = true,
		EDU = true,
		EE = true,
		EG = true,
		ER = true,
		ES = true,
		ET = true,
		EU = true,
		FI = true,
		FJ = true,
		FK = true,
		FM = true,
		FO = true,
		FR = true,
		GA = true,
		GB = true,
		GD = true,
		GE = true,
		GF = true,
		GG = true,
		GH = true,
		GI = true,
		GL = true,
		GM = true,
		GN = true,
		GOV = true,
		GP = true,
		GQ = true,
		GR = true,
		GS = true,
		GT = true,
		GU = true,
		GW = true,
		GY = true,
		HK = true,
		HM = true,
		HN = true,
		HR = true,
		HT = true,
		HU = true,
		ID = true,
		IE = true,
		IL = true,
		IM = true,
		IN = true,
		INFO = true,
		INT = true,
		IO = true,
		IQ = true,
		IR = true,
		IS = true,
		IT = true,
		JE = true,
		JM = true,
		JO = true,
		JOBS = true,
		JP = true,
		KE = true,
		KG = true,
		KH = true,
		KI = true,
		KM = true,
		KN = true,
		KP = true,
		KR = true,
		KW = true,
		KY = true,
		KZ = true,
		LA = true,
		LB = true,
		LC = true,
		LI = true,
		LK = true,
		LR = true,
		LS = true,
		LT = true,
		LU = true,
		LV = true,
		LY = true,
		MA = true,
		MC = true,
		MD = true,
		ME = true,
		MG = true,
		MH = true,
		MIL = true,
		MK = true,
		ML = true,
		MM = true,
		MN = true,
		MO = true,
		MOBI = true,
		MP = true,
		MQ = true,
		MR = true,
		MS = true,
		MT = true,
		MU = true,
		MUSEUM = true,
		MV = true,
		MW = true,
		MX = true,
		MY = true,
		MZ = true,
		NA = true,
		NAME = true,
		NC = true,
		NE = true,
		NET = true,
		NF = true,
		NG = true,
		NI = true,
		NL = true,
		NO = true,
		NP = true,
		NR = true,
		NU = true,
		NZ = true,
		OM = true,
		ORG = true,
		PA = true,
		PE = true,
		PF = true,
		PG = true,
		PH = true,
		PK = true,
		PL = true,
		PM = true,
		PN = true,
		PR = true,
		PRO = true,
		PS = true,
		PT = true,
		PW = true,
		PY = true,
		QA = true,
		RE = true,
		RO = true,
		RS = true,
		RU = true,
		RW = true,
		SA = true,
		SB = true,
		SC = true,
		SD = true,
		SE = true,
		SG = true,
		SH = true,
		SI = true,
		SJ = true,
		SK = true,
		SL = true,
		SM = true,
		SN = true,
		SO = true,
		SR = true,
		ST = true,
		SU = true,
		SV = true,
		SY = true,
		SZ = true,
		TC = true,
		TD = true,
		TEL = true,
		TF = true,
		TG = true,
		TH = true,
		TJ = true,
		TK = true,
		TL = true,
		TM = true,
		TN = true,
		TO = true,
		TP = true,
		TR = true,
		TRAVEL = true,
		TT = true,
		TV = true,
		TW = true,
		TZ = true,
		UA = true,
		UG = true,
		UK = true,
		UM = true,
		US = true,
		UY = true,
		UZ = true,
		VA = true,
		VC = true,
		VE = true,
		VG = true,
		VI = true,
		VN = true,
		VU = true,
		WF = true,
		WS = true,
		YE = true,
		YT = true,
		YU = true,
		ZA = true,
		ZM = true,
		ZW = true,
	}

	local patterns = {
		-- X://Y url
		{ pattern = "^(%a[%w+.-]+://%S+)", matchfunc = Link },
		{ pattern = "%f[%S](%a[%w+.-]+://%S+)", matchfunc = Link },
		-- www.X.Y url
		{ pattern = "^(www%.[-%w_%%]+%.(%a%a+))", matchfunc = LinkwTLD },
		{ pattern = "%f[%S](www%.[-%w_%%]+%.(%a%a+))", matchfunc = LinkwTLD },
		-- "W X"@Y.Z email (this is seriously a valid email)
		{ pattern = '^(%"[^%"]+%"@[%w_.-%%]+%.(%a%a+))', matchfunc = LinkwTLD },
		{ pattern = '%f[%S](%"[^%"]+%"@[%w_.-%%]+%.(%a%a+))', matchfunc = LinkwTLD },
		-- X@Y.Z email
		{ pattern = "(%S+@[%w_.-%%]+%.(%a%a+))", matchfunc = LinkwTLD },
		-- XXX.YYY.ZZZ.WWW:VVVV/UUUUU IPv4 address with port and path
		{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)", matchfunc = Link },
		{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)", matchfunc = Link },
		-- XXX.YYY.ZZZ.WWW:VVVV IPv4 address with port (IP of ts server for example)
		{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc = Link },
		{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc = Link },
		-- XXX.YYY.ZZZ.WWW/VVVVV IPv4 address with path
		{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)", matchfunc = Link },
		{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)", matchfunc = Link },
		-- XXX.YYY.ZZZ.WWW IPv4 address
		{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]", matchfunc = Link },
		{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]", matchfunc = Link },
		-- X.Y.Z:WWWW/VVVVV url with port and path
		{ pattern = "^([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d/%S+)", matchfunc = LinkwTLD },
		{ pattern = "%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d/%S+)", matchfunc = LinkwTLD },
		-- X.Y.Z:WWWW url with port (ts server for example)
		{ pattern = "^([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc = LinkwTLD },
		{ pattern = "%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc = LinkwTLD },
		-- X.Y.Z/WWWWW url with path
		{ pattern = "^([%w_.-%%]+[%w_-%%]%.(%a%a+)/%S+)", matchfunc = LinkwTLD },
		{ pattern = "%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+)/%S+)", matchfunc = LinkwTLD },
		-- X.Y.Z url
		{ pattern = "^([-%w_%%]+%.[-%w_%%]+%.(%a%a+))", matchfunc = LinkwTLD },
		{ pattern = "%f[%S]([-%w_%%]+%.[-%w_%%]+%.(%a%a+))", matchfunc = LinkwTLD },
		{ pattern = "^([-%w_%%]+%.(%a%a+))", matchfunc = LinkwTLD },
		{ pattern = "%f[%S]([-%w_%%]+%.(%a%a+))", matchfunc = LinkwTLD },
    }

	local function RawLink(link)
		local returnedLink = ""

		if DraeUI.db.chat.colorurl then
			local c = DraeUI.db.chat.colorurl
			local color = string.format("%02x%02x%02x", c.r * 255, c.g * 255, c.b * 255)

			returnedLink = "|cff" .. color
		end

		link = link:gsub('%%', '%%%%')

		returnedLink = returnedLink .. "|Hurl:" .. link .. "|h"

		if (DraeUI.db.chat.bracketurl) then
			returnedLink = returnedLink .. "[" .. link .. "]"
		else
			returnedLink = returnedLink .. link
		end

		returnedLink = returnedLink .. "|h|r"

		return returnedLink
	end

	local function AddLink(link)
		return RegisterMatch(link)
	end

	function Link(link, ...)
		if link == nil then
			return ""
		end

		return AddLink(RawLink(link))
	end

	function LinkwTLD(link, tld, ...)
		if link == nil or tld == nil then
			return ""
		end

		if tlds[tld:upper()] then
			link = RawLink(link)
		end

		return AddLink(link)
	end

	local function Skip(link, ...)
		if link == nil then
			return ""
		end

		return AddLink(link)
	end
end

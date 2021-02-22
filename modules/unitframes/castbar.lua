--[[


--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")

-- Localise a bunch of functions
local _G = _G
local unpack, pairs, format = unpack, pairs, string.format
local UnitChannelInfo = UnitChannelInfo


--[[
		Castbar functions
--]]
local OnCastbarUpdate = function(self, elapsed)
	if (self.casting or self.channeling) then
		local parent = self:GetParent()
		local duration = self.casting and self.duration + elapsed or self.duration - elapsed

		if ((self.casting and duration >= self.max) or (self.channeling and duration <= 0)) then
			self.casting = nil
			self.channeling = nil
			return
		end

		if (self.Time) then
			if (parent.unit == "player") then
				if (self.delay ~= 0) then
					self.Time:SetFormattedText("%.1f | |cffff0000%.1f|r", duration, self.casting and self.max + self.delay or self.max - self.delay)
				else
					self.Time:SetFormattedText("%.1f | %.1f", duration, self.max)
				end
			else
				self.Time:SetFormattedText("%.1f | %.1f", duration, self.casting and self.max + self.delay or self.max - self.delay)
			end
		end

		self.duration = duration
		self:SetValue(duration)

		if(self.Spark) then
			self.Spark:SetPoint("CENTER", self, "LEFT", (duration / self.max) * self:GetWidth(), 0)
		end
	else
		self.unitName = nil
		self.casting = nil
		self.castid = nil
		self.channeling = nil

		self.Spark:Hide()
		local alpha = self:GetAlpha() - 0.02

		if (alpha > 0) then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

local PostCastStart = function(self, unit, name, rank, text)
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	self.border:SetBackdropBorderColor(0, 0, 0)

	-- Hidden by onupdate at cast end/stop/fail
	self:SetAlpha(1.0)
	self.Spark:Show()

	if (unit == "player") then
		if (self.casting) then
			if (self.mergingTradeSkill) then
				self.duration = self.duration + self.max * self.countCurrent
				self.max = self.max * self.countTotal
				self:SetMinMaxValues(0, self.max)
				self:SetValue(self.duration)
				self.countCurrent = self.countCurrent + 1

				if (self.countCurrent == self.countTotal) then
					self.mergingTradeSkill = nil
				end
			end
		end
	end
end

local PostCastStop = function(self, unit, name, rank, castid)
	if (self.mergingTradeSkill) then
		self.duration = self.max * self.countCurrent / self.countTotal
		self:SetValue(self.duration)
		self:SetStatusBarColor(unpack(self.CastingColor))
		self.fadeOut = nil

		local sparkPosition = (self.duration / self.max) * self:GetWidth()
		self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, 2)
		self.Spark:Show()
	else
		if (not self.fadeOut) then
			self:SetStatusBarColor(unpack(self.CompleteColor))
			self.fadeOut = true
		end

		self:SetValue(self.max)
		self:Show()
	end
end

local PostChannelStop = function(self, unit, name, rank)
	self.fadeOut = true
	self.mergingTradeSkill = nil
	self:SetValue(0)
	self:Show()
end

local PostCastFailed = function(self, event, unit, name, rank, castid)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)

	if (not self.fadeOut) then
		self.fadeOut = true
	end

	self.mergingTradeSkill = nil
	self.duration = 0
	self:Show()
end

--[[
		Create a castbar
--]]
UF.CreateCastBar = function(self, width, height, anchor, anchorAt, anchorTo, xOffset, yOffset, reverse)
	local castbar = CreateFrame("StatusBar", nil, self, BackdropTemplateMixin and "BackdropTemplate")
	castbar:SetSize(width, height)
	castbar:SetPoint(anchorAt, anchor, anchorTo, xOffset, yOffset)
	castbar:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
	castbar:SetStatusBarColor(0.5, 0.5, 1, 1)

	--color
	castbar.CastingColor 			= DraeUI.db["castbar"].colorCasting or { 0.5, 0.5, 1.0 }
	castbar.CompleteColor 			= DraeUI.db["castbar"].colorComplete or { 0.5, 1.0, 0 }
	castbar.FailColor 				= DraeUI.db["castbar"].colorFail or { 1.0, 0.05, 0 }
	castbar.ChannelingColor 		= DraeUI.db["castbar"].colorChannel or { 0.5, 0.5, 1.0 }

	castbar.OnUpdate 				 = OnCastbarUpdate
	castbar.PostCastStart 			 = PostCastStart
	castbar.PostChannelStart 		 = PostCastStart
	castbar.PostCastStop 			 = PostCastStop
	castbar.PostChannelStop 		 = PostChannelStop
	castbar.PostCastFailed 			 = PostCastFailed
	castbar.PostCastInterrupted 	 = PostCastFailed

	-- Border
	local border = CreateFrame("Frame", nil, castbar, BackdropTemplateMixin and "BackdropTemplate")
	border:SetPoint("TOPLEFT", -2, 2)
	border:SetPoint("BOTTOMRIGHT", 2, -2)
	border:SetFrameStrata("BACKGROUND")
	border:SetBackdrop {
		bgFile = "Interface\\BUTTONS\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\White8x8",
		tile = false,
		edgeSize = 2
	}
	border:SetBackdropColor(0, 0, 0)
	border:SetBackdropBorderColor(0, 0, 0)
	castbar.border = border

	-- Spark
	local spark = castbar:CreateTexture(nil, "OVERLAY")
	spark:SetBlendMode("ADD")
	spark:SetAlpha(0.75)
	spark:SetHeight(castbar:GetHeight() * 2.75)
	castbar.Spark = spark

	-- Cast time
	castbar.Time = DraeUI.CreateFontObject(castbar, DraeUI.db["general"].fontsize3, DraeUI["media"].font, "RIGHT", 2, height + 6)

	-- Spell name
	castbar.Text = DraeUI.CreateFontObject(castbar, DraeUI.db["general"].fontsize3, DraeUI["media"].font, "LEFT", -2, height + 6)

	local shield = castbar:CreateTexture(nil, "BACKGROUND", nil, 7)
	shield:SetTexture("Interface\\TARGETINGFRAME\\PortraitQuestBadge")
	shield:SetPoint(reverse and "RIGHT" or "LEFT", castbar, reverse and "RIGHT" or "LEFT", reverse and 15 or -15, 0)
	shield:SetSize(30, 30)
	castbar.Shield = shield

	if (self.unit and self.unit == "player") then
		local safezone = castbar:CreateTexture(nil, 'OVERLAY')
		safezone:SetTexture("Interface\\Buttons\\White8x8")
		safezone:SetVertexColor(1.0, 0, 0, 0.75)
		castbar.SafeZone = safezone
	end

	self.Castbar = castbar
end

-- Mirror bars
do
	local updateInterval = 1.0 -- One second
	local lastUpdate = 0

	local getFormattedNumber = function(number)
		if (strlen(number) < 2 ) then
			return "0" .. number
		else
			return number
		end
	end

	UF.CreateMirrorCastbars = function(self)
		for _, barId in pairs({"1", "2", "3",}) do
			local bar = "MirrorTimer"..barId

			for i, region in pairs({_G[bar]:GetRegions()}) do
				if (not region:GetName() or region.GetTexture and region:GetTexture() == "SolidTexture") then
					region:Hide()
				end
			end

			--glowing borders
			local border = CreateFrame("Frame", nil, _G[bar], BackdropTemplateMixin and "BackdropTemplate")
			border:SetFrameStrata("BACKGROUND")
			border:SetPoint("TOPLEFT", -2, 2)
			border:SetPoint("BOTTOMRIGHT", 2, -2)
			border:SetBackdrop {
				edgeFile = "Interface\\Buttons\\White8x8",
				tile = false,
				edgeSize = 2
			}
			border:SetBackdropBorderColor(0, 0, 0)

			_G[bar]:SetParent(UIParent)
			_G[bar]:SetScale(1)
			_G[bar]:SetHeight(DraeUI.db["castbar"].player.height)
			_G[bar]:SetWidth(DraeUI.db["castbar"].player.width / 2)
			if (bar == "MirrorTimer1") then
				_G[bar]:ClearAllPoints()
				_G[bar]:SetPoint("RIGHT", self.Castbar, "RIGHT", 0, 30)
			else
				_G[bar]:ClearAllPoints()
				_G[bar]:SetPoint("BOTTOM", _G["MirrorTimer"..(barId - 1)], "TOP", 0, 5)
			end

			_G[bar.."Background"] = _G[bar]:CreateTexture(bar.."Background", "BACKGROUND", _G[bar])
			_G[bar.."Background"]:SetTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
			_G[bar.."Background"]:SetAllPoints(bar)
			_G[bar.."Background"]:SetVertexColor(0, 0, 0, 0)

			_G[bar.."Border"]:Hide()

			_G[bar.."Text"]:ClearAllPoints()
			_G[bar.."Text"]:SetFont(DraeUI["media"].font, 10)
			_G[bar.."Text"]:SetPoint("LEFT", _G[bar.."StatusBar"], 5, 1)

			_G[bar.."TextTime"] = DraeUI.CreateFontObject(_G[bar.."StatusBar"], 10, DraeUI["media"].font, "RIGHT", -5, 1, "NONE") -- Our timer

			_G[bar.."StatusBar"]:ClearAllPoints()
			_G[bar.."StatusBar"]:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\striped")
			_G[bar.."StatusBar"]:SetAllPoints(_G[bar])

			local timeMsg = ""
			local minutes = 0
			local seconds = 0

			-- Hook scripts
			_G[bar]:HookScript("OnShow", function(self)
				local c = MirrorTimerColors[self.timer]
				_G[self:GetName().."Background"]:SetVertexColor(c.r * 0.33, c.g * 0.33, c.b * 0.33, 1)
			end)

			_G[bar]:HookScript("OnHide", function(self)
				_G[self:GetName().."Background"]:SetVertexColor(0, 0, 0, 0)
				_G[self:GetName().."TextTime"]:SetText("")
			end)

			_G[bar]:HookScript("OnUpdate", function(self, elapsed)
				if (self.paused) then
					return
				end

				if (lastUpdate <= 0) then
					if (self.value >= 60) then
						minutes = floor(self.value / 60)
						local seconds = ceil(self.value - (60 * minutes))

						if (seconds == 60) then
							minutes = minutes + 1
							seconds = 0
						end

						timeMsg = format("%s:%s", minutes, getFormattedNumber(seconds))
					else
						timeMsg = format("%d", self.value)
					end

					_G[self:GetName().."TextTime"]:SetText(timeMsg)

					lastUpdate = updateInterval
				end

				lastUpdate = lastUpdate - elapsed
			end)
		end
	end
end

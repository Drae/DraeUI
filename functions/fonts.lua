--[[

--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

--[[

--]]
local ChangeFont = function(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)

	if (sr and sg and sb) then obj:SetShadowColor(sr, sg, sb) end

	if (sox and soy) then obj:SetShadowOffset(sox, soy) end

	if (r and g and b) then
		obj:SetTextColor(r, g, b)
	elseif (r) then
		obj:SetAlpha(r)
	end
end

T.UpdateBlizzardFonts = function(self)
	-- Change fonts
	local FontStandard = self["media"].font
	local FontSmall = FontStandard
	local FontFancy = self["media"].fontFancy
	local FontCombat = self["media"].fontCombat
	local FontTimers = self["media"].fontTimers

	local SizeSmall    = 10
	local SizeMedium   = 12
	local SizeLarge    = 16
	local SizeHuge     = 18
	local SizeInsane   = 26

	-- Base fonts
	ChangeFont(SystemFont_Tiny                   , FontSmall   , SizeSmall , nil)
	ChangeFont(SystemFont_Small                  , FontSmall   , SizeSmall , nil)
	ChangeFont(SystemFont_Outline_Small          , FontSmall   , SizeSmall , "OUTLINE")
	ChangeFont(SystemFont_Shadow_Small           , FontSmall   , SizeSmall , nil)
	ChangeFont(SystemFont_InverseShadow_Small    , FontSmall   , SizeSmall , nil)
	ChangeFont(SystemFont_Med1                   , FontStandard, SizeMedium, nil)
	ChangeFont(SystemFont_Shadow_Med1            , FontStandard, SizeMedium, nil)
	ChangeFont(SystemFont_Med2                   , FontStandard, SizeMedium, nil)
	ChangeFont(SystemFont_Med3                   , FontStandard, SizeMedium, nil)
	ChangeFont(SystemFont_Shadow_Med3            , FontStandard, SizeMedium, nil)
	ChangeFont(SystemFont_Large                  , FontStandard, SizeLarge , nil)
	ChangeFont(SystemFont_Shadow_Large           , FontStandard, SizeLarge , nil)
	ChangeFont(SystemFont_Shadow_Large_Outline   , FontTimers,   SizeLarge , "OUTLINE")
	ChangeFont(SystemFont_Shadow_Huge1           , FontStandard, SizeHuge  , nil)
	ChangeFont(SystemFont_OutlineThick_Huge2     , FontStandard, SizeHuge  , "THICKOUTLINE")
	ChangeFont(SystemFont_Shadow_Outline_Huge2   , FontStandard, SizeHuge  , "THICKOUTLINE")
	ChangeFont(SystemFont_Shadow_Huge3           , FontStandard, SizeHuge  , nil)
	ChangeFont(SystemFont_OutlineThick_Huge4     , FontStandard, SizeHuge  , "THICKOUTLINE")
	ChangeFont(SystemFont_OutlineThick_WTF       , FontStandard, SizeInsane, "THICKOUTLINE")

	ChangeFont(NumberFont_Shadow_Small           , FontSmall   , SizeSmall , nil)
	ChangeFont(NumberFont_OutlineThick_Mono_Small, FontStandard, SizeMedium, "OUTLINE")
	ChangeFont(NumberFont_Shadow_Med             , FontStandard, SizeMedium, nil)
	ChangeFont(NumberFont_Outline_Med            , FontStandard, SizeMedium, "OUTLINE")
	ChangeFont(NumberFont_Outline_Large          , FontStandard, SizeLarge , "OUTLINE")
	ChangeFont(NumberFont_Outline_Huge           , FontStandard, SizeHuge  , "OUTLINE")

	ChangeFont(QuestFont_Large                   , FontFancy   , SizeMedium, nil)
	ChangeFont(QuestFont_Shadow_Huge             , FontFancy   , SizeHuge  , nil)
	ChangeFont(GameTooltipHeader                 , FontStandard, SizeMedium, nil)
	ChangeFont(MailFont_Large                    , FontFancy   , SizeMedium, nil)
	ChangeFont(SpellFont_Small                   , FontSmall   , SizeSmall , nil)
	ChangeFont(InvoiceFont_Med                   , FontStandard, SizeMedium, nil)
	ChangeFont(InvoiceFont_Small                 , FontSmall   , SizeSmall , nil)
	ChangeFont(Tooltip_Med                       , FontStandard, SizeMedium, nil)
	ChangeFont(Tooltip_Small                     , FontSmall   , SizeSmall , nil)
	ChangeFont(AchievementFont_Small             , FontSmall   , SizeSmall , nil)
	ChangeFont(ReputationDetailFont              , FontSmall   , SizeSmall , nil)
	ChangeFont(FriendsFont_UserText              , FontSmall   , SizeSmall , nil)
	ChangeFont(FriendsFont_Normal                , FontStandard, SizeMedium, nil)
	ChangeFont(FriendsFont_Small                 , FontSmall   , SizeSmall , nil)
	ChangeFont(FriendsFont_Large                 , FontStandard, SizeLarge , nil)
	ChangeFont(CombatTextFont					 , FontCombat  , 150       , "THINOUTLINE")

	-- Game engine fonts
	STANDARD_TEXT_FONT = FontStandard
	NAMEPLATE_FONT = FontStandard
	UNIT_NAME_FONT = FontStandard
	DAMAGE_TEXT_FONT = FontCombat
end

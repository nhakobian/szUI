function dummy()
end

local function Kill(frame)
	frame.old_show = frame.Show
	frame.Show = dummy
	frame:Hide()
end

-- set the chat style
local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()
	local tab = _G[chat.."Tab"]
	
	-- always set alpha to 1, don't fade it anymore
	tab:SetAlpha(1)
	tab.SetAlpha = UIFrameFadeRemoveFrame
	
	-- hide text when setting chat
	_G[chat.."TabText"]:Hide()
	
	-- now show text if mouse is found over tab.
	tab:HookScript("OnEnter", function() _G[chat.."TabText"]:Show() end)
	tab:HookScript("OnLeave", function() _G[chat.."TabText"]:Hide() end)
	
	-- yeah baby
	_G[chat]:SetClampRectInsets(0,0,0,0)
	
	-- Removes crap from the bottom of the chatbox so it can go to the bottom of the screen.
	_G[chat]:SetClampedToScreen(false)
			
	-- Stop the chat chat from fading out
	_G[chat]:SetFading(false)
	
	-- move the chat edit box
	_G[chat.."EditBox"]:ClearAllPoints();
	_G[chat.."EditBox"]:SetPoint("BOTTOMLEFT", pUI_ChatDock, "TOPLEFT", 2, -2)
	_G[chat.."EditBox"]:SetPoint("BOTTOMRIGHT", pUI_ChatDock, "TOPRIGHT", -2, -2)
	
	-- Hide textures
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	-- Removes Default ChatFrame Tabs texture				
	Kill(_G[format("ChatFrame%sTabLeft", id)])
	Kill(_G[format("ChatFrame%sTabMiddle", id)])
	Kill(_G[format("ChatFrame%sTabRight", id)])

	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])
	
	--Kill(_G[format("ChatFrame%sTabHighlightLeft", id)])
	--Kill(_G[format("ChatFrame%sTabHighlightMiddle", id)])
	--Kill(_G[format("ChatFrame%sTabHighlightRight", id)])

	-- Killing off the new chat tab selected feature
	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])

	-- Kills off the new method of handling the Chat Frame scroll buttons as well as the resize button
	-- Note: This also needs to include the actual frame textures for the ButtonFrame onHover
	Kill(_G[format("ChatFrame%sButtonFrameUpButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameDownButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameBottomButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameMinimizeButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrame", id)])

	-- Kills off the retarded new circle around the editbox
	Kill(_G[format("ChatFrame%sEditBoxFocusLeft", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusMid", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusRight", id)])

	-- Kill off editbox artwork
	local a, b, c = select(6, _G[chat.."EditBox"]:GetRegions()); Kill (a); Kill (b); Kill (c)
				
	-- Disable alt key usage
	_G[chat.."EditBox"]:SetAltArrowKeyMode(false)
	
	-- hide editbox on login
	_G[chat.."EditBox"]:Hide()

	-- script to hide editbox instead of fading editbox to 0.35 alpha via IM Style
	_G[chat.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	
	-- hide edit box every time we click on a tab
	_G[chat.."Tab"]:HookScript("OnClick", function() _G[chat.."EditBox"]:Hide() end)
			
	-- rename combag log to log
	--if _G[chat] == _G["ChatFrame2"] then
	--	FCF_SetWindowName(_G[chat], "Log")
	--end
			
	-- create our own texture for edit box
	local EditBoxBackground = CreateFrame("frame", "pUI_ChatchatEditBoxBackground", _G[chat.."EditBox"])
	EditBoxBackground:SetBackdrop({ bgFile="Interface\\AddOns\\paradoxUI\\media\\Flat", edgeFile="Interface\\AddOns\\paradoxUI\\media\\Flat", edgeSize=2})
	EditBoxBackground:SetBackdropColor(0, 0, 0, .65)
	--TukuiDB.CreatePanel(EditBoxBackground, 1, 1, "LEFT", _G[chat.."EditBox"], "LEFT", 0, 0)
	EditBoxBackground:ClearAllPoints()
	EditBoxBackground:SetPoint("TOPLEFT", _G[chat.."EditBox"], 5, -5)
	EditBoxBackground:SetPoint("BOTTOMRIGHT", _G[chat.."EditBox"], -5, 5)
	EditBoxBackground:SetFrameStrata("LOW")
	EditBoxBackground:SetFrameLevel(1)
	
	local function colorize(r,g,b)
		EditBoxBackground:SetBackdropBorderColor(r, g, b)
	end
	
	-- update border color according where we talk
	hooksecurefunc("ChatEdit_UpdateHeader", function()
		local type = _G[chat.."EditBox"]:GetAttribute("chatType")
		if ( type == "CHANNEL" ) then
		local id = GetChannelName(_G[chat.."EditBox"]:GetAttribute("channelTarget"))
			if id == 0 then
				colorize( .6,.6,.6,1)
			else
				colorize(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
			end
		else
			colorize(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
		end
	end)
	
	--if _G[chat] ~= _G["ChatFrame2"] then
	--	origs[_G[chat]] = _G[chat].AddMessage
	--	_G[chat].AddMessage = AddMessage
	--end
end

-- Setup chatframes 1 to 10 on login.
local function SetupChat(self)	
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
		FCFTab_UpdateAlpha(frame)
	end
				
	Kill(ChatFrameMenuButton)
	
	-- Remember last channel
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
end

local function SetupChatPosAndFont(self)	
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local tab = _G[format("ChatFrame%sTab", i)]
		local id = chat:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local point = GetChatWindowSavedPosition(id)
		local _, fontSize = FCF_GetChatWindowInfo(id)
		
		chat:SetParent(pUI_ChatDock)
		
		-- well... tukui font under fontsize 12 is unreadable.
		--if fontSize < 12 then		
			FCF_SetChatWindowFontSize(nil, chat, 12)
		--	local fontFile, unused, fontFlags = chat:GetFont();
		--	chat:SetFont("Interface\\AddOns\\paradoxUI\\media\\expressway.ttf", fontSize, fontFlags);
		--else
		--	FCF_SetChatWindowFontSize(nil, chat, fontSize)
		--end
		
		-- force chat position on #1 and #4, needed if we change ui scale or resolution
		-- also set original width and height of chatframes 1 and 4 if first time we run tukui.
		-- doing resize of chat also here for users that hit "cancel" when default installation is show.
		if i == 1 then
			chat:ClearAllPoints()
			chat:SetPoint("BOTTOMLEFT", pUI_ChatDock, 5, 5)
			chat:SetPoint("TOPRIGHT", pUI_ChatDock, -5, -5)
			FCF_SavePositionAndDimensions(chat)
		--elseif i == 4 and name == "Loot" then
		--	if not chat.isDocked then
		--		chat:ClearAllPoints()
		--		chat:SetPoint("BOTTOMRIGHT", TukuiInfoRight, "TOPRIGHT", 0, TukuiDB.Scale(6))
		--		chat:SetJustifyH("RIGHT") 
		--		FCF_SavePositionAndDimensions(chat)
		--	end
		end
	end
	
	FriendsMicroButton:ClearAllPoints()
	FriendsMicroButton:SetPoint("TOPRIGHT", pUI_ChatDock, "TOPRIGHT", 3, -2)	
		
	-- reposition battle.net popup over chat #1
	BNToastFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 30)
	end)
end

pUI_ChatDock:RegisterEvent("ADDON_LOADED")
pUI_ChatDock:RegisterEvent("PLAYER_ENTERING_WORLD")
pUI_ChatDock:SetScript("OnEvent", function(self, event, ...)
	local addon = ...
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			SetupChat(self)
			--return CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		SetupChatPosAndFont(self)
	end
end)

-- Setup temp chat (BN, WHISPER) when needed.
local function SetupTempChat()
	local frame = FCF_GetCurrentChatFrame()
	SetChatStyle(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)

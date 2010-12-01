-- ----------------------Minimap (To move to separate file)------------------------------------------

-- Set Square Map Mask
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')

-- For others mods with a minimap button, set minimap buttons position in square mode.
function GetMinimapShape() return 'SQUARE' end

MinimapZoneTextButton:ClearAllPoints()
MinimapZoneTextButton:SetPoint("TOP", Minimap, "TOP")--, -.25*42, -.25*42)
MinimapZoneTextButton:SetBackdrop({bgFile = "Interface/Buttons/WHITE8X8", insets={top=1, bottom=-1, left=1, right=1}})
MinimapZoneTextButton:SetBackdropColor(0, 0, 0, 1)
MinimapZoneTextButton:SetWidth(4*42)
MinimapZoneTextButton:SetHeight(.35*42)
MinimapZoneTextButton:SetFrameLevel(100)
MinimapZoneText:SetWidth(MinimapZoneTextButton:GetWidth()*0.9)
MinimapZoneText:ClearAllPoints()
MinimapZoneText:SetPoint("CENTER", MinimapZoneTextButton, "CENTER", 0, 0)

Minimap:ClearAllPoints()
Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -.25*42, -.24*42)
Minimap:SetSize(4*42, 4*42)
Minimap:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile="Interface/Buttons/WHITE8X8", insets= {left=2, right=2, top=0, bottom=2}, edgeSize=2})
Minimap:SetBackdropBorderColor(0, 0, 0, 1)

-- Hide Border
MinimapBorder:Hide()
MinimapBorderTop:Hide()
--MinimapBorderTop:ClearAllPoints()
--MinimapBorderTop:SetPoint("BOTTOM", Minimap, "TOP", 0, 0)

-- Hide Zoom Buttons
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- Hide Voice Chat Frame
MiniMapVoiceChatFrame:Hide()

-- Hide North texture at top
MinimapNorthTag:SetTexture(nil)

-- Adjust Tracking Button
--MiniMapTracking:Hide()
MiniMapTrackingButtonBorder:Hide()
MiniMapTrackingBackground:Hide()
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -4, -4)

-- Hide Calendar Button
GameTimeFrame:Hide()

-- Hide Mail Button
MiniMapMailFrame:SetWidth(MiniMapMailIcon:GetWidth())
MiniMapMailFrame:SetHeight(MiniMapMailIcon:GetHeight())
MiniMapMailIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
MiniMapMailIcon:ClearAllPoints()
MiniMapMailIcon:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", 0, 0)
MiniMapMailIcon:SetBlendMode("ADD")
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", -2, 2)
MiniMapMailBorder:Hide()

--Remode the Hideous Texture behind the minimap clock
local a, b, c = TimeManagerClockButton:GetRegions()
a:Hide()
TimeManagerClockButton:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background"})
TimeManagerClockButton:SetBackdropColor(0, 0, 0, 1)
TimeManagerClockButton:SetHeight(.3*42)
TimeManagerClockButton:SetWidth(1*42)
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 0)
TimeManagerClockTicker:ClearAllPoints()
TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 0, 1)

-- Get Current zone coordinates and attach below zone name frame
local mappos = CreateFrame("Frame", "MapPosition")
mappos:SetParent(Minimap)
mappos.texture = mappos:CreateTexture(nil)
mappos.texture:SetTexture(0,0,0,0.8)
mappos.texture:SetAllPoints(mappos)
mappos:SetHeight(TimeManagerClockButton:GetHeight())
mappos:SetPoint("TOP", MinimapZoneTextButton, "BOTTOM")
local fs = mappos:CreateFontString(nil, "OVERLAY")
fs:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
fs:SetAllPoints(mappos)
fs:SetText("(00.00, 00.00)")
fs:SetJustifyH("CENTER")
fs:SetJustifyV("CENTER")
mappos:SetWidth(fs:GetStringWidth())

mappos:SetScript("OnUpdate", function(self, ...)
	local x, y = GetPlayerMapPosition("player")
	fs:SetText(string.format("(%.1f, %.1f)", x*100, y*100))
end)

--LFG Icon and Position
MiniMapLFGFrameBorder:Hide()
MiniMapLFGFrame:SetWidth(MiniMapLFGFrameIcon:GetWidth())
MiniMapLFGFrame:SetHeight(MiniMapLFGFrameIcon:GetHeight())
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrame:SetPoint("LEFT", MiniMapTracking, "RIGHT", -4, 0)

-- Move battleground icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("LEFT", MiniMapTracking, "RIGHT", -4, 0)
MiniMapBattlefieldBorder:Hide()

-- Hide world map button
MiniMapWorldMapButton:Hide()

----------------------------------------------------------------------------------------
-- Right click menu
----------------------------------------------------------------------------------------

local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = CHARACTER_BUTTON,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON,
    func = function() ToggleFrame(SpellBookFrame) end},
    {text = TALENTS_BUTTON,
    func = function() if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end PlayerTalentFrame_Toggle() end},
    {text = ACHIEVEMENT_BUTTON,
    func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON,
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = SOCIAL_BUTTON,
    func = function() ToggleFriendsFrame(1) end},
    {text = PLAYER_V_PLAYER,
    func = function() ToggleFrame(PVPFrame) end},
    {text = ACHIEVEMENTS_GUILD_TAB,
    func = function() if IsInGuild() then if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end GuildFrame_Toggle() end end},
    {text = LFG_TITLE,
    func = function() ToggleFrame(LFDParentFrame) end},
    {text = L_LFRAID,
    func = function() ToggleFrame(LFRParentFrame) end},
    {text = HELP_BUTTON,
    func = function() ToggleHelpFrame() end},
    {text = L_CALENDAR,
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
}

Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
--		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
--	elseif btn == "MiddleButton" then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)


local settings = szUI.actionbars

if select(2, UnitClass("player")) ~= "SHAMAN" then return end

local function dummy() end

local pUI_TotemBar = CreateFrame("FRAME", "pUI_TotemBar", UIParent, "SecureHandlerStateTemplate")

pUI_TotemBar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:SetWidth(settings.iconsize*6)
		self:SetHeight(settings.iconsize)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", pUI_BLeftFrame, "TOPLEFT", -2, 0)
		MultiCastSlotButton1:ClearAllPoints()
		MultiCastSlotButton1:SetPoint("Left", MultiCastSummonSpellButton, "Right", 2,0)
		MultiCastSlotButton2:ClearAllPoints()
		MultiCastSlotButton2:SetPoint("Left", MultiCastSlotButton1, "Right", 2,0)
		MultiCastSlotButton3:ClearAllPoints()
		MultiCastSlotButton3:SetPoint("Left", MultiCastSlotButton2, "Right", 2,0)
		MultiCastSlotButton4:ClearAllPoints()
		MultiCastSlotButton4:SetPoint("Left", MultiCastSlotButton3, "Right", 2,0)
		MultiCastRecallSpellButton:ClearAllPoints()
		MultiCastRecallSpellButton:SetPoint("LEFT",MultiCastActionButton4, "RIGHT", 2, 0)
		MultiCastRecallSpellButton.SetPoint = dummy
	elseif event == "PLAYER_ENTERING_WORLD" then
		local activeSlots = MultiCastActionBarFrame.numActiveSlots;
		if ( activeSlots > 0 ) then
			pUI_BLeftFrame.bkg:SetBkgPoints(self)
		else
			pUI_BLeftFrame.bkg:SetBkgPoints(pUI_BLeftFrame)
		end
	end
end)
pUI_TotemBar:RegisterEvent("PLAYER_ENTERING_WORLD")
pUI_TotemBar:RegisterEvent("PLAYER_LOGIN")

hooksecurefunc("MultiCastActionButton_Update",function(actionbutton) 
	if not InCombatLockdown() then 
		actionbutton:SetAllPoints(actionbutton.slotButton) 
	end 
	actionbutton:SetNormalTexture("")

end)

hooksecurefunc("MultiCastSummonSpellButton_Update", function(actionbutton)
	actionbutton:SetNormalTexture("")
end)

hooksecurefunc("MultiCastRecallSpellButton_Update", function(actionbutton)
	actionbutton:SetNormalTexture("")
end)

MultiCastActionBarFrame:SetParent(pUI_TotemBar)
MultiCastActionBarFrame:SetScript("OnUpdate", nil)
MultiCastActionBarFrame:SetScript("OnShow", nil)
MultiCastActionBarFrame:SetScript("OnHide", nil)
MultiCastActionBarFrame:ClearAllPoints()
MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", pUI_TotemBar)


MultiCastActionBarFrame.SetParent = dummy
MultiCastActionBarFrame.SetPoint = dummy
--MultiCastRecallSpellButton.SetPoint = dummy -- bug fix, see http://www.tukui.org/v2/forums/topic.php?id=2405

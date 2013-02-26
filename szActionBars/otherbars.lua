local settings = szUI.actionbars

local pUI_LeftFrame = CreateFrame("Frame", "pUI_LeftFrame", UIParent, "SecureHandlerStateTemplate")
local pUI_RightFrame = CreateFrame("Frame", "pUI_RightFrame", UIParent,  "SecureHandlerStateTemplate")
local pUI_BLeftFrame = CreateFrame("Frame", "pUI_BLeftFrame", UIParent,  "SecureHandlerStateTemplate")
local pUI_BRightFrame = CreateFrame("Frame", "pUI_BRightFrame", UIParent,  "SecureHandlerStateTemplate")

pUI_LeftFrame:RegisterEvent("PLAYER_LOGIN")
pUI_RightFrame:RegisterEvent("PLAYER_LOGIN")
pUI_BLeftFrame:RegisterEvent("PLAYER_LOGIN")
pUI_BRightFrame:RegisterEvent("PLAYER_LOGIN")

pUI_LeftFrame:SetAttribute("actionpage", 4)
pUI_RightFrame:SetAttribute("actionpage", 3)
pUI_BLeftFrame:SetAttribute("actionpage", 6)
pUI_BRightFrame:SetAttribute("actionpage", 5)

--Individual Setup and styling functions for each window

pUI_LeftFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetWidth(settings.LeftNX*settings.iconsize + (settings.LeftNX-1)*settings.padding)
		self:SetHeight(settings.LeftNY*settings.iconsize + (settings.LeftNY-1)*settings.padding)
		self:SetPoint("BOTTOMLEFT", pUI_ActionBar1, "BOTTOMRIGHT", 20, 0)

		MakeABCube(self, "MultiBarLeftButton", settings.LeftNX, settings.LeftNY, "BOTTOMLEFT")
	end
end)

pUI_RightFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetWidth(settings.RightNX*settings.iconsize + (settings.RightNX-1)*settings.padding)
		self:SetHeight(settings.RightNY*settings.iconsize + (settings.RightNY-1)*settings.padding)
		self:SetPoint("BOTTOMRIGHT", UIParent, -10, 10)
		
		MakeABCube(self, "MultiBarRightButton", settings.RightNX, settings.RightNY, "BOTTOMLEFT")
	end
end)

pUI_BLeftFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetWidth(settings.BLeftNX*settings.iconsize + (settings.BLeftNX-1)*settings.padding)
		self:SetHeight(settings.BLeftNY*settings.iconsize + (settings.BLeftNY-1)*settings.padding)
		self:SetPoint("BOTTOMRIGHT", pUI_ActionBar1, "BOTTOMLEFT", -20, 0)
	
		MakeABCube(self, "MultiBarBottomLeftButton", settings.BLeftNX, settings.BLeftNY, "BOTTOMLEFT", 0, 0)
	end
end)

pUI_BRightFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		self:SetWidth(settings.BRightNX*settings.iconsize + (settings.BRightNX-1)*settings.padding)
		self:SetHeight(settings.BRightNY*settings.iconsize + (settings.BRightNY-1)*settings.padding)
		self:SetPoint("BOTTOM", pUI_ActionBar1, "TOP", 0, settings.padding)
		MakeABCube(self, "MultiBarBottomRightButton", settings.BRightNX, settings.BRightNY, "BOTTOMLEFT")
	end
end)

















--Integration for Recount
local recountframe = CreateFrame("FRAME", "pUI_RecountDock")
recountframe:SetParent(pUI_InfoDock)

recountframe:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		--hooksecurefunc(Recount, "AddFontString", function(self, string)
		--	local Font, Height, Flags = string:GetFont()
		--	string:SetFont(Font, Height, "OUTLINE")
		--
		--end)
	
		local width = pUI_InfoDock:GetWidth()/2.0
		recountframe:ClearAllPoints()
		recountframe:SetPoint("TOPLEFT", pUI_InfoDock, "TOPLEFT", width, 0)
		recountframe:SetPoint("BOTTOMRIGHT", pUI_InfoDock, "BOTTOMRIGHT", 0, 0)
		--recountframe:SetBackdrop({ bgFile="Interface\\AddOns\\paradoxUI\\media\\Flat", edgeFile="Interface\\AddOns\\paradoxUI\\media\\Flat", edgeSize=2})

		Recount:LockWindows(false)
		Recount_MainWindow:SetParent(recountframe)
		Recount:ResizeMainWindow()
		Recount_MainWindow:ClearAllPoints()
		Recount_MainWindow:SetPoint("TOPLEFT", recountframe, "TOPLEFT", 0, 10)
		Recount_MainWindow:SetPoint("BOTTOMRIGHT", recountframe, "BOTTOMRIGHT", 0, 0)
		Recount_MainWindow:SetWidth(Recount_MainWindow:GetRight()-Recount_MainWindow:GetRight())
		Recount_MainWindow:SetHeight(Recount_MainWindow:GetTop()-Recount_MainWindow:GetBottom())
		Recount:ResizeMainWindow()
		Recount:LockWindows(true)
		Recount.db.profile.Locked = true
		Recount.Colors:SetColor("Window", "Background", { r = 24/255, g = 24/255, b = 24/255, a = 0})
		Recount.Colors:SetColor("Other Windows", "Title", { r = 0, g = 0, b = 0, a = 1})
		Recount.Colors:SetColor("Window", "Title", { r = 0, g = 0, b = 0, a = 1})
		
		recountframe:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)
recountframe:RegisterEvent("PLAYER_ENTERING_WORLD")

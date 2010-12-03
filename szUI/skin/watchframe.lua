function WatchPosition(...)
	WatchFrame:ClearAllPoints()
	WatchFrame:SetClampedToScreen(false)
	WatchFrame:SetPoint("TOP", Minimap, "BOTTOMRIGHT", 0, -0.25*42)
	WatchFrame:SetPoint("BOTTOM", pUI_RightFrame, "TOPRIGHT", 0, 0.25*42)
	WatchFrame:SetPoint("RIGHT", UIParent, 0.25*42, 0)
end

hooksecurefunc("UIParent_ManageFramePositions", WatchPosition)
--------------------------------------------

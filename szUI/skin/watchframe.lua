function WatchPosition(...)
	WatchFrame:ClearAllPoints()
	WatchFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -0.25*42)
	WatchFrame:SetPoint("BOTTOMRIGHT", pUI_RightFrame, "TOPRIGHT", 0, 0.25*42)
end

hooksecurefunc("UIParent_ManageFramePositions", WatchPosition)
--------------------------------------------

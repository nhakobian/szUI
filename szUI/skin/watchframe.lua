function WatchPosition(...)
	WatchFrame:ClearAllPoints()
	WatchFrame:SetClampedToScreen(false)
	WatchFrame:SetPoint("TOP", Minimap, "BOTTOMRIGHT", 0, -0.25*42)
	WatchFrame:SetPoint("BOTTOM", pUI_RightFrame, "TOPRIGHT", 0, 0.25*42)
	WatchFrame:SetPoint("RIGHT", UIParent, 0.25*42, 0)
end

hooksecurefunc("UIParent_ManageFramePositions", WatchPosition)
--------------------------------------------
local myriad = [[Interface\AddOns\szUnitFrames\media\myriad.ttf]]
local fsize = 12
local flags = "THINOUTLINE"
local nextline = 1
hooksecurefunc("WatchFrame_Update", function(self, ...)
	WatchFrameTitle:SetFont(myriad, fsize, flags)
	for i = nextline, 50 do
		line = _G["WatchFrameLine"..i]
		if line then
			line.text:SetFont(myriad, fsize, flags)
			line.dash:SetFont(myriad, fsize, flags)
			line.text:SetShadowColor(0,0,0,1)
			line.text:SetShadowOffset(1,-1)
		else
			nextline = i	--so we only have to change new lines during the hook
			break
		end
	end

end)
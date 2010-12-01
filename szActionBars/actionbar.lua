szCommon:EventDebug("szActionBars")

function style(self)
	local name = self:GetName()
	if name:match("MultiCastActionButton") then return end
	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]

	Button:SetNormalTexture("")
	Icon:SetTexCoord(.08, .92, .08, .92)
	Icon:SetPoint("TOPLEFT", Button, 2, -2)
	Icon:SetPoint("BOTTOMRIGHT", Button, -2, 2)
	

	HotKey:ClearAllPoints()
	HotKey:SetPoint("TOPRIGHT", Button, "TOPRIGHT", 1, -3)
	
	--normal:SetSize(55,56)
	normal:ClearAllPoints()
	normal:SetPoint("TOPLEFT", 0, 0)
	normal:SetPoint("BOTTOMRIGHT")
	--normal:SetTexCoord(.16, .82, .16, .82)
	normal:SetBlendMode("ADD")
	normal:SetDrawLayer("BACKGROUND")
end

hooksecurefunc("ActionButton_Update", style)

local elements = {
	MainMenuBar, 
	MainMenuBarArtFrame, --Prevents some tabs in the character window from being visible
	BonusActionBarFrame, 
	VehicleMenuBar,
	PossessBarFrame, 
	ShapeshiftBarFrame,
	VehicleMenuBarArtFrame,
	--PetActionBarFrame, --Can use default actions here.
	ShapeshiftBarLeft, 
	ShapeshiftBarMiddle, 
	ShapeshiftBarRight,
}

for _, element in pairs(elements) do
	if element:GetObjectType() == "Frame" then
		element:UnregisterAllEvents()
	end
	element:Hide()
	element:SetAlpha(0)
end
elements = nil

MainMenuBarArtFrame:Hide()
MainMenuBarArtFrame:SetAlpha(0)
MainMenuBarArtFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
MainMenuBarArtFrame:UnregisterEvent("PLAYER_ENTERING_VEHICLE")
MainMenuBarArtFrame:UnregisterEvent("PLAYER_EXITING_VEHICLE")
VehicleMenuBarArtFrame:Hide()
VehicleMenuBarArtFrame:SetAlpha(0)

CharacterFrameTab4:Show()

do
	local uiManagedFrames = {
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomLeft",
		"MultiBarBottomRight",
		"ShapeshiftBarFrame",
		"PossessBarFrame",
		"PETACTIONBAR_YPOS",
		"MultiCastActionBarFrame",
		"MULTICASTACTIONBAR_YPOS",
		"ChatFrame1",
		"ChatFrame2",
	}
	for _, frame in pairs(uiManagedFrames) do
		UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
	end
	uiManagedFrames = nil
end

--function pUI:MakeABCube
--Defines an actionbar "cube" of any shape, up to the size of an action bar: 12
--

-- Growthtable defines the SetPoint relationships; used to avoid if..then statements
-- The third and 4th factors are the padding masks (whether to pad in the x or y direction or not)
local gtable = {
	["TOPLEFT"] = { "LEFT", "RIGHT", 1, "TOP", "BOTTOM", -1 },
	["TOPRIGHT"] = { "RIGHT", "LEFT", -1,"TOP", "BOTTOM", -1 },
	["BOTTOMLEFT"] = { "LEFT", "RIGHT", 1, "BOTTOM", "TOP", 1 },
	["BOTTOMRIGHT"] = { "RIGHT", "LEFT", -1, "BOTTOM", "TOP", 1 },

}

function MakeABCube(parentframe, templatebutton, ncolumns, nrows, anchor, xoff, yoff)
	local iconsize = 32
	local padding = 0
	
	if (anchor ~= "TOPLEFT") and (anchor ~= "TOPRIGHT") and (anchor ~= "BOTTOMLEFT") and (anchor ~= "BOTTOMRIGHT") then
		error("Anchor must be TOP/BOTTOM + LEFT/RIGHT")
	end
	
	local NROW, NCOL = nrows, ncolumns
	for j = 1, NROW do
		for i = 1, NCOL do
			local n = (NCOL*(j - 1)) + i
			
			button = _G[templatebutton..n]
			
			button:ClearAllPoints()
			button:SetSize(iconsize, iconsize)
			button:SetParent(parentframe)

			if j == 1 then
				p = _G[templatebutton..i-1]
				if i == 1 then
					button:SetPoint(anchor, parentframe, xoff, yoff)
				else
					button:SetPoint(gtable[anchor][1], p, gtable[anchor][2], gtable[anchor][3]*padding, 0)
				end
			else
				pr = _G[templatebutton..n-NCOL]
				button:SetPoint(gtable[anchor][4], pr, gtable[anchor][5], 0, gtable[anchor][6]*padding )
			end
		end
	end	


end

--function MakeBackgroundWindow

function MakeBkgWindow(frame)
	local alpha = 0.9

	bkg = CreateFrame("FRAME", nil, frame, "SecureHandlerStateTemplate")
	frame.bkg = bkg
	
	bkg:SetFrameStrata("BACKGROUND")

	bkg.reframe = frame
	bkg.SetBkgPoints = function(self, frame)
		self:ClearAllPoints()
		self:SetPoint("TOP", frame, 0, 6)
		self:SetPoint("LEFT", self.reframe, -6, 0)
		self:SetPoint("BOTTOMRIGHT", self.reframe, 6, -6)
	end
	bkg:SetBkgPoints(frame)
	
	bkg.bg = bkg:CreateTexture(nil, "BACKGROUND")
	bkg.bg:SetTexture(.0, .0, .0, alpha)
	bkg.bg:SetPoint("TOPLEFT", bkg, 3, -3)
	bkg.bg:SetPoint("BOTTOMRIGHT", bkg, "BOTTOMRIGHT", -3, 3)
	bkg:SetBackdrop({bgFile=""})
	CreateBorder(bkg, 14, .5, 0, 0)
end

--MakeBkgWindow(pUI_InfoDock)
--MakeBkgWindow(pUI_ChatDock)

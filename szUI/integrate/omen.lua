
--Integration for Omen

local defaults = {
	profile = {
		Alpha        = 1,
		Scale        = 1,
		GrowUp       = false,
		Autocollapse = false,
		NumBars      = 10,
		CollapseHide = false,
		Locked       = true, --changed
		PositionW    = 200,
		PositionH    = 82,
		VGrip1       = 75,
		VGrip2       = 115,
		UseFocus     = false,
		IgnorePlayerPets = true,
		FrameStrata = "3-MEDIUM",
		ClampToScreen = true,
		ClickThrough = false,
		Background = {
			Texture = "Solid", --Changes
			BorderTexture = "None", --Changed
			Color = {r = 1, g = 1, b = 1, a = 0,}, --Changed Alpha
			BorderColor = {r = 0.8, g = 0.6, b = 0, a = 0,}, --Changed Alpha
			Tile = false,
			TileSize = 32,
			EdgeSize = 1,  --Changed (border thickness)
			BarInset = 1,  --Changed
		},
		TitleBar = {
			Height = 16,
			Font = "Friz Quadrata TT",
			FontOutline = "",
			FontColor = {r = 1, g = 1, b = 1, a = 1,},
			FontSize = 10,
			ShowTitleBar = false, --changed
			UseSameBG = true,
			Texture = "Blizzard Parchment",
			BorderTexture = "Blizzard Dialog",
			Color = {r = 1, g = 1, b = 1, a = 1,},
			BorderColor = {r = 0.8, g = 0.6, b = 0, a = 1,},
			Tile = false,
			TileSize = 32,
			EdgeSize = 8,
		},
		Bar = {
			Texture = "Armory", --Changed
			Height = 12,
			Spacing = 0,
			AnimateBars  = true,
			ShortNumbers = true,
			Font = "Friz Quadrata TT",
			FontOutline = "Outline", --Changed
			FontColor = {r = 1, g = 1, b = 1, a = 1,},
			FontSize = 10,
			Classes = {
				DEATHKNIGHT = true,
				DRUID = true,
				HUNTER = true,
				MAGE = true,
				PALADIN = true,
				PET = true,
				PRIEST = true,
				ROGUE = true,
				SHAMAN = true,
				WARLOCK = true,
				WARRIOR = true,
				["*NOTINPARTY*"] = true,
			},
			ShowTPS = true,
			TPSWindow = 10,
			ShowHeadings = true,
			HeadingBGColor = {r = 0, g = 0, b = 0, a = 0,},
			UseMyBarColor = false,
			MyBarColor = {r = 1, g = 0, b = 0, a = 1,},
			ShowPercent = true,
			ShowValue = true,
			UseClassColors = true,
			BarColor = {r = 1, g = 0, b = 0, a = 1,},
			UseTankBarColor = false,
			TankBarColor = {r = 1, g = 0, b = 0, a = 1,},
			AlwaysShowSelf = true,
			ShowAggroBar = true,
			AggroBarColor = {r = 1, g = 0, b = 0, a = 1,},
			PetBarColor = {r = 0.77, g = 0, b = 1, a = 1},
			FadeBarColor = {r = 0.5, g = 0.5, b = 0.5, a = 1},
			UseCustomClassColors = true,
			InvertColors = false,
		},
		ShowWith = {
			UseShowWith = true,
			Pet = true,
			Alone = true,
			Party = true,
			Raid = true,
			-- Deprecated SV values
			-- Resting = false, PVP = false, Dungeon = true, ShowOnlyInCombat = false,
			HideWhileResting = true,
			HideInPVP = true,
			HideWhenOOC = false,
		},
		FuBar = {
			HideMinimapButton = true,
			AttachMinimap = false,
		},
		Warnings = {
			Sound = true,
			Flash = true,
			Shake = false,
			Message = false,
			SinkOptions = {},
			Threshold = 90,
			SoundFile = "Fel Nova",
			DisableWhileTanking = true,
		},
		MinimapIcon = {
			hide = true, --changed
			minimapPos = 220,
			radius = 80,
		},
	},
}



local omenframe = CreateFrame("FRAME", "pUI_OmenDock")
omenframe:SetParent(pUI_InfoDock)
omenframe:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		OmenAnchor:SetParent(omenframe)
		local width = pUI_InfoDock:GetWidth()/2.0
		Omen.db:SetProfile("Default")
		Omen.db:RegisterDefaults(defaults)
		Omen.db:ResetProfile()
		Omen:OnProfileChanged("", Omen.db, "")
		OmenAnchor:ClearAllPoints()
		omenframe:SetPoint("TOPLEFT", pUI_InfoDock, "TOPLEFT", 0, 0)
		omenframe:SetPoint("BOTTOMRIGHT", pUI_InfoDock, "BOTTOMRIGHT", -width, 0)
		OmenAnchor:SetAllPoints(omenframe)
		Omen:Toggle()
		--omenframe:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end	
end)

omenframe:RegisterEvent("PLAYER_ENTERING_WORLD")




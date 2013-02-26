--Register Group Unit Frames
local pets = {}
local partytargets = {}
	
oUF:Factory(function(self)
	oUF:SetActiveStyle("szGroup")

	local raid = CreateFrame("FRAME", "oUF_szRaid", UIParent)
	
	local group1 = self:SpawnHeader("oUF_szGroup1", nil, "custom [@raid26,exists] hide; [@raid6,exists] show;",--"custom [@raid11,exists] hide;show", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', 90,
		'initial-height', 42,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "1", 
		"groupingOrder", "1",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "LEFT"
	)
	
	local group2 = self:SpawnHeader("oUF_szGroup2", nil, "custom [@raid26,exists] hide; [@raid6,exists] show;", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', 90,
		'initial-height', 42,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "2", 
		"groupingOrder", "2",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "LEFT"
	)

	local group3 = self:SpawnHeader("oUF_szGroup3", nil, "custom [@raid26,exists] hide; [@raid6,exists] show;", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', 90,
		'initial-height', 42,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "3", 
		"groupingOrder", "3",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "LEFT"
	)

	local group4 = self:SpawnHeader("oUF_szGroup4", nil, "custom [@raid26,exists] hide; [@raid6,exists] show;", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', 90,
		'initial-height', 42,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "4", 
		"groupingOrder", "4",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "LEFT"
	)

	local group5 = self:SpawnHeader("oUF_szGroup5", nil, "custom [@raid26,exists] hide; [@raid6,exists] show;", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', 90,
		'initial-height', 42,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "5", 
		"groupingOrder", "5",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "LEFT"
	)

	group1:SetParent(oUF_szRaid)
	group2:SetParent(oUF_szRaid)
	group3:SetParent(oUF_szRaid)
	group4:SetParent(oUF_szRaid)
	group5:SetParent(oUF_szRaid)

	group1:SetPoint("TOP", group2, "BOTTOM")
	group2:SetPoint("TOP", group3, "BOTTOM")
	group3:SetPoint("CENTER", oUF_szRaid)
	group4:SetPoint("BOTTOM", group3, "TOP")
	group5:SetPoint("BOTTOM", group4, "TOP")
	
	local xpos, ypos = oUF_paradoxPlayer:GetCenter()
	local _, cypos = UIParent:GetCenter()
	oUF_szRaid:SetPoint('CENTER', UIParent, "CENTER", 0, -(cypos-ypos))
	oUF_szRaid:SetSize(400,400)

end)

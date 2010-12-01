--Register Group Unit Frames
local pets = {}
local partytargets = {}
	
oUF:Factory(function(self)
	oUF:SetActiveStyle("szGroup")

	local raid = CreateFrame("FRAME", "oUF_szRaid", UIParent)
	
	local visibility = "custom [@raid26,exists] hide; [@raid6,exists] show;"
	local initialw = 90
	local initialh = 40
	local padding = 0
	
	local group1 = self:SpawnHeader("oUF_szGroup1", nil, visibility,
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', initialw,
		'initial-height', initialh,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "1", 
		"groupingOrder", "1",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "LEFT"
	)
	
	local group2 = self:SpawnHeader("oUF_szGroup2", nil, visibility, 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', initialw,
		'initial-height', initialh,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "2", 
		"groupingOrder", "2",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "LEFT"
	)

	local group3 = self:SpawnHeader("oUF_szGroup3", nil, visibility, 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', initialw,
		'initial-height', initialh,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "3", 
		"groupingOrder", "3",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "LEFT"
	)

	local group4 = self:SpawnHeader("oUF_szGroup4", nil, visibility, 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', initialw,
		'initial-height', initialh,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "4", 
		"groupingOrder", "4",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "LEFT"
	)

	local group5 = self:SpawnHeader("oUF_szGroup5", nil, visibility, 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', initialw,
		'initial-height', initialh,	
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

	group1:SetPoint("TOPLEFT", group2, "BOTTOMLEFT")
	group2:SetPoint("TOPLEFT", group3, "BOTTOMLEFT")
	group3:SetPoint("LEFT", oUF_szRaid)
	group4:SetPoint("BOTTOMLEFT", group3, "TOPLEFT")
	group5:SetPoint("BOTTOMLEFT", group4, "TOPLEFT")
	
	local xpos, ypos = oUF_paradoxPlayer:GetCenter()
	local _, cypos = UIParent:GetCenter()
	oUF_szRaid:SetPoint('CENTER', UIParent, "CENTER", 0, -(cypos-ypos))
	oUF_szRaid:SetSize(initialw*5 + padding*4, initialh*5 + padding*4)

end)



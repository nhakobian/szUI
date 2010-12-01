local alpha = .8

chat = CreateFrame("FRAME", "pUI_ChatDock", UIParent)
chat:SetFrameStrata("LOW")
chat:SetPoint("BOTTOMLEFT", UIParent, .25*42, 0.25*42)
chat:SetWidth(9.5*42)
chat:SetHeight(4.25*42)
MakeBkgWindow(chat)

info = CreateFrame("FRAME", "pUI_InfoDock", UIParent)
info:SetFrameStrata("LOW")
info:SetPoint("BOTTOMRIGHT", UIParent, -10, 10)
info:SetWidth(9.5*42)
info:SetHeight(178)
MakeBkgWindow(info)

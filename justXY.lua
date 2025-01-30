local XYFrame = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
XYFrame:SetPoint("BOTTOM", Minimap, 0, -25)
-- XYFrame:SetPoint("TOPLEFT", Minimap, 0, 25)
XYFrame:SetSize(90, 20)
XYFrame:SetBackdrop(BACKDROP_TUTORIAL_16_16)

XYFrame:CreateFontString("XYText", "OVERLAY", "NumberFontNormalSmall")
XYText:SetPoint("CENTER")
XYText:SetTextColor(1, 1, 1, 1)
XYText:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")
XYFrame:SetScript("OnUpdate", function() 
  local map = C_Map.GetBestMapForUnit("player")
  if not map then XYText:SetText("no map") return end
  local pos = C_Map.GetPlayerMapPosition(map, "player")
  if not pos then XYText:SetText("no pos") return end
  XYText:SetText(string.format("%.2f, %.2f", pos.x*100, pos.y*100))
end)

XYFrame:SetScript("OnEnter", function(self, motion) 
  GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
  GameTooltip:SetText("Show Player Position(XY)")
end)
XYFrame:SetScript("OnLeave", function(self, motion)
  GameTooltip:Hide()
end)

function coord1()
  print("coord1")
end

-- register slash for justXY
SLASH_COORD1 = "/coord"
SlashCmdList["COORD"] = coord1

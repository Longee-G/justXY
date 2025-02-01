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

-- register slash for justXY
SLASH_COORD1 = "/coord"
SLASH_COORD2 = "/wp"
SLASH_COORD3 = "/xy"
SlashCmdList.COORD = function(msg, editBox)
  --print("msg="..msg)
  local x, y = msg:match("^(%S*)%s*(%S*)")
  x = tonumber(x) or 0
  y = tonumber(y) or 0
  if x > 100 then x = 100 elseif x < 0 then x = 0 end
  if y > 100 then y = 100 elseif y < 0 then y = 0 end
  --print("x="..x..",y="..y)
  local map = C_Map.GetBestMapForUnit("player")
  if map and C_Map.CanSetUserWaypointOnMap(map) then
    --local pos = C_Map.GetPlayerMapPosition(map, "player")
    PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CLICK_TO_PLACE);
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(map, x/100, y/100))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
  end
end

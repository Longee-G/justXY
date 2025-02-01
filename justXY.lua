local XYFrame = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
XYFrame:SetPoint("BOTTOM", Minimap, 0, -25)
-- XYFrame:SetPoint("TOPLEFT", Minimap, 0, 25)
XYFrame:SetSize(90, 20)
XYFrame:SetBackdrop(BACKDROP_TUTORIAL_16_16)

XYFrame:CreateFontString("XYText", "OVERLAY", "NumberFontNormalSmall")
XYText:SetPoint("CENTER")
XYText:SetTextColor(1, 1, 1, 1)
XYText:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")

local interval = 0
XYFrame:SetScript("OnUpdate", function(self, elapsed) 
  interval = interval + elapsed
  if(interval < 0.1) then return else interval = 0 end
  local map = C_Map.GetBestMapForUnit("player")
  if not map then XYText:SetText("no map") return end
  local pos = C_Map.GetPlayerMapPosition(map, "player")
  if not pos then XYText:SetText("--,--") return end
  XYText:SetText(string.format("%.2f, %.2f", pos.x*100, pos.y*100))
end)

XYFrame:SetScript("OnEnter", function(self, motion) 
  GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
  GameTooltip:AddLine("Player Coordinates Tracker")
  GameTooltip:AddLine("|cFF00FF00/xy X Y|r to set waypoint", 1, 1, 1)
  GameTooltip:Show()
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
  local x, y = msg:match("^%s*(%d+%.?%d*)%s+(%d+%.?%d*)%s*$")
  if not x or not y then 
    print("<justXY>|cFFFF0000Invalid format! Usage: /xy X Y|r")
    print("<justXY>|cFF00FF00Example: /xy 56.7 32.1|r")
    return 
  end
  x = tonumber(x)
  y = tonumber(y)
  if not x or not y then print("<justXY> Invalid coordinates. Numbers required.") return end
  x = math.min(100, math.max(0, x))
  y = math.min(100, math.max(0, x))
  --print("x="..x..",y="..y)
  local map = C_Map.GetBestMapForUnit("player")
  if map and C_Map.CanSetUserWaypointOnMap(map) then
    --local pos = C_Map.GetPlayerMapPosition(map, "player")
    PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CLICK_TO_PLACE);
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(map, x/100, y/100))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
  end
end

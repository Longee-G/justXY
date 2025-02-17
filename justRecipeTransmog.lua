local addonName, addonTable = ...

-- 保存原始的 GetFilteredRecipeIDs 函数
local original_GetFilteredRecipeIDs = C_TradeSkillUI.GetFilteredRecipeIDs

-- 是否启用未收藏外观过滤
local enableUncollectedFilter = false

local function IsRecipeAppearanceCollected(recipeID)
    local hasAppearance = false
    local isCollected = false    
    local outputItemData = C_TradeSkillUI.GetRecipeOutputItemData(recipeID)
    
    if outputItemData and outputItemData.itemID then
        local itemAppearanceID, itemModifiedAppearanceID  = C_TransmogCollection.GetItemInfo(outputItemData.itemID)
        if itemAppearanceID and itemModifiedAppearanceID then
            hasAppearance = true
            local sources = C_TransmogCollection.GetAppearanceSources(itemAppearanceID)
            if sources then
                for i, s in ipairs(sources) do
                    local info = C_TransmogCollection.GetAppearanceInfoBySource(s.sourceID)
                    if info.sourceIsCollected then
                        isCollected = true
                        break
                    end
                end
            end
        end
    end
    return hasAppearance, isCollected
end


-- 自定义过滤函数
local function FilterUncollectedRecipes()
    --print("[dbg]C_TradeSkillUI.GetFilteredRecipeIDs...")

    local recipeIDs = original_GetFilteredRecipeIDs()

    if not enableUncollectedFilter then
        return recipeIDs
    end

    print("[dbg]execture my FilterUncollectedRecipes...")

    local uncollectedRecipes = {}
    for _, recipeID in ipairs(recipeIDs) do
        local recipeInfo = C_TradeSkillUI.GetRecipeInfo(recipeID)
        local hasAppearance, isCollected = IsRecipeAppearanceCollected(recipeID)

        if hasAppearance and not isCollected then
            table.insert(uncollectedRecipes, recipeID)
        end
    end
 
    return uncollectedRecipes
end

-- 钩住 GetFilteredRecipeIDs
C_TradeSkillUI.GetFilteredRecipeIDs = FilterUncollectedRecipes

print("[dbg]test...")

local function TradeSkillFrame_Update()
    --C_TradeSkillUI.TradeSkillListUpdate()
end
--[[
    
-- 创建复选框
local checkButton = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate")
checkButton:SetSize(24, 24)
checkButton:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 10, -30)
checkButton:SetScript("OnClick", function(self)
    enableUncollectedFilter = self:GetChecked()
    if enableUncollectedFilter then
        print("[dbg]开启未收藏过滤")
    else
        print("[dbg]关闭未收藏过滤")
    end
    TradeSkillFrame_Update()
end)

-- 添加标签
local label = checkButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
label:SetText("仅显示未收藏外观")
label:SetPoint("LEFT", checkButton, "RIGHT", 5, 0)
--]]
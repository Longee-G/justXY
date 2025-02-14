local addonName, addonTable = ...

-- 保存原始的 GetFilteredRecipeIDs 函数
local original_GetFilteredRecipeIDs = C_TradeSkillUI.GetFilteredRecipeIDs

-- 是否启用未收藏外观过滤
local enableUncollectedFilter = true

local function IsRecipeAppearanceCollected(recipeID)
    local hasAppearance = false
    local isCollected = false    
    local outputItemData = C_TradeSkillUI.GetRecipeOutputItemData(recipeID)
    
    if outputItemData and outputItemData.itemID then
        local itemAppearanceID, itemModifiedAppearanceID  = C_TransmogCollection.GetItemInfo(outputItemData.itemID)
        if itemAppearanceID and itemModifiedAppearanceID then
            hasAppearance = true
            local sources = C_TransmogCollection.GetAppearanceSources(itemAppearanceID)
            for i, s in ipairs(sources) do
                local info = C_TransmogCollection.GetAppearanceInfoBySource(s.sourceID)
                if info.sourceIsCollected then
                    isCollected = true
                    break
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

    --print("[dbg]execture my FilterUncollectedRecipes...")

    local uncollectedRecipes = {}
    for _, recipeID in ipairs(recipeIDs) do
        local recipeInfo = C_TradeSkillUI.GetRecipeInfo(recipeID)
        local hasAppearance, isCollected = IsRecipeAppearanceCollected(recipeID)
        if hasAppearance then
            if isCollected then
                print("配方["..recipeInfo.name.."]。")
            else
                print("*配方["..recipeInfo.name.."]。")
            end
        end

        --if recipeInfo.name then print("[dbg]"..recipeInfo.name) end
        -- 
        local sourceID = recipeInfo.sourceID
        if sourceID then
            local sourceInfo = C_TransmogCollection.GetSourceInfo(recipeID)            
            if not sourceInfo.isCollected then
                if sourceInfo.name then
                    print("未收藏:"..sourceInfo.name)
                end
                table.insert(uncollectedRecipes, recipeID)
            end
        else
            -- 如果配方没有外观（sourceID 为 nil），默认显示
            table.insert(uncollectedRecipes, recipeID)
        end
    end
    print("[dbg]------------------")

    return recipeIDs
    --return uncollectedRecipes
end

-- 钩住 GetFilteredRecipeIDs
C_TradeSkillUI.GetFilteredRecipeIDs = FilterUncollectedRecipes

print("[dbg]test...")

-- 创建复选框
local checkButton = CreateFrame("CheckButton", nil, TradeSkillFrame, "UICheckButtonTemplate")
checkButton:SetSize(24, 24)
checkButton:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 10, -30)
checkButton:SetScript("OnClick", function(self)
    enableUncollectedFilter = self:GetChecked()
    TradeSkillFrame_Update()
end)

-- 添加标签
local label = checkButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
label:SetText("仅显示未收藏外观")
label:SetPoint("LEFT", checkButton, "RIGHT", 5, 0)

-- 监听事件
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
eventFrame:SetScript("OnEvent", function()
    TradeSkillFrame_Update()
end)
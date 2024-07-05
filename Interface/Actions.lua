-------------------------------------------------------------------------------
-- Slicer Actions {{{
-------------------------------------------------------------------------------

function MBS_UpdateLiveDisplay(Index, Unit)
    
    local baseFrame = "MoronBoxDecursiveAfflictedListFrame"
    local afflictedList = getglobal(baseFrame)
    local listItem = afflictedList["ListItem"..Index]

    local coloredName = MBS_GetClassColoredName(Unit)

    if listItem.Name:GetText() == coloredName and
       listItem.UnitID == Unit then
        return
    end

    listItem.UnitID = Unit
    listItem.Overlay:SetText(coloredName)

    listItem:Show()
end

function MBS_HideAfflictedItemsFromIndex(Index)
    for i = Index, 10 do
        local baseFrame = "MoronBoxDecursiveAfflictedListFrame"
        local afflictedList = getglobal(baseFrame)
        local listItem = afflictedList["ListItem"..i]
        if listItem then
            listItem:Hide()
        end
    end
end

function MBS_GetClassColoredName(unit)
    local classColors = {
        ["Warrior"] = "|cffC79C6E",
        ["Hunter"] = "|cffABD473",
        ["Mage"] = "|cff69CCF0",
        ["Rogue"] = "|cffFFF569",
        ["Warlock"] = "|cff9482C9",
        ["Druid"] = "|cffFF7D0A",
        ["Shaman"] = "|cff0070DE",
        ["Priest"] = "|cffFFFFFF",
        ["Paladin"] = "|cffF58CBA",
    }

    local unitClass = UnitClass(unit)
    local unitName = UnitName(unit)
    local color = classColors[unitClass] or "|cffFFFFFF" -- Default to white if class not found

    return color..unitName.."|r"
end
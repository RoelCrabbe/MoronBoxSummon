-------------------------------------------------------------------------------
-- InterFace Frame {{{
-------------------------------------------------------------------------------

MBS = CreateFrame("Frame", "MBS", UIParent)
local AddonInitializer = CreateFrame("Frame", nil)

-------------------------------------------------------------------------------
-- DO NOT CHANGE {{{
-------------------------------------------------------------------------------

MBS.Session = {
    Title = "MoronBoxSummon",
    Warlock = "Warlock",
    PlayerName = UnitName("player"),
	PlayerClass = UnitClass("player"),
    PlayerData = {},
    AddonLoader = {
        Cooldown = 2.5
    },
    Max_Amount_Shown = 10,
    AddPlayer = "RSAdd",
    RemovePlayer = "RSRemove",
}

-------------------------------------------------------------------------------
-- Core Event Code {{{
-------------------------------------------------------------------------------

do
	for _, event in {
        "ADDON_LOADED",
		"CHAT_MSG_ADDON", 
        "CHAT_MSG_RAID",
        "CHAT_MSG_PARTY",
		} 
		do MBS:RegisterEvent(event)
	end
end

function MBS:OnEvent()
    if event == "ADDON_LOADED" and arg1 == MBS.Session.Title then

        MBS:CreateWindows()
        AddonInitializer:SetScript("OnUpdate", AddonInitializer.OnUpdate)

    elseif event == "CHAT_MSG_SAY" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_PARTY" then

        if string.find(arg1, "123") then
            SendAddonMessage(MBS.Session.AddPlayer, arg2, "RAID")
        end

    elseif event == "CHAT_MSG_ADDON" then

        if arg1 == MBS.Session.AddPlayer then

            if not MBS_TableHasValue(MBS.Session.PlayerData, arg2) and MBS.Session.PlayerName ~= arg2 then
                table.insert(MBS.Session.PlayerData, arg2)
                MBS_UpdateList()
            end

        elseif arg1 == MBS.Session.RemovePlayer then

            if MBS_TableHasValue(MBS.Session.PlayerData, arg2) then
                for i, v in ipairs(MBS.Session.PlayerData) do
                    if v == arg2 then
                        table.remove(MBS.Session.PlayerData, i)
                        MBS_UpdateList()
                        break
                    end
                end
            end
        end
    end
end

MBS:SetScript("OnEvent", MBS.OnEvent) 

function AddonInitializer:OnUpdate()

    MBS.Session.AddonLoader.Cooldown = MBS.Session.AddonLoader.Cooldown - arg1
    if MBS.Session.AddonLoader.Cooldown > 0 then return end

    if MBS.Session.PlayerClass ~= MBS.Session.Warlock then
        if GetAddOnInfo(MBS.Session.Title) then
            DisableAddOn(MBS.Session.Title)
        end
    end

    AddonInitializer:SetScript("OnUpdate", nil)
end

-------------------------------------------------------------------------------
-- Main Code {{{
-------------------------------------------------------------------------------

function MBS_ListItemOnClick(arg1, UnitID)

    local tName = UnitName(UnitID)
    if not tName then return end

    if arg1 == "LeftButton" then

        local pShards = mb_numShards() or 0
        local pCombat = UnitAffectingCombat("player")
        local tCombat = UnitAffectingCombat(UnitID)
        local Message = "Summoning <"..GetColors(tName).."> ["..pShards.." Shards]"

        if (pCombat and tCombat) or pShards == 0 then
            return
        end

        if mb_hasBuffOrDebuff("Evil Twin", UnitID, "debuff") then
            SendAddonMessage(MBS.Session.RemovePlayer, tName, "RAID")
            return
        end

        TargetByName(tName)

        if CheckInteractDistance(UnitID, 4) then
            SendAddonMessage(MBS.Session.RemovePlayer, tName, "RAID")
            return
        end

        CastSpellByName("Ritual of Summoning")
        SendChatMessage(Message, "RAID")
        SendAddonMessage(MBS.Session.RemovePlayer, tName, "RAID")

    elseif arg1 == "RightButton" then

        SendAddonMessage(MBS.Session.RemovePlayer, tName, "RAID")
    end

    MBS_UpdateList()
end

function MBS_UpdateList()

    local TempRaidTable = { }
    local raidNum = GetNumRaidMembers()

    if ( MBS.Session.PlayerClass == MBS.Session.Warlock ) then

        if raidNum > 0 then
            for i = 1, raidNum do
                local rName, _, _, _, rClass = GetRaidRosterInfo(i)

                for j, v in ipairs(MBS.Session.PlayerData) do 
                    if v == rName then

                        TempRaidTable[j] = {
                            rName = rName,
                            rClass = rClass,
                            rVIP = (rClass == MBS.Session.Warlock),
                            rIndex = "raid"..i
                        }
                    end
                end

                table.sort(TempRaidTable, function(a, b) return tostring(a.rVIP) > tostring(b.rVIP) end)
            end
        end

		for i = 1, MBS.Session.Max_Amount_Shown do

            local listItem = getglobal("MoronBoxSummonPlayerListFrameListItem"..i)

			if TempRaidTable[i] then

                local function SetClassColor(Class)
                    local color = MBS_GetClassColor(string.upper(Class))
                    listItem.Overlay:SetTextColor(color.r, color.g, color.b, 1)
                end

                listItem.UnitID = TempRaidTable[i].rIndex
                listItem.Overlay:SetText(TempRaidTable[i].rName)
                SetClassColor(TempRaidTable[i].rClass)
                ShowUIPanel(listItem)               
			else
                HideUIPanel(listItem)
			end
		end
		
		if not MBS.Session.PlayerData[1] then
			if MBS.MainFrame:IsVisible() then
				
                HideUIPanel(MBS.MainFrame)
			end
		else
			ShowUIPanel(MBS.MainFrame, 1)
		end
	end	
end

-------------------------------------------------------------------------------
-- Utility {{{
-------------------------------------------------------------------------------

function MBS_TableHasValue(tab, val)
    for i, v in ipairs(tab) do
        if v == val then
            return true
        end
    end
    return false
end

function MBS_GetClassColor(class)
	if (class) then
		local color = RAID_CLASS_COLORS[class]
		if (color) then
			return color
		end
	end
	return {r = 0.5, g = 0.5, b = 1}
end
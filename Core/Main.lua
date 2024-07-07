-------------------------------------------------------------------------------
-- InterFace Frame {{{
-------------------------------------------------------------------------------

MBS = CreateFrame("Frame", "MBS", UIParent)
local AddonInitializer = CreateFrame("Frame", nil)

-------------------------------------------------------------------------------
-- DO NOT CHANGE {{{
-------------------------------------------------------------------------------

MBS.Session = {
    InCombat = nil,
    PlayerName = UnitName("player"),
	PlayerClass = UnitClass("player"),
    PlayerData = {},
    AddonLoader = {
        Cooldown = 2.5
    },
    Max_Amount_Shown = 10
}

MSG_PREFIX_ADD		= "RSAdd"
MSG_PREFIX_REMOVE	= "RSRemove"

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
    if event == "ADDON_LOADED" and arg1 == "MoronBoxSummon" then

        MBS:CreateWindows()

    elseif event == "CHAT_MSG_SAY" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_PARTY" then

        if string.find(arg1, "123") then
            SendAddonMessage(MSG_PREFIX_ADD, arg2, "RAID")
        end

    elseif event == "CHAT_MSG_ADDON" then

        if arg1 == MSG_PREFIX_ADD then

            if not MBS_TableHasValue(MBS.Session.PlayerData, arg2) and MBS.Session.PlayerName ~= arg2 then
                table.insert(MBS.Session.PlayerData, arg2)
                MBS_UpdateList()
            end

        elseif arg1 == MSG_PREFIX_REMOVE then

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

function MBS_AddonMessage(Msg, Arg)

    if UnitInRaid("player") then
		
		SendAddonMessage(Msg, Arg, "RAID")

	elseif UnitInParty("player") then
		
		SendAddonMessage(Msg, Arg, "PARTY")
	end
end

function MBS_ChatMessage(Msg)

    if UnitInRaid("player") then
		
		SendChatMessage(Msg, "RAID")

	elseif UnitInParty("player") then
		
		SendChatMessage(Msg, "PARTY")
	end
end

function MBS_TableHasValue(tab, val)
    for i, v in ipairs(tab) do
        if v == val then
            return true
        end
    end
    return false
end

function MBS_ListItemOnClick(arg1, UnitID)

    if arg1 == "LeftButton" then

        if UnitID then

            local pCombat = UnitAffectingCombat("player")
            local tCombat = UnitAffectingCombat(UnitID)
            local Message = "Summoning <"..GetColors(UnitID).."> ["..mb_numShards().." Shards]"

            if (pCombat and tCombat) or mb_numShards() == 0 then
                return
            end

            if mb_hasBuffOrDebuff("Evil Twin", UnitID, "debuff") then
                MBS_AddonMessage(MSG_PREFIX_REMOVE, name)
                return
            end

            DoEmote("Stand")
            TargetUnit(UnitID)

            if CheckInteractDistance(UnitID, 4) then
                MBS_AddonMessage(MSG_PREFIX_REMOVE, name)
                return
            end

            CastSpellByName("Ritual of Summoning")
            MBS_ChatMessage(Message)
            MBS_AddonMessage(MSG_PREFIX_REMOVE, name)
        else

            MBS_AddonMessage(MSG_PREFIX_REMOVE, name)
        end

    elseif arg1 == "RightButton" then

        MBS_AddonMessage(MSG_PREFIX_REMOVE, name)
    end

    MBS_UpdateList()
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

function MBS_GetRaidMembers()

    local TempRaidTable = { }
    local raidNum = GetNumRaidMembers()

	if raidNum > 0 then
		for i = 1, raidNum do
			local rName, _, rGroup = GetRaidRosterInfo(i)

			if (not rName) then 
			    rName = "unknown"..i
			end

            TempRaidTable[i] = {
                rName = rName,
                rGroup = rGroup,
                rIndex = i
            }
	    end
	end

    return TempRaidTable
end
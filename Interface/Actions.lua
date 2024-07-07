-------------------------------------------------------------------------------
-- Slicer Actions {{{
-------------------------------------------------------------------------------

function MBS_UpdateList()

    local TempRaidTable = { }
    local raidNum = GetNumRaidMembers()

    if ( MBS.Session.PlayerClass == "Warlock" ) then

        if raidNum > 0 then
            for i = 1, raidNum do
                local rName, _, _, _, rClass = GetRaidRosterInfo(i)

                for j, v in ipairs(MBS.Session.PlayerData) do 
                    if v == rName then

                        TempRaidTable[j] = {
                            rName = rName,
                            rClass = rClass,
                            rVIP = (rClass == "Warlock") and true or false,
                            rIndex = j
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
                    local color = MBS_GetClassColor(Class)
                    listItem.Overlay:SetTextColor(color.r, color.g, color.b, 1)
                end

                if TempRaidTable[i].rClass == "Druid" then
                    SetClassColor("DRUID")
                elseif TempRaidTable[i].rClass == "Hunter" then
                    SetClassColor("HUNTER")
                elseif TempRaidTable[i].rClass == "Mage" then
                    SetClassColor("MAGE")
                elseif TempRaidTable[i].rClass == "Paladin" then
                    SetClassColor("PALADIN")
                elseif TempRaidTable[i].rClass == "Priest" then
                    SetClassColor("PRIEST")
                elseif TempRaidTable[i].rClass == "Rogue" then
                    SetClassColor("ROGUE")
                elseif TempRaidTable[i].rClass == "Shaman" then
                    SetClassColor("SHAMAN")
                elseif TempRaidTable[i].rClass == "Warlock" then
                    SetClassColor("WARLOCK")
                elseif TempRaidTable[i].rClass == "Warrior" then
                    SetClassColor("WARRIOR")
                end

                listItem.Overlay:SetText(TempRaidTable[i].rName)
                listItem:Show()                
			else
				listItem:Hide()
			end
		end
		
		if not MBS.Session.PlayerData[1] then
			if MBS.MainFrame:IsVisible() then
				
				MBS.MainFrame:Hide()
			end
		else
			ShowUIPanel(MBS.MainFrame, 1)
		end
	end	
end
-------------------------------------------------------------------------------
-- Frame Names {{{
-------------------------------------------------------------------------------

local _G, _M = getfenv(0), {}
setfenv(1, setmetatable(_M, {__index=_G}))

MBS.MainFrame = CreateFrame("Frame", nil , UIParent) 

function MBS:CreateWindows()
    MBS.MainFrame:CreateMainFrame()
end

function MBS_ResetAllWindow()
    MBS_ResetFramePosition(MBS.MainFrame)
end

function MBS_OpenMainFrame()
    if MBS.MainFrame:IsShown() then
        MBS_CloseAllWindow()
    else 
        MBS.MainFrame:Show()
    end
end

function MBS_CloseAllWindow()
    MBS_ResetAllWindow()
    MBS.MainFrame:Hide()
end

-------------------------------------------------------------------------------
-- Locals {{{
-------------------------------------------------------------------------------

local ColorPicker = {
    Transparent = { r = 0, g = 0, b = 0, a = 0 },
    White = { r = 1, g = 1, b = 1, a = 1 },                 -- #ffffff
    Black = { r = 0, g = 0, b = 0, a = 1 },                 -- #000000 

    -- Gray Shades
    Gray50 = { r = 0.976, g = 0.976, b = 0.976, a = 1 },    -- #f9f9f9
    Gray100 = { r = 0.925, g = 0.925, b = 0.925, a = 1 },   -- #ececec
    Gray200 = { r = 0.890, g = 0.890, b = 0.890, a = 1 },   -- #e3e3e3
    Gray300 = { r = 0.804, g = 0.804, b = 0.804, a = 1 },   -- #cdcdcd
    Gray400 = { r = 0.706, g = 0.706, b = 0.706, a = 1 },   -- #b4b4b4
    Gray500 = { r = 0.608, g = 0.608, b = 0.608, a = 1 },   -- #9b9b9b
    Gray600 = { r = 0.404, g = 0.404, b = 0.404, a = 1 },   -- #676767
    Gray700 = { r = 0.259, g = 0.259, b = 0.259, a = 1 },   -- #424242
    Gray800 = { r = 0.184, g = 0.184, b = 0.184, a = 1 },   -- #2f2f2f
    Gray850 = { r = 0.184, g = 0.184, b = 0.184, a = 0.5 },

    -- Blue Shades
    Blue50 = { r = 0.678, g = 0.725, b = 0.776, a = 1 },    -- #adb9c6
    Blue100 = { r = 0.620, g = 0.675, b = 0.737, a = 1 },   -- #9eaebd
    Blue200 = { r = 0.561, g = 0.624, b = 0.698, a = 1 },   -- #8fa0b2
    Blue300 = { r = 0.502, g = 0.576, b = 0.659, a = 1 },   -- #8093a8
    Blue400 = { r = 0.443, g = 0.529, b = 0.620, a = 1 },   -- #71879e
    Blue500 = { r = 0.384, g = 0.482, b = 0.682, a = 1 },   -- #627bb0
    Blue600 = { r = 0.325, g = 0.435, b = 0.643, a = 1 },   -- #5370a4
    Blue700 = { r = 0.267, g = 0.388, b = 0.604, a = 1 },   -- #44639a
    Blue800 = { r = 0.208, g = 0.341, b = 0.565, a = 1 },   -- #355791

    -- Green Shades
    Green50 = { r = 0.561, g = 0.698, b = 0.624, a = 1 },   -- #8fb28f
    Green100 = { r = 0.502, g = 0.659, b = 0.576, a = 1 },  -- #80a89a
    Green200 = { r = 0.443, g = 0.620, b = 0.529, a = 1 },  -- #719e86
    Green300 = { r = 0.384, g = 0.682, b = 0.482, a = 1 },  -- #62ae7b
    Green400 = { r = 0.325, g = 0.643, b = 0.435, a = 1 },  -- #53a480
    Green500 = { r = 0.267, g = 0.604, b = 0.388, a = 1 },  -- #439a63
    Green600 = { r = 0.208, g = 0.565, b = 0.341, a = 1 },  -- #359155
    Green700 = { r = 0.149, g = 0.525, b = 0.294, a = 1 },  -- #27864b
    Green800 = { r = 0.090, g = 0.486, b = 0.247, a = 1 },  -- #176f3f

    -- Red Shades
    Red500 = { r = 0.937, g = 0.267, b = 0.267, a = 1 },    -- #ef4444
    Red550 = { r = 0.4, g = 0.1, b = 0.1, a = 1 },   -- #cc3333
    Red600 = { r = 0.404, g = 0.1, b = 0.1, a = 1 },
    Red700 = { r = 0.725, g = 0.110, b = 0.110, a = 1 },    -- #b91c1c
}

local BackDrop = {
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = false,
    tileSize = 16,
    edgeSize = 4,
    insets = {
        left = 1,
        right = 1,
        top = 1,
        bottom = 1
    }
}

-------------------------------------------------------------------------------
-- Main Frame {{{
-------------------------------------------------------------------------------

function MBS.MainFrame:CreateMainFrame()

    MBS_DefaultFrameTemplate(self)
    MBS_CreateSummonList(self.TitleBackground)
end

-------------------------------------------------------------------------------
-- Helper Functions {{{
-------------------------------------------------------------------------------

function MBS_ResetFramePosition(Frame)
    if not Frame then return end

    Frame:ClearAllPoints()
    Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    Frame:Hide()
end

function MBS_SetBackdropColor(Frame, Color)
    if not Frame or not Color then return end
    Frame:SetBackdropColor(MBS_GetColorValue(Color))
    Frame:SetBackdropBorderColor(MBS_GetColorValue(Color))
end

function MBS_SetSize(Frame, Width, Height)
    if not Frame or not Width or not Height then return end
    Frame:SetWidth(Width)
	Frame:SetHeight(Height)
    Frame:SetPoint("CENTER", 0, 0)
end

function MBS_GetColorValue(colorKey)
    return ColorPicker[colorKey].r, ColorPicker[colorKey].g, ColorPicker[colorKey].b, ColorPicker[colorKey].a
end

function MBS_DefaultFrameTemplate(Frame)
    local IsMoving = false

    Frame:SetFrameStrata("LOW")
    Frame:SetBackdrop(BackDrop)
    Frame:SetMovable(true)
    Frame:EnableMouse(true)
    MBS_SetSize(Frame, 100, 180)
    MBS_SetBackdropColor(Frame, "Gray850")

    local TitleBackground = CreateFrame("Button", nil, Frame)
    TitleBackground:SetBackdrop(BackDrop)
    TitleBackground:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    MBS_SetBackdropColor(TitleBackground, "Gray800")
    TitleBackground:SetPoint("TOPLEFT", Frame, "TOPLEFT", 0, 0)
    TitleBackground:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", 0, -25)
    Frame.TitleBackground = TitleBackground

    local Title = TitleBackground:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    Title:SetText("MoronBoxSummon")
    Title:SetPoint("CENTER", TitleBackground, "CENTER", 0, 0)
    TitleBackground.Title = Title

    local function Frame_OnMouseUp()
        if IsMoving then
            Frame:StopMovingOrSizing()
            IsMoving = false
        end
    end

    local function Frame_OnMouseDown()
        if not IsMoving and arg1 == "LeftButton" then
            Frame:StartMoving()
            IsMoving = true
        end
    end

    Frame:SetScript("OnMouseUp", Frame_OnMouseUp)
    Frame:SetScript("OnMouseDown", Frame_OnMouseDown)
    Frame:SetScript("OnHide", Frame_OnMouseUp)
    TitleBackground:SetScript("OnMouseUp", Frame_OnMouseUp)
    TitleBackground:SetScript("OnMouseDown", Frame_OnMouseDown)
    TitleBackground:SetScript("OnHide", Frame_OnMouseUp)

    TitleBackground:SetScript("OnEnter", function()
        MBS_SetBackdropColor(TitleBackground, "Red600")
    end)

    TitleBackground:SetScript("OnLeave", function()
        MBS_SetBackdropColor(TitleBackground, "Gray800")
    end)

    TitleBackground:SetScript("OnClick", function()
        if arg1 == "RightButton" then
            Frame:Hide()
        end
    end)

    Frame:Hide()
end

function MBS_CreateSummonTemplate(Name, Parent)

    local SummonButton = CreateFrame("Button", Name, Parent)
    SummonButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    SummonButton:SetBackdrop(BackDrop)
    MBS_SetSize(SummonButton, 100, 20)
    MBS_SetBackdropColor(SummonButton, "Transparent")

    local Overlay = SummonButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    Overlay:SetText("Name")
    Overlay:SetPoint("CENTER", SummonButton, "CENTER")
    SummonButton.Overlay = Overlay

    SummonButton:SetScript("OnClick", function()
        if SummonButton.UnitID then
            MBS_ListItemOnClick(arg1, SummonButton.UnitID)
        end
    end)

    SummonButton:SetScript("OnEnter", function()
        MBS_SetBackdropColor(SummonButton, "Gray500")
    end)

    SummonButton:SetScript("OnLeave", function()
        MBS_SetBackdropColor(SummonButton, "Transparent")
    end)

    SummonButton:Hide()
    return SummonButton
end

function MBS_CreateSummonListItem(Parent, Name, RelativeTo)
    local listItem = MBS_CreateSummonTemplate(Name, Parent)
    listItem:SetPoint("TOPLEFT", RelativeTo, "BOTTOMLEFT", 0, 0)
    return listItem
end

function MBS_CreateSummonList(Parent)
    if not Parent then return end

    local SummonList = CreateFrame("Frame", "MoronBoxSummonPlayerListFrame", Parent)
    MBS_SetSize(SummonList, 100, 1)
    SummonList:SetPoint("TOP", Parent, "BOTTOM", 0, 0)
    Parent.SummonList = SummonList

    for i = 1, MBS.Session.Max_Amount_Shown do
        local PreviousItem = i == 1 and SummonList or SummonList["ListItem"..(i - 1)]
        local Item = MBS_CreateSummonListItem(SummonList, "$parentListItem"..i, PreviousItem)
        SummonList["ListItem"..i] = Item
    end

    return SummonList
end
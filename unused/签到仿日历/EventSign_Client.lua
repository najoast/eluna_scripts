
local AIO = AIO or require("AIO")

if AIO.AddAddon() then
    return
end

local EventSignHandlers = AIO.AddHandlers("EventSignStore", {})

local DayButtons = {}
local DayStrings = {}

local EventSignFrame = CreateFrame("Frame", "EventSignFrame", UIParent)
EventSignFrame:SetSize(480, 480)
EventSignFrame:RegisterForDrag("LeftButton")
EventSignFrame:SetPoint("CENTER")
EventSignFrame:SetToplevel(true)
EventSignFrame:SetClampedToScreen(true)
EventSignFrame:SetMovable(true)
EventSignFrame:EnableMouse(true)
EventSignFrame:SetScript("OnDragStart", EventSignFrame.StartMoving)
EventSignFrame:SetScript("OnHide", EventSignFrame.StopMovingOrSizing)
EventSignFrame:SetScript("OnDragStop", EventSignFrame.StopMovingOrSizing)
EventSignFrame:SetBackdrop(
{
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

EventSignFrame:EnableMouseWheel(true)

tinsert(UISpecialFrames, "EventSignFrame")

EventSignFrame:Hide()

-- 初始框
local EventSignFrameMin = CreateFrame("Button", "EventSignFrameMin", UIParent)
EventSignFrameMin:SetSize(64, 64)
EventSignFrameMin:SetPoint("CENTER", 600, -280)
EventSignFrameMin:SetMovable(true)
EventSignFrameMin:EnableMouse(true)
EventSignFrameMin:RegisterForDrag("LeftButton")
EventSignFrameMin:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
EventSignFrameMin:SetBackdrop({bgFile = "Interface\\Icons\\Inv_Misc_Tournaments_banner_Nightelf"})
EventSignFrameMin:SetScript("OnDragStart", EventSignFrameMin.StartMoving)
EventSignFrameMin:SetScript("OnDragStop", EventSignFrameMin.StopMovingOrSizing)
EventSignFrameMin:SetScript("OnMouseUp", 
function(self)
    if (EventSignFrame:IsShown()) then
        EventSignFrame:Hide()
    else
        EventSignFrame:Show()
    end
end)

EventSignFrameMin:SetScript("OnEnter", 
    function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip.default = 1
        GameTooltip:SetText("|cFFFF0033签到奖励|r\n|cFFFFCC66按住拖动图标|r\n|cFF99FF33单击打开功能|r\n|cFF00CCFF再次单击关闭|r\n|cFF00CCFF按 Esc 键退出|r")
        GameTooltip:Show()
    end)

EventSignFrameMin:SetScript("OnLeave", 
    function(self)
        GameTooltip:Hide()
    end)

EventSignFrameMin:Show()

-- 关闭按钮
local EventSignFrameClose = CreateFrame("Button", "EventSignFrameClose", EventSignFrame, "UIPanelCloseButton")
EventSignFrameClose:SetPoint("TOPRIGHT", 15, 15)
EventSignFrameClose:EnableMouse(true)
EventSignFrameClose:SetSize(36, 36)

-- 标题模块
local EventSignTitle = CreateFrame("Frame", "EventSignTitle", EventSignFrame, nil)
EventSignTitle:SetSize(150, 30)
EventSignTitle:SetPoint("TOP", 0, 25)
EventSignTitle:EnableMouse(true)
EventSignTitle:SetBackdrop(
{
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

--标题模块文字描述
local EventSignTitleText = EventSignTitle:CreateFontString("EventSignTitleText")
EventSignTitleText:SetFont("Interface\\Fonts\\FRIZQT_.TTF", 18)
EventSignTitleText:SetPoint("CENTER", 0, 0)
EventSignTitleText:SetText("|cffFFC125签到奖励|r")

--年份文字
local SignYearText = EventSignFrame:CreateFontString("SignYearText")
SignYearText:SetFont("Interface\\Fonts\\FRIZQT_.TTF", 18)
SignYearText:SetPoint("TOPLEFT", 108, -28)

-- 月份选项左
local EventSignMonthButtonLeft = CreateFrame("Button", "EventSignMonthButtonLeft", EventSignFrame)
EventSignMonthButtonLeft:SetSize(30, 30)
EventSignMonthButtonLeft:SetPoint("TOPLEFT", 200, -20)
EventSignMonthButtonLeft:EnableMouse(true)
EventSignMonthButtonLeft:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
EventSignMonthButtonLeft:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
EventSignMonthButtonLeft:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
EventSignMonthButtonLeft:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")

-- 月份选项右
local EventSignMonthButtonRight = CreateFrame("Button", "EventSignMonthButtonRight", EventSignFrame)
EventSignMonthButtonRight:SetSize(30, 30)
EventSignMonthButtonRight:SetPoint("TOPLEFT", 320, -20)
EventSignMonthButtonRight:EnableMouse(true)
EventSignMonthButtonRight:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
EventSignMonthButtonRight:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
EventSignMonthButtonRight:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
EventSignMonthButtonRight:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")

-- 中间月份
local EventSignMonthButtonCenter = CreateFrame("Button", "EventSignMonthButtonCenter", EventSignFrame)
EventSignMonthButtonCenter:SetSize(94, 28)
EventSignMonthButtonCenter:SetPoint("TOPLEFT", 228, -20)
EventSignMonthButtonCenter:EnableMouse(true)
EventSignMonthButtonCenter:SetBackdrop(
{
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

-- 月份说明
local ButtonCenterStr  = EventSignMonthButtonCenter:CreateFontString("ButtonCenterStr")
ButtonCenterStr:SetFont("Interface\\Fonts\\FRIZQT_.TTF", 15)
ButtonCenterStr:SetPoint("CENTER")

-- 星期1-7
local SignWeekday1 = CreateFrame("Button", "SignWeekday1", EventSignFrame)
local SignWeekday2 = CreateFrame("Button", "SignWeekday2", EventSignFrame)
local SignWeekday3 = CreateFrame("Button", "SignWeekday3", EventSignFrame)
local SignWeekday4 = CreateFrame("Button", "SignWeekday4", EventSignFrame)
local SignWeekday5 = CreateFrame("Button", "SignWeekday5", EventSignFrame)
local SignWeekday6 = CreateFrame("Button", "SignWeekday6", EventSignFrame)
local SignWeekday7 = CreateFrame("Button", "SignWeekday7", EventSignFrame)

local WeekdayStr1  = SignWeekday1:CreateFontString("WeekdayStr1")
local WeekdayStr2  = SignWeekday2:CreateFontString("WeekdayStr2")
local WeekdayStr3  = SignWeekday3:CreateFontString("WeekdayStr3")
local WeekdayStr4  = SignWeekday4:CreateFontString("WeekdayStr4")
local WeekdayStr5  = SignWeekday5:CreateFontString("WeekdayStr5")
local WeekdayStr6  = SignWeekday6:CreateFontString("WeekdayStr6")
local WeekdayStr7  = SignWeekday7:CreateFontString("WeekdayStr7")

for i=1,7,1 do
    _G["SignWeekday"..i]:SetSize(60, 30)
	_G["SignWeekday"..i]:SetPoint("TOPLEFT", (i - 1) * 60 + 30, -60)
	_G["SignWeekday"..i]:SetBackdrop(
    {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
	_G["SignWeekday"..i]:SetHighlightTexture("Interface\\Buttons\\UI-QuickslotRed")
	
	_G["WeekdayStr"..i]:SetFont("Interface\\Fonts\\FRIZQT_.TTF", 15)
	_G["WeekdayStr"..i]:SetPoint("CENTER")
end

for i=1,42,1 do
    DayButtons[i] = CreateFrame("Button", "DayButton"..i, EventSignFrame)
	--DayButtons[i]:SetID(i)
	DayButtons[i]:SetSize(60, 60)
	if (i < 8) then
	    DayButtons[i]:SetPoint("TOPLEFT", (i - 1) * 60 + 30, -90)
	elseif (i > 7 and i < 15) then
	    DayButtons[i]:SetPoint("TOPLEFT", (i - 7 - 1) * 60 + 30, -150)
	elseif (i > 14 and i < 22) then
	    DayButtons[i]:SetPoint("TOPLEFT", (i - 14 - 1) * 60 + 30, -210)
    elseif (i > 21 and i < 29) then
	    DayButtons[i]:SetPoint("TOPLEFT", (i - 21 - 1) * 60 + 30, -270)
	elseif (i > 28 and i < 36) then
	    DayButtons[i]:SetPoint("TOPLEFT", (i - 28 - 1) * 60 + 30, -330)
    else
	    DayButtons[i]:SetPoint("TOPLEFT", (i - 35 - 1) * 60 + 30, -390)
	end
	
	DayButtons[i]:SetBackdrop(
    {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
	DayButtons[i]:SetHighlightTexture("Interface\\Buttons\\UI-Quickslot-Depress")
	
	DayButtons[i]:SetScript("OnClick",
    function(self)
	    DayButtons[i]:UnlockHighlight()
	    if (tonumber(DayStrings[i]:GetText()) == tonumber(date("%d"))) then
		    DayButtons[i]:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-Button-Overlay")
	        DayButtons[i]:LockHighlight()
			print("调试 签到"..i)
		end
    end)
	
	DayButtons[i]:SetScript("OnEnter", 
    function(self)
	    for k=1,7,1 do
		    if ((i - k) % 7 == 0) then
				_G["SignWeekday"..k]:LockHighlight()
			end
		end
    end)

    DayButtons[i]:SetScript("OnLeave", 
    function(self)
	    for p=1,7,1 do
		    if ((i - p) % 7 == 0) then
		        _G["SignWeekday"..p]:UnlockHighlight()
			end
		end
    end)
	
	DayStrings[i] = DayButtons[i]:CreateFontString("DayString"..i)
	DayStrings[i]:SetPoint("CENTER")
	DayStrings[i]:SetFont("Interface\\Fonts\\FRIZQT_.TTF", 24)
end

WeekdayStr1:SetText("|cFFFF9900周日|r")
WeekdayStr2:SetText("|cFFFF9900周一|r")
WeekdayStr3:SetText("|cFFFF9900周二|r")
WeekdayStr4:SetText("|cFFFF9900周三|r")
WeekdayStr5:SetText("|cFFFF9900周四|r")
WeekdayStr6:SetText("|cFFFF9900周五|r")
WeekdayStr7:SetText("|cFFFF9900周六|r")

local Clicks = 0
local _, MaxMonth, _, MaxYear = CalendarGetMaxDate()
local _, MinMonth, _, MinYear = CalendarGetMinDate()

EventSignFrame:SetScript("OnShow", 
function(self)
    Clicks = 0
	UpdateDayEvent(Clicks)
end)

EventSignMonthButtonLeft:SetScript("OnClick",
function(self)
	Clicks = Clicks - 1
	UpdateDayEvent(Clicks)
end)

EventSignMonthButtonRight:SetScript("OnClick",
function(self)
    Clicks = Clicks + 1
	UpdateDayEvent(Clicks)
end)

function UpdateDayEvent(NowClick)
    local PreMonth, PreYear, PreNumDays, PreFirstWeekday = CalendarGetMonth(NowClick - 1)
    local Month, Year, NumDays, FirstWeekday = CalendarGetMonth(NowClick)
	local NextMonth, NextYear, NextNumDays, NextFirstWeekday = CalendarGetMonth(NowClick + 1)
	
	local PreFirstDay = PreNumDays - (FirstWeekday - 1)
	local NextFirstDay = NumDays + FirstWeekday - 1
	local FirstDay = FirstWeekday - 1
	
	
    SignYearText:SetText("|cFF00FF00"..Year.."年|r")
	ButtonCenterStr:SetText("|cFFFFFF00"..Month.."月|r")
	
	if (NowClick < 0) then
	    if (EventSignMonthButtonLeft:IsEnabled() == 0) then
            EventSignMonthButtonLeft:Enable()
	    end
	elseif(NowClick > 0) then
	    if (EventSignMonthButtonRight:IsEnabled() == 0) then
            EventSignMonthButtonRight:Enable()
	    end
	else
	    EventSignMonthButtonLeft:Enable()
	    EventSignMonthButtonRight:Enable()
	end
	
	if (Year <= MinYear and Month == MinMonth) then
	    EventSignMonthButtonLeft:Disable()
	end
	
	if (Year >= MaxYear and Month == MaxMonth) then
	    EventSignMonthButtonRight:Disable()
	end
	
	for i=1,42,1 do
	    DayButtons[i]:UnlockHighlight()
		DayStrings[i]:SetVertexColor(204/255, 204/255, 204/255)
		DayStrings[i]:SetAlpha(0.5)
		if (i < FirstWeekday) then
		    DayStrings[i]:SetText(tostring(i + PreFirstDay))
		elseif (i > NextFirstDay) then
		    DayStrings[i]:SetText(tostring(i - NextFirstDay))
		else
			DayStrings[i]:SetVertexColor(0, 255/255, 0)
			DayStrings[i]:SetAlpha(1)
			DayStrings[i]:SetText(tostring(i - FirstDay))
			if (tonumber(DayStrings[i]:GetText()) == tonumber(date("%d")) and NowClick == 0) then
		        DayButtons[i]:SetHighlightTexture("Interface\\Buttons\\UI-Button-Outline")
	            DayButtons[i]:LockHighlight()
		    end
		end
	end
end












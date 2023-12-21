print(">>Script: New Character Created for DeathKnight.")

----------------------------------------------
---------------- 常量定义 --------------------

local TELE_TO_GM_MODE   = 1 --传送到GM模式
local ITEM_HEARTHSTONE  = 6948 --炉石

-- 职业
local CLASS_DEATHKNIGHT = 6 --死亡骑士

-- 种族
local RACE_HUMAN        = 1  --人类
local RACE_ORC          = 2  --兽人
local RACE_DWARF        = 3  --矮人
local RACE_NIGHT_ELF    = 4  --暗夜精灵
local RACE_UNDEAD       = 5  --亡灵
local RACE_TAUREN       = 6  --牛头人
local RACE_GNOME        = 7  --侏儒
local RACE_TROLL        = 8  --巨魔
local RACE_BLOOD_ELF    = 10 --血精灵
local RACE_DRAENEI      = 11 --德莱尼

----------------------------------------------
-------------------- 配置 --------------------

-- 不同种族共享的任务
local SHARED_QUESTS = {
    12800,12801,12738,12679,12680,12619,12751,12754,12755,12756,
    12757,12697,12698,12700,12701,12641,12706,12778,12714,12715,
    12779,13165,13166,12719,12720,12593,12722,12723,12724,12725,
    12657,12727,12842,12687,12636,12850,12848,12733,12670,12678,
}

-- 种族特有的任务
local RACE_QUESTS = {
    [RACE_HUMAN]     = {12742,13188},--人类
    [RACE_ORC]       = {12748,13189},--兽人
    [RACE_DWARF]     = {12744,13188},--矮人
    [RACE_NIGHT_ELF] = {12743,13188},--暗夜精灵
    [RACE_UNDEAD]    = {12750,13189},--亡灵
    [RACE_TAUREN]    = {12739,13189},--牛头人
    [RACE_GNOME]     = {12745,13188},--侏儒
    [RACE_TROLL]     = {12749,13189},--巨魔
    [RACE_BLOOD_ELF] = {12747,13189},--血精灵
    [RACE_DRAENEI]   = {12746,13188},--德莱尼
}

----------------------------------------------
-------------------- 代码 --------------------

local function AutoCompleteQuests(player, quests)
    if not player or not quests then
        return
    end
    for _, questId in pairs(quests) do
        player:AddQuest(questId)                  --接受任务
        player:CompleteQuest(questId)             --完成任务
        player:RewardQuest(questId)               --获得任务奖励
    end
end

local function DeathKnightAutoCompleteBornTask(_, player)
    local class = player:GetClass() --判断职业
    if class ~= CLASS_DEATHKNIGHT then
        return
    end

    -- 添加炉石
    player:AddItem(ITEM_HEARTHSTONE)
    -- 完成任务
    AutoCompleteQuests(player, SHARED_QUESTS) --完成共享任务
    AutoCompleteQuests(player, RACE_QUESTS[player:GetRace()]) --完成种族特定任务
    -- 传送到达拉然
    player:Teleport(571, 5809.55, 503.975, 657.526, 2.38338, TELE_TO_GM_MODE)
end

RegisterPlayerEvent(30, DeathKnightAutoCompleteBornTask) --玩家首次登录 PLAYER_EVENT_ON_FIRST_LOGIN

--[[
local questCount = {}
for _, v in pairs(QUEST) do
    for _, q in pairs(v) do
        questCount[q] = (questCount[q] or 0) + 1
    end
end

local sharedQuests = {}
for q, c in pairs(questCount) do
    if c >= 10 then
        table.insert(sharedQuests, q)
    end
end

print(table.concat(sharedQuests, ","))

local sharedQuestMap = {}
for _, questId in pairs(sharedQuests) do
    sharedQuestMap[questId] = true
end

for k, v in pairs(QUEST) do
    local newQuests = {}
    for _, q in pairs(v) do
        if not sharedQuestMap[q] then
            table.insert(newQuests, q)
        end
    end
    QUEST[k] = newQuests
end

-- print new QUEST
for k, v in pairs(QUEST) do
    print(k, table.concat(v, ","))
end
]]

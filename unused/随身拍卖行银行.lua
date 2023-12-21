print(">>Script: BANK&AH by Mojito -------------OK")

--[[ 执行下面的SQL语句，在角色库生成一个表
     表里的内容为允许使用随身银行和随身拍卖行的账号 
	 只要在accountID里填上账号id就可以了。

   DROP TABLE IF EXISTS `premium`;
   CREATE TABLE `premium` (
    `AccountId` int(11) unsigned NOT NULL,
   `active` int(11) unsigned NOT NULL default '1'
    ) ENGINE=MyISAM DEFAULT CHARSET=latin1;
]] --

local function PremiumOnLogin(event, player)  -- 发送一条信息告诉玩家是否可使用随身银行随身拍卖行
    local result = CharDBQuery("SELECT AccountId FROM premium WHERE active=1 and AccountId = "..player:GetAccountId())
    if (result) then
        player:SendBroadcastMessage("|CFFE55BB0[MOJITO]|r|CFFFE8A0E 欢迎你 "..player:GetName().." 你可以使用随身银行和随身拍卖行，命令为 #AH  |r")
    else
        player:SendBroadcastMessage("|CFFE55BB0[MOJITO]|r|CFFFE8A0E 欢迎你 "..player:GetName().." 你无法使用随身银行和随身拍卖行! |r")
    end
end

local function PremiumOnChat(event, player, msg, _, lang)
    local result = CharDBQuery("SELECT AccountId FROM premium WHERE active=1 and AccountId = "..player:GetAccountId())
    if (msg == "#AH") then  -- Use #premium for sending the gossip menu
        if (result) then
            OnPremiumHello(event, player)
        else
            player:SendBroadcastMessage("|CFFE55BB0[MOJITO]|r|CFFFE8A0E 抱歉 "..player:GetName().." 你无法使用随身银行和随身拍卖行! |r")
        end
    end
end

function OnPremiumHello(event, player)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "|TInterface\\ICONS\\INV_Misc_EngGizmos_19.blp:30|t 使用随身银行", 0, 3)
    player:GossipMenuAddItem(0, "|TInterface\\ICONS\\Achievement_BG_overcome500disadvantage.blp:30|t 使用随身拍卖行", 0, 4)
    player:GossipMenuAddItem(0, "|TInterface\\ICONS\\Spell_Shadow_SacrificialShield.blp:30|t 关闭菜单", 0, 1)
    -- Room for more premium things
    player:SendBroadcastMessage("|CFFFF0303欢迎使用随身银行&拍卖行系统！， "..player:GetName().."|r")
    player:GossipSendMenu(0x7FFFFFFF, player, 100)
end

function OnPremiumSelect(event, player, _, sender, intid, code)
    if (intid == 1) then                     -- 关闭菜单
        player:GossipComplete()
    elseif (intid == 2) then                 -- 返回主菜单
        OnPremiumHello(event, player)
    elseif (intid == 3) then                 -- 显示银行
        player:SendShowBank(player)
    elseif (intid == 4) then                 -- 显示拍卖行
        player:SendAuctionMenu(player)
    end
    -- Room for more premium things
end

RegisterPlayerEvent(3, PremiumOnLogin)              -- 玩家登陆
RegisterPlayerEvent(18, PremiumOnChat)              -- 使用命令 #AH
RegisterPlayerGossipEvent(100, 2, OnPremiumSelect)  -- 菜单功能
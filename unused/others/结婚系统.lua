---by 有爱 ljq5555
---by:ayase 消耗物品或者金币的lua(世界聊天)
CharDBExecute(
    [[
        CREATE TABLE IF NOT EXISTS `_player_marry` (
            `Unmarry` int(11) DEFAULT NULL,
            `marry1` bigint(20) DEFAULT NULL,
            `marry2` bigint(20) DEFAULT NULL,
            `Smarry` bigint(20) DEFAULT NULL,
            `marrylevel` int(11) DEFAULT NULL
          ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]
)
CharDBExecute(
    [[
        CREATE TABLE IF NOT EXISTS `_player_marryb` (
            `marry1` bigint(20) DEFAULT NULL,
            `marry1name` varchar(50) DEFAULT NULL,
            `marry1class` varchar(50) DEFAULT NULL,
            `marry1zz` varchar(50) DEFAULT NULL,
            `marry1zy` varchar(50) DEFAULT NULL,
            `marry2zy` varchar(50) DEFAULT NULL,
            `marry2` bigint(20) DEFAULT NULL,
            `marry2zz` bigint(20) DEFAULT NULL,
            `marry2name` varchar(50) DEFAULT NULL,
            `marry2class` varchar(50) DEFAULT NULL
          ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]
)
----自动加入工会
local guildid = {
    --自动加入的工会名称
    [0] = '客官不可以自撸要撸我帮你',
    [1] = '客官不可以自撸要撸我帮你'
}
---------------------世界聊天配置----------------------------------
local marry = {}
marry.itemid = 21829
marry.ItemEntry = 0 --需要物品id(如果物品id为0，则需求金币，下面的数量变为需求的铜币数量)
marry.ItemCount = 0 --需要物品数量
marry.Command = 'sj ' --使用世界聊天的命令 sj(有空格)  则游戏命令为 .sj(空格)要说的话 当然没空格也行 没那么好看而已
marry.Color = '|cFFF08000' --世界聊天字体颜色
marry.TimeSetting = '' --时间的格式设置 %Y-%m-%d %H:%M:%S  对应显示为 2015-06-03 16:44:48 自己对号入座设置哈 留空就是不显示
marry.TeamName = {[0] = '|cFF0070d0联盟|r', [1] = '|cFFF000A0部落|r'}
marry.ClassName = {
    [1] = '|cffC79C6E', --战士
    [2] = '|cffF58CBA', --圣骑士
    [3] = '|cffABD473', --猎人
    [4] = '|cffFFF569', --盗贼
    [5] = '|cffFFFFFF', --牧师
    [6] = '|cffC41F3B', --死亡骑士
    [7] = '|cff2459FF', --萨满
    [8] = '|cff69CCF0', --法师
    [9] = '|cff9482C9', --术士
    [11] = '|cffFF7D0A' --德鲁伊
}
------------------结婚系统配置---------------------------------
marry.servername = '|CFFE55BB0[天丫魔兽]|r'
 ---服务器名称
marry.name = '姻缘殿'
marry.marryClassName = {
    [1] = '战士',
    [2] = '圣骑',
    [3] = '猎人',
    [4] = '盗贼',
    [5] = '牧师',
    [6] = '死骑',
    [7] = '萨满',
    [8] = '法师',
    [9] = '术士',
    [11] = '小德'
}
marry.unmarryid = 65136
--离婚使用的道具
marry.unmarrycount = 1
--离婚需要的数量
marry.hfgxid = 65136
--恢复关系需要的道具
marry.hfgxcount = 3
--恢复关系需要的道具
marry.marrytoid = 65136
--求婚需要的道具
marry.marrytocount = 5
--求婚需要的数量
marry.marryd = {}
marry.levelname = {
    --称号
    [1] = '|cFF7DBEF1珠|r|cFF64A5F4联|r|cFF4B8CF7璧|r|cFF3273F9合|r',
    [2] = '|cFFFE9FD8比|r|cFFCB8CE0翼|r|cFF9879E8双|r|cFF6667EF飞|r',
    [3] = '|cFFFFCCFF情|r|cFFCCB0FF比|r|cFF9994FF金|r|cFF6679FF坚|r'
}
marry.levelID = {
    --升级使用的物品ID
    [1] = 65136,
    [2] = 65136
}
marry.levelcount = {
    --升级使用的物品数量
    [1] = 4,
    [2] = 10
}
marry.levelexp = {
    --单次升级经验
    [1] = 1,
    [2] = 1
}

marry.level = {
    --等级经验
    [1] = 0,
    [2] = 100,
    [3] = 249
}
marry.levelspell = {
    --等级附带技能
    [1] = 521108,
    [2] = 521109,
    [3] = 521110
}
marry.levelitem = {
    --等级奖励的物品 为0则是不启用
    [1] = 0,
    [2] = 0,
    [3] = 0
}
----------------------配置结束------------------
function marry._Money(Money)
    local G = math.floor(Money / 10000)
    local Y = math.floor((Money - G * 10000) / 100)
    local T = math.floor(Money - G * 10000 - Y * 100)
    return string.format('%s金%s银%s铜', G, Y, T)
end
function marry.getlevelname(playerID)
    local marryed = '|cFFFFFAFA单身狗|r'
    local text =
        CharDBQuery(
        'select marry1,marry2,marrylevel  from _player_marry a where a.marry1 =' ..
            playerID .. ' or a.marry2 =' .. playerID
    )

    if (text) then
        local level = text:GetString(2) + 0
        if (level >= marry.level[3]) then
            marryed = marry.levelname[3]
        elseif (level >= marry.level[2]) then
            marryed = marry.levelname[2]
        else
            marryed = marry.levelname[1]
        end
    end
    return marryed
end
function marry.ChatEvent(_, p, comm)
    if string.find(comm, marry.Command) then
        local check = true
        if marry.ItemEntry > 0 and marry.ItemCount ~= 0 then
            if p:HasItem(marry.ItemEntry, marry.ItemCount) == false then
                check = false
                p:SendBroadcastMessage(
                    '使用世界聊天每次需要消耗' .. GetItemLink(marry.ItemEntry) .. ' x ' .. marry.ItemCount .. '。'
                )
                return false
            end
        elseif marry.ItemEntry == 0 and marry.ItemCount ~= 0 then
            if p:GetCoinage() <= marry.ItemCount then
                check = false
                p:SendBroadcastMessage('使用世界聊天每次需要消耗' .. marry._Money(marry.ItemCount) .. '。')
                return false
            end
        end
        if check == true then
            local _time = os.date(marry.TimeSetting, os.time())
            local team = marry.TeamName[p:GetTeam()]
            local class = marry.ClassName[p:GetClass()]
            local lv = p:GetLevel()
            local name = p:GetName()
            local Gender = '|cFF00FF99男|r-'
            if (p:GetGender() == 1) then
                Gender = '|cFFCC0000女|r-'
            end
            local playerID = tostring(p:GetGUID())
            local marryed = marry.getlevelname(playerID)
            local color = marry.Color
            local say = string.gsub(comm, marry.Command, '')
            local MSG =
                string.format(
                '|cFF00CCFF%s|r[|cFF009933世|r][%s][%s%s:%s|r][%s]说:%s%s|r',
                _time,
                team,
                class,
                lv,
                name,
                Gender .. marryed,
                color,
                say
            )
            if marry.ItemEntry > 0 and marry.ItemCount ~= 0 then
                p:RemoveItem(marry.ItemEntry, marry.ItemCount)
            elseif marry.ItemEntry == 0 and marry.ItemCount ~= 0 then
                p:ModifyMoney(-marry.ItemCount)
            end
            SendWorldMessage(MSG)
            return false
        end
    end
end
function marry.Tele_Book1(event, player, item)
    player:MoveTo(0, player:GetX() + 0.01, player:GetY(), player:GetZ())
    if (player:IsInCombat() == true) then
        player:SendAreaTriggerMessage('你不能在战斗中使用!')
    else
        marry.Tele_Menumarry(item, player)
    end
end
function CheckSpell(player, del, level)
    player:RemoveAura(marry.levelspell[1])
    player:RemoveAura(marry.levelspell[2])
    player:RemoveAura(marry.levelspell[3])

    if (del) then
    else
        local spellid = 0
        local spellname = ''
        if (level >= marry.level[3]) then
            spellid = marry.levelspell[3]
            spellname = marry.levelname[3]
        elseif (level >= marry.level[2]) then
            spellid = marry.levelspell[2]
            spellname = marry.levelname[2]
        else
            spellid = marry.levelspell[1]
            spellname = marry.levelname[1]
        end
        player:AddAura(spellid, player)
    end
end
function updatelevel(player, id, playerID)
    if (player:HasItem(marry.levelID[id], marry.levelcount[id])) then
        player:RemoveItem(marry.levelID[id], marry.levelcount[id])
        player:SendBroadcastMessage(
            '|cFF33CC33你失去了|r ' .. GetItemLink(marry.levelID[id]) .. ' |cFF33CC33x ' .. marry.levelcount[id] .. ' 个|r'
        )
        CharDBQuery(
            'update _player_marry set marrylevel=marrylevel+' ..
                marry.levelexp[id] .. ' where marry1 =' .. playerID .. ' or marry2 =' .. playerID
        )
        player:SendBroadcastMessage('亲密度增加成功，等级发生变化后再次点击即可生效')
        player:SendAreaTriggerMessage('亲密度增加成功，等级发生变化后再次点击即可生效')
    else
        player:SendBroadcastMessage(
            '对不起.你没有' .. GetItemLink(marry.levelID[id]) .. 'X' .. marry.levelcount[id] .. '.无法升级'
        )
        player:SendAreaTriggerMessage(
            '对不起.你没有' .. GetItemLink(marry.levelID[id]) .. 'X' .. marry.levelcount[id] .. '.无法升级'
        )
    end
end
function marry.unmarry(event, player, object, sender, intid, code)
    local playerID = tostring(player:GetGUID())
    player:RemoveItem(marry.unmarryid, marry.unmarrycount)
    player:SendBroadcastMessage(
        '|cFF33CC33你失去了|r ' .. GetItemLink(marry.unmarryid) .. ' |cFF33CC33x ' .. marry.unmarrycount .. ' 个|r'
    )
    CharDBQuery(
        'update _player_marry set  unmarry=1,smarry=' ..
            playerID .. ' where marry1 =' .. playerID .. ' or marry2 =' .. playerID
    )
    CheckSpell(player, true, 0)
    player:SendBroadcastMessage('你的请求已发送给对方,请等待对方同意')
    player:SendAreaTriggerMessage('你的请求已发送给对方,请等待对方同意')
end
function marry.tymarry(event, player, object, sender, intid, code)
end
function marry.hfgx(event, player, object, sender, intid, code)
    local playerID = tostring(player:GetGUID())
    player:RemoveItem(marry.hfgxid, marry.hfgxcount)
    player:SendBroadcastMessage(
        '|cFF33CC33你失去了|r ' .. GetItemLink(marry.hfgxid) .. ' |cFF33CC33x ' .. marry.hfgxcount .. ' 个|r'
    )
    CharDBQuery('update _player_marry set  unmarry=0 where smarry =' .. playerID)
    player:SendBroadcastMessage('关系已恢复，再次点击即可生效')
    player:SendAreaTriggerMessage('关系已恢复，再次点击即可生效')
end
function marry.marryto(event, player, object, sender, intid, code)
end
function marry.tyunmarry(event, player, object, sender, intid, code)
    local playerID = tostring(player:GetGUID())
    CharDBQuery('delete from  _player_marry  where marry1 =' .. playerID .. ' or marry2 =' .. playerID)
    CheckSpell(player, true, 0)
    SendWorldMessage(
        '|cFFE55AAF[|r|cFFBF56BC姻|r|cFF9952CA缘|r|cFF734DD7殿|r|cFF4C49E4]|r|cFF00FF99有|r|cFF00EEA2一|r|cFF00DCAC对|r|cFF00CBB5新|r|cFF00BABE人|r|cFF00A9C7感|r|cFF0097D1情|r|cFF0086DA破|r|cFF0075E3裂|r|cFF0064EC了|r' ..
            player:GetName() .. '|cFF00FF99恢|r|cFF00DFAA复|r|cFF00C0BB了|r|cFF00A0CC单|r|cFF0080DD身|r'
    )
end
function marry.Tele_Select1(event, player, item, sender, intid, code)
    if intid == 4 then
        if (player:HasItem(marry.marrytoid, marry.marrytocount)) then
            local marryid = tonumber(code)
            if (marryid == nil) then
                player:SendBroadcastMessage('请输入正确的账号！')
                player:GossipComplete()
                return true
            end

            if tostring(marryid) == tostring(player:GetGUID()) then
                player:SendBroadcastMessage('不可以向自己求婚哦！')
                player:GossipComplete()
                return true
            end
            local marryed = GetPlayerByGUID(marryid)
            player:GossipComplete()
            player:GossipClearMenu()
            if (marryed == nil) then
                --[[  player:GossipMenuAddItem(
                    30,
                    '求婚请求',
                    0,
                    1,
                    false,
                    '|TInterface/FlavorImages/BloodElfLogo-small:64:64:0:-30|t\n \n \n \n \n \n您求婚的玩家并不在线，您确定继续向[' ..
                        code .. ']求婚吗？'
                )]]
                player:SendBroadcastMessage('您求婚的玩家并不在线,请通知对方上线！')
                player:SendAreaTriggerMessage('您求婚的玩家并不在线,请通知对方上线！')
                return true
            else
                player:GossipMenuAddItem(
                    30,
                    '求婚请求',
                    0,
                    1,
                    false,
                    '|TInterface/FlavorImages/BloodElfLogo-small:64:64:0:-30|t\n \n \n \n \n \n您求婚的对象[' ..
                        marryed:GetName() .. ']在线，点击接受将直接发起浪漫求婚'
                )
            end
            -- player:GossipSendMenu(100, player, 1999)
            local playerID = tostring(player:GetGUID())
            player:RemoveItem(marry.marrytoid, marry.marrytocount)
            player:SendBroadcastMessage(
                '|cFF33CC33你失去了|r ' .. GetItemLink(marry.marrytoid) .. ' |cFF33CC33x ' .. marry.marrytocount .. ' 个|r'
            )
            CharDBQuery(
                'INSERT INTO `_player_marryb` (`marry1`, `marry1name`, `marry1zz`, `marry1zy`, `marry2`,`marry1class`,`marry2name`,`marry2zy`,`marry2class`,`marry2zz`) VALUES (' ..
                    playerID ..
                        ",'" ..
                            player:GetName() ..
                                "','" ..
                                    player:GetRace() ..
                                        "', '" ..
                                            marry.TeamName[player:GetTeam()] ..
                                                "', " ..
                                                    code ..
                                                        ",'" ..
                                                            marry.marryClassName[player:GetClass()] ..
                                                                "','" ..
                                                                    marryed:GetName() ..
                                                                        "','" ..
                                                                            marry.TeamName[marryed:GetTeam()] ..
                                                                                "', '" ..
                                                                                    marry.marryClassName[
                                                                                        marryed:GetClass()
                                                                                    ] ..
                                                                                        "','" ..
                                                                                            player:GetRace() .. "');"
            )

            player:SendBroadcastMessage('您的申请已提交，请等待对方同意')
            player:SendAreaTriggerMessage('您的申请已提交，请等待对方同意')
            marryed:SendBroadcastMessage('玩家【' .. player:GetName() .. '】向您求婚了，您的魅力好大哦')
            marryed:SendAreaTriggerMessage('玩家【' .. player:GetName() .. '】向您求婚了，您的魅力好大哦')
            SendWorldMessage(
                '|cFFE55AAF[|r|cFFBF56BC姻|r|cFF9952CA缘|r|cFF734DD7殿|r|cFF4C49E4]|r玩家[|cFFFF0000' ..
                    player:GetName() .. '|r]向心爱的[|cFFFF0000' .. marryed:GetName() .. '|r]求婚了，哦哇，好尼玛浪漫哦'
            )
            return true
        else
            player:SendBroadcastMessage('对不起.你没有' .. GetItemLink(marry.marrytoid) .. 'X' .. marry.marrytocount)
            player:SendAreaTriggerMessage('对不起.你没有' .. GetItemLink(marry.marrytoid) .. 'X' .. marry.marrytocount)
        end
    end
    if intid == 3 then
        local marryid = tonumber(code)
        if (marryid == nil) then
            player:SendBroadcastMessage('请输入正确的账号！')
            player:GossipComplete()
            return true
        end

        if tostring(marryid) == tostring(player:GetGUID()) then
            player:SendBroadcastMessage('不可以对自己操作哦！')
            player:GossipComplete()
            return true
        end
        local marryed = GetPlayerByGUID(marryid)
        player:GossipComplete()
        player:GossipClearMenu()
        local playerID = tostring(player:GetGUID())
        local text =
            CharDBQuery(
            'select a.marry1,a.marry1name ,a.marry1zz ,a.marry1zy ,a.marry1class  from _player_marryb a where a.marry2 =' ..
                playerID .. ' and marry1=' .. marryid
        )
        local zaixian = '在线'
        if (text) then
            if (marryed == nil) then
                zaixian = '不在线'
            end

            player:GossipMenuAddItem(
                30,
                '求婚请求',
                0,
                1,
                false,
                '|TInterface/FlavorImages/BloodElfLogo-small:64:64:0:-30|t\n \n \n \n \n \n像您求婚的对象[' ..
                    text:GetString(1) .. ']' .. zaixian .. '，点击接受后将同意他的求婚'
            )
            CharDBQuery('delete from  _player_marryb   where marry1 =' .. playerID .. ' or marry2 =' .. playerID)
            CharDBQuery(
                ' INSERT INTO `_player_marry` (`marry1`, `marry2`, `marrylevel`) VALUES ( ' ..
                    code .. ', ' .. playerID .. ', 0);'
            )

            SendWorldMessage(
                '|cFFE55AAF[|r|cFFBF56BC姻|r|cFF9952CA缘|r|cFF734DD7殿|r|cFF00FF99哇塞，' ..
                    player:GetName() .. '结婚了，真的令人羡慕哦，让我们恭喜他们吧，愿他们白头到老哦|r'
            )
            CheckSpell(player, false, 0)
            player:SendBroadcastMessage('您已经结婚了，恭喜哦，小退后可以领取结婚增益效果哦')
            player:SendAreaTriggerMessage('您已经结婚了，恭喜哦，小退后可以领取结婚增益效果哦')
            --  player:GossipSendMenu(100, player, 2003)
            return true
        else
            player:SendBroadcastMessage('[' .. marryid .. ']并未向您求婚，您自作多情了哦！')
            player:SendBroadcastMessage('[' .. marryid .. ']并未向您求婚，您自作多情了哦！')
        end
    end
    if intid == 13 then
        local playerID = tostring(player:GetGUID())
        local text =
            CharDBQuery(
            'select marry1,marry2,marrylevel  from _player_marry a where a.marry1 =' ..
                playerID .. ' or a.marry2 =' .. playerID
        )
        if (text) then
            local marryed = nil
            if (text:GetString(1) == playerID) then
                marryed = GetPlayerByGUID(text:GetString(0) + 0)
            else
                marryed = GetPlayerByGUID(text:GetString(1) + 0)
            end
            if (marryed == nil) then
                player:SendBroadcastMessage('您的爱人不在线哦')
                player:SendBroadcastMessage('您的爱人不在线哦')
            else
                player:Teleport(marryed:GetMapId(), marryed:GetX(), marryed:GetY(), marryed:GetZ(), marryed:GetO())
            end
        end
    end
    if intid == 14 then
        local playerID = tostring(player:GetGUID())
        local text =
            CharDBQuery(
            'select marry1,marry2,marrylevel  from _player_marry a where a.marry1 =' ..
                playerID .. ' or a.marry2 =' .. playerID
        )

        if (text) then
            local level = text:GetString(2) + 0
            if (level >= marry.level[3]) then
                player:SendBroadcastMessage('已经达到了最高等级')
            elseif (level >= marry.level[2]) then
                updatelevel(player, 2, playerID)
            else
                updatelevel(player, 1, playerID)
            end
        end
    end
    if intid == 15 then
        player:GossipComplete()
        player:GossipClearMenu()
        if (player:HasItem(marry.unmarryid, marry.unmarrycount)) then
            player:GossipMenuAddItem(30, '离婚请求', 3, 1, false, '您确认要解除和恋人的关系吗？')
            player:GossipSendMenu(100, player, 2001)
            return true
        else
            player:SendBroadcastMessage('对不起.你没有' .. GetItemLink(marry.unmarryid) .. 'X' .. marry.unmarrycount)
            player:SendAreaTriggerMessage('对不起.你没有' .. GetItemLink(marry.unmarryid) .. 'X' .. marry.unmarrycount)
        end
        player:GossipComplete()
    end
    if intid == 16 then
        player:GossipComplete()
        player:GossipClearMenu()
        if (player:HasItem(marry.hfgxid, marry.hfgxcount)) then
            player:GossipMenuAddItem(30, '求婚请求', 3, 1, false, '您需要恢复和恋人的关系吗？')
            player:GossipSendMenu(100, player, 2000)
            return true
        else
            player:SendBroadcastMessage('对不起.你没有' .. GetItemLink(marry.hfgxid) .. 'X' .. marry.hfgxcount)
            player:SendAreaTriggerMessage('对不起.你没有' .. GetItemLink(marry.hfgxid) .. 'X' .. marry.hfgxcount)
        end
    end
    if intid == 17 then
        player:GossipComplete()
        player:GossipClearMenu()
        player:GossipMenuAddItem(30, '离婚请求', 3, 1, false, '对方已提出解除关系请求，您同意吗？手续费由对方承担')
        player:GossipSendMenu(100, player, 2002)
        return true
    end
    if intid == 7 then
        local playerID = tostring(player:GetGUID())
        local text =
            CharDBQuery(
            'select a.marry1,a.marry1name ,a.marry1zz ,a.marry1zy ,a.marry1class  from _player_marryb a where a.marry2 =' ..
                playerID
        )
        local str = ''
        if (text) then
            repeat
                str =
                    'ID=' ..
                    text:GetString(0) .. ',' .. text:GetString(3) .. text:GetString(1) .. '-' .. text:GetString(4)
                player:GossipMenuAddItem(0, str, 0, text:GetString(0) + 20000)
            until not text:NextRow()
            player:GossipSendMenu(1, item)
        else
            player:SendBroadcastMessage('汗...没有人向你求婚！')
            player:SendAreaTriggerMessage('汗...没有人向你求婚！')
        end
        return true
    end
    if intid == 9 then
        local playerID = tostring(player:GetGUID())
        local text =
            CharDBQuery(
            'select a.marry2,a.marry2name ,a.marry2zz ,a.marry2zy ,a.marry2class from _player_marryb a where a.marry1 =' ..
                playerID
        )
        local str = ''
        local marryer = nil
        if (text) then
            repeat
                str =
                    'ID=' ..
                    text:GetString(0) .. ',' .. text:GetString(3) .. text:GetString(1) .. '-' .. text:GetString(4)
                player:GossipMenuAddItem(0, str, 0, text:GetString(0) + 20000)
                text:NextRow()
            until not text:NextRow()
            player:GossipSendMenu(1, item)
        else
            player:SendBroadcastMessage('你还没有向爱人表白哦！')
            player:SendAreaTriggerMessage('你还没有向爱人表白哦！')
        end
        return true
    end
    player:GossipComplete()
end
function marry.Tele_Menumarry(item, player) -- Home Page
    local Gender = '男'
    if (player:GetGender() == 1) then
        Gender = '女'
    end
    local playerID = tostring(player:GetGUID())

    player:GossipMenuAddItem(5, '|cFFFF0000------------------' .. marry.name .. '--------------------|r', 0, 998)
    local text =
        CharDBQuery(
        'select marry1,marry2,marrylevel,unmarry,smarry  from _player_marry a where a.marry1 =' ..
            playerID .. ' or a.marry2 =' .. playerID
    )
    CheckSpell(player, true, 0)
    if (text) then
        local marryed = nil
        if (text:GetString(3) == '1') then
            player:SendBroadcastMessage('您当前处于感情破裂阶段,无法享受BUFF增益')
            player:SendAreaTriggerMessage('您当前处于感情破裂阶段,无法享受BUFF增益')
        else
            CheckSpell(player, false, text:GetString(2) + 0)
        end
        if (text:GetString(1) == playerID) then
            marryed = GetPlayerByGUID(text:GetString(0) + 0)
        else
            marryed = GetPlayerByGUID(text:GetString(1) + 0)
        end
        if (marryed == nil) then
            player:GossipMenuAddItem(
                6,
                '|TInterface\\ICONS\\achievement_zone_zuldrak_05.blp:30|t |cff0000ff您的伴侣不在线',
                0,
                11
            )
        else
            player:GossipMenuAddItem(
                6,
                '|TInterface\\ICONS\\achievement_zone_zuldrak_05.blp:30|t |cff0000ff您的伴侣[' .. marryed:GetName() .. ']在线',
                0,
                11
            )
            player:GossipMenuAddItem(
                2,
                '|TInterface\\ICONS\\Achievement_Boss_PrinceKeleseth.blp:30|t |cff0000ff传送到您的爱人身边',
                0,
                13
            )
        end
        if (text:GetString(3) == '1') then
            if (text:GetString(4) == playerID) then
                player:GossipMenuAddItem(
                    2,
                    '|TInterface\\ICONS\\Achievement_Zone_Blackrock_01.blp:30|t |cFFFF0000您已发起离婚请求,点击此处可取消',
                    0,
                    16
                )
            else
                player:GossipMenuAddItem(
                    2,
                    '|TInterface\\ICONS\\Achievement_Zone_Blackrock_01.blp:30|t |cFFFF0000您的恋人向您发起离婚请求,点击此处处理',
                    0,
                    17
                )
            end
        else
            player:GossipMenuAddItem(
                2,
                '|TInterface\\ICONS\\Achievement_Zone_EasternKingdoms_01.blp:30|t |cFFFF0000您和伴侣的亲密度为[' ..
                    marry.getlevelname(playerID) .. ']-[' .. text:GetString(2) .. ']',
                0,
                12
            )

            player:GossipMenuAddItem(
                6,
                '|TInterface\\ICONS\\Achievement_Zone_IceCrown_01.blp:30|t |cff0000ff提升亲密度',
                0,
                14
            )
            player:GossipMenuAddItem(
                2,
                '|TInterface\\ICONS\\Achievement_Zone_IsleOfQuelDanas.blp:30|t |cFFFF0000解除婚约',
                0,
                15
            )
        end
    else
        player:GossipMenuAddItem(
            6,
            '|TInterface\\ICONS\\achievement_zone_zuldrak_05.blp:30|t |cff0000ff您暂无伴侣,您可以选择异性来结婚',
            0,
            1
        )
        player:GossipMenuAddItem(
            2,
            '|TInterface\\ICONS\\Achievement_Zone_EasternKingdoms_01.blp:30|t |cFFFF0000您是' ..
                Gender .. '性,求婚ID为' .. playerID,
            0,
            2
        )
        player:GossipMenuAddItem(
            2,
            '|TInterface\\ICONS\\Achievement_Zone_IceCrown_01.blp:30|t |cff0000ff发|r|cFF0041FF起|r|cFF1BE6B8求|r|cFF530080婚|r',
            0,
            4,
            true
        )
        player:GossipMenuAddItem(
            2,
            '|TInterface\\ICONS\\Achievement_Zone_IsleOfQuelDanas.blp:30|t |cFFFF0000向我求婚的人',
            0,
            7
        )
        player:GossipMenuAddItem(2, '|TInterface\\LFGFrame\\LFGIcon-TheForgeofSouls.blp:30|t |cff0000ff我求婚的人', 0, 9)
        player:GossipMenuAddItem(
            2,
            '|TInterface\\ICONS\\Achievement_Zone_IsleOfQuelDanas.blp:30|t |cFFFF0000同意某人的求婚',
            0,
            3,
            true
        )
    end
    player:GossipSendMenu(1, item)
end

function MarryOnLogin(event, player)
    if not player:IsInGuild() then
        local newguild = GetGuildByName(guildid[player:GetTeam()])
        if newguild == nil then
        else
            newguild:AddMember(player, 1)
        end
    end
    if player:HasItem(marry.itemid, 1) then
    else
        player:SendBroadcastMessage('您可以使' .. marry.name .. '系统了.')
        player:AddItem(marry.itemid, 1)
    end
    local playerID = tostring(player:GetGUID())
    local text =
        CharDBQuery(
        'select marry1,marry2,marrylevel,unmarry,smarry  from _player_marry a where a.marry1 =' ..
            playerID .. ' or a.marry2 =' .. playerID
    )
    if (text) then
        if (text:GetString(3) == '1') then
            if (marry.levelitem[1] > 0) then
                player:RemoveItem(marry.levelitem[1], 1)
            end
            if (marry.levelitem[2] > 0) then
                player:RemoveItem(marry.levelitem[2], 1)
            end
            if (marry.levelitem[3] > 0) then
                player:RemoveItem(marry.levelitem[3], 1)
            end
            player:SendBroadcastMessage('您当前处于感情破裂阶段,无法享受增益福利')
            player:SendAreaTriggerMessage('您当前处于感情破裂阶段,无法享受增益福利')
        else
            local level=text:GetString(2) + 0
            CheckSpell(player, false,level  )
 
            if (level>= marry.level[3]) then
                SendWorldMessage(
                    marry.servername ..
                        '|r|cFFFF0066欢|r|cFF0041FF迎|r|cFF1BE6B8服务中的真的的一对情人[|r' ..
                            player:GetName() ..
                                '|cFF0041FF]|r|cFF0041FF和|r|cFF0041FF爱|r|cFF0E94DC人|r|cFF1BE6B8的|r|cFF37739C感情感动了天和地|r了'
                )
                if (marry.levelitem[3] > 0) then
                    if player:HasItem(marry.levelitem[2], 1) then
                    else
                        if (tonumber(text:GetString(2)) > marry.levelexp[2]) then
                            player:SendBroadcastMessage('您获得了3级亲密度奖励物品')
                            player:AddItem(marry.levelitem[3], 1)
                        end
                    end
                end
            elseif (level >= marry.level[2]) then
                if (marry.levelitem[2] > 0) then
                    if player:HasItem(marry.levelitem[1], 1) then
                    else
                        if (tonumber(text:GetString(2)) > marry.levelexp[2]) then
                            player:SendBroadcastMessage('您获得了2级亲密度奖励物品')
                            player:AddItem(marry.levelitem[2], 1)
                        end
                    end
                end
            else
                if (marry.levelitem[1] > 0) then
                    if player:HasItem(marry.levelitem[1], 1) then
                    else
                        player:SendBroadcastMessage('您获得了1级亲密度奖励物品')
                        player:AddItem(marry.levelitem[1], 1)
                    end
                end
            end
        end
    else
        if (marry.levelitem[1] > 0) then
            player:RemoveItem(marry.levelitem[1], 1)
        end
        if (marry.levelitem[2] > 0) then
            player:RemoveItem(marry.levelitem[2], 1)
        end
        if (marry.levelitem[3] > 0) then
            player:RemoveItem(marry.levelitem[3], 1)
        end
    end
    player:SendBroadcastMessage(
        marry.servername ..
            '|cFFFF0066欢|r|cFF0041FF迎|r|cFF1BE6B8你|r' ..
                player:GetName() ..
                    '|cFF0041FF你|r|cFF0041FF可|r|cFF0041FF以|r|cFF0E94DC使|r|cFF1BE6B8用|r' .. marry.name .. '了'
    )
end
RegisterPlayerEvent(3, MarryOnLogin)
RegisterPlayerEvent(42, marry.ChatEvent)
RegisterItemGossipEvent(marry.itemid, 1, marry.Tele_Book1)
RegisterItemGossipEvent(marry.itemid, 2, marry.Tele_Select1)
RegisterPlayerGossipEvent(2000, 2, marry.hfgx)
RegisterPlayerGossipEvent(2001, 2, marry.unmarry)
RegisterPlayerGossipEvent(2002, 2, marry.tyunmarry)
print('loading marry.lua...ok by ljq5555 ')

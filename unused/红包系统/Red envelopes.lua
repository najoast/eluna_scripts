---by ljq5555
local itemcd = 6948 --物品ID
local systemname = '红包系统' --功能名称
local people_num = 5 --红包默认可抢的人数
local Fname = '|cFF1BE6B8[' .. systemname .. ']|r' --广播前缀
local senditem = 65136 --可发货币
local minItemCount = 10 --最少发送货币数量
local minMoney = 10 --最少发送金币数量 单位金
local Levelexp = {5, 1}
local paihangbang = 10 --排行榜显示最大人数
local minlevel = 10 --抢红包的最低等级
--每最小单位积累的经验值 影响排行榜
local level = {
    [1] = {'|cFFFF0000小气鬼|r', 0},
    [2] = {'|cFFFF0000财|r|cFFAA1655助|r', 1},
    [3] = {'|cFFFF0000大|r|cFF0041FF财|r|cFF1BE6B8主|r', 50},
    [4] = {'|cFFFF0000壕|r|cFFCC0D33无|r|cFF991A66人|r|cFF662799性|r', 100}
}

local playerinfo = {}
local rediteminfo = {}
local Maxid = 0
CharDBExecute(
    [[
        CREATE TABLE IF NOT EXISTS `_player_red` (
          `guid` bigint(20) DEFAULT NULL,
          `name` text,
          `exp` int(11) DEFAULT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]
)
CharDBExecute(
    [[
        CREATE TABLE IF NOT EXISTS `_player_red_list` (
            `Remarks` text,
            `guild` int(11) NOT NULL DEFAULT '0',
            `yue` int(11) NOT NULL DEFAULT '0',
            `yx` int(11) NOT NULL DEFAULT '1',
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `itemid` int(11) NOT NULL DEFAULT '0',
            `nums` int(11) NOT NULL DEFAULT '0',
            `fenpei` text,
            PRIMARY KEY (`id`)
          ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]
)

local text = CharDBQuery('select guid,name,exp from _player_Red')
if (text) then
    repeat
        playerinfo[tonumber(text:GetString(0))] = {
            text:GetString(1),
            tonumber(text:GetString(2))
        }
    until not text:NextRow()
end
text = CharDBQuery('select id,Remarks,guild,yue,itemid,nums,fenpei from _player_red_list WHERE YX=1 order by id')
if (text) then
    repeat
        rediteminfo[tonumber(text:GetString(0))] = {
            ['Remarks'] = text:GetString(1),
            ['guild'] = tonumber(text:GetString(2)),
            ['yue'] = tonumber(text:GetString(3)),
            ['itemid'] = tonumber(text:GetString(4)),
            ['nums'] = tonumber(text:GetString(5)),
            ['id'] = tonumber(text:GetString(0)),
            ['fenpei'] = text:GetString(6)
        }
    until not text:NextRow()
end
text = CharDBQuery("SELECT `AUTO_INCREMENT`  FROM  INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME  = '_player_red_list'")
if (text) then
    Maxid = tonumber(text:GetString(0))
end
function Red_Book(event, player, item)
    player:MoveTo(0, player:GetX() + 0.01, player:GetY(), player:GetZ())
    if (player:IsInCombat() == true) then
        player:SendAreaTriggerMessage(Fname .. '你不能在战斗中使用!')
        player:SendBroadcastMessage(Fname .. '你不能在战斗中使用')
    else
        if (player:GetLevel() < minlevel) then
            player:SendAreaTriggerMessage(Fname .. '你还不能使用此功能!需要达到等级' .. minlevel .. '级')
            player:SendBroadcastMessage(Fname .. '你还不能使用此功能!需要达到等级' .. minlevel .. '级')
        else
            Red_Menu(item, player)
        end
    end
end
function Red_Menu(item, player)
    player:GossipMenuAddItem(5, '|cFFFF0000------------------' .. systemname .. '------------------|r', 0, 998)
    player:GossipMenuAddItem(6, '|TInterface\\ICONS\\red\\caishen.blp:80:80:80:0|t |cff0000ff', 0, 1)
    player:GossipMenuAddItem(6, '|TInterface\\ICONS\\red\\fa.blp:50:50:0:0|t |cFFFF0000我壕无人性-我要发红包|r', 0, 2)
    player:GossipMenuAddItem(6, '|TInterface\\ICONS\\red\\qiang.blp:50:50:0:0|t |cFF000000我穷我有理-我要抢红包|r', 0, 3)
    player:GossipMenuAddItem(
        6,
        '|TInterface\\ICONS\\red\\Achievement_Guild_level30.blp:40:40:0:0|t |cFFCC0099壕排行榜|r',
        0,
        4
    )
    player:GossipSendMenu(1, item)
end
function Get_levelName(levelexp)
    if levelexp >= level[4][2] then
        return level[4][1]
    elseif levelexp >= level[3][2] then
        return level[3][1]
    elseif levelexp >= level[2][2] then
        return level[2][1]
    elseif levelexp >= level[1][2] then
        return level[1][1]
    end
end
function StrSplit(str, reps)
    local StrList = {}
    string.gsub(
        str,
        '[^' .. reps .. ']+',
        function(F)
            table.insert(StrList, F)
        end
    )
    return StrList
end
function CheckRight(playerid, intid, player)
    if rediteminfo[intid]['yue'] == 5 then
        rediteminfo[intid]['Remarks'] = tostring(playerid)
        rediteminfo[intid]['yue'] = 4
        Updateredinfo(rediteminfo[intid]['id'], rediteminfo[intid]['yue'], rediteminfo[intid]['Remarks'], player)
        return true
    end
    local list = StrSplit(rediteminfo[intid]['Remarks'], '|')
    for i, v in pairs(list) do
        if tostring(v) == tostring(playerid) then
            player:SendBroadcastMessage(Fname .. '这个红包你已经抢过啦')
            return false
        end
    end
    rediteminfo[intid]['Remarks'] = rediteminfo[intid]['Remarks'] .. '|' .. tostring(playerid)
    rediteminfo[intid]['yue'] = rediteminfo[intid]['yue'] - 1
    Updateredinfo(rediteminfo[intid]['id'], rediteminfo[intid]['yue'], rediteminfo[intid]['Remarks'], player)
    return true
end
function CheckLeft(playerid, intid)
    if rediteminfo[intid]['yue'] == 5 then
        return true
    end
    local list = StrSplit(rediteminfo[intid]['Remarks'], '|')
    for i, v in pairs(list) do
        if tostring(v) == tostring(playerid) then
            return false
        end
    end
    return true
end
function Updateredinfo(id, yue, Remarks, player)
    local x = StrSplit(rediteminfo[id]['fenpei'], '|')
    if yue > 0 then
        CharDBQuery('update _player_Red_list set yue=' .. yue .. ",remarks='" .. Remarks .. "' where id =" .. id)
    else
        CharDBQuery('update _player_Red_list set yue=' .. yue .. ",remarks='" .. Remarks .. "',yx=0 where id =" .. id)
    end
    local y = tonumber(x[yue + 1])
    local sendstr
    if (rediteminfo[id]['itemid'] == 0) then
        sendstr = '|cFFFF0000' .. y .. ' 金币|r'
        y = y * 100 * 100
        player:ModifyMoney(y)
        player:SendBroadcastMessage(Fname .. '|cFFFF0000你抢到了一个红包获得|r' .. sendstr)
    else
        sendstr = GetItemLink(rediteminfo[id]['itemid']) .. '|cFFFF0000X' .. y .. '个|r'
        player:SendBroadcastMessage(Fname .. '|cFFFF0000你抢到了一个红包获得|r' .. sendstr)
        player:AddItem(rediteminfo[id]['itemid'], y)
    end
    if (yue == 0) then
        rediteminfo[id] = nil
    end
    SendWorldMessage(Fname .. '[' .. player:GetName() .. ']|cFFFF0000抢到了一个红包,获得了|r' .. sendstr)
end
function Updateinfo(guid, name, exp, item_id, guild, itemcount)
    if playerinfo[guid] == nil then
        CharDBQuery(
            "INSERT INTO `_player_Red` (`guid`,`name`,`exp`) VALUES ('" ..
                tostring(guid) .. "','" .. name .. "','" .. exp .. "')"
        )
        playerinfo[guid] = {name, exp}
    else
        playerinfo[guid] = {name, playerinfo[guid][2] + exp}
        CharDBQuery('update _player_Red set exp=' .. playerinfo[guid][2] .. ' where guid=' .. guid)
    end
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local data = splitX(tonumber(itemcount), people_num)
    CharDBQuery(
        "INSERT INTO `_player_red_list` (`guild`,`itemid`,`nums`,`yue`,`fenpei`) VALUES ('" ..
            guild .. "','" .. item_id .. "','" .. itemcount .. "','" .. people_num .. "','" .. data .. "')"
    )
    rediteminfo[Maxid] = {
        ['Remarks'] = '',
        ['guild'] = guild,
        ['yue'] = people_num,
        ['itemid'] = item_id,
        ['nums'] = itemcount,
        ['id'] = Maxid,
        ['fenpei'] = data
    }
    Maxid = Maxid + 1
end
function Red_Select(event, player, item, sender, intid, code)
    if intid == 1 or intid == 21 then
        player:SendAreaTriggerMessage(Fname .. '土豪，发个红包，我们就是朋友啦')
        player:SendBroadcastMessage(Fname .. '土豪，发个红包，我们就是朋友啦')
    elseif intid > 10000 then
        local last = true
        if (rediteminfo[intid - 10000] == nil) then
            last = false
        end
        if last and rediteminfo[intid - 10000]['yue'] > 0 and CheckRight(player:GetGUID(), intid - 10000, player) then
            player:GossipMenuAddItem(6, '|TInterface\\ICONS\\red\\yes1.blp:200:200:20:0|t |cff0000ff', 0, 3)
            player:GossipMenuAddItem(
                6,
                '|TInterface\\ICONS\\red\\ability_Paladin_Veneration.blp:30|t |cFF000000返回上一层|r',
                0,
                3
            )
        else
            player:SendAreaTriggerMessage(Fname .. '你下手慢啦，被别人抢走了')
            player:SendBroadcastMessage(Fname .. '你下手慢啦，被别人抢走了')
            player:GossipMenuAddItem(6, '|TInterface\\ICONS\\red\\no.blp:200:200:20:0|t |cff0000ff', 0, 3)
            player:GossipMenuAddItem(
                6,
                '|TInterface\\ICONS\\red\\ability_Paladin_Veneration.blp:30|t |cFF000000返回上一层|r',
                0,
                3
            )
        end
        player:GossipSendMenu(1, item)
    elseif intid == 31 or intid == 32 then
        local keys = {}
        for k, v in pairs(rediteminfo) do
            table.insert(keys, k)
        end
        table.sort(
            keys,
            function(a, b)
                return a > b
            end
        )
        local menucdadd = 10000
        local Guild = 0
        if intid == 32 and not player:IsInGuild() then
            player:SendBroadcastMessage(Fname .. '请您先加入一个工会！')
            player:GossipComplete()
            return true
        end
        Guild = player:GetGuildId()
        local jz = false
        local nums = 0
        for i, v in pairs(keys) do
            if rediteminfo[v]['guild'] > 0 then
                if (not player:IsInGuild()) or (not (Guild == rediteminfo[v]['guild'])) or (intid == 31) then
                    jz = false
                else
                    jz = true
                end
            else
                if intid == 32 then
                    jz = false
                else
                    jz = true
                end
            end
            if jz and CheckLeft(player:GetGUID(), rediteminfo[v]['id']) then
                if rediteminfo[v]['itemid'] > 0 then
                    player:GossipMenuAddItem(
                        6,
                        '|TInterface\\ICONS\\red\\read.blp:20|t ' ..
                            GetItemLink(rediteminfo[v]['itemid']) ..
                                'X' .. rediteminfo[v]['nums'] .. '     [' .. rediteminfo[v]['id'] .. ']',
                        0,
                        menucdadd + rediteminfo[v]['id']
                    )
                else
                    player:GossipMenuAddItem(
                        6,
                        '|TInterface\\ICONS\\red\\money.blp:20|t |cFF0041FF金币X' ..
                            rediteminfo[v]['nums'] .. '     [' .. rediteminfo[v]['id'] .. ']',
                        0,
                        menucdadd + rediteminfo[v]['id']
                    )
                end
                nums = nums + 1
            end
        end
        if (nums == 0) then
            player:SendBroadcastMessage(Fname .. '没有可以抢的红包！您可以自己发一个哦！')
            player:SendAreaTriggerMessage(Fname .. '没有可以抢的红包！您可以自己发一个哦！')
            player:GossipComplete()
            return true
        end
        player:GossipMenuAddItem(
            6,
            '|TInterface\\ICONS\\red\\ability_Paladin_Veneration.blp:30|t |cFF000000返回上一层|r',
            0,
            3
        )
        player:GossipSendMenu(1, item)
    elseif intid == 3 then
        player:GossipMenuAddItem(6, '|TInterface\\ICONS\\red\\Read.blp:40|t |cFF0041FF世界红包|r', 0, 31)
        player:GossipMenuAddItem(6, '|TInterface\\ICONS\\red\\money.blp:40|t |cFF0041FF工会红包|r', 0, 32)

        player:GossipMenuAddItem(
            6,
            '|TInterface\\ICONS\\red\\ability_Paladin_Veneration.blp:30|t |cFF000000返回主菜单|r',
            0,
            99
        )
        player:GossipSendMenu(1, item)
    elseif intid == 4 then
        local keys = {}
        for k, v in pairs(playerinfo) do
            table.insert(keys, k)
        end
        table.sort(
            keys,
            function(a, b)
                return a < b
            end
        )

        local qishu = 0
        for i, v in pairs(keys) do
            qishu = qishu + 1
            if (qishu > paihangbang) then
                break
            else
                if (qishu % 2 == 0) then
                    player:GossipMenuAddItem(
                        6,
                        '|TInterface\\ICONS\\red\\Priest_spell_leapoffaith_a.blp:20|t |cFFFF0000' ..
                            playerinfo[v][1] .. '-富豪值：' .. playerinfo[v][2] .. '|r',
                        0,
                        99
                    )
                else
                    player:GossipMenuAddItem(
                        6,
                        '|TInterface\\ICONS\\red\\Priest_spell_leapoffaith_b.blp:20|t |cFF0041FF' ..
                            playerinfo[v][1] .. '-富豪值：' .. playerinfo[v][2] .. '|r',
                        0,
                        99
                    )
                end
            end
        end
        player:GossipMenuAddItem(
            6,
            '|TInterface\\ICONS\\red\\ability_Paladin_Veneration.blp:30|t |cFF000000返回主菜单|r',
            0,
            99
        )
        player:GossipSendMenu(1, item)
    elseif intid == 2 then
        player:GossipMenuAddItem(5, '|cFF0000FF不发红包怎么证明我是壕！！！|r', 0, 997)
        player:GossipMenuAddItem(6, '|TInterface\\ICONS\\red\\rian.blp:40:40:80:0|t |cff0000ff', 0, 21)
        player:GossipMenuAddItem(
            6,
            '|TInterface\\ICONS\\red\\INV_MISC_CUTGEMNORMAL.blp:30|t |cFFFF0000' ..
                GetItemLink(senditem) .. '红包雨-所有人可见|r',
            0,
            22,
            true
        )
        player:GossipMenuAddItem(
            6,
            '|TInterface\\ICONS\\red\\INV_MISC_CUTGEMSUPERIOR.blp:30|t |cFFFF0000' .. GetItemLink(senditem) .. '工会红包|r',
            0,
            23,
            true
        )
        player:GossipMenuAddItem(
            6,
            '|TInterface\\ICONS\\red\\inv_misc_cutgemnormal2.blp:30|t |cFFFF0000金币红包雨-所有人可见|r',
            0,
            24,
            true
        )
        player:GossipMenuAddItem(
            6,
            '|TInterface\\ICONS\\red\\INV_MISC_CUTGEMSUPERIOR2.blp:30|t |cFFFF0000金币-工会红包|r',
            0,
            25,
            true
        )
        player:GossipMenuAddItem(
            6,
            '|TInterface\\ICONS\\red\\ability_Paladin_Veneration.blp:30|t |cFF000000返回主菜单|r',
            0,
            99
        )
        player:GossipSendMenu(1, item)
    elseif intid == 99 then
        Red_Menu(item, player)
    elseif intid == 22 or intid == 23 or intid == 24 or intid == 25 then
        local itemcount = tonumber(code)
        if (itemcount == nil) then
            player:SendBroadcastMessage(Fname .. '请输入正确的数字！')
            player:GossipComplete()
            return true
        end
        local Worldmessagestr = ''
        local Kind = ''
        local Guild = 0
        if (intid == 23 or intid == 25) then
            if not player:IsInGuild() then
                player:SendBroadcastMessage(Fname .. '请您先加入一个工会！')
                player:GossipComplete()
                return true
            end
            Kind = '|cFFE55AAF工|r|cFFCA6EA7会|r'
            Guild = player:GetGuildId()
        end
        local m = false
        local playerexp = 50

        if (intid == 22 or intid == 23) then
            if (minItemCount > itemcount) then
                player:SendBroadcastMessage(
                    Fname .. '土豪，红包最少需要发送' .. minItemCount .. '个' .. GetItemLink(senditem) .. '哦！'
                )
                player:GossipComplete()
                return true
            end
            if (player:HasItem(senditem, itemcount)) then
                player:RemoveItem(senditem, itemcount)
                player:SendBroadcastMessage(
                    Fname .. '|cFF33CC33你失去了|r ' .. GetItemLink(senditem) .. ' |cFF33CC33x ' .. itemcount .. ' 个|r'
                )
            else
                player:SendBroadcastMessage(Fname .. '对不起.你没有' .. GetItemLink(senditem) .. 'X' .. itemcount .. '.无法发红包')
                player:SendAreaTriggerMessage(
                    Fname .. '对不起.你没有' .. GetItemLink(senditem) .. 'X' .. itemcount .. '.无法发红包'
                )
            end
        else
            if (minMoney > itemcount) then
                player:SendBroadcastMessage(Fname .. '土豪，红包最少需要发送' .. minMoney .. '金币哦！')
                player:GossipComplete()
                return true
            end
            if player:GetCoinage() < itemcount * 100 * 100 then
                player:SendBroadcastMessage(Fname .. '你的钱不够哦，单位是金币')
                player:GossipComplete()
                return true
            else
                player:ModifyMoney(itemcount * 100 * 100 * -1)
                player:SendBroadcastMessage(Fname .. '|cFF33CC33你失去了 ' .. itemcount .. ' 金币|r')
                m = true
            end
        end
        local p_exp = 0
        if m then
            Worldmessagestr =
                Fname ..
                '|cFFCC6633壕|r|cFF665499无|r|cFF0041FF人|r|cFF0E94DC性|r|cFF1BE6B8的|r[' ..
                    Get_levelName(playerexp) ..
                        '-' ..
                            player:GetName() ..
                                ']|cFFFF0000发|r|cFFAA1655送|r|cFF552BAA了|r|cFF0041FF一|r|cFF0978E7个|r|cFF12AFD0金|r|cFF1BE6B8币|r|cFFFFFF00x|r|cFF00FF99' ..
                                    itemcount ..
                                        '|r|cFF8C5555的|r' ..
                                            Kind ..
                                                '|cFFFFDF48红|r|cFFFEBF90包|r|cFFFE9FD8，|r|cFFB4AA90哇|r|cFF69B448塞|r|cFF1FBF00，|r|cFF619D3A这|r|cFFA37C75个|r|cFFE55AAF工|r|cFFCA6EA7会|r|cFFAF819E好|r|cFF949596多|r|cFF8CA3B4土|r|cFF85B0D3豪|r|cFF7DBEF1，|r|cFF589FB8我|r|cFF34807E要|r|cFF0F6145入|r|cFF24723F会|r|cFF388338！|r'
            p_exp = itemcount / minItemCount * Levelexp[2]
            Updateinfo(tonumber(tostring(player:GetGUID())), player:GetName(), p_exp, 0, Guild, itemcount)
        else
            Worldmessagestr =
                Fname ..
                '|cFFCC6633壕|r|cFF665499无|r|cFF0041FF人|r|cFF0E94DC性|r|cFF1BE6B8的|r[' ..
                    Get_levelName(playerexp) ..
                        '-' ..
                            player:GetName() ..
                                ']|cFFFF0000发|r|cFFF3030C送|r|cFFE80617了|r|cFFDC0923一|r|cFFD10C2E个|r' ..
                                    GetItemLink(senditem) ..
                                        '|cFFFFFF00x|r|cFF00FF99' ..
                                            itemcount ..
                                                '|r|cFF8B1E74的|r' ..
                                                    Kind ..
                                                        '|cFF7F2080红|r|cFF74238B包|r|cFF682697，|r|cFF5D29A2大|r|cFF512CAE家|r|cFF462FB9赶|r|cFF3A32C5紧|r|cFF2E35D1抢|r|cFF2338DC啦|r|cFF173BE8！|r'
            p_exp = itemcount / minMoney * Levelexp[1]
            Updateinfo(tonumber(tostring(player:GetGUID())), player:GetName(), p_exp, senditem, Guild, itemcount)
        end

        player:SendBroadcastMessage(Fname .. '红包发送成功！')
        player:SendAreaTriggerMessage(Fname .. '红包发送成功！')
        SendWorldMessage(Worldmessagestr)
    end
end
function shuffle(t)
    if not t then
        return
    end
    local cnt = #t
    for i = 1, cnt do
        local j = math.random(i, cnt)
        t[i], t[j] = t[j], t[i]
    end
end

function splitX(m, n)
    local mark = {}
    for i = 1, m - 1 do
        mark[i] = i
    end

    shuffle(mark)
    local validMark = {}
    for i = 1, n - 1 do
        validMark[i] = mark[i]
    end

    table.sort(
        validMark,
        function(a, b)
            return a < b
        end
    )

    validMark[0] = 0
    validMark[n] = m
    local out = ''
    for i = 1, n do
        if (i == 1) then
            out = tostring(validMark[i] - validMark[i - 1])
        else
            out = out .. '|' .. tostring(validMark[i] - validMark[i - 1])
        end
    end
    return out
end
function RedOnLogin(event, player)
    if not player:HasItem(itemcd, 1) then
        player:AddItem(itemcd, 1)
        player:SendBroadcastMessage(Fname .. '|cFF33CC33你获得了|r ' .. GetItemLink(itemcd) .. ' |cFF33CC33x1个|r')
    end
    player:SendBroadcastMessage(
        '|cFFFF0066欢|r|cFF0041FF迎|r|cFF1BE6B8你|r' ..
            player:GetName() .. '|cFF0041FF你|r|cFF0041FF可|r|cFF0041FF以|r|cFF0E94DC使|r|cFF1BE6B8用|r' .. systemname .. '了'
    )
end
RegisterPlayerEvent(3, RedOnLogin)
RegisterItemGossipEvent(itemcd, 1, Red_Book)
RegisterItemGossipEvent(itemcd, 2, Red_Select)

--[[信息：
	牛皮德来定制版用于335或者335锁定70的
	此为自动搜索包裹内所有物品以匹配幻化
]]--
local NPC_Entry = 90003
local transmogcost = 10000
local entryMap = {}   --给在线时候更换装备仍然保持幻化效果用的内存数组

local EQUIPMENT_SLOT_START        = 0   --判定开始
local EQUIPMENT_SLOT_HEAD         = 0
local EQUIPMENT_SLOT_NECK         = 1
local EQUIPMENT_SLOT_SHOULDERS    = 2
local EQUIPMENT_SLOT_BODY         = 3
local EQUIPMENT_SLOT_CHEST        = 4
local EQUIPMENT_SLOT_WAIST        = 5
local EQUIPMENT_SLOT_LEGS         = 6
local EQUIPMENT_SLOT_FEET         = 7
local EQUIPMENT_SLOT_WRISTS       = 8
local EQUIPMENT_SLOT_HANDS        = 9
local EQUIPMENT_SLOT_FINGER1      = 10
local EQUIPMENT_SLOT_FINGER2      = 11
local EQUIPMENT_SLOT_TRINKET1     = 12
local EQUIPMENT_SLOT_TRINKET2     = 13
local EQUIPMENT_SLOT_BACK         = 14
local EQUIPMENT_SLOT_MAINHAND     = 15
local EQUIPMENT_SLOT_OFFHAND      = 16
local EQUIPMENT_SLOT_RANGED       = 17
local EQUIPMENT_SLOT_TABARD       = 18
local EQUIPMENT_SLOT_END          = 19   --幻化槽位结尾判定,以及用这个作为菜单索引,以和前面0-18用以装备槽位索引区分开来

local INVENTORY_SLOT_BAG_START    = 19   --背包槽位1
local INVENTORY_SLOT_BAG_END      = 23	 --背包槽位4

local INVENTORY_SLOT_ITEM_START   = 23   --角色自身背包1,也就是第一格
local INVENTORY_SLOT_ITEM_END     = 39   --角色自身背包最后一格

local INVTYPE_CHEST               = 5
local INVTYPE_WEAPON              = 13
local INVTYPE_2HWEAPON			  = 14    --目前是猜的,待测试后确认
local INVTYPE_ROBE                = 20
local INVTYPE_WEAPONMAINHAND      = 21
local INVTYPE_WEAPONOFFHAND       = 22

local ITEM_CLASS_WEAPON           = 2
local ITEM_CLASS_ARMOR            = 4

local ITEM_SUBCLASS_WEAPON_BOW          = 2
local ITEM_SUBCLASS_WEAPON_GUN          = 3
local ITEM_SUBCLASS_WEAPON_CROSSBOW     = 18

local EXPANSION_WOTLK = 2
local EXPANSION_TBC = 1
local PLAYER_VISIBLE_ITEM_1_ENTRYID
local ITEM_SLOT_MULTIPLIER
if GetCoreExpansion() < EXPANSION_TBC then
    PLAYER_VISIBLE_ITEM_1_ENTRYID = 260
    ITEM_SLOT_MULTIPLIER = 12
elseif GetCoreExpansion() < EXPANSION_WOTLK then
    PLAYER_VISIBLE_ITEM_1_ENTRYID = 346
    ITEM_SLOT_MULTIPLIER = 16
else
    PLAYER_VISIBLE_ITEM_1_ENTRYID = 283   --335端用这个,也可以直接指定用这个参数
    ITEM_SLOT_MULTIPLIER = 2   			  --335端用这个,也可以直接指定用这个参数
end

local Equiped_Slots_Bag        = 255         --获取背包默认用255

local SlotNames = {   --用来实现多语言,如果后面的为nil,则自动用第一列的文字.
    [EQUIPMENT_SLOT_HEAD      ] = {"头部", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_SHOULDERS ] = {"肩膀", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_BACK      ] = {"背部", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_CHEST     ] = {"胸甲", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_BODY      ] = {"衬衣", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_TABARD    ] = {"战袍", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_WRISTS    ] = {"腕部", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_HANDS     ] = {"手部", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_WAIST     ] = {"腰部", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_LEGS      ] = {"腿部", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_FEET      ] = {"脚部", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_MAINHAND  ] = {"主手", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_OFFHAND   ] = {"副手", nil, nil, nil, nil, nil, nil, nil, nil},
    [EQUIPMENT_SLOT_RANGED    ] = {"远程", nil, nil, nil, nil, nil, nil, nil, nil},
}

local Locales = {      --用来多语言实现,如果后面的为nil,则自动用第一列的文字.
    {"刷新目录", nil, nil, nil, nil, nil, nil, nil, nil},
    {"移除所有部位幻化和隐藏效果", nil, nil, nil, nil, nil, nil, nil, nil},
    {"确认移除或隐藏幻化效果?", nil, nil, nil, nil, nil, nil, nil, nil},
    {"确认用该装备幻化？", nil, nil, nil, nil, nil, nil, nil, nil},
    {"%s 部位确认移除(或隐藏)幻化?", nil, nil, nil, nil, nil, nil, nil, nil},
    {"返回..", nil, nil, nil, nil, nil, nil, nil, nil},
    {"移除当前部位幻化和隐藏效果", nil, nil, nil, nil, nil, nil, nil, nil},
    {"已移除所有幻化效果", nil, nil, nil, nil, nil, nil, nil, nil},
    {"不存在任何幻化效果", nil, nil, nil, nil, nil, nil, nil, nil},
    {"%s 的幻化效果已移除", nil, nil, nil, nil, nil, nil, nil, nil},
    {"未发现 %s 的幻化效果", nil, nil, nil, nil, nil, nil, nil, nil},
    {"%s 已幻化为选择的装备", nil, nil, nil, nil, nil, nil, nil, nil},
    {"不能匹配幻化的装备或槽位", nil, nil, nil, nil, nil, nil, nil, nil},
    {"请把需要幻化的装备放在包裹内，银行的无效", nil, nil, nil, nil, nil, nil, nil, nil},
    {"隐藏装备", nil, nil, nil, nil, nil, nil, nil, nil},
    {"隐藏所有装备", nil, nil, nil, nil, nil, nil, nil, nil},
}
local function LocText(id, p)   -- "%s":format("test")
    if Locales[id] then
        local s = Locales[id][p:GetDbcLocale()+1] or Locales[id][1]    --如果对应语言有，就取对应语言，如果niu，就取第一个默认语言
        if s then
            return s
        end
    end
    return "该信息缺乏提示: "..(id or 0)
end

local function GetSlotName(slot, locale)
    if not SlotNames[slot] then return end
    return SlotNames[slot][locale+1] or SlotNames[slot][1]   --如果对应语言有，就取对应语言，如果niu，就取第一个默认语言
end



WeaponVisual = {
-- 设定可使用的武器幻光效果
-- 对应关系, 物品 -> 技能效果 -> 技能misc ->SpellItemEnchantment

    --[物品ID] = SpellItemEnchantment, 
    [0] = 0, --隐藏幻光
    [38779] = 249,  --卷轴：附魔武器 - 初级屠兽
    [38796] = 943,  --卷轴：附魔双手武器 - 次级冲击
    [38813] = 853,  --卷轴：附魔武器 - 次级屠兽
    [38814] = 854,  --卷轴：附魔武器 - 次级元素杀手
    [38821] = 943,  --卷轴：附魔武器 - 攻击
    [38822] = 1897, --卷轴：附魔双手武器 - 冲击
    [38838] = 803,  --卷轴：附魔武器 - 烈焰
    [38840] = 912,  --卷轴：附魔武器 - 屠魔
    [38845] = 963,  --卷轴：附魔双手武器 - 强效冲击
    [38848] = 805,  --卷轴：附魔武器 - 强效攻击
    [38868] = 1894, --卷轴：附魔武器 - 冰寒
    [38869] = 1896, --卷轴：附魔双手武器 - 超强冲击
    [38870] = 1897, --卷轴：附魔武器 - 超强打击
    [38871] = 1898, --卷轴：附魔武器 - 生命偷取
    [38872] = 1899, --卷轴：附魔武器 - 邪恶武器
    [38873] = 1900, --卷轴：附魔武器 - 十字军
    [38874] = 1903, --卷轴：附魔双手武器 - 特效精神
    [38875] = 1904, --卷轴：附魔双手武器 - 特效智力
    [38877] = 2504, --卷轴：附魔武器 - 法术能量
    [38878] = 2505, --卷轴：附魔武器 - 治疗能量
    [38879] = 2563, --卷轴：附魔武器 - 力量
    [38880] = 2564, --卷轴：附魔武器 - 敏捷
    [38883] = 2567, --卷轴：附魔武器 - 强效精神
    [38884] = 2568, --卷轴：附魔武器 - 强效智力
    [38896] = 2646, --卷轴：附魔双手武器 - 敏捷
    [38917] = 963,  --卷轴：附魔武器 - 特效打击
    [38918] = 2666, --卷轴：附魔武器 - 特效智力
    [38919] = 2667, --卷轴：附魔双手武器 - 野蛮
    [38920] = 2668, --卷轴：附魔武器 - 力量
    [38921] = 2669, --卷轴：附魔武器 - 特效法术能量
    [38922] = 2670, --卷轴：附魔双手武器 - 特效敏捷
    [38923] = 2671, --卷轴：附魔武器 - 阳炎
    [38924] = 2672, --卷轴：附魔武器 - 魂霜
    [38925] = 2673, --卷轴：附魔武器 - 猫鼬
    [38926] = 2674, --卷轴：附魔武器 - 魔法激荡
    [38927] = 2675, --卷轴：附魔武器 - 作战专家
    [38946] = 3846, --卷轴：附魔武器 - 特效治疗
    [38947] = 3222, --卷轴：附魔武器 - 强效敏捷
    [38948] = 3225, --卷轴：附魔武器 - 斩杀
    [38963] = 3844, --卷轴：附魔武器 - 优异精神
    [38965] = 3239, --卷轴：附魔武器 - 破冰
    [38972] = 3241, --卷轴：附魔武器 - 生命护卫
    [38981] = 3247, --卷轴：附魔双手武器 - 天谴斩除
    [38988] = 3251, --卷轴：附魔武器 - 巨人杀手
    [38991] = 3830, --卷轴：附魔武器 - 优异法术能量
    [38992] = 3828, --卷轴：附魔双手武器 - 强效野蛮
    [38995] = 1103, --卷轴：附魔武器 - 优异敏捷
    [38998] = 3273, --卷轴：附魔武器 - 死亡霜冻
    [43987] = 3790, --卷轴：附魔武器 - 黑魔法
    [44453] = 1606, --卷轴：附魔武器 - 强效潜能
    [44463] = 3827, --卷轴：附魔双手武器 - 杀戮
    [44466] = 3833, --卷轴：附魔武器 - 超强潜能
    [44467] = 3834, --卷轴：附魔武器 - 极效法术能量
    [44493] = 3789, --卷轴：附魔武器 - 狂暴
    [44497] = 3788, --卷轴：附魔武器 - 精确
    [45056] = 3854, --卷轴：附魔法杖 - 强效法术能量
    [45060] = 3855, --卷轴：附魔法杖 - 法术能量
    [46026] = 3869, --卷轴：附魔武器 - 利刃防护
    [46098] = 3870, --卷轴：附魔武器 - 吸血
}

local function RestoreOriginal(item)
    local player = item:GetOwner()
	if player then
        local slot = item:GetSlot()
		local pEnchant = item:GetEnchantmentId(0)
        local pGUID = player:GetGUIDLow()
        if entryMap[pGUID][slot] then
            entryMap[pGUID][slot] = nil
        end
        CharDBExecute("DELETE FROM custom_transmogs WHERE Owner = "..pGUID.." and GUID = "..slot)    --数据库删除角色对应位置条目	
        player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), item:GetEntry())
        player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER)+1, pEnchant)
        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), item:GetEntry())
        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER)+1, pEnchant)
        return true
	end
    return false	
end

local function SetFakeEntry(item, TransmogerItem)
    local player = item:GetOwner()
    if player then
		local entry = 0
		local pEnchant = 0
		if TransmogerItem ~= 0 then
			entry = TransmogerItem:GetEntry()
			pEnchant = TransmogerItem:GetEnchantmentId(0)   --物品可以有2个附魔,0为默认附魔
			player:SendBroadcastMessage(string.format("选中模型的附魔ID为 %s", pEnchant))
		end
	    local slot = item:GetSlot()
		player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), entry)
        player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER)+1, pEnchant)
        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), entry)
        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER)+1, pEnchant)
        local pGUID = player:GetGUIDLow()
        if not entryMap[pGUID] then
            entryMap[pGUID] = {}
        end
        entryMap[pGUID][slot] = entry     --记录幻化用的装备模型
        entryMap[pGUID][slot+20] = pEnchant  --记录幻化用的装备0位置附魔效果,因为装备只有18个,用超过18个临时在内存表示
        CharDBExecute("DELETE FROM custom_transmogs WHERE Owner = "..pGUID.." and GUID = "..slot)        --因为没有主键,所以需要数据库先删除角色对应位置的幻化
        CharDBExecute("REPLACE INTO custom_transmogs (GUID, FakeEntry, Enchant, Owner) VALUES ("..slot..", "..entry..", "..pEnchant..", "..pGUID..")")    --然后再加进去，遮掩避免相同的重复条目
    end
end

local function IsRangedWeapon(Class, SubClass)
    return Class == ITEM_CLASS_WEAPON and (
    SubClass == ITEM_SUBCLASS_WEAPON_BOW or
    SubClass == ITEM_SUBCLASS_WEAPON_GUN or
    SubClass == ITEM_SUBCLASS_WEAPON_CROSSBOW)
end

local function SuitableForTransmog(player, transmogrified, transmogrifier)
    if not transmogrified or not transmogrifier then
        return false
    end

    local fierClass = transmogrifier:GetClass()
    local fiedClass = transmogrified:GetClass()
    local fierSubClass = transmogrifier:GetSubClass()
    local fiedSubClass = transmogrified:GetSubClass()
    local fierInventorytype = transmogrifier:GetInventoryType()
    local fiedInventorytype = transmogrified:GetInventoryType()

    if fiedInventorytype == INVTYPE_BAG or
    fiedInventorytype == INVTYPE_RELIC or
    -- fiedInventorytype == INVTYPE_BODY or
    fiedInventorytype == INVTYPE_FINGER or
    fiedInventorytype == INVTYPE_TRINKET or
    fiedInventorytype == INVTYPE_AMMO or
    fiedInventorytype == INVTYPE_QUIVER then
        return false
    end

    if fierInventorytype == INVTYPE_BAG or
    fierInventorytype == INVTYPE_RELIC or
     --fierInventorytype == INVTYPE_BODY or
    fierInventorytype == INVTYPE_FINGER or
    fierInventorytype == INVTYPE_TRINKET or
    fierInventorytype == INVTYPE_AMMO or
    fierInventorytype == INVTYPE_QUIVER then
        return false
    end

    if fierClass ~= fiedClass then
        return false
    end
	
    if IsRangedWeapon(fiedClass, fiedSubClass) ~= IsRangedWeapon(fierClass, fierSubClass) then
        return false
    end

    if (fierInventorytype ~= fiedInventorytype) then
        if (fierClass == ITEM_CLASS_WEAPON and not ((IsRangedWeapon(fiedClass, fiedSubClass) or
            ((fiedInventorytype == INVTYPE_WEAPON or fiedInventorytype == INVTYPE_2HWEAPON) and
                (fierInventorytype == INVTYPE_WEAPON or fierInventorytype == INVTYPE_2HWEAPON)) or
            ((fiedInventorytype == INVTYPE_WEAPONMAINHAND or fiedInventorytype == INVTYPE_WEAPONOFFHAND) and
                (fierInventorytype == INVTYPE_WEAPON or fierInventorytype == INVTYPE_2HWEAPON))))) then
            return true
        end
        if (fierClass == ITEM_CLASS_ARMOR and
            not ((fierInventorytype == INVTYPE_CHEST or fierInventorytype == INVTYPE_ROBE) and
                (fiedInventorytype == INVTYPE_CHEST or fiedInventorytype == INVTYPE_ROBE))) then
            return false
        end
    end
	
    return true
end

local menu_id = math.random(1000)

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
        local slotName = GetSlotName(slot, player:GetDbcLocale())
        if slotName then
            player:GossipMenuAddItem(3, slotName, EQUIPMENT_SLOT_END, slot)
        end
    end
    player:GossipMenuAddItem(9, LocText(16, player), EQUIPMENT_SLOT_END+5, 0, false, LocText(3, player), 0)	 --全隐藏
    player:GossipMenuAddItem(8, LocText(2, player), EQUIPMENT_SLOT_END+2, 0, false, LocText(3, player), 0)   --全恢复
    player:GossipMenuAddItem(7, LocText(1, player), EQUIPMENT_SLOT_END+1, 0)  --刷新当前
    player:GossipSendMenu(100, creature, menu_id)
end

local function OnGossipSelect(event, player, creature, MenuGroup, MenuID)
    if MenuGroup == EQUIPMENT_SLOT_END then      --根据主页选择进入某位置菜单后，扫描对应位置包裹内可幻化物品，并生成选择清单
        local transmogeds = player:GetItemByPos(Equiped_Slots_Bag, MenuID)
        local transmogers = transmogeds		--重复的目标物品扫描清单，但是必须在if循环外线预定义并赋值，不然会出错	
        for i = INVENTORY_SLOT_ITEM_START, INVENTORY_SLOT_ITEM_END-1 do      --角色自带背包扫描
            transmogers = player:GetItemByPos(Equiped_Slots_Bag, i)	
            if SuitableForTransmog(player, transmogeds, transmogers) then
				-- player:SendBroadcastMessage(string.format("可幻化物品在%s格,装备名字为%s", i-22, transmogers:GetName()))
				local popup = LocText(4, player).."\n\n"..transmogers:GetItemLink(player:GetDbcLocale()).."\n"
				player:GossipMenuAddItem(4, transmogers:GetItemLink(player:GetDbcLocale()), MenuID, i, false, popup, transmogcost)
			end
		end
        for i = INVENTORY_SLOT_BAG_START, INVENTORY_SLOT_BAG_END-1 do      --角色额外的4个背包扫描
		    local bag = player:GetItemByPos(Equiped_Slots_Bag, i)
            if bag then
                for j = 0, bag:GetBagSize()-1 do
				    transmogers = player:GetItemByPos(i, j)
    				if SuitableForTransmog(player, transmogeds, transmogers) then
    					-- player:SendBroadcastMessage(string.format("可幻化物品在第%s包裹,第%s槽,装备名字为%s", i-18, j+1, transmogers:GetName()))
						local LogicSLOT = (i - 17) * 36 + j			--跳过23到38默认包裹ID,故第一个背包包裹序号19的第一槽位用2*36+0=72
    					local popup = LocText(4, player).."\n\n"..transmogers:GetItemLink(player:GetDbcLocale()).."\n"
    					player:GossipMenuAddItem(4, transmogers:GetItemLink(player:GetDbcLocale()), MenuID, LogicSLOT, false, popup, transmogcost)
    				end
    			end
			end
		end
		player:GossipMenuAddItem(9, LocText(15, player), EQUIPMENT_SLOT_END+4, MenuID, false, LocText(5, player):format(GetSlotName(MenuID, player:GetDbcLocale())))  --隐藏
		player:GossipMenuAddItem(8, LocText(7, player), EQUIPMENT_SLOT_END+3, MenuID, false, LocText(5, player):format(GetSlotName(MenuID, player:GetDbcLocale())))   --恢复
        player:GossipMenuAddItem(7, LocText(6, player), EQUIPMENT_SLOT_END+1, 0)  --返回
        player:GossipSendMenu(100, creature, menu_id)

    elseif MenuGroup == EQUIPMENT_SLOT_END+1 then -- 刷新和回退到主菜单
        OnGossipHello(event, player, creature)

    elseif MenuGroup == EQUIPMENT_SLOT_END+2 then -- 主菜单的移除所有幻化效果
        local removed = false
        for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
            local transmogallreal = player:GetItemByPos(Equiped_Slots_Bag, slot)
            if transmogallreal then
                if RestoreOriginal(transmogallreal) and not removed then
                    removed = true
                end
            end
        end
        if removed then
            player:SendAreaTriggerMessage(LocText(8, player))
        else
            player:SendNotification(LocText(9, player))
        end
        OnGossipHello(event, player, creature)

    elseif MenuGroup == EQUIPMENT_SLOT_END+5 then   -- 主菜单的隐藏所有装备
        for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
            local transmoghideall = player:GetItemByPos(Equiped_Slots_Bag, slot)
			if transmoghideall then
				SetFakeEntry(transmoghideall, 0)    --0对应模型在游戏内为隐藏的
			end
		end
        OnGossipHello(event, player, creature)
		
    elseif MenuGroup == EQUIPMENT_SLOT_END+3 then   -- 移除幻化或者去掉隐藏效果
        local transmogonereal = player:GetItemByPos(Equiped_Slots_Bag, MenuID)
        if transmogonereal then
            if RestoreOriginal(transmogonereal) then
                player:SendAreaTriggerMessage(LocText(10, player):format(GetSlotName(MenuID, player:GetDbcLocale())))
            else
                player:SendNotification(LocText(11, player):format(GetSlotName(MenuID, player:GetDbcLocale())))
            end
        end
        OnGossipSelect(event, player, creature, EQUIPMENT_SLOT_END, MenuID)

    elseif MenuGroup == EQUIPMENT_SLOT_END+4 then   -- 单独移除当前选择装备的幻化效果
        local transmoghidereal = player:GetItemByPos(Equiped_Slots_Bag, MenuID)
        if transmoghidereal then
            SetFakeEntry(transmoghidereal, 0)    --0对应模型在游戏内为隐藏的
        end
        OnGossipSelect(event, player, creature, EQUIPMENT_SLOT_END, MenuID)
		
	else    --幻化过程
		local transmoged = player:GetItemByPos(Equiped_Slots_Bag, MenuGroup)
		local transmoger = transmoged     --变量必须定义在if循环外,if内的变量在判断结束后就没有了,这里饶了个大弯路,默认用当前装备幻化
		if (MenuID >= INVENTORY_SLOT_ITEM_START) and (MenuID < INVENTORY_SLOT_ITEM_END) then
			transmoger = player:GetItemByPos(Equiped_Slots_Bag, MenuID)
			if transmoger then    --第一个包裹格子为从23开始,所以需要减去22以显示对应位置
				player:SendBroadcastMessage(string.format("幻化 %s 为第 %s 槽的 %s ", GetSlotName(MenuGroup, player:GetDbcLocale()), MenuID-22, transmoger:GetName()))
			end
		elseif MenuID > 71 then  --超过默认包裹最大值38,则计算额外包裹,否则直接用默认包裹
			local i =  math.modf(MenuID/36)
			local j = MenuID % 36
			transmoger = player:GetItemByPos(i+17, j)
			if transmoger then
				player:SendBroadcastMessage(string.format("幻化 %s 为 %s 包第 %s 槽的 %s ", GetSlotName(MenuGroup, player:GetDbcLocale()), i-1, j+1, transmoger:GetName()))
			end
		else
			player:SendBroadcastMessage(string.format("包裹或装备有变化，无法完成幻化，即将刷新菜单界面！"))
			OnGossipHello(event, player, creature)
			return
		end
        if SuitableForTransmog(player, transmoged, transmoger) then
            SetFakeEntry(transmoged, transmoger)        --开始幻化
            player:SendAreaTriggerMessage(LocText(12, player):format(GetSlotName(MenuGroup, player:GetDbcLocale())))
        else
            player:SendNotification(LocText(13, player))
		end
        OnGossipSelect(event, player, creature, EQUIPMENT_SLOT_END, MenuGroup)
		
    end
end

local function OnLogin(event, player)
    local pGUID = player:GetGUIDLow()
    entryMap[pGUID] = {}
    local result = CharDBQuery("SELECT GUID, FakeEntry, Enchant FROM custom_transmogs WHERE Owner = "..pGUID)
    if result then
			repeat          --从数据库恢复数据到内存数组 entryMap[玩家ID][装备位置],不用内存也可以,不过会复杂一点
            local SlotID = result:GetUInt32(0)
            local fakeEntry = result:GetUInt32(1)
            local pEnchant = result:GetUInt32(2)
            entryMap[pGUID][SlotID] = fakeEntry
            entryMap[pGUID][SlotID+20] = pEnchant		--记录幻化用的装备0位置附魔效果,因为装备只有18个,用加上20后的复用这个表,以表示附魔效果	
        until not result:NextRow()

        for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do   --进入游戏时候替换幻化模型
            local item = player:GetItemByPos(Equiped_Slots_Bag, slot)
            if item then
                if entryMap[pGUID] then
                    if entryMap[pGUID][slot] then
						player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), entryMap[pGUID][slot])
                        player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER)+1, entryMap[pGUID][slot+20])
                        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), entryMap[pGUID][slot])
                        player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER)+1, entryMap[pGUID][slot+20])
                    end
                end
            end
        end
    end
end

local function OnLogout(event, player)   --玩家退出时候清理内存数组
    local pGUID = player:GetGUIDLow()
    entryMap[pGUID] = nil
end

local function OnEquip(event, player, item, bag, slot)
    local pGUID = player:GetGUIDLow()
    if entryMap[pGUID] then
        if entryMap[pGUID][slot] then
            player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), entryMap[pGUID][slot])
			player:SetUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER)+1, entryMap[pGUID][slot+20])
            player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER), entryMap[pGUID][slot])
			player:UpdateUInt32Value(PLAYER_VISIBLE_ITEM_1_ENTRYID + (slot * ITEM_SLOT_MULTIPLIER)+1, entryMap[pGUID][slot+20])
        end
    end
end

-- Note, Query is instant when Execute is delayed
CharDBQuery([[
CREATE TABLE IF NOT EXISTS `custom_transmogs` (
`GUID` INT(10) UNSIGNED NOT NULL COMMENT 'Item guidLow',
`FakeEntry` INT(10) UNSIGNED NOT NULL COMMENT 'Item entry',
`Enchant` INT(10) UNSIGNED NOT NULL COMMENT 'Item enchant',
`Owner` INT(10) UNSIGNED NOT NULL COMMENT 'Player guidLow'
)
COMMENT='version 4.0'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;
]])

RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(4, OnLogout)
RegisterPlayerEvent(29, OnEquip)

RegisterCreatureGossipEvent(NPC_Entry, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_Entry, 2, OnGossipSelect)

local plrs = GetPlayersInWorld()
if plrs then
    for k, player in ipairs(plrs) do
        OnLogin(k, player)
    end
end
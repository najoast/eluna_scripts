function RollEnchant(item)
        rarityRoll = math.random(100)
        local itemClass = ""
        if (item:GetClass() == 2) then
                itemClass = "WEAPON"
        elseif (item:GetClass() == 4) then
                itemClass = "ARMOR"
        end
        if (rarityRoll <= 44) then
                local query = WorldDBQuery("SELECT enchantID FROM item_enchantment_random_tiers WHERE tier=1 AND exclusiveSubClass=NULL AND class='"..itemClass.."' OR exclusiveSubClass="..item:GetSubClass().." OR class='ANY' ORDER BY RAND() LIMIT 1")
                return query:GetUInt32(0)
        elseif (rarityRoll <= 64) then
                local query = WorldDBQuery("SELECT enchantID FROM item_enchantment_random_tiers WHERE tier=2 AND exclusiveSubClass=NULL AND class='"..itemClass.."' OR exclusiveSubClass="..item:GetSubClass().." OR class='ANY' ORDER BY RAND() LIMIT 1")
                return query:GetUInt32(0)
        elseif (rarityRoll <= 79) then
                local query = WorldDBQuery("SELECT enchantID FROM item_enchantment_random_tiers WHERE tier=3 AND exclusiveSubClass=NULL AND class='"..itemClass.."' OR exclusiveSubClass="..item:GetSubClass().." OR class='ANY' ORDER BY RAND() LIMIT 1")
                return query:GetUInt32(0)
        elseif (rarityRoll <= 92) then
                local query = WorldDBQuery("SELECT enchantID FROM item_enchantment_random_tiers WHERE tier=4 AND exclusiveSubClass=NULL AND class='"..itemClass.."' OR exclusiveSubClass="..item:GetSubClass().." OR class='ANY' ORDER BY RAND() LIMIT 1")
                return query:GetUInt32(0)
        else
                local query = WorldDBQuery("SELECT enchantID FROM item_enchantment_random_tiers WHERE tier=5 AND exclusiveSubClass=NULL AND class='"..itemClass.."' OR exclusiveSubClass="..item:GetSubClass().." OR class='ANY' ORDER BY RAND() LIMIT 1")
                return query:GetUInt32(0)
        end
end

function OnLoot1(event, player, item, count)
	if (item:GetClass() == 2 or item:GetClass() == 4 ) then
        item:SetEnchantment(RollEnchant(item), 5)
	end
end
 
RegisterPlayerEvent(32, OnLoot1)
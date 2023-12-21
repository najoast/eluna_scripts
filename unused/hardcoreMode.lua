--Item that designates that character is a hardcore character.
local hardCoreItem = 90000
--NPC id
local hcNPC = 90000
--This is how long the character is locked for - default is 32 years.
local banTimer = 999999999

--on death function - checks if player has token and bans character if it does.
local function PlayerDeath(event, killer, killed)
    if(killed:HasItem(hardCoreItem,1)) then
        print(killed:GetName() .. " was killed by " .. killer:GetName())
        SendWorldMessage(killed:GetName() .. " was killed by " .. killer:GetName())
        Ban(1,killed:GetName(),banTimer)
    end
end

--First Gossip Screen for NPC
function OnFirstTalk(event, player, unit)
	player:GossipMenuAddItem(0, "Looking for a challenge??? Click here to try hardcore mode!", 0, 1)
	player:GossipSendMenu(1, unit)
end

--Selection for NPC gossip
function OnSelect(event, player, unit, sender, intid, code)
	if (intid == 1) then
		player:GossipMenuAddItem(0, "Just making sure that you want to turn on hardcore mode?? This will lock the character after death and you will no longer be able to play the character!!!", 0, 2)
        	player:GossipMenuAddItem(0, "NO TAKE ME BACK!", 0, 3)
        	player:GossipSendMenu(2, unit)
	end
end

--if player chooses to do hardcore they receive the token 
function OnHardCore(event, player, unit, sender, initid, code)
    if (initd == 2) then
        player:GiveItem(hardCoreItem)
    --else gossip ends
    else
        player:GossipComplete()
    end
end


RegisterCreatureGossipEvent(hcNPC, 1 , OnFirstTalk)
RegisterCreatureGossipEvent(hcNPC, 2, OnSelect)
RegisterCreatureGossipEvent(hcNPC, 2, OnHardCore)
RegisterPlayerEvent( 8, PlayerDeath)

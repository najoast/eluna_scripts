local CheatCommands = {};

CheatCommands.Config={
	prefix='[Command +]|r\n',
	spacer='     ',
	color1='|CFFB296BE',
	color2='|CFFDF5050',
	color3='|CFFFFFFFF',
	color4='|CFFFF0000',
	color5='|CFF00B405';
};

CheatCommands.Text={
	main=''..CheatCommands.Config.color1..CheatCommands.Config.prefix..CheatCommands.Config.spacer..CheatCommands.Config.color3..'';
	mainError=CheatCommands.Config.color4..'[ERROR] #NO ENTRY OR TARGET SELECTED';
	teleError=CheatCommands.Config.color4..'[ERROR] #NO TELEPORT SELECTED';
	factionError=CheatCommands.Config.color4..'[ERROR] #NO RACE SELECTED';

	imodel='Model of this item is -> ';
	idupli='Entry of your new item is -> ';

	gmodel='Model of this gameobject is -> ';
	gdupli='Entry of your new gameobject is -> ';

	cmodel='Model of this npc is -> ';
	centry='Entry of this npc is -> ';
	cguid='Guid of this npc is -> ';
	cdupli='Entry of your new npc is -> ';

	ptele='Player Teleported to -> ';
	pfaction='Player has the faction for race -> ';
};

CheatCommands.List = {
	'getmodel item',
	'getmodel npc',
	'getmodel gob',

	'getnpc entry',
	'getnpc guid',
	'getnpc model',

	'duplicate item',
	'duplicate npc',
	'duplicate gob',

	'player set faction',
	'player teleport',
};

CheatCommands.TpList = {};

function CheatCommands.getTeleport(informations)
	local getTele = WorldDBQuery('SELECT map, position_x, position_y, position_z, orientation, name FROM game_tele;');
	if getTele then
		repeat
			local getTele_Data = getTele:GetRow();

			local map = getTele_Data['map'];
			local position_x = getTele_Data['position_x'];
			local position_y = getTele_Data['position_y'];
			local position_z = getTele_Data['position_z'];
			local orientation = getTele_Data['orientation'];
			local name = string.lower(getTele_Data['name']);

			table.insert(CheatCommands.TpList, {name, map, position_x, position_y, position_z, orientation});
		until not getTele:NextRow();
	end
end
RegisterServerEvent(33, CheatCommands.getTeleport)

-- In dev
function CheatCommands.playerfaction(informations)
	if(informations.type)then
		if(informations.digits)then
			CheatCommands.race = {
				[1]='Human', [2]='Orc', [3]='Dwarf', [4]='NightElf', [5]='Undead', [6]='Tauren', [7]='Gnome', [8]='Troll', [10]='BloodElf', [11]='Draenei';
			};
			informations.type:SetFactionForRace(informations.digits);
			for k, v in pairs(CheatCommands.race)do
				if(informations.digits == ''..k..'')then
					informations.letters = v;
				end
			end
			informations.result = CheatCommands.Config.color5..informations.letters;
		else
			informations.result = CheatCommands.Text.factionError;
		end
	else
		informations.result = CheatCommands.Text.mainError;
	end
	return informations.result;
end

function CheatCommands.playerteleport(informations)
	if(informations.type)then
		if(informations.letters)then
			for k, v in pairs(CheatCommands.TpList)do
				if (v[1] == string.lower(informations.letters))then
					informations.type:Teleport(v[2], v[3], v[4], v[5], v[6]);
					informations.result = CheatCommands.Config.color5..informations.letters;
				end
			end
		else
			informations.result = CheatCommands.Text.teleError;
		end
	else
		informations.result = CheatCommands.Text.mainError;
	end
	return informations.result;
end

function CheatCommands.duplicate(informations)
	if(informations.type)then
		if informations.type==7 then 
			informations.type='item_template';
			informations.column='displayid';
		elseif informations.type==8 then 
			informations.type='creature_template';
			informations.column='modelid1';
		elseif informations.type==9 then 
			informations.type='gameobject_template';
			informations.column='displayid';
		end

		local getData = WorldDBQuery('SELECT entry FROM '..informations.type..' WHERE entry = '..informations.digits..';');
		if(getData)then
			WorldDBQuery('CREATE TEMPORARY TABLE TEMP_QUERY ENGINE=MEMORY SELECT * FROM '..informations.type..' WHERE entry = '..informations.digits..';')
			WorldDBQuery('UPDATE TEMP_QUERY SET entry=(SELECT MAX(entry)+1 FROM '..informations.type..');');
			WorldDBQuery('INSERT INTO '..informations.type..' SELECT * FROM TEMP_QUERY;');
			WorldDBQuery('DROP TABLE TEMP_QUERY;');

			informations.result = CheatCommands.Config.color5..WorldDBQuery('SELECT MAX(entry) FROM '..informations.type..';'):GetUInt32(0);
		else
			informations.result = CheatCommands.Text.mainError;
		end
	else
		informations.result = CheatCommands.Text.mainError;
	end
	return informations.result;
end

function CheatCommands.getModel(informations)
	if(informations.type)then
		if informations.type==1 then 
			informations.type='item_template';
			informations.column='displayid';
		elseif informations.type==2 then 
			informations.type='creature_template';
			informations.column='modelid1';
		elseif informations.type==3 then 
			informations.type='gameobject_template';
			informations.column='displayid';
		end

		local getModel = WorldDBQuery('SELECT '..informations.column..' FROM '..informations.type.. ' where entry='..informations.digits..';');

		if(getModel)then
			informations.result = CheatCommands.Config.color5..getModel:GetUInt32(0);
		else
			informations.result = CheatCommands.Text.mainError;
		end
	end
	return informations.result;
end

function CheatCommands.getSelectEntry(informations)
	if(informations.type)then
		informations.result = CheatCommands.Config.color5..informations.type:GetEntry();
	end
	return informations.result;
end

function CheatCommands.getSelectGuid(informations)
	if(informations.type)then
		informations.result = CheatCommands.Config.color5..informations.type:GetGUIDLow();
	end
	return informations.result;
end

function CheatCommands.getSelectModel(informations)
	if(informations.type)then
		informations.result = CheatCommands.Config.color5..informations.type:GetDisplayId();
	end
	return informations.result;
end

CheatCommands.Action = {
	[1]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.imodel..CheatCommands.getModel(CheatCommands.informations))end,
	[2]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.cmodel..CheatCommands.getModel(CheatCommands.informations))end,
	[3]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.gmodel..CheatCommands.getModel(CheatCommands.informations))end,

	[4]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.centry..CheatCommands.getSelectEntry(CheatCommands.informations))end,
	[5]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.cguid..CheatCommands.getSelectGuid(CheatCommands.informations))end,
	[6]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.cmodel..CheatCommands.getSelectModel(CheatCommands.informations))end,

	[7]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.idupli..CheatCommands.duplicate(CheatCommands.informations))end,
	[8]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.cdupli..CheatCommands.duplicate(CheatCommands.informations))end,
	[9]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.gdupli..CheatCommands.duplicate(CheatCommands.informations))end,

	[10]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.pfaction..CheatCommands.playerfaction(CheatCommands.informations))end,
	[11]=function(player, target)player:SendBroadcastMessage(CheatCommands.Text.main..CheatCommands.Text.ptele..CheatCommands.playerteleport(CheatCommands.informations))end;
};

function CheatCommands.onCommand(event, player, command)
	for index, value in pairs(CheatCommands.List) do
		
		CheatCommands.c = string.lower(command);
		CheatCommands.v = string.lower(value);

		if(string.match(CheatCommands.c, CheatCommands.v..'?')) then
			CheatCommands.getTarget = player:GetSelection();

			if (index == 4 or index == 5 or index == 6 or index == 10 or index == 11)then
				if (CheatCommands.getTarget)then
					if(CheatCommands.getTarget:GetTypeId() == 3)then
						CheatCommands.informations={
							letters = command:gsub(CheatCommands.v.." ", "");
							digits = string.match(CheatCommands.c, "%d+");
							type = CheatCommands.getTarget;
						};
					elseif (CheatCommands.getTarget:GetTypeId() == 4)then
						CheatCommands.informations={
							letters = command:gsub(CheatCommands.v.." ", "");
							digits = string.match(CheatCommands.c, "%d+");
							type = CheatCommands.getTarget;
						};
					end
				else
					CheatCommands.informations={
						result = CheatCommands.Text.mainError;
					};
				end
			elseif(index == 1 or index == 2 or index == 3 or index == 7 or index == 8 or index == 9)then
				CheatCommands.informations={
					letters = command:gsub(CheatCommands.v.." ", "");
					digits = string.match(CheatCommands.c, "%d+");
					type = index;
				};
			else
				CheatCommands.informations={
					result = CheatCommands.Text.mainError;
				};
			end

			CheatCommands.Action[index](player, CheatCommands.informations);
			return false;
		end
	end
end
RegisterPlayerEvent(42, CheatCommands.onCommand)
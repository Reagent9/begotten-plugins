--[[
	Begotten III: Jesus Wept
--]]

-- Todo: Detect character changing, disconnects, players leaving the dueling arena somehow (maybe teleported by admin by mistake?).

local map = game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_begotten_redux" or game.GetMap() == "rp_scraptown";
local CTFrespawnTime = 30;

-- Called when Clockwork has loaded all of the entities.
function cwDueling:ClockworkInitPostEntity()
	if (map) then
		for k, v in pairs(DUELING_STATUES) do -- statues
			local statueEnt = ents.Create("cw_duelstatue");
			
			statueEnt:SetPos(DUELING_STATUES[k]["spawnPosition"]);
			statueEnt:SetAngles(DUELING_STATUES[k]["spawnAngles"]);
			statueEnt:Spawn();
		end

		for k, v in pairs(DUELING_LEADERBOARDS) do -- leaderboards
			local leadEnt = ents.Create("cw_leaderboard");
			
			leadEnt:SetPos(DUELING_LEADERBOARDS[k]["spawnPosition"]);
			leadEnt:SetAngles(DUELING_LEADERBOARDS[k]["spawnAngles"]);
			leadEnt.LeaderboardType = DUELING_LEADERBOARDS[k]["leaderboardType"]
			leadEnt:Spawn();
		end

	end;
end

-- Called when a player dies.
function cwDueling:PlayerDeath(player, inflictor, attacker, damageInfo)
	if (!map) then
		return;
	end;
	
	if self:PlayerIsDueling(player) then
		local duelType = player:GetSharedVar("duelType")
		local duelArena = player:GetSharedVar("duelArena")
		local playerTID = player:GetSharedVar("teamID");

		if attacker and type(attacker.GetSharedVar) == "function" then
			local attackerTID = attacker:GetSharedVar("teamID");
			if attackerTID == playerTID then
				attackerFriendlyFires = attacker:GetSharedVar("duelFriendlyFires") or 0;
				attacker:SetSharedVar("duelFriendlyFires", attackerFriendlyFires + 1)
			else
				local attackerKills = attacker:GetSharedVar("duelKills") or 0;
				attacker:SetSharedVar("duelKills", attackerKills + 1)
			end
		end
		
		if duelType == "FFA" then
			winner, losers = cwDueling:FFAEndCheck()
			if winner ~= nil then 
				self:FFACompleted(winner, losers)
			else
				timer.Simple(1, function()
					if IsValid(player) then
						player:Spectate(0);
						player:UnSpectate();
						cwObserverMode:MakePlayerEnterObserverMode(player);
						player:Extinguish();
					end
				end);
			end
		elseif duelType == "Thralls" then
			if cwDueling:AreTeamPlayersAllDead(cwDueling.THRALL_ARENAS[duelArena].players) then
				cwDueling:ThrallCompleted(duelArena, true)
			else
				timer.Simple(1, function()
					if IsValid(player) then
						player:Spectate(0);
						player:UnSpectate();
						cwObserverMode:MakePlayerEnterObserverMode(player);
					end
				end);
			end
		elseif duelType == "CTF" then
			local playerCarryingFlag = player:GetSharedVar("DuelCarryingFlag")
			if playerCarryingFlag then
				hook.Remove("PlayerSwitchWeapon", "DropFlagOnSwitch" .. player:GetName())
				DropFlag(player);
			end
			if timer.Exists("DuelCTFRespawn" .. playerTID) then
				local timeLeft = timer.TimeLeft("DuelCTFRespawn" .. playerTID) or 0;
				if timeLeft ~= 0 then
					if timeLeft >= 3 then
						timer.Simple(1, function()
							if IsValid(player) then
								player:Spectate(0);
								player:UnSpectate();
								cwObserverMode:MakePlayerEnterObserverMode(player);
								player:Extinguish();
							end
						end);
					end
					Schema:EasyText(player, "You will respawn in " .. math.floor(timeLeft) .. " seconds.");
				end
			else
				timer.Simple(1, function()
					if IsValid(player) then
						player:Spectate(0);
						player:UnSpectate();
						cwObserverMode:MakePlayerEnterObserverMode(player);
						player:Extinguish();
					end
				end);

				Schema:EasyText(player, "You will respawn in " .. CTFrespawnTime .. " seconds.");
				timer.Create("DuelCTFRespawn" .. playerTID, CTFrespawnTime, 1, function()
					cwDueling:CTFRespawnDeadTeam(playerTID, duelArena)
				end)
			end
		else
			local team = cwDueling:GetPlayerTeam(player);
			if cwDueling:AreTeamPlayersAllDead(team.players) then
				local winner = player.opponent;
				if winner then
					self:DuelCompleted(winner, team, duelArena);
				else
					self:DuelAborted(team, winner, duelArena);
				end

			else
			timer.Simple(1, function() -- try removing timer in future
				if IsValid(player) then
					player:Spectate(0);
					player:UnSpectate();
					cwObserverMode:MakePlayerEnterObserverMode(player);
				end
			end);
		end
	end
end
end;

function cwDueling:PlayerDisconnected(player)
	local duelParty = player:GetSharedVar("duelParty")
	local duelType = player:GetSharedVar("duelType")
	local duelArena = player:GetSharedVar("duelArena")
	
	if self:PlayerIsDueling(player) and !player.duelStatue then
		local players = _player.GetAll()
		Schema:EasyText(players, player:GetName() .. " rage quit a duel!!");
		
		if duelType == "FFA" then
			for k,pparty in pairs(DUELING_ARENAS[duelArena].duelingFFAPlayers) do
				if pparty.players[1] == player then
					table.remove(DUELING_ARENAS[duelArena].duelingFFAPlayers, k)
					break
				end
			end
			winner, losers = cwDueling:FFAEndCheck()
			if winner ~= nil then 
				self:FFACompleted(winner, losers)
			end
		elseif duelType == "Thralls" then
			for k,p in pairs(cwDueling.THRALL_ARENAS[duelArena].players) do
				if p == player then
					table.remove(cwDueling.THRALL_ARENAS[duelArena].players, k)
					break
				end
			end

			if cwDueling:AreTeamPlayersAllDead(cwDueling.THRALL_ARENAS[duelArena].players) then
				cwDueling:ThrallCompleted(duelArena, true)
			end
		elseif duelType == "CTF" then
			local playerCarryingFlag = player:GetSharedVar("DuelCarryingFlag")
			if playerCarryingFlag then
				hook.Remove("PlayerSwitchWeapon", "DropFlagOnSwitch" .. player:GetName())
				DropFlag(player);
			end

			local team = cwDueling:GetPlayerTeam(player);
			for k,p in pairs(team.players) do
				if p:GetName() == player:GetName() then
					print("Removing " .. p:GetName() .. " from their team due to them leaving.")
					table.remove(team.players, k)
					break
				end
			end
			if #team.players == 0 then
				local winner = player.opponent;
				if #winner.players > 0 then
					cwDueling:CTFCompleted(winner, team, duelArena);
				else
					cwDueling:CTFAborted(winner, team, duelArena);
				end
			end
		else
			local team = cwDueling:GetPlayerTeam(player);
			-- remove player from team
			for k,p in pairs(team.players) do
				if p:GetName() == player:GetName() then
					print("Removing " .. p:GetName() .. " from their team due to them leaving.")
					table.remove(team.players, k) 
					break
				end
			end
			if cwDueling:AreTeamPlayersAllDead(team.players) then
				local winner = player.opponent;
				if winner then
					self:DuelCompleted(winner, team, duelArena);
				else
					self:DuelAborted(team, winner, duelArena);
				end
			end
		end
	elseif self:PlayerIsInMatchmaking(player) then
		if duelParty ~= nil then
			self:PartyExitsMatchmaking(duelParty);
		else
			self:PlayerExitsMatchmaking(player);
		end
	end
	
	-- Remove from party if in one, put in function later
	if duelParty ~= nil and cwDueling.DUELING_PARTIES[duelParty] then
        for i, partyMember in pairs(cwDueling.DUELING_PARTIES[duelParty].players) do
            if partyMember == player then
				if cwDueling.DUELING_PARTIES[duelParty].size == 1 then
					cwDueling.DUELING_PARTIES[duelParty] = nil;
				else
                	table.remove(cwDueling.DUELING_PARTIES[duelParty].players, i)
					cwDueling.DUELING_PARTIES[duelParty].size = cwDueling.DUELING_PARTIES[duelParty].size - 1;
				end
                break
            end
        end
    end
end;

-- For recording player damage done to opponents
function cwDueling:FuckMyLife(entity, damageInfo)
	if cwDueling:PlayerIsDueling(entity) then
		local inflictor = damageInfo:GetInflictor()
		local attacker = damageInfo:GetAttacker()
		local amount = math.ceil(damageInfo:GetDamage())

		if attacker and type(attacker.GetSharedVar) == "function" then
			local entTID = entity:GetSharedVar("teamID")
			local atkTID = attacker:GetSharedVar("teamID");
			if entTID ~= atkTID then
				local dmgSoFar = (attacker:GetSharedVar("duelDamageDone") or 0) + amount;
				attacker:SetSharedVar("duelDamageDone", dmgSoFar)
			end
		end
	end
end

-- Called when a player wants to fallover.
function cwDueling:PlayerCanFallover(player)
	if player.opponent or self:PlayerIsInMatchmaking(player) then
		return false;
	end
end

function cwDueling:PlayerCanTakeLimbDamage(player, hitGroup)
	--[[if player.opponent then
		return false;
	end]]--
end;

function cwDueling:PlayerCanSwitchCharacter(player, character)
	if --[[self:PlayerIsDueling(player)]] player.opponent or self:PlayerIsInMatchmaking(player) then
		return false
	end
end;

-- Called when a player attempts to use an item.
function cwDueling:PlayerCanUseItem(player, itemTable, noMessage)
	if self:PlayerIsInMatchmaking(player) then
		Schema:EasyText(player, "firebrick", "You cannot use items while matchmaking for a duel!");
		return false;
	--elseif self:PlayerIsDueling(player) then
	elseif player.opponent then
		Schema:EasyText(player, "firebrick", "You cannot use items while in a duel!");
		return false;
	end;
end;

-- Called when a player attempts to drop an item.
function cwDueling:PlayerCanDropItem(player, itemTable, noMessage)
	if self:PlayerIsInMatchmaking(player) then
		Schema:EasyText(player, "firebrick", "You cannot drop items while matchmaking for a duel!");
		return false;
	--elseif self:PlayerIsDueling(player) then
	elseif player.opponent then
		Schema:EasyText(player, "firebrick", "You cannot drop items while in a duel!");
		return false;
	end;
end;

function cwDueling:PlayerUse(player, entity)
	if player.opponent then
		return false;
	end
end;
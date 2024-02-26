--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]] -- 

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwDueling = cwDueling;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props/begotten/misc/duel_statue.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetCollisionGroup(COLLISION_GROUP_WORLD);
	--[[self.Sound = CreateSound(self, "ambient/statue/st_seventhday_01.wav");
	self.Sound:PlayEx(0.2, 100);]]--

	local physicsObject = self:GetPhysicsObject();
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- Called when someone uses the entity
function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		if caller.opponent == nil then
			local duelParty = caller:GetSharedVar("duelParty")
			
			if (!cwDueling:PlayerIsInMatchmaking(caller)) then
				if not cwDueling.firearmsAllowed then
					for k, v in pairs(caller:GetWeapons()) do
						local weaponItemTable = item.GetByWeapon(v);
						if weaponItemTable then
							if weaponItemTable.category == "Firearms" then
								if Clockwork then
									Schema:EasyText(caller, "peru","You cannot enter a duel with a firearm equipped!");
								end
								return;
							end
						end
					end
				end
				Clockwork.dermaDuel:RequestDuel(caller, "Duel", "There is no risk for dueling, select a type.", cwDueling:GetPlayersInQueue(), function(response)
					if response == "cancel" then
					elseif response == "6" and (not cwDueling.FFAmodeEnabled and not (caller:SteamID() == "STEAM_0:1:39698692")) then
						Schema:EasyText(caller, "peru","Disabled.");
					elseif response == "7" and (not cwDueling.CTFmodeEnabled and not (caller:SteamID() == "STEAM_0:1:39698692")) then
						Schema:EasyText(caller, "peru","Disabled.");
					elseif response == "8" and (not cwDueling.thrallmodeEnabled and not (caller:SteamID() == "STEAM_0:1:39698692")) then
						Schema:EasyText(caller, "peru","Disabled.");
					else	
						local maxPlayers;
						if response == "5" then
							Schema:EasyText(caller, "peru","FFA Beta testing, report any bugs!");
							maxPlayers = 1 
						elseif response == "6" then
							Schema:EasyText(caller, "peru","Thrall Survival Beta testing, report any bugs!");
							maxPlayers = 4
						elseif response == "7" then
							Schema:EasyText(caller, "peru","CTF Beta testing, report any bugs!");
							maxPlayers = 3
						else
							maxPlayers = tonumber(response) + 1
						end
						response = tonumber(response) + 1
						
						if duelParty and cwDueling.DUELING_PARTIES[duelParty] then
							if cwDueling.DUELING_PARTIES[duelParty].size > maxPlayers then
								Schema:EasyText(caller, "peru","You have too many players in your party to choose this duel type.");
							else
							
								local leader = cwDueling.DUELING_PARTIES[duelParty].players[1]
								if caller:GetName() == leader:GetName() then
									local partyInDuelingCircle = true
									for _, partyMember in ipairs(cwDueling.DUELING_PARTIES[duelParty]) do
										if partyMember:GetPos():DistToSqr(leader.duelStatue:GetPos()) > (256 * 256) then
											partyInDuelingCircle = false
											break;
										end
									end

									if partyInDuelingCircle then
										cwDueling:PartyEntersMatchmaking(cwDueling.DUELING_PARTIES[duelParty], response)
										for k,v in pairs(cwDueling.DUELING_PARTIES[duelParty].players) do
											v.cachedPos = v:GetPos()
											v.cachedAngles = v:GetAngles()
											v.cachedHP = v:Health()
											v.duelStatue = self
										end
									else
										Schema:EasyText(caller, "peru","Failure: One of your party members is outside your duel shrine.");
									end
								else
									Schema:EasyText(caller, "peru","Failure: Not leader of party");
								end
							end
						else
							cwDueling:PlayerEntersMatchmaking(caller, response)
							caller.cachedPos = caller:GetPos()
							caller.cachedAngles = caller:GetAngles()
							caller.cachedHP = caller:Health()
							caller.duelStatue = self
						end
					end
				end);				
			else
				if duelParty and cwDueling.DUELING_PARTIES[duelParty] ~= nil then
					cwDueling:PartyExitsMatchmaking(duelParty);
					Schema:EasyText(cwDueling.DUELING_PARTIES[duelParty].players, "icon16/shield_go.png", "orange", "Party Member Exited Duel Matchmaking")
					for _,v in pairs(cwDueling.DUELING_PARTIES[duelParty].players) do
						v.cachedPos = nil;
						v.cachedAngles = nil;
						v.cachedHP = nil;
						v.duelStatue = nil;
					end
				else
					Schema:EasyText(caller, "icon16/shield_go.png", "orange", "Exited Duel Matchmaking")
					cwDueling:PlayerExitsMatchmaking(caller);
				
					caller.cachedPos = nil;
					caller.cachedAngles = nil;
					caller.cachedHP = nil;
					caller.duelStatue = nil;
				end
			end;
		end;
	end;
end;

--[[function ENT:OnRemove()
	self.Sound:Stop();
end;]]--

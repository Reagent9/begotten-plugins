--[[
	Begotten III: Jesus Wept
--]]

Clockwork.datastream:Hook("SetPlayerDueling", function(dueling)
	Clockwork.Client.dueling = dueling;
end);

function cwDueling:CanOpenEntityMenu()
	if Clockwork.Client.dueling then
		local curTime = CurTime();
		if !cwDueling.nextInteractMessage or cwDueling.nextInteractMessage < curTime then
			cwDueling.nextInteractMessage = curTime + 5;
			Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You cannot interact with entities while in a duel!");
		end
		return false;
	end
end

function cwDueling:CanPlayAmbientMusic()
	if Clockwork.Client.dueling then
		return false;
	end
end

-- Called when the target ID HUD should be drawn.
function GM:HUDDrawTargetID()
	if (IsValid(Clockwork.Client) and Clockwork.Client:Alive() and !IsValid(Clockwork.EntityMenu)) then
		if (!Clockwork.Client:IsRagdolled(RAGDOLL_FALLENOVER)) then
			local trace = Clockwork.player:GetRealTrace(Clockwork.Client)
			local traceEntity = trace.Entity
			local fadeDistance = 1024;
			
			local curTime = UnPredictedCurTime()
			
			if (!self.TargetEntities) then
				self.TargetEntities = {}
			end

			if (IsValid(traceEntity) and !traceEntity:IsEffectActive(EF_NODRAW) and traceEntity:GetColor().a > 0) then
				if (!self.TargetEntities[traceEntity]) then
					if (traceEntity.WrappedTable) then
						traceEntity.WrappedTable = nil;
					end;
					
					if (traceEntity.SEXMONSTERTABLE) then
						traceEntity.SEXMONSTERTABLE = nil;
					end;

					self.TargetEntities[traceEntity] = 1
					traceEntity.grace = curTime + 2
				end
			end
			
			local targetIDTextFont = Clockwork.option:GetFont("target_id_text")
			local shootPosition = Clockwork.Client:GetShootPos()
			local frameTime = FrameTime()
			
			Clockwork.kernel:OverrideMainFont(targetIDTextFont)
			
			for k, v in pairs (self.TargetEntities) do
				local alpha = self.TargetEntities[k]
				local entity = k
				
				if (!IsValid(entity) or alpha == 0 and self.TargetEntities[k]) then
					self.TargetEntities[k] = nil
					continue
				end

				local entityPosition = entity:GetPos()
				local class = entity:GetClass()
				local distance = shootPosition:Distance(entityPosition)
				local screenPosition = (entityPosition + Vector(0, 0, 20)):ToScreen()
				local x, y = screenPosition.x, screenPosition.y
				local fade = false

				if (distance >= fadeDistance) then
					fade = true
				elseif (traceEntity != entity) then
					fade = true
				end
				
				if (fade) then
					if (alpha != 0) then
						self.TargetEntities[k] = math.Approach(alpha, 0, frameTime * 256)
					else
						self.TargetEntities[k] = nil continue
					end
				else
					if (alpha != 255) then
						self.TargetEntities[k] = math.Approach(alpha, 255, frameTime * 256)
					end
				end
				
				local distanceAlpha = Clockwork.kernel:CalculateAlphaFromDistance(fadeDistance, shootPosition, entityPosition)
				alpha = math.min(distanceAlpha, alpha)

				if alpha > 0 then
					local player = Clockwork.entity:GetPlayer(entity)
					
					if (player and Clockwork.Client != player) then
						if (Clockwork.plugin:Call("ShouldDrawPlayerTargetID", player)) then
							if (!Clockwork.player:IsNoClipping(player)) then
								if (Clockwork.nextCheckRecognises and Clockwork.nextCheckRecognises[2] != player) then
									Clockwork.Client:SetSharedVar("TargetKnows", true)
								end
								
								local playerEntity = nil
								local position = Clockwork.plugin:Call("GetPlayerTypingDisplayPosition", player)
								local ragdoll = player:GetRagdollEntity()
								
								if (IsValid(ragdoll)) then
									playerEntity = ragdoll
								else
									playerEntity = player
								end

								if (!position) then
									local headBone = "ValveBiped.Bip01_Head1"
									
									if (string.find(playerEntity:GetModel(), "vortigaunt")) then
										headBone = "ValveBiped.Head"
									end
									
									local headID = playerEntity:LookupBone(headBone)

									if (headID) then
										local bonePosition = playerEntity:GetBonePosition(headID)
										
										if (!bonePosition) then
											local ragdolled = playerEntity:IsRagdolled()
											local vehicle = playerEntity:InVehicle()
											local add = 80

											if (vehicle) then
												add = 128
											elseif (ragdolled) then
												add = 16
											elseif (crouching) then
												add = 64
											end
											
											position = entityPosition + Vector(0, 0, add)
										else
											position = bonePosition + Vector(0, 0, 18)
										end
									end
									
									if (!position) then
										position = entityPosition
									end
								end
								
								local screenPosition = position:ToScreen()
								local x, y = screenPosition.x, screenPosition.y
								local clientFaction = Clockwork.Client:GetFaction();
								local playerFaction = player:GetFaction();
								
								if (Clockwork.player:DoesRecognise(player, RECOGNISE_PARTIAL)) then
									local teamColor = _team.GetColor(player:Team());
									local text = string.Explode("\n", Clockwork.plugin:Call("GetTargetPlayerName", player))
									local newY
									
									if playerFaction == "Gatekeeper" and clientFaction ~= "Gatekeeper" and clientFaction ~= "Holy Hierarchy" then
										local clothesItem = player:GetClothesEquipped();
										
										if !clothesItem or (clothesItem.faction and clothesItem.faction ~= playerFaction) then
											teamColor = Color(200, 200, 200, 255);
										end
									elseif playerFaction == "Children of Satan" and clientFaction ~= "Children of Satan" then
										if not string.find(player:GetModel(), "models/begotten/satanists") then
											local kinisgerOverride = player:GetSharedVar("kinisgerOverride");
											
											if kinisgerOverride then
												local classTable = Clockwork.class:GetStored()[kinisgerOverride];
												
												if classTable then
													teamColor = _team.GetColor(classTable.index) or Color(200, 200, 200, 255);
												else
													teamColor = Color(200, 200, 200, 255);
												end
											else
												teamColor = Color(200, 200, 200, 255);
											end
										end
									end
									
									for k, v in pairs(text) do
										newY = Clockwork.kernel:DrawInfo(v, x, y, teamColor, alpha)

										if (newY) then
											y = newY
										end
									end
								else
									local unrecognisedName, usedPhysDesc = Clockwork.player:GetUnrecognisedName(player)
									local wrappedTable = {unrecognisedName}
									local teamColor = _team.GetColor(player:Team())
									
									if playerFaction == "Gatekeeper" and clientFaction ~= "Gatekeeper" and clientFaction ~= "Holy Hierarchy" then
										local clothesItem = player:GetClothesEquipped();
										
										if !clothesItem or (clothesItem.faction and clothesItem.faction ~= playerFaction) then
											teamColor = Color(200, 200, 200, 255);
										end
									elseif playerFaction == "Children of Satan" and clientFaction ~= "Children of Satan" then
										if not string.find(player:GetModel(), "models/begotten/satanists") then
											local kinisgerOverride = player:GetSharedVar("kinisgerOverride");
											
											if kinisgerOverride then
												local classTable = Clockwork.class:GetStored()[kinisgerOverride];
												
												if classTable then
													teamColor = _team.GetColor(classTable.index) or Color(200, 200, 200, 255);
												else
													teamColor = Color(200, 200, 200, 255);
												end
											else
												teamColor = Color(200, 200, 200, 255);
											end
										end
									end
									
									local result;
									local newY;

									if CW_CONVAR_PHYSDESCINSPECT:GetInt() == 0 or input.IsKeyDown(KEY_X) then
										result = Clockwork.plugin:Call("PlayerCanShowUnrecognised", player, x, y, unrecognisedName, teamColor, alpha)
									else
										--result = "Press <X> to inspect this character.";
									end
									
									if result then
										if (type(result) == "string") then
											wrappedTable = {""}
											Clockwork.kernel:WrapTextSpaced(result, targetIDTextFont, math.max(math.Round(ScrW() / 3.75), 512), wrappedTable)
										elseif (usedPhysDesc) then
											wrappedTable = {""}
											Clockwork.kernel:WrapTextSpaced(unrecognisedName, targetIDTextFont, math.max(math.Round(ScrW() / 3.75), 512), wrappedTable)
										end

										if (result == true or type(result) == "string") then
											if (wrappedTable) then
												for k, v in pairs(wrappedTable) do
													newY = Clockwork.kernel:DrawInfo(v, x, y, teamColor, alpha)

													if (newY) then
														y = newY
													end
												end
											end;
										elseif (tonumber(result)) then
											y = result
										end
									end
								end
								
								local colorWhite = Color(255, 255, 255)
								
								if CW_CONVAR_PHYSDESCINSPECT:GetInt() == 0 or input.IsKeyDown(KEY_X) then
									Clockwork.TargetPlayerText.stored = {}
									
									Clockwork.plugin:Call("GetTargetPlayerText", player, Clockwork.TargetPlayerText)
									Clockwork.plugin:Call("DestroyTargetPlayerText", player, Clockwork.TargetPlayerText)
									
									y = Clockwork.plugin:Call("DrawTargetPlayerStatus", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetPlayerSubfaction", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetPlayerLevel", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetPlayerMarked", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetPlayerSymptoms", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetPlayerDuelstatus", player, alpha, x, y) or y
									
									for k, v in pairs(Clockwork.TargetPlayerText.stored) do
										if (v.scale) then
											y = Clockwork.kernel:DrawInfoScaled(v.scale, v.text, x, y, v.color or colorWhite, alpha)
										else
											y = Clockwork.kernel:DrawInfo(v.text, x, y, v.color or colorWhite, alpha)
										end
									end
								else
									if !(Clockwork.player:DoesRecognise(player, RECOGNISE_PARTIAL)) then
										Clockwork.TargetPlayerText.stored = {}
									
										Clockwork.plugin:Call("GetTargetPlayerText", player, Clockwork.TargetPlayerText)
										Clockwork.plugin:Call("DestroyTargetPlayerText", player, Clockwork.TargetPlayerText)
										
										for k, v in pairs(Clockwork.TargetPlayerText.stored) do
											if (v.scale) then
												y = Clockwork.kernel:DrawInfoScaled(v.scale, v.text, x, y, v.color or colorWhite, alpha)
											else
												y = Clockwork.kernel:DrawInfo(v.text, x, y, v.color or colorWhite, alpha)
											end
										end
									end
									
									y = Clockwork.plugin:Call("DrawTargetPlayerStatus", player, alpha, x, y) or y
									y = Clockwork.kernel:DrawInfo("Press <X> to inspect this character.", x, y, colorWhite, alpha)
								end
								
								if (!Clockwork.nextCheckRecognises or curTime >= Clockwork.nextCheckRecognises[1] or Clockwork.nextCheckRecognises[2] != player) then
									Clockwork.datastream:Start("GetTargetRecognises", player)
									
									Clockwork.nextCheckRecognises = {curTime + 2, player}
								end
							end
						end
					--[[elseif (Clockwork.generator and Clockwork.generator:FindByID(class)) then
						local generator = Clockwork.generator:FindByID(class)
						local power = trace.Entity:GetPower()
						local name = generator.name

						y = Clockwork.kernel:DrawInfo(name, x, y, Color(150, 150, 100, 255), alpha)
						
						local info = {
							showPower = true,
							generator = generator,
							x = x,
							y = y
						}
						
						Clockwork.plugin:Call("DrawGeneratorTargetID", trace.Entity, info)
						
						if (info.showPower) then
							if (power == 0) then
								info.y = Clockwork.kernel:DrawInfo("Press Use to re-supply", info.x, info.y, Color(255, 255, 255, 255), alpha)
							else
								info.y = Clockwork.kernel:DrawBar(
									info.x - 80, info.y, 160, 16, Clockwork.option:GetColor("information"), generator.powerPlural,
									power, generator.power, power < (generator.power / 5), {uniqueID = class}
								)
							end
						end
					elseif (entity:IsWeapon()) then
						local inactive = !IsValid(entity:GetParent())
						
						if (inactive) then
							y = Clockwork.kernel:DrawInfo(entity:GetPrintName(), x, y, Color(200, 100, 50, 255), alpha)
							y = Clockwork.kernel:DrawInfo("Press use to equip.", x, y, Color(255, 255, 255), alpha)
						end]]--
					elseif (entity.HUDPaintTargetID) then
						entity:HUDPaintTargetID(x, y, alpha)
					else
						hook.Call("HUDPaintEntityTargetID", Clockwork, entity, {
							alpha = alpha,
							x = x,
							y = y,
						})
					end
				end
			end
			
			Clockwork.kernel:OverrideMainFont(false)
		end
	end
end

hook.Add("DrawTargetPlayerDuelstatus", "", function(target, alpha, x, y)
    if Clockwork.Client.dueling then
		local pDuelTeamID = Clockwork.Client:GetSharedVar("teamID")
		local tDuelTeamID = target:GetSharedVar("teamID")
        local textColor 
		local txt

		if pDuelTeamID == tDuelTeamID then
			txt = "Part of your duel team."
			textColor = Color(0, 255, 0, 255)
		else
			txt = "Not part of your duel team."
			textColor = Color(255, 0, 0, 255)
		end

        if txt then
            return Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(txt), x, y, textColor, alpha)
        end
    end
end, HOOK_LOW)


-- Determine friendlies in duels and prepare to draw outlines on them
function cwDueling:AddEntityOutlines(outlines)
	local duelingHalo = Clockwork.Client:GetSharedVar("duelingHalo");
	local playerTID = Clockwork.Client:GetSharedVar("teamID");
	if Clockwork.Client.dueling and (duelingHalo == nil or not duelingHalo) then
		local playerCount = _player.GetCount();
		local players = _player.GetAll();

		for i = 1, playerCount do
			local v, k = players[i], i;
			local dueling = v:GetSharedVar("dueling");

			if dueling then
				local vTID = v:GetSharedVar("teamID");
				if vTID == playerTID then
					self:DrawPlayerOutline(v, outlines, Color(0, 255, 00, 255));
				end
			end;
		end;
	end
end

-- Handles the outline drawing logic
function cwDueling:DrawPlayerOutline(player, outlines, color)
	local moveType = player:GetMoveType();
	
	if (moveType == MOVETYPE_WALK or moveType == MOVETYPE_LADDER) then
		outlines:Add(player, color, 2, true);
		
		if IsValid(player.clothesEnt) then
			outlines:Add(player.clothesEnt, color, 2, true);
		end
	elseif player:IsRagdolled() then
		local ragdollEntity = player:GetRagdollEntity();
		
		if IsValid(ragdollEntity) then
			outlines:Add(ragdollEntity, color, 2, true);
			
			if IsValid(ragdollEntity.clothesEnt) then
				outlines:Add(ragdollEntity.clothesEnt, color, 2, true);
			end
		end
	end;
end;
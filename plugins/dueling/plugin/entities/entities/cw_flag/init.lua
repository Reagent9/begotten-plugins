function ENT:Initialize()
    self:SetModel(self.Model)
    self.CheckRadius = 55       -- Set the radius to check
    self.PickupDelay = 2        -- Set the pickup delay in seconds
    self.PlayersInSphere = {}   -- add players here in think() if not in alrdy, itr through the list to check if sphere
    self.Grabbed = false;
end

function ENT:Think()
    local entities = ents.FindInSphere(self:GetPos(), self.CheckRadius)
    for _, ent in ipairs(entities) do
        if ent:IsPlayer() then   
            local ply = ent
            local callerTeamID = ply:GetSharedVar("teamID")

            if callerTeamID ~= self.teamID then
                if self.PlayersInSphere[ply:GetName()] == nil then
                    if ply:HasWeapon("begotten_polearm_glazicbanner") then
                        -- print(ply:GetName() .. " has the weapon begotten_polearm_glazicbanner and won't pick up a new one!")
                    else
                        self.PlayersInSphere[ply:GetName()] = ply;
                        Schema:EasyText(ply, "peru", "The flag will be picked up in " .. self.PickupDelay .. " seconds.");
                        timer.Create("DuelCTFFlagGrabTimer" .. ply:GetName(), self.PickupDelay, 1, function()
                            if self.Grabbed == false then
                                self.Grabbed = true;
                                HandFlagTo(self, ply)
                            end
                        end)
                    end
                end
            end  
        end

        for k,v in pairs(self.PlayersInSphere) do
            if not table.HasValue(entities, v) then
                if IsValid(v) and v ~= nil then
                    self.PlayersInSphere[v:GetName()] = nil;
                    if timer.Exists("DuelCTFFlagGrabTimer" .. v:GetName()) then
                        timer.Remove("DuelCTFFlagGrabTimer" .. v:GetName())
                    end
                end
            end
        end
    end

    
end

function HandFlagTo(ent, grabber)
    Schema:EasyText(grabber, "peru", "Get the flag back to your base! Swapping weapons will drop the flag.");
    if IsValid(grabber) and grabber:IsPlayer() then
        grabber:Give("begotten_polearm_glazicbanner")
        grabber:SelectWeapon("begotten_polearm_glazicbanner")
        grabber:SetSharedVar("DuelCarryingFlag", true);

        hook.Add("PlayerSwitchWeapon", "DropFlagOnSwitch" .. grabber:GetName(), function(ply, oldWeapon, newWeapon)
            local grabberCarryingFlag = grabber:GetSharedVar("DuelCarryingFlag")
            if grabberCarryingFlag then
                if newWeapon:GetClass() ~= "begotten_polearm_glazicbanner" then
                    hook.Remove("PlayerSwitchWeapon", "DropFlagOnSwitch" .. ply:GetName())
                    ent.Grabbed = false;
                    DropFlag(ply)
                end
            else
                hook.Remove("PlayerSwitchWeapon", "DropFlagOnSwitch" .. ply:GetName())
                ent.Grabbed = false;
            end
        end)

        local arena = grabber:GetSharedVar("duelArena")
        cwDueling:CTFRemoveFlag(arena, ent)
        grabber:SetSharedVar("DuelFlagOrigin", ent.origin)
    end
end

function DropFlag(ply)
    local arena = ply:GetSharedVar("duelArena")
    local entDuelFlagOrig = ply:GetSharedVar("DuelFlagOrigin")
    
    ply:StripWeapon("begotten_polearm_glazicbanner")
    ply:SetSharedVar("DuelCarryingFlag", false);
    ply:SetSharedVar("DuelFlagOrigin", nil)

    if arena ~= nil and ply.opponent.ID ~= nil then
        local flag = ents.Create("cw_flag")
        flag:SetPos(ply:GetPos() + Vector(0, 0, 95))
        flag.teamID = ply.opponent.ID;
        flag.origin = entDuelFlagOrig;
        flag:SetAngles(ply:GetAngles())
        flag:Spawn()
        cwDueling:CTFAddFlag(arena, flag)
        -- start a timer for the flag, mayb above func. after n seconds, the flag will reset back to its flagzone
    end
end
Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("shared.lua");

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_NONE)
    self.radius = 135;
    if self.type == 0 then
        --
    else
        StartFlag(self)
    end
end

function ENT:Think()
    local entities = ents.FindInSphere(self:GetPos(), self.radius)
    for _,v in pairs(entities) do
        if v:IsPlayer() and IsValid(v) and v:Alive() then
            local entCarryingFlag = v:GetSharedVar("DuelCarryingFlag")
            local entTeam = v:GetSharedVar("teamID")
            if entCarryingFlag and entTeam == self.teamID then
                local entDuelFlagOrig = v:GetSharedVar("DuelFlagOrigin")
                ResetFlag(entDuelFlagOrig, v)
            end
        end
    end
end


function ResetFlag(self, ply)
    ply:SetSharedVar("DuelCarryingFlag", false);
    local flag = ents.Create("cw_flag")
    flag.teamID = self.teamID;
    flag.origin = self;
    flag:SetPos(self:GetPos() + Vector(0, 0, 60))
    flag:SetAngles(Angle(0,0,0))
    flag:Spawn()
    ply:StripWeapon("begotten_polearm_glazicbanner")
    ply:SetSharedVar("DuelFlagOrigin", nil)

    local plyTeamID = ply:GetSharedVar("teamID");
    local plyDuelArena = ply:GetSharedVar("duelArena");
    cwDueling:CTFAddFlag(plyDuelArena, flag)
    cwDueling:AwardPointCTF(plyTeamID, plyDuelArena); -- give a team in a duel arena a point

    local flagCap = ply:GetSharedVar("duelFlagCaps") or 0;
    ply:SetSharedVar("duelFlagCaps", flagCap + 1);
end

function StartFlag(self)
    local flag = ents.Create("cw_flag")
    flag.teamID = self.teamID;
    flag.origin = self;
    flag:SetPos(self:GetPos() + Vector(0, 0, 80))
    flag:SetAngles(Angle(0,0,0))
    flag:Spawn()
    cwDueling:CTFAddFlag(self.duelArena, flag)
end
--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwDueling");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- DermaDuel lib
library.New("dermaDuel", Clockwork)

local REQUEST_INDEX = 0

function Clockwork.dermaDuel:GenerateID()
    REQUEST_INDEX = REQUEST_INDEX + 1
    return os.time() + REQUEST_INDEX
end

if (SERVER) then
    local hooks = Clockwork.dermaDuel.hooks or {}
    Clockwork.dermaDuel.hooks = hooks

    -- Trigger client dermaDuel to pop up.
    function Clockwork.dermaDuel:RequestDuel(player, title, question, mmQueue, Callback)
        local rID = self:GenerateID()
        netstream.Start(player, "dermaDuel_duelQuery", { id = rID, title = title, question = question, mmQueue = mmQueue})
        hooks[rID] = { Callback = Callback, player = player }
    end

    -- UNUSED, REMOVE LATER
    function Clockwork.dermaDuel:Message(player, message, title, button)
        netstream.Start(player, "dermaDuel_message", { message = message, title = title or nil, button = button or nil })
    end

    -- An internal function to validate a return
    function Clockwork.dermaDuel:Validate(player, data)
        if (data.id and data.recv and hooks[data.id] and hooks[data.id].player == player) then
            return true
        end
        return false
    end

    netstream.Hook("dermaDuelCallback", function(player, data)
        if (!Clockwork.dermaDuel:Validate(player, data)) then return end
        hooks[data.id].Callback(data.recv)
        hooks[data.id] = nil
    end)
else
    function Clockwork.dermaDuel:Send(id, recv)
        netstream.Start("dermaDuelCallback", { id = id, recv = recv })
    end

    netstream.Hook("dermaDuel_duelQuery", function(data)
        local options = {"1v1", "2v2", "3v3", "4v4", "5v5", "FFA", "Thralls", "CTF", "Cancel"}
        Clockwork.dermaDuel:CustomDialog(data.title, data.question, options, data.mmQueue, function(index)
            local response
            if options[index] == "Cancel" then
                response = "cancel"
            elseif options[index] == "FFA" then
                response = "5"
            elseif options[index] == "Thralls" then
                response = "6"
            elseif options[index] == "CTF" then
                response = "7"
            else
                response = tostring(index - 1)
            end
            Clockwork.dermaDuel:Send(data.id, response)
        end)
    end)
    
    
    netstream.Hook("dermaDuel_message", function(data)
        local title = data.title or nil
        local button = data.button or nil
        Derma_Message(data.message, data.title, data.button)
    end)
end

function Clockwork.dermaDuel:CustomDialog(title, question, buttons, playercount, callback)
    local dialogPanel = vgui.Create("DFrame")
    dialogPanel:SetTitle(title)
    dialogPanel:SetSize(550, 150)
    dialogPanel:Center()
    dialogPanel:MakePopup()

    local label = vgui.Create("DLabel", dialogPanel)
    label:SetText(question)
    label:SetFont("Decay_FormText")
    label:SetContentAlignment(5)
    label:SizeToContents()
    label:StretchToParent(5, 5, 5, 5)	

    local buttonContainer = vgui.Create("DPanel", dialogPanel)
    buttonContainer:Dock(BOTTOM)
    buttonContainer:SetTall(80)

    local buttonWidth = 80
    local buttonHeight = 30
    local padding = 12
    local x = 8
    local y = 0
    local buttonsPerRow = 6;
    local totalButtonWidth = (#buttons * buttonWidth) + ((#buttons - 1) * padding)

    local startX = (buttonContainer:GetWide() - totalButtonWidth) / 2

    for i=1, #buttons do
        local button = vgui.Create("DButton", buttonContainer)
        if playercount[i] ~= nil then
            local spacing = "      "
            if i == 7 then
                spacing = "    "
            end
            button:SetText(spacing.. buttons[i] .. "\n(" .. playercount[i] .. " players)")
        else
            button:SetText(buttons[i])
        end
        button:SetWide(buttonWidth)
        button:SetHeight(buttonHeight)
        if i~=1 && (i-1) % buttonsPerRow == 0 then
            x = 8
            y = y + 40
        end
        button:SetPos(x, y)
        button:SetContentAlignment(5)
        x = x + button:GetWide() + 8

        if i > 1 then
            button:DockMargin(padding, 0, 0, 0)
        end

        button.DoClick = function()
            callback(i)
            dialogPanel:Close()
        end
    end

    buttonContainer:CenterHorizontal()
    label:Dock(FILL)

    buttonContainer:SetPos(0, 0)
end

local COMMAND = Clockwork.command:New("DuelForceEnterMatchmaking")
COMMAND.tip = "Force a character to enter duel matchmaking. Useful for debugging with bots."
COMMAND.text = "<string Name> <duelType>"
COMMAND.access = "s"
COMMAND.arguments = 2
COMMAND.alias = {"ForceEnterMatchmaking", "PlyEnterMatchmaking"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local target = Clockwork.player:FindByID(arguments[1]);
    local duelType = tonumber(arguments[2])

    if target then
        targetDuelPID = target:GetSharedVar("duelParty")
        
        if targetDuelPID and cwDueling.DUELING_PARTIES[targetDuelPID] then -- if its a party
            
            if cwDueling.DUELING_PARTIES[targetDuelPID].size > duelType then
                Schema:EasyText(player, "peru","This party has too many players to choose this duel type.");
            else
                local leader = cwDueling.DUELING_PARTIES[targetDuelPID].players[1]
                if target:GetName() == leader:GetName() then
                    local partyInDuelingCircle = true
                    for _, partyMember in ipairs(cwDueling.DUELING_PARTIES[targetDuelPID]) do
                        if partyMember:GetPos():DistToSqr(leader.duelStatue:GetPos()) > (256 * 256) then
                            partyInDuelingCircle = false
                            break;
                        end
                    end

                    if partyInDuelingCircle then
                        cwDueling:PartyEntersMatchmaking(cwDueling.DUELING_PARTIES[targetDuelPID], duelType)
                        for k,v in pairs(cwDueling.DUELING_PARTIES[targetDuelPID].players) do
                            v.cachedPos = v:GetPos()
                            v.cachedAngles = v:GetAngles()
                            v.cachedHP = v:Health()
                            v.duelStatue = self
                        end
                        Schema:EasyText(player, "peru","The target is in a party.");
                    else
                        Schema:EasyText(player, "peru","Failure: One of the party members is outside the duel shrine.");
                    end
                else
                    -- not leader of party
                    Schema:EasyText(player, "peru","Failure: The target isn't the leader of party");
                end
            end
        else
            -- if its a single player
            Schema:EasyText(player, "peru","The target is in a solo party.");
            if (target) then
                Clockwork.player:Notify(player, target:Name().." has been forcibly added to duel matchmaking!");
                cwDueling:PlayerEntersMatchmaking(target, tonumber(arguments[2]));
                target.cachedPos = target:GetPos();
                target.cachedAngles = target:GetAngles();
                target.cachedHP = target:Health();
            else
                Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
            end
        end
    else
        Schema:EasyText(player, "peru","That isn't a valid player.");
    end
end
COMMAND:Register()

-- View duel wins
local COMMAND = Clockwork.command:New("DuelWins");
COMMAND.tip = "Check your duel wins.";
COMMAND.alias = {"ViewWins"};

function COMMAND:OnRun(player, arguments)
    local wins = player:GetCharacterData("DuelWins") or {0, 0, 0, 0, 0, 0, 0, 0};
	local losses = player:GetCharacterData("DuelLosses") or {0, 0, 0, 0, 0, 0, 0, 0};
	if type(losses) ~= "table" then
		losses = {0, 0, 0, 0, 0, 0, 0, 0};
	end

    if type(wins) == "table" then
        local message = "Duel Wins: ";
        for i, winCount in ipairs(wins) do

			local loseCount = losses[i] or 0
            if i == 6 then
                message = message .. string.format("[FFA: %d / %d] ", winCount, loseCount);
            elseif i == 7 then
                message = message .. string.format("[Thralls Wave: %d] ", winCount);
            elseif i == 8 then
                message = message .. string.format("[CTF: %d / %d] ", winCount, loseCount);
            else
                message = message .. string.format("[%dv%d: %d / %d] ", i, i, winCount, loseCount);
            end
        end

        Clockwork.player:Notify(player, message);
    else
        Clockwork.player:Notify(player, "No duel wins recorded.");
    end
end

-- Register the command
COMMAND:Register();


-- view duel leaderboard
local COMMAND = Clockwork.command:New("DuelLeaderboard");
COMMAND.tip = "Check the top 5 duel wins for each category.";
--COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
    if cwDueling.LeaderboardTable then
        for duelType,v in pairs(cwDueling.LeaderboardTable) do
            local str = ""
            if duelType >= 0 and duelType <= 5 then
                str = str .. duelType .. "v" .. duelType .. ":";
            elseif duelType == 6 then
                str = "FFA:"; 
            elseif duelType == 7 then
                str = "Thralls (Highest Wave):"; 
            elseif duelType == 8 then
                str = "CTF:"; 
            elseif duelType == 8 then
                str = "Overall:"; 
            end
            Clockwork.player:Notify(player, "Top 5 Players for " .. str)
            for i = 1, math.min(8, #v) do
                Clockwork.player:Notify(player, i .. ". " .. v[i].player .. " - Wins: " .. v[i].wins)
            end
        end
    else
        Clockwork.player:Notify(player, "Could not retrieve duel wins.")
    end

end

COMMAND:Register();


-- Command to create a new duel party
local COMMAND = Clockwork.command:New("DuelPartyCreate")
COMMAND.tip = "Create a new duel party."

function COMMAND:OnRun(player, arguments)
	local duelParty = player:GetSharedVar("duelParty")
    if not duelParty then
        local newParty = {size = 1, players = {player}, ID = os.time() .. "_" .. math.random(1000, 9999)}
        player:SetSharedVar("duelParty", newParty.ID)
		cwDueling.DUELING_PARTIES[newParty.ID] = newParty
        Clockwork.player:Notify(player, "You have created a new duel party.")
    else
        Clockwork.player:Notify(player, "You are already in a duel party!")
    end
end

COMMAND:Register()


-- Invite a player you're looking at to your party provided they are in range of the dueling shrine
local COMMAND = Clockwork.command:New("DuelPartyInvite")
COMMAND.tip = "Invite a player you're looking at to your party provided they are in range of the dueling shrine."

function COMMAND:OnRun(player, arguments)
    local trace = player:GetEyeTrace()
    local entity = trace.Entity
	local duelParty = player:GetSharedVar("duelParty")
    if not duelParty or cwDueling.DUELING_PARTIES[duelParty] == nil then
		-- new party
		local newParty = {size = 1, players = {player}, ID = os.time() .. "_" .. math.random(1000, 9999)}
		player:SetSharedVar("duelParty", newParty.ID)
		duelParty = newParty.ID
		cwDueling.DUELING_PARTIES[newParty.ID] = newParty
		Clockwork.player:Notify(player, "You aren't in a party, making a new one.")
	end

	duelParty = player:GetSharedVar("duelParty")
	if cwDueling.DUELING_PARTIES[duelParty].players[1] ~= player  then
		Clockwork.player:Notify(player, "You aren't the leader of your party!")
	elseif IsValid(entity) then
		
		local entName = entity:GetName()
		local playName = player:GetName()
		local entPid = entity:GetSharedVar("duelParty")

		if (not entPid) then

			if not entity.duelPartyInvites then
				entity.duelPartyInvites = {}
			end

			if #entity.duelPartyInvites >= 5 then
				table.remove(entity.duelPartyInvites, 1)
			end

			if table.HasValue(entity.duelPartyInvites, duelParty) then
				Clockwork.player:Notify(player, "You have already invited " .. entName)
				return
			end
			
			Clockwork.player:Notify(player, "You invited " .. entName)
			Clockwork.player:Notify(entity, "You have been invited by " .. player:GetName())
			local duelPartyInvite = {ID = duelParty, player = player};
			table.insert(entity.duelPartyInvites, duelPartyInvite)
		else
			Clockwork.player:Notify(player, "They're already in a party!")
		end
    else
        Clockwork.player:Notify(player, "You are not looking at a valid entity.")
    end
end

COMMAND:Register()

-- View Duel invites
local COMMAND = Clockwork.command:New("DuelPartyViewInvites")
COMMAND.tip = "View pending duel invites."

function COMMAND:OnRun(player, arguments)
    local notificationString = ""

    if player.duelPartyInvites and #player.duelPartyInvites > 0 then
        notificationString = "Duel Invites:\n"
        local isFirstInvite = true
        for _, invPartyID in ipairs(player.duelPartyInvites) do
            local inviterName = cwDueling.DUELING_PARTIES[invPartyID.ID].players[1]:GetName() 
            if inviterName then
                if not isFirstInvite then
                    notificationString = notificationString .. ", "
                else
                    isFirstInvite = false
                end
                notificationString = notificationString .. inviterName
            end
        end
    else
        notificationString = "No pending duel invites."
    end

    Clockwork.player:Notify(player, notificationString)
end

COMMAND:Register()



-- Accept duel invite
local COMMAND = Clockwork.command:New("DuelPartyAcceptInvite")
COMMAND.tip = "Accept a duel party invite from a specific player."
COMMAND.text = "<InviterName>"
COMMAND.arguments = 1

function COMMAND:OnRun(player, arguments)
	local target = arguments[1]
	local targetName = target:GetName()
	local pDuelParty = player:GetSharedVar("duelParty")
	local tDuelParty = target:GetSharedVar("duelParty")
	local inviteFound = false;

	for _,v in pairs(player.duelPartyInvites) do
		if v.ID == tDuelParty then
			inviteFound = true;
			break;
		end
	end

	if pDuelParty ~= nil then
		Clockwork.player:Notify(player, "You're already in a party.")
	elseif not player.duelPartyInvites or not tDuelParty or not inviteFound then
		Clockwork.player:Notify(player, "You don't have an invite from that person.")
	elseif cwDueling.DUELING_PARTIES[tDuelParty].size == 5  then
		Clockwork.player:Notify(player, "The party you are trying to join is full!")
	else
		Clockwork.player:Notify(player, "You accepted the duel invite from " .. targetName)
		for k,v in pairs(player.duelPartyInvites) do
			if v.ID == tDuelParty then
				table.RemoveByValue(player.duelPartyInvites, k)
				break;
			end
		end
		player:SetSharedVar("duelParty", tDuelParty) 
		
		table.insert(cwDueling.DUELING_PARTIES[tDuelParty].players, player)
		cwDueling.DUELING_PARTIES[tDuelParty].size = cwDueling.DUELING_PARTIES[tDuelParty].size + 1
	end
end

COMMAND:Register()

-- View players in your party
local COMMAND = Clockwork.command:New("DuelPartyInfo")
COMMAND.tip = "View all players in your party and other info."

function COMMAND:OnRun(player, arguments)
	local parts = {}
	local duelParty = player:GetSharedVar("duelParty")
	if duelParty and cwDueling.DUELING_PARTIES[duelParty] then
		for _,p in pairs(cwDueling.DUELING_PARTIES[duelParty].players) do
			table.insert(parts, p:GetName())
		end
		Clockwork.player:Notify(player, "Party Members: " .. table.concat(parts, ", "))
	else
		Clockwork.player:Notify(player, "You don't have a party!")
	end
end
COMMAND:Register()

-- Disband your party
local COMMAND = Clockwork.command:New("DuelPartyDisband")
COMMAND.tip = "Disband your party."

function COMMAND:OnRun(player, arguments)
    local duelParty = player:GetSharedVar("duelParty")

	-- check if a party is in matchmaking
	if not cwDueling:IsPartyInMatchmaking(duelParty) or not cwDueling:IsPartyDueling(duelParty) then
		if duelParty and cwDueling.DUELING_PARTIES[duelParty] then
			if player:GetName() == cwDueling.DUELING_PARTIES[duelParty].players[1]:GetName() then
				for _, partyPlayer in ipairs(cwDueling.DUELING_PARTIES[duelParty].players) do
					partyPlayer:SetSharedVar("duelParty", nil)
				end

				cwDueling.DUELING_PARTIES[duelParty] = nil
				Clockwork.player:Notify(player, "Party disbanded.")
			else
				Clockwork.player:Notify(player, "You aren't the leader!")
			end
		else
			Clockwork.player:Notify(player, "You are not in a party.")
		end
	else
		Clockwork.player:Notify(player, "You are in matchmaking or dueling, you cant disband your party!")
	end -- woo
end

COMMAND:Register()

-- Leave your party
local COMMAND = Clockwork.command:New("DuelPartyLeave")
COMMAND.tip = "Leave your party."

function COMMAND:OnRun(player, arguments)
    local duelParty = player:GetSharedVar("duelParty")

    -- check if a party is in matchmaking
	if duelParty and cwDueling.DUELING_PARTIES[duelParty] then
   	 	if not cwDueling:IsPartyInMatchmaking(duelParty) or not cwDueling:IsPartyDueling(duelParty) then
        
            if cwDueling.DUELING_PARTIES[duelParty].players[1] ~= player then
                local playerIndex = table.KeyFromValue(cwDueling.DUELING_PARTIES[duelParty].players, player)

                if playerIndex then
                    table.remove(cwDueling.DUELING_PARTIES[duelParty].players, playerIndex)
                    cwDueling.DUELING_PARTIES[duelParty].size = cwDueling.DUELING_PARTIES[duelParty].size - 1
                    player:SetSharedVar("duelParty", nil)

                    Clockwork.player:Notify(player, "You have left your party.")
                else
                    Clockwork.player:Notify(player, "You are not in a party.")
                end
            else
                Clockwork.player:Notify(player, "You are the leader, you can't leave! Try disbanding instead.")
            end
        else
            Clockwork.player:Notify(player, "You are in matchmaking or dueling, you can't disband your party!")
        end
    else
        Clockwork.player:Notify(player, "You are not in a party.")
    end
end

COMMAND:Register()

-- Remove a player from your party given their name
local COMMAND = Clockwork.command:New("DuelPartyRemove")
COMMAND.tip = "Remove a pest from your party."
COMMAND.text = "<string Name>"
COMMAND.arguments = 1

function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	local duelParty = player:GetSharedVar("duelParty")
	playerFound = false
	
	if duelParty and cwDueling.DUELING_PARTIES[duelParty] then
		-- check if a party is in matchmaking
		
		if not cwDueling:IsPartyInMatchmaking(duelParty) or not cwDueling:IsPartyDueling(duelParty) then
			for i,p in ipairs(cwDueling.DUELING_PARTIES[duelParty].players) do
				if p:GetName() == target:GetName() then
					Clockwork.player:Notify(player, "Removed " .. p:GetName() .. " from your party!")
					p:SetSharedVar("duelParty", nil) 
					table.remove(cwDueling.DUELING_PARTIES[duelParty].players, i)
					cwDueling.DUELING_PARTIES[duelParty].size = cwDueling.DUELING_PARTIES[duelParty].size - 1
					playerFound = true
					break
				end
			end
			if not playerFound then
				Clockwork.player:Notify(player, "Player not found.")
			end
		else
			Clockwork.player:Notify(player, "You are in matchmaking, you cant remove players!")
		end
	else
		Clockwork.player:Notify(player, "You're not in a party!")
	end
end
COMMAND:Register()


-- Toggle duelingHalo for brazils
local COMMAND = Clockwork.command:New("ToggleDuelingHalo")
COMMAND.tip = "Toggle friendly halos in duels."

function COMMAND:OnRun(player, arguments)
    local duelingHalo = player:GetSharedVar("duelingHalo")

    if duelingHalo == nil then
        duelingHalo = true
        player:SetSharedVar("duelingHalo", true)
    else
        duelingHalo = not duelingHalo
        player:SetSharedVar("duelingHalo", duelingHalo)
    end

    local status = duelingHalo and "enabled" or "disabled"
    Clockwork.player:Notify(player, "Dueling Halo is now " .. status .. ".")
end

-- Register the command
COMMAND:Register()

-- Admin debug commands
-- Admin DEBUG force a player to accept your invite
local COMMAND = Clockwork.command:New("DuelForceAcceptInvite")
COMMAND.tip = "Admin DEBUG: Force a player to accept your invite."
COMMAND.text = "<string TargetName>"
COMMAND.arguments = 1
COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
    if player:IsAdmin() then
        local target = Clockwork.player:FindByID(arguments[1])
        if IsValid(target) then
			local pDuelParty = player:GetSharedVar("duelParty")
			local tDuelParty = target:GetSharedVar("duelParty")
			local inviteFound = false;

			for _,v in pairs(target.duelPartyInvites) do
				if v.ID == pDuelParty then
					inviteFound = true;
					break;
				end
			end

			if pDuelParty == nil then
				Clockwork.player:Notify(player, "You don't have a duel party!")
			elseif tDuelParty~= nil then
				Clockwork.player:Notify(player, "Player is already in a duel party!")
			elseif not target.duelPartyInvites or not inviteFound then
				Clockwork.player:Notify(player, "They don't have an invite from you.")
			elseif cwDueling.DUELING_PARTIES[pDuelParty].size == 5  then
				Clockwork.player:Notify(player, "Your party is full!")
			else
				Clockwork.player:Notify(player, "You forced " .. target:GetName() .. " to join your duel party.")
				for k,v in pairs(target.duelPartyInvites) do
					if v.ID == pDuelParty then
						table.RemoveByValue(target.duelPartyInvites, k)
						break;
					end
				end
				target:SetSharedVar("duelParty", pDuelParty) -- player:GetSharedVar("duelParty")
				cwDueling.DUELING_PARTIES[pDuelParty].size = cwDueling.DUELING_PARTIES[pDuelParty].size + 1
				table.insert(cwDueling.DUELING_PARTIES[pDuelParty].players, target)
			end
        else
            Clockwork.player:Notify(player, "Invalid target player.")
        end
    else
        Clockwork.player:Notify(player, "Invalid use.")
    end
end

COMMAND:Register()


-- Admin DEBUG remove a player from their party
local COMMAND = Clockwork.command:New("DuelAdminKickParty")
COMMAND.tip = "Admin DEBUG: Remove a player from their party."
COMMAND.text = "<string TargetName>"
COMMAND.arguments = 1
COMMAND.access = "s";


function COMMAND:OnRun(player, arguments)
    if player:IsAdmin() then
        local target = Clockwork.player:FindByID(arguments[1])

        if IsValid(target) then
			local partyID = target:GetSharedVar("duelParty")
            if partyID ~= nil then

                -- Remove the player from the party
                for key, p in pairs(cwDueling.DUELING_PARTIES[partyID].players) do
                    if p == target then
                        table.remove(cwDueling.DUELING_PARTIES[partyID].players, key)
                        cwDueling.DUELING_PARTIES[partyID].size = cwDueling.DUELING_PARTIES[partyID].size - 1
						target:SetSharedVar("duelParty", nil)
						Clockwork.player:Notify(player, "Removed " .. target:GetName() .. " from their party.")
						Clockwork.player:Notify(target, "You have been removed from your party by an admin.")
                        break
                    end
                end
            else
                player:PrintMessage(HUD_PRINTTALK, "Player is not in a duel party.")
            end
        else
            player:PrintMessage(HUD_PRINTTALK, "Invalid target player.")
        end
    else
        player:PrintMessage(HUD_PRINTTALK, "You do not have permission to use this command.")
    end
end

COMMAND:Register()

-- ADMIN DEBUG remove a party
local COMMAND = Clockwork.command:New("DuelAdminRemoveParty")
COMMAND.tip = "Admin DEBUG: Remove a party."
COMMAND.text = "<string TargetPartyID>"
COMMAND.arguments = 1
COMMAND.access = "s";


function COMMAND:OnRun(player, arguments)
    if player:IsAdmin() then
        local targetPartyID = arguments[1]

        if cwDueling.DUELING_PARTIES[targetPartyID] ~= nil then
            -- Notify players in the party
            for _, targetPlayer in ipairs(cwDueling.DUELING_PARTIES[targetPartyID].players) do
                if IsValid(targetPlayer) then
                    Clockwork.player:Notify(targetPlayer, "Your party has been removed by an admin.")
					targetPlayer:SetSharedVar("duelParty", nil) 
                end
            end

            -- Remove the party from the list
            cwDueling.DUELING_PARTIES[targetPartyID] = nil
            player:PrintMessage(HUD_PRINTTALK, "Removed party with ID " .. targetPartyID)
        else
            player:PrintMessage(HUD_PRINTTALK, "Party with ID " .. targetPartyID .. " does not exist.")
        end
    else
        player:PrintMessage(HUD_PRINTTALK, "You do not have permission to use this command.")
    end
end

COMMAND:Register()

-- Admin DEBUG: Force a player to make a duel party.
local COMMAND = Clockwork.command:New("DuelForceMakeParty")
COMMAND.tip = "Admin DEBUG: Force a player to make a duel party."
COMMAND.text = "<string TargetName>"
COMMAND.arguments = 1
COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
    if player:IsAdmin() then
        local target = Clockwork.player:FindByID(arguments[1])

        if IsValid(target) then
            local targetPartyID = os.time() .. "_" .. math.random(1000, 9999)
            target:SetSharedVar("duelParty", targetPartyID)
            cwDueling.DUELING_PARTIES[targetPartyID] = { players = { target }, size = 1, ID = targetPartyID }
            Clockwork.player:Notify(player, "Forced " .. target:GetName() .. " to make a duel party.")
        else
            Clockwork.player:Notify(player, "Invalid target player.")
        end
    else
        Clockwork.player:Notify(player, "Invalid use.")
    end
end

COMMAND:Register()


-- Admin DEBUG: Force a player to invite another player to their duel party.
local COMMAND = Clockwork.command:New("DuelForceInviteParty")
COMMAND.tip = "Admin DEBUG: Force a player to invite another player to their duel party."
COMMAND.text = "<string InviterName> <string InviteeName>"
COMMAND.arguments = 2
COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
    if player:IsAdmin() then
        local inviter = Clockwork.player:FindByID(arguments[1])
        local invitee = Clockwork.player:FindByID(arguments[2])
		

        if IsValid(inviter) and IsValid(invitee) then
            local inviterPartyID = inviter:GetSharedVar("duelParty")
			if not invitee.duelPartyInvites then
				invitee.duelPartyInvites = {}
			end

			local invFound = false;
			for _,v in pairs(invitee.duelPartyInvites) do
				if inviterPartyID ~= nil and v.ID == inviterPartyID then
					invFound = true;
					break;
				end
			end

			if not invFound then
				local duelPartyInvite = {ID = inviterPartyID, player = inviter};
				table.insert(invitee.duelPartyInvites, duelPartyInvite)
				Clockwork.player:Notify(player, "Forced " .. inviter:GetName() .. " to invite " .. invitee:GetName() .. " to their duel party.")
			end
        else
            Clockwork.player:Notify(player, "Invalid target player(s).")
        end
    else
        Clockwork.player:Notify(player, "Invalid use.")
    end
end

COMMAND:Register()

-- Admin DEBUG: Force a player to accept a duel party invite.
local COMMAND = Clockwork.command:New("DuelForceAcceptParty")
COMMAND.tip = "Admin DEBUG: Force a player to accept a duel party invite."
COMMAND.text = "<string InviterName> <string InviteeName>"
COMMAND.arguments = 2
COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
    if player:IsAdmin() then
        local inviter = Clockwork.player:FindByID(arguments[1])
        local invitee = Clockwork.player:FindByID(arguments[2])

        if IsValid(inviter) and IsValid(invitee) then
            local inviterPartyID = inviter:GetSharedVar("duelParty")
			local inviteFound = false;

			for _,v in pairs(target.duelPartyInvites) do
				if v.ID == inviterPartyID then
					inviteFound = true;
					break;
				end
			end
			

            if inviterPartyID ~= nil and inviteFound then
                invitee:SetSharedVar("duelParty", inviterPartyID)
				for k,v in pairs(invitee.duelPartyInvites) do
					if v.ID == inviterPartyID then
						table.RemoveByValue(invitee.duelPartyInvites, k)
						break;
					end
				end
                cwDueling.DUELING_PARTIES[inviterPartyID].size = cwDueling.DUELING_PARTIES[inviterPartyID].size + 1
                table.insert(cwDueling.DUELING_PARTIES[inviterPartyID].players, invitee)
                Clockwork.player:Notify(player, "Forced " .. invitee:GetName() .. " to accept " .. inviter:GetName() .. "'s duel party invite.")
            else
                Clockwork.player:Notify(player, "Invalid conditions for the force accept.")
            end
        else
            Clockwork.player:Notify(player, "Invalid target player(s).")
        end
    else
        Clockwork.player:Notify(player, "Invalid use.")
    end
end


local COMMAND = Clockwork.command:New("DuelParty")
COMMAND.tip = "Open up the duel party management menu.";
COMMAND.alias = {"dp"};

function COMMAND:OnRun(player, arguments)
    local good = true;
	local partyPlayersID = player:GetSharedVar("duelParty");
	local partyPlayers;
	if partyPlayersID then
        if not cwDueling.DUELING_PARTIES[partyPlayersID] then
            good = false;
        else
            partyPlayers = cwDueling.DUELING_PARTIES[partyPlayersID].players;
        end
		
	else
		partyPlayers = nil
	end

    if good then
	    netstream.Start(player, "UpdatePartyDerma", {partyPlayers, player.duelPartyInvites});
    else
        Clockwork.player:Notify(player, "Can't open party menu right now.");
    end
end

COMMAND:Register()


COMMAND = Clockwork.command:New("ViewParties")
COMMAND.tip = "View the current parties and their members."
COMMAND.access = "o"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local partiesFound = false

    local i = 1
    for _, party in pairs(cwDueling.DUELING_PARTIES) do
        local partyString = i .. ". "

        local numPlayers = #party.players
        for j, playerData in pairs(party.players) do
            partyString = partyString .. playerData:GetName()

            if j < numPlayers then
                partyString = partyString .. ", "
            end
        end

        Schema:EasyText(player, "skyblue", partyString)
        partiesFound = true
        i = i + 1
    end

    -- Check if no parties were found
    if not partiesFound then
        Schema:EasyText(player, "skyblue", "No parties found.")
    end
end


COMMAND:Register()

COMMAND = Clockwork.command:New("ViewArenas")
COMMAND.tip = "View the current arenas in play."
COMMAND.alias = {"ViewDuels", "ViewArenas", "DuelViewArenas"}

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local arenaDetails = cwDueling:GetArenaDetails()

    if #arenaDetails == 0 then
        Schema:EasyText(player, "skyblue", "No players are in any arenas currently.");
    else
        for _,v in pairs(arenaDetails) do
            Schema:EasyText(player, "skyblue", v);
        end
    end
    
end

COMMAND:Register()


local COMMAND = Clockwork.command:New("ViewMatchmakingStatus")
COMMAND.tip = "View matchmaking status."
COMMAND.alias = {"ViewMM"}

function COMMAND:OnRun(player, arguments)
    local matchmakingStatus = {}

    for i = 1, 8 do
        local players = ""
        local currentPlayers = 0
        local maxPlayers = i * 2
        if i == 7 then
            maxPlayers = 4;
        elseif i == 8 then
            maxPlayers = 4;
        end
		local duelType = cwDueling.playersInMatchmaking[i]
		for _, team in pairs(duelType) do
            for _,p in pairs(team.players) do
               players = players .. p:GetName() .. ", ";
            end
			currentPlayers = currentPlayers + team.size
		end
        players = string.sub(players, 1, -3)

        table.insert(matchmakingStatus, string.format("[%d] %d/%d\t%s", i, currentPlayers, maxPlayers, players))
	end

    for _,v in pairs(matchmakingStatus) do
    --local formattedStatus = table.concat(matchmakingStatus, " | ")
        Clockwork.player:Notify(player, v)
    end
    
end

-- Register the command
COMMAND:Register()

local COMMAND = Clockwork.command:New("ClearNulls")
COMMAND.tip = "CN"
COMMAND.access = "o"

function COMMAND:OnRun(player, arguments)

    local removed = 0;
    if cwDueling.playersInMatchmaking then
        for _,duelType in pairs(cwDueling.playersInMatchmaking) do
            for pk,party in pairs(duelType) do
                for _,pl in pairs(party.players) do
                    if not IsValid(pl) then
                        if #party.players == 1 then
                            table.remove(duelType, pk);
                        else
                            cwDueling:PartyExitsMatchmaking(pl.ID)
                        end
                        removed = removed + 1;
                        
                    end
                end
            end 
        end
    end

    -- search arenas for any null players too
    Clockwork.player:Notify(player, "Removed " .. removed .. " players.");
end

-- Register the command
COMMAND:Register()
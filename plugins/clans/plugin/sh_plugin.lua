Clockwork.kernel:IncludePrefixed("./framework/libraries/sv_database.lua");
Clockwork.kernel:IncludePrefixed("./framework/config/sv_config.lua");
Clockwork.kernel:IncludePrefixed("./framework/libraries/sv_player.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

if not config then
    include("sh_config.lua")
end

-- Check if a clan name already exists
function ClanNameExists(clanName, Callback)
    local clansTable = config.Get("mysql_clans_table"):Get()
    local queryObj = Clockwork.database:Select(clansTable)
    queryObj:Where("_Name", clanName)
    queryObj:Callback(function(result)
        if result and #result > 0 then
            Callback(true)
        else
            Callback(false) 
        end
    end)
    queryObj:Execute()
end



-- Get clan data
function GetClanData(Callback)
    local charactersTable = config.Get("mysql_characters_table"):Get()
    local queryObj = Clockwork.database:Select(charactersTable)
    queryObj:Where("_Key", 1)
    queryObj:Callback(function(result)
        if result and #result > 0 then
            local clanData = result[1].ClanData
            -- PrintTable(result) -- Print the content of the result table for debugging

            Callback(clanData)
        else
            Callback(nil)
        end
    end)
    queryObj:Execute()
end

-- Set clan data
function SetClanData(clanData, Callback)
    local charactersTable = config.Get("mysql_characters_table"):Get()
    local queryObj = Clockwork.database:Update(charactersTable)
    queryObj:Where("_Key", 1)
    queryObj:Update("_ClanData", util.TableToJSON(clanData))
    queryObj:Execute()

    Callback()
end

-- Create a clan
local COMMAND = Clockwork.command:New("ClanCreate")
COMMAND.tip = "Creates a clan."
COMMAND.text = "<clan name>"
COMMAND.flags = CMD_DEFAULT
COMMAND.arguments = 1

-- Define the maximum allowed clan name length
local MAX_CLAN_NAME_LENGTH = 32

function COMMAND:OnRun(player, arguments)
    local clanName = arguments[1] or "Unnamed Clan"
    local playerSubFac = player:GetSubfaction()

    -- Check if the clan name exceeds the maximum length
    if string.len(clanName) > MAX_CLAN_NAME_LENGTH then
        Schema:EasyText(player, "red", "Clan name exceeds the maximum length of " .. MAX_CLAN_NAME_LENGTH .. " characters.")
        return
    end

    if playerSubFac ~= "N/A" then
        Schema:EasyText(player, "red", "You already belong to a clan! Leave it first: " .. playerSubFac);
    elseif player:GetFaction() ~= "Wanderer" then
        Schema:EasyText(player, "red", "Only wanderers can create clans!");
    else
        ClanNameExists(clanName, function(exists)
            if exists then
                Schema:EasyText(player, "red", "Clan '" .. clanName .. "' already exists!")
            else
                -- Create the clan data structure
                local clanData = {
                    Name = clanName,
                    Players = {player:Name()},
                    Enemies = {},
                    Allies = {}
                }
                
                player:SetCharacterData("Subfaction", clanName, true)
                player:SetSharedVar("subfaction", clanName)

                -- Clockwork.player:LoadCharacter(player, Clockwork.player:GetCharacterID(player))
                Schema:EasyText(player, "green", "Clan '" .. clanName .. "' has been created by you")

                -- Insert the clan into the database
                local clansTable = config.Get("mysql_clans_table"):Get() 
                local queryObj = Clockwork.database:Insert(clansTable)
                queryObj:Insert("_Name", clanData.Name)
                queryObj:Insert("_Characters", util.TableToJSON(clanData.Players))
                queryObj:Insert("_Enemies", util.TableToJSON(clanData.Enemies))
                queryObj:Insert("_Allies", util.TableToJSON(clanData.Allies))
                queryObj:Callback(callback)
                queryObj:Execute()

                -- Add the clan to the character's character table
                local charactersTable = config.Get("mysql_characters_table"):Get() 
                local updateQuery = Clockwork.database:Update(charactersTable)
                updateQuery:Update("_ClanName", clanName)
                updateQuery:Where("_Name", player:Name())
                updateQuery:Execute()
            end
        end)
    end
end
COMMAND:Register()



-- Invite a player to a clan
local COMMAND = Clockwork.command:New("ClanInvite");
COMMAND.tip = "Add a player you're looking at to your clan.";
COMMAND.flags = CMD_DEFAULT;

function COMMAND:OnRun(player, arguments)
    local trace = player:GetEyeTraceNoCursor();
    local target = Clockwork.entity:GetPlayer(trace.Entity);

    
    if not target then
        Schema:EasyText(player, "red", "You're not looking at anyone.");
    elseif target:GetFaction() ~= "Wanderer" then
        Schema:EasyText(player, "red", "The person you're trying to invite isn't a wanderer!");
    else
        local clanName = player:GetSubfaction()
        local tarClanName = target:GetSubfaction()

        if not clanName or clanName == "N/A" then
            Schema:EasyText(player, "red", "You aren't in a clan!");
        elseif tarClanName ~= "N/A"  then
            Schema:EasyText(player, "red", "Your target is in a clan! " .. tarClanName .. " " .. clanName);
        else
            target:SetSharedVar("ClanInvitation", clanName)
            Schema:EasyText(player, "green", target:Name() .. " invited to clan '" .. clanName .. "'!")   
            Schema:EasyText(target, "green", player:Name() .. " invited you to '" .. clanName .. "'!")   
        end
    end
end;
COMMAND:Register();

-- Get current invite
local COMMAND = Clockwork.command:New("ClanCheckInv");
COMMAND.tip = "Check if you've been invited to a clan.";
COMMAND.flags = CMD_DEFAULT;

function COMMAND:OnRun(player, arguments)
    local clanInvitation = player:GetSharedVar("ClanInvitation");
    if not clanInvitation or clanInvitation == "" then
        Schema:EasyText(player, "red", "You have no invites.") 
    else
        Schema:EasyText(player, "green", "You've been invited to" .. clanInvitation .. "'!") 
    end
end;
COMMAND:Register();


-- Remove a player from a clan
local COMMAND = Clockwork.command:New("ClanKick")
COMMAND.tip = "Kick a player from your clan."
COMMAND.text = "<player name>"
COMMAND.flags = CMD_DEFAULT
COMMAND.arguments = 1

function COMMAND:OnRun(player, arguments)
    local target = Clockwork.player:FindByID(arguments[1])
    local clanName = player:GetSubfaction()

    if not target then
        Schema:EasyText(player, "red", "Player not found/online.")
    elseif clanName == "N/A" then
        Schema:EasyText(player, "red", "You aren't in a clan!")
    elseif target:GetSubfaction() ~= clanName then
        Schema:EasyText(player, "red", target:Name() .. " is not in your clan!")
    else
        local charactersTable = config.Get("mysql_characters_table"):Get()
        local clansTable = config.Get("mysql_clans_table"):Get() 
        local queryObj = Clockwork.database:Select(clansTable)
        queryObj:Where("_Name", clanName)
        queryObj:Callback(function(result)
            if result and #result > 0 then
                local clanData = result[1]
                local characters = util.JSONToTable(clanData._Characters) or {}

                -- Check if the player executing the command is the officer of the clan
                if characters[1] == player:Name() then
                    -- Edit the target player's ClanName column in characters
                    local updateQuery = Clockwork.database:Update(charactersTable)
                    updateQuery:Update("_ClanName", "N/A")
                    updateQuery:Where("_Name", target:Name())
                    updateQuery:Execute()

                    -- Remove the target player's name from clans
                    for i, name in ipairs(characters) do
                        if name == target:Name() then
                            table.remove(characters, i)
                            break
                        end
                    end

                    local updateQuery = Clockwork.database:Update(clansTable)
                    updateQuery:Update("_Characters", util.TableToJSON(characters))
                    updateQuery:Where("_Name", clanName)
                    updateQuery:Execute()

                    target:SetCharacterData("Subfaction", "N/A", true)
                    target:SetSharedVar("subfaction", "N/A")
                    Schema:EasyText(player, "green", target:Name() .. " removed from clan '" .. clanName .. "'!")
                else
                    Schema:EasyText(player, "red", "You are not the officer of this clan and cannot kick members.")
                end
            else
                Schema:EasyText(player, "red", "Clan not found.")
            end
        end)
        queryObj:Execute()
    end
end
COMMAND:Register()




-- Print all clan details. Names of all players, enemies of clan, allies of clan
local COMMAND = Clockwork.command:New("ClanDetails");
COMMAND.tip = "Print all clan details.";
COMMAND.flags = CMD_DEFAULT;

function COMMAND:OnRun(player, arguments)
    local clanName = player:GetSubfaction()

    if not clanName or clanName == "N/A" then
        Schema:EasyText(player, "red", "You aren't in a clan!")
        return
    end

    local clansTable = config.Get("mysql_clans_table"):Get()
    local queryObj = Clockwork.database:Select(clansTable)
    queryObj:Where("_Name", clanName)
    queryObj:Callback(function(result)
        if result and #result > 0 then
            local clanData = result[1]
            local characters = util.JSONToTable(clanData._Characters) or {}
            local enemies = util.JSONToTable(clanData._Enemies) or {}
            local allies = util.JSONToTable(clanData._Allies) or {}

            local charList = table.concat(characters, ", ")
            local enemyList = table.concat(enemies, ", ")
            local allyList = table.concat(allies, ", ")

            local message = "Clan Details:\n"
            message = message .. "Name: clanName\n"
            message = message .. "Characters: [" .. charList .. "]\n"
            message = message .. "Enemies: [" .. enemyList .. "]\n"
            message = message .. "Allies: [" .. allyList .. "]"

            Schema:EasyText(player, "green", message)
        else
            Schema:EasyText(player, "red", "Clan not found.")
        end
    end)
    queryObj:Execute()
end;
COMMAND:Register();


-- Accept a clan invitation
local COMMAND = Clockwork.command:New("ClanAcceptInvite");
COMMAND.tip = "Accept a clan invitation.";
COMMAND.flags = CMD_DEFAULT;


function COMMAND:OnRun(player, arguments)
    local clanInvitation = player:GetSharedVar("ClanInvitation")

    if not clanInvitation or clanInvitation == "" then
        Schema:EasyText(player, "red", "You don't have a pending clan invitation.")
        return
    end

    local clansTable = config.Get("mysql_clans_table"):Get()
    local queryObj = Clockwork.database:Select(clansTable)
    queryObj:Where("_Name", clanInvitation)
    queryObj:Callback(function(result)
        if result and #result > 0 then
            local clanData = result[1]
            local characters = util.JSONToTable(clanData._Characters) or {}

            if table.HasValue(characters, player:Name()) then
                Schema:EasyText(player, "red", "You already are a member of this clan!")
                player:SetSharedVar("ClanInvitation", "")
                return
            end
            table.insert(characters, player:Name())

            local updateQuery = Clockwork.database:Update(clansTable)
            updateQuery:Update("_Characters", util.TableToJSON(characters))
            updateQuery:Where("_Name", clanInvitation)
            updateQuery:Execute()

            -- Add the clan to the charcter's character table
            local charactersTable = config.Get("mysql_characters_table"):Get() 
            local updateQuery = Clockwork.database:Update(charactersTable)
            updateQuery:Update("_ClanName", clanInvitation)
            updateQuery:Where("_Name", player:Name())
            updateQuery:Execute()

            player:SetCharacterData("Subfaction", clanInvitation, true)
            player:SetSharedVar("subfaction", clanInvitation)
            player:SetSharedVar("ClanInvitation", "")

            Schema:EasyText(player, "green", "You have joined clan '" .. clanInvitation .. "'!")
        else
            Schema:EasyText(player, "red", "Clan not found.")
        end
    end)
    queryObj:Execute()
end

COMMAND:Register()


-- Toggle if your clan affilation should be hidden or not
local COMMAND = Clockwork.command:New("ClanHide");
COMMAND.tip = "Toggle if your clan affilation should be hidden or not";
COMMAND.flags = CMD_DEFAULT;


function COMMAND:OnRun(player, arguments)
    local clanVisibility = player:SetSharedVar("ClanVisibility")

    if not clanVisibility or clanVisibility == "" or clanVisibility == "visible" then
        player:SetSharedVar("ClanVisibility", "hidden")
        Schema:EasyText(player, "red", "Hiding your clan status from outsiders.")
    else
        player:SetSharedVar("ClanVisibility", "visible")
        Schema:EasyText(player, "red", "Showing your clan status to outsiders.")
    end
end
COMMAND:Register()


-- Leave a clan
local COMMAND = Clockwork.command:New("ClanLeave")
COMMAND.tip = "Leave from your active clan."
COMMAND.flags = CMD_DEFAULT

function COMMAND:OnRun(player, arguments)
    local clanName = player:GetSubfaction()

    if clanName == "N/A" then
        Schema:EasyText(player, "red", "You aren't in a clan!")
    else
        local clansTable = config.Get("mysql_clans_table"):Get() 
        local queryObj = Clockwork.database:Select(clansTable)
        queryObj:Where("_Name", clanName)
        queryObj:Callback(function(result)
            if result and #result > 0 then
                local clanData = result[1]
                local characters = util.JSONToTable(clanData._Characters) or {}

                -- Remove the player's name from the clan's character list.
                for i, name in ipairs(characters) do
                    if name == player:Name() then
                        table.remove(characters, i)
                        break
                    end
                end

                local updateQuery = Clockwork.database:Update(clansTable)
                updateQuery:Update("_Characters", util.TableToJSON(characters))
                updateQuery:Where("_Name", clanName)
                updateQuery:Execute()

                player:SetCharacterData("Subfaction", "N/A", true)
                player:SetSharedVar("subfaction", "N/A")
                Schema:EasyText(player, "green", " You have quit the clan " .. clanName .. "'!")

                -- Check if the clan has no more members, and if so, delete it.
                if #characters == 0 then
                    local deleteQuery = Clockwork.database:Delete(clansTable)
                    deleteQuery:Where("_Name", clanName)
                    deleteQuery:Callback(function()
                        Schema:EasyText(player, "green", "The clan '" .. clanName .. "' has been deleted because you were the last member.")
                    end)
                    deleteQuery:Execute()
                end
            else
                Schema:EasyText(player, "red", "Clan not found.")
            end
        end)
        queryObj:Execute()
    end
end
COMMAND:Register()


-- DEV/DEBUG COMMANDS -- 
-- Toggle clan visiblity for a player you're looking at
local COMMAND = Clockwork.command:New("ClanDevHide");
COMMAND.tip = "Force a player to toggle their clan affiliation visibility.";
COMMAND.access = "a"; 

function COMMAND:OnRun(player, arguments)
    local trace = player:GetEyeTraceNoCursor();
    local target = Clockwork.entity:GetPlayer(trace.Entity);

    if not target then
        Schema:EasyText(player, "red", "You're not looking at anyone.");
        return
    end

    local clanVisibility = target:GetSharedVar("ClanVisibility") or "visible"

    if clanVisibility == "visible" then
        target:SetSharedVar("ClanVisibility", "hidden")
        Schema:EasyText(target, "red", "Your clan status has been hidden by an admin.")
        Schema:EasyText(player, "green", "You forced " .. target:Name() .. " to hide their clan status.")
    else
        target:SetSharedVar("ClanVisibility", "visible")
        Schema:EasyText(target, "green", "Your clan status has been shown by an admin.")
        Schema:EasyText(player, "red", "You forced " .. target:Name() .. " to show their clan status.")
    end
end
COMMAND:Register()


-- DEV Force a place you're looking at to accept a clan invite
local COMMAND = Clockwork.command:New("ClanDevAccept");
COMMAND.tip = "Force a player to accept their clan invitation.";
COMMAND.access = "a";

function COMMAND:OnRun(player, arguments)
    local trace = player:GetEyeTraceNoCursor();
    local target = Clockwork.entity:GetPlayer(trace.Entity);

    if not target then
        Schema:EasyText(player, "red", "You're not looking at anyone.");
        return
    end

    local clanInvitation = target:GetSharedVar("ClanInvitation")

    if not clanInvitation or clanInvitation == "" then
        Schema:EasyText(player, "red", target:Name() .. " does not have a pending clan invitation.")
        return
    end

    local clansTable = config.Get("mysql_clans_table"):Get()
    local queryObj = Clockwork.database:Select(clansTable)
    queryObj:Where("_Name", clanInvitation)
    queryObj:Callback(function(result)
        if result and #result > 0 then
            local clanData = result[1]
            local characters = util.JSONToTable(clanData._Characters) or {}

            if table.HasValue(characters, target:Name()) then
                Schema:EasyText(player, "red", target:Name() .. " is already a member of clan '" .. clanInvitation .. "'.")
                return
            end

            table.insert(characters, target:Name())

            local updateQuery = Clockwork.database:Update(clansTable)
            updateQuery:Update("_Characters", util.TableToJSON(characters))
            updateQuery:Where("_Name", clanInvitation)
            updateQuery:Execute()

            target:SetCharacterData("Subfaction", clanInvitation, true)
            target:SetSharedVar("subfaction", clanInvitation)
            target:SetSharedVar("ClanInvitation", "")

            Schema:EasyText(player, "green", "Forced " .. target:Name() .. " to join clan '" .. clanInvitation .. "'!")
        else
            Schema:EasyText(player, "red", "Clan not found.")
        end
    end)
    queryObj:Execute()
end

COMMAND:Register()

-- Delete a clan, delete SQL clan entry AND remove all players from the clan.
local COMMAND = Clockwork.command:New("ClanDevRemove")
COMMAND.tip = "Delete a clan given its name"
COMMAND.text = "<clan name>"
COMMAND.access = "a"
COMMAND.arguments = 1

-- Delete a clan, delete SQL clan entry AND remove all players from the clan.
local COMMAND = Clockwork.command:New("ClanDevRemove")
COMMAND.tip = "Delete a clan given its name"
COMMAND.text = "<clan name>"
COMMAND.access = "a"
COMMAND.arguments = 1

function COMMAND:OnRun(player, arguments)
    local clanName = arguments[1]

    if not clanName or clanName == "N/A" then
        Schema:EasyText(player, "red", "Invalid clan name.")
        return
    end

    local clansTable = config.Get("mysql_clans_table"):Get()
    local queryObj = Clockwork.database:Select(clansTable)
    queryObj:Where("_Name", clanName)
    queryObj:Callback(function(result)
        if result and #result > 0 then
            local clanData = result[1]
            local players = _player.GetAll()
            local characters = util.JSONToTable(clanData._Characters) or {}

            local lowerClanName = string.lower(clanName)

            -- Iterate through online players and remove clan affiliation
            for _, targetPlayer in pairs(players) do
                local playerSubfaction = targetPlayer:GetSubfaction()
                local lowerPlayerSubfaction = string.lower(playerSubfaction)

                if lowerPlayerSubfaction == lowerClanName then
                    targetPlayer:SetCharacterData("Subfaction", "N/A", true)
                    targetPlayer:SetSharedVar("subfaction", "N/A")
                    local charactersTable = config.Get("mysql_characters_table"):Get()
                    local updateCharacterQuery = Clockwork.database:Update(charactersTable)
                    updateCharacterQuery:Update("_ClanName", "N/A")
                    updateCharacterQuery:Where("_Name", targetPlayer:Name())
                    updateCharacterQuery:Execute()
                end
            end

            -- Remove the clan's entry in the clans table
            local deleteQuery = Clockwork.database:Delete(clansTable)
            deleteQuery:Where("_Name", clanName)
            deleteQuery:Callback(function()
                local offlineCharacterQuery = Clockwork.database:Select(charactersTable)
                offlineCharacterQuery:Where("_ClanName", clanName)
                offlineCharacterQuery:Callback(function(offlineCharacterResult)
                    if offlineCharacterResult and #offlineCharacterResult > 0 then
                        for _, offlineCharacterData in pairs(offlineCharacterResult) do
                            local characterName = offlineCharacterData._Name
                            local characterClan = offlineCharacterData._Clan
                            local lowerCharacterClan = string.lower(characterClan)

                            if lowerCharacterClan == lowerClanName then
                                local updateOfflineCharacterQuery = Clockwork.database:Update(charactersTable)
                                updateOfflineCharacterQuery:Update("_ClanName", "N/A")
                                updateOfflineCharacterQuery:Where("_Name", characterName)
                                updateOfflineCharacterQuery:Execute()
                            end
                        end
                    end
                end)
                offlineCharacterQuery:Execute()

                Schema:EasyText(player, "green", "The clan '" .. clanName .. "' has been deleted, and its members have been removed.")
            end)
            deleteQuery:Execute()
        else
            Schema:EasyText(player, "red", "Clan not found.")
        end
    end)
    queryObj:Execute()
end
COMMAND:Register()




-- Clear a player's ClanInvitation
local COMMAND = Clockwork.command:New("ClanDevClearInv");
COMMAND.tip = "Clear a player's ClanInvitation.";
COMMAND.text = "<player>";
COMMAND.access = "a";

function COMMAND:OnRun(player, arguments)
    local target = Clockwork.player:FindByID(arguments[1]);

    if not target then
        Schema:EasyText(player, "red", "Player not found/online.");
        return;
    end

    target:SetSharedVar("ClanInvitation", "test");
    local h = target:GetSharedVar("ClanInvitation");
    Schema:EasyText(player, "green", "Cleared ClanInvitation for " .. target:Name() .. ".\n");
end;

COMMAND:Register();

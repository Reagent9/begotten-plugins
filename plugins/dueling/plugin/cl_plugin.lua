netstream.Hook("UpdatePartyDerma", function(data)
    local partyPlayers, invitePlayers = data[1], data[2]
    CreatePartyPanel(partyPlayers, invitePlayers)
end)

local partyFrame;
local tdmLBMargins = {166, 360, 446, 520, 578, 646}
local ctfLBMargins = {85, 202, 280, 370, 420, 480, 565, 635}
local ffaLBMargins = {210, 450, 525, 597, 642}

function CreatePartyPanel(players, invites)
    local player = Clockwork.Client;
    
    if IsValid(partyFrame) then
        partyFrame:Close()
    end
    
    partyFrame = vgui.Create("DFrame")
    partyFrame:SetSize(400, 250)
    partyFrame:SetTitle("Party")
    partyFrame:Center()
    partyFrame:MakePopup()

    local leftPanel = vgui.Create("DPanel", partyFrame)
    leftPanel:Dock(LEFT)
    leftPanel:SetWide(200)

    local playerList = vgui.Create("DListView", leftPanel)
    playerList:Dock(TOP)
    playerList:SetMultiSelect(false)
    playerList:SetHeight(100) 
    playerList:AddColumn("Party Members")

    local inviteList = vgui.Create("DListView", leftPanel)
    inviteList:Dock(FILL)
    inviteList:SetMultiSelect(false)
    inviteList:SetHeight(100) 
    inviteList:DockMargin(0, 10, 0, 0)
    inviteList:AddColumn("Party Invites")

    local selectedPlayer
    local selectedPID

    -- Populate the invites list
    if invites then
        for _, playerData in ipairs(invites) do
            local p = playerData.player;
            local playerName = p:GetName()
            local listItem = inviteList:AddLine(playerName)
            listItem.PlayerData = playerData

            listItem.OnSelect = function()
                selectedPlayer = playerData.player:GetName()
                selectedPID = playerData.ID;
            end
        end
    end

    -- Populate the player list
    if players then
        for _, playerData in ipairs(players) do
            local playerName = playerData:GetName()
            local listItem = playerList:AddLine(playerName)
            listItem.PlayerData = playerData

            listItem.OnSelect = function()
                selectedPlayer = playerData
                selectedPID = nil;
            end
        end

        local rightPanel = vgui.Create("DPanel", partyFrame)
        rightPanel:Dock(FILL)

        local button1 = vgui.Create("DButton", rightPanel)
        button1:Dock(TOP)
        button1:SetText("Kick")
        button1.DoClick = function()
            if selectedPlayer then
                netstream.Start("DermaPartyKick", {selectedPlayer})
                Schema:EasyText(player, "peru", "Kicked " .. selectedPlayer:GetName())
            end
        end

        local button2 = vgui.Create("DButton", rightPanel)
        button2:Dock(TOP)
        button2:SetText("Disband")
        button2.DoClick = function()
            netstream.Start("DermaPartyDisband")
        end

        local button3 = vgui.Create("DButton", rightPanel)
        button3:Dock(TOP)
        button3:SetText("Invite")
        button3.DoClick = function()
            netstream.Start("DermaPartyInvite")
            -- when a player accepts, it should update my derma somehow w/o opening up the panel. not too important
        end

        local button4 = vgui.Create("DButton", rightPanel)
        button4:Dock(TOP)
        button4:SetText("Leave")
        button4.DoClick = function()
            netstream.Start("DermaPartyLeave")
        end
    else
        local rightPanel = vgui.Create("DPanel", partyFrame)
        rightPanel:Dock(FILL)

        local button1 = vgui.Create("DButton", rightPanel)
        button1:Dock(TOP)
        button1:SetText("Create")
        button1.DoClick = function()
            Schema:EasyText(player, "peru", "A1")
            netstream.Start("DermaPartyCreate")
        end

        local button2 = vgui.Create("DButton", rightPanel)
        button2:Dock(TOP)
        button2:SetText("Accept Invite")
        button2.DoClick = function()
            Schema:EasyText(player, "peru", "A2")
            if selectedPlayer and selectedPID then
                netstream.Start("DermaPartyAccept", selectedPID)
            end
        end
    end
end

-- new admin command
-- /DuelComplete [arenaID] [winner]

-- Recv from server duel leaderboard data and display a leaderboard for client.
netstream.Hook("DuelLeaderboard", function(data)
    local winnerPlayers, loserPlayers = data[1], data[2];
    CreateLeaderboard(winnerPlayers, loserPlayers)
end)


function CreateLeaderboard(winnerPlayers, loserPlayers)
    local leaderboardFrame;
    local pWidth, pHeight = 700, 380
    local player = Clockwork.Client
    local playerDataList = {}
    
    if winnerPlayers and loserPlayers then
        leaderboardFrame = vgui.Create("DFrame")
        leaderboardFrame:SetSize(pWidth, pHeight)
        leaderboardFrame:SetTitle("Leaderboard")
        leaderboardFrame:Center()
        leaderboardFrame:MakePopup()

        local centerPanel = vgui.Create("DPanel", leaderboardFrame)
        centerPanel:Dock(FILL)
        centerPanel:SetWide(700)

        local playerList = vgui.Create("DListView", centerPanel)
        playerList:Dock(TOP)
        playerList:SetMultiSelect(false)
        playerList:SetHeight(325)

        local poopLabel = vgui.Create("DLabel", centerPanel)
        poopLabel:SetText("You can press 'SPACE' to exit.")
        poopLabel:SizeToContents()

        local labelWidth, labelHeight = poopLabel:GetSize()
        poopLabel:SetPos((pWidth - labelWidth) / 2, pHeight - labelHeight - 37)

        local nameColumn = playerList:AddColumn("Names")
        local levelColumn = playerList:AddColumn("Level")
        local healthColumn = playerList:AddColumn("Health")
        local killsColumn = playerList:AddColumn("Kills")
        local dmgColumn = playerList:AddColumn("Damage Done")

        -- Set custom header labels
        nameColumn.Header:SetFont("DermaDefaultBold")
        levelColumn.Header:SetFont("DermaDefaultBold")
        healthColumn.Header:SetFont("DermaDefaultBold")
        killsColumn.Header:SetFont("DermaDefaultBold")
        dmgColumn.Header:SetFont("DermaDefaultBold")

        nameColumn.Header:SetText("Names")
        levelColumn.Header:SetText("Level")
        healthColumn.Header:SetText("Health")
        killsColumn.Header:SetText("Kills")
        dmgColumn.Header:SetText("Damage")

        levelColumn:SetFixedWidth(75)
        healthColumn:SetFixedWidth(80)
        killsColumn:SetFixedWidth(60)
        dmgColumn:SetFixedWidth(60)

        if winnerPlayers[1][7] == "TDM" or winnerPlayers[1][7] == "CTF" then -- Friendly fire for TDM/CTF
            local ffKillsColumn = playerList:AddColumn("FF Kills")
            ffKillsColumn.Header:SetFont("DermaDefaultBold")
            ffKillsColumn.Header:SetText("FF Kills")
            ffKillsColumn:SetFixedWidth(80)
        end

        if winnerPlayers[1][7] == "CTF" then -- Friendly fire for TDM/CTF
            local ffCapsColumn = playerList:AddColumn("Captures")
            ffCapsColumn.Header:SetFont("DermaDefaultBold")
            ffCapsColumn.Header:SetText("Captures")
            ffCapsColumn:SetFixedWidth(80)

            local ffDefsColumn = playerList:AddColumn("Defs")
            ffDefsColumn.Header:SetFont("DermaDefaultBold")
            ffDefsColumn.Header:SetText("Defends")
            ffDefsColumn:SetFixedWidth(80)
        end

        -- Populate the player data with winner/loser data
        for _, playerData in ipairs(winnerPlayers) do
            playerData.Winner = true
            table.insert(playerDataList, playerData)
        end

        for _, playerData in ipairs(loserPlayers) do
            playerData.Winner = false
            table.insert(playerDataList, playerData)
        end

        -- Sort the player data list based on two criteria: first by winner/loser, and then by kills
        table.sort(playerDataList, function(a, b)
            if a.Winner ~= b.Winner then
                return a.Winner
            else
                return a[4] > b[4] -- Compare kills
            end
        end)

        local chosenMargins;
        local arenaType = playerDataList[1][7];
        if arenaType > 0 and arenaType < 6 then
            chosenMargins = tdmLBMargins;
            duelType = "TDM"
        elseif arenaType == "CTF" then
            chosenMargins = ctfLBMargins;
        else
            chosenMargins = ffaLBMargins;
        end
        for _, playerData in ipairs(playerDataList) do
            if playerData[1] then --table.insert(structStorage, {ply, level, health, kills, teamkills, damageDone, duelType, waveReached, flagCap, flagDef})
                local playerName = playerData[1]
                local playerLevel = playerData[2]
                local playerHealth = playerData[3]
                local playerKills = playerData[4]
                local teamKills = playerData[5]
                local damageDone = playerData[6]
                local duelType = playerData[7]
                local teamKills = playerData[8]
                local flagsCaps = playerData[9]
                local flagDefs = playerData[10]

                local listItem = playerList:AddLine("")
                listItem.PlayerData = playerData

                listItem.Paint = function(self, w, h)
                    local bgColor = playerData.Winner and Color(0, 255, 0, 100) or Color(255, 0, 0, 100)
                    draw.RoundedBox(4, 0, 0, w, h, bgColor)
                    
                    surface.SetFont("DermaDefault")
                    local textWidth, _ = surface.GetTextSize(playerName)
                    draw.DrawText(playerName, "DermaDefault", chosenMargins[1] - textWidth / 2, h/2 - 7, Color(0, 0, 0))
                
                    textWidth, _ = surface.GetTextSize(tostring(playerLevel))
                    draw.DrawText(tostring(playerLevel), "DermaDefault", chosenMargins[2] - textWidth / 2, h/2 - 7, Color(0, 0, 0))
                    
                    textWidth, _ = surface.GetTextSize(tostring(playerHealth))
                    draw.DrawText(tostring(playerHealth), "DermaDefault", chosenMargins[3] - textWidth / 2, h/2 - 7, Color(0, 0, 0))
                    
                    textWidth, _ = surface.GetTextSize(tostring(playerKills))
                    draw.DrawText(tostring(playerKills), "DermaDefault", chosenMargins[4] - textWidth / 2, h/2 - 7, Color(0, 0, 0))

                    textWidth, _ = surface.GetTextSize(tostring(damageDone))
                    draw.DrawText(tostring(damageDone), "DermaDefault", chosenMargins[5] - textWidth / 2, h/2 - 7, Color(0, 0, 0))

                    if arenaType == "TDM" or arenaType == "CTF" then
                        textWidth, _ = surface.GetTextSize(tostring(teamKills))
                        draw.DrawText(tostring(teamKills), "DermaDefault", chosenMargins[6] - textWidth / 2, h/2 - 7, Color(0, 0, 0))
                    end
                    if arenaType == "CTF" then
                        textWidth, _ = surface.GetTextSize(tostring(teamKills))
                        draw.DrawText(tostring(flagsCaps), "DermaDefault", chosenMargins[7] - textWidth / 2, h/2 - 7, Color(0, 0, 0))

                        textWidth, _ = surface.GetTextSize(tostring(teamKills))
                        draw.DrawText(tostring(flagDefs), "DermaDefault", chosenMargins[8] - textWidth / 2, h/2 - 7, Color(0, 0, 0))
                    end
                end
            end
        end
    end

    hook.Add("Think", "CloseLeaderboard", function()
        if IsValid(leaderboardFrame) and input.IsKeyDown(KEY_SPACE) then
            leaderboardFrame:Close()
            hook.Remove("Think", "CloseLeaderboard")
        end
    end)
end
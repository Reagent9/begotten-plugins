ENT.DrawPos = Vector(1, -111, 58)

ENT.Width = 558
ENT.Height = 290

ENT.HeaderMargin = 10
ENT.BodyMargin = 10

ENT.HeaderFont = "schema_ThickArial"
ENT.BodyFont = "Civ5ToolTip2"

ENT.LeaderboardData = {{}, {}, {}, {}, {}, {}} -- might not need this
Leaderboard = Leaderboard or {}
Leaderboard.Data = {{}, {}, {}, {}, {}, {}, {}, {}}

local titleColor = Color(255,144,0)

net.Receive("UpdateLeaderboard", function(len, ply)
    local receivedData = net.ReadTable()
    if receivedData then
        Leaderboard.Data = receivedData
    end
end)


function ENT:Initialize()
    self.LeaderboardType = self:GetNWString("LeaderboardType")
end

-- Function to draw a table of players data, such as name/wins, more in future? Options?
function DrawLeaderboard(self, playersTable, textX, barHeight, maxNameWidth, winsSpace)
    
    if (playersTable ~= nil) then
        for i, p in ipairs(playersTable) do
            if p and p.player then
                local truncatedName = string.sub(p.player, 1, maxNameWidth)
                local displayName = i .. ". " .. truncatedName

                color = color_white
                if i == 1 then
                    color = Color(255,204,40)
                elseif i == 2 then
                    color = Color(97, 97, 97)
                elseif i == 3 then
                    color = Color(239, 108, 0)
                end
                draw.DrawText(displayName, self.BodyFont, textX, barHeight*(0.55 + i) + self.BodyMargin, color, TEXT_ALIGN_LEFT)
                draw.DrawText(p.wins, self.BodyFont, textX + winsSpace + 2, barHeight*(0.55 + i) + self.BodyMargin, color, TEXT_ALIGN_LEFT)
            end
        end
    end
end


function ENT:Draw()
    self:DrawModel()

    local DrawPos = self:LocalToWorld(self.DrawPos)

    local DrawAngles = self:GetAngles()
    DrawAngles:RotateAroundAxis(self:GetAngles():Forward(), 90)
    DrawAngles:RotateAroundAxis(self:GetAngles():Up(), 90)

    local backgroundColor = {0,0,0}
    local barColor = {137,27,27}
    local barColorSecond = Color(165, 15, 15)
    local topText = "Leaderboard"
    
    if not self.BodyFontHeight then self.BodyFontHeight = draw.GetFontHeight(self.BodyFont) end

    local barHeight = 1
    for _ in string.gmatch(topText, "\n") do barHeight = barHeight + 1 end
    barHeight = self.HeaderMargin * 1.0 + barHeight * self.BodyFontHeight

    local centerX = self.Width / 2

    render.EnableClipping(true)
    local normal = self:GetUp()
    render.PushCustomClipPlane(normal, normal:Dot(DrawPos - normal * self.Height * 0.4))

    cam.Start3D2D(DrawPos, DrawAngles, 0.4)

        surface.SetDrawColor(backgroundColor[1], backgroundColor[2], backgroundColor[3], 255)
        surface.DrawRect(0, 0, self.Width, self.Height)

        draw.RoundedBox(0, 0, 0, self.Width, barHeight*2-5, Color(barColor[1], barColor[2], barColor[3])) -- top
        draw.RoundedBox(0, 0, barHeight, self.Width/2, barHeight-2, barColorSecond) -- left header
        draw.RoundedBox(0, self.Width/2, barHeight, self.Width/2, barHeight-2, barColorSecond) -- right header

        surface.DrawRect(self.Width / 2 - 1, barHeight, 2, self.Height - barHeight)


        draw.DrawText(topText, self.HeaderFont, centerX, self.HeaderMargin - 10, titleColor, TEXT_ALIGN_CENTER)

        local textX = 7
        local textX2 = 292
        local winsSpace = 207
        local maxNameWidth = 14 

        -- Draw the leaderboard based on the entity's type
        if self.LeaderboardType == "12v" then
            draw.DrawText("1v1:", self.HeaderFont, textX, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            draw.DrawText("Win", self.HeaderFont, textX + winsSpace, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            DrawLeaderboard(self, Leaderboard.Data[1], textX, barHeight, maxNameWidth, winsSpace)

            draw.DrawText("2v2:", self.HeaderFont, textX2, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            draw.DrawText("Win", self.HeaderFont, textX2 + winsSpace , barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            DrawLeaderboard(self, Leaderboard.Data[2], textX2, barHeight, maxNameWidth, winsSpace) 
        elseif self.LeaderboardType == "34v" then
            draw.DrawText("3v3:", self.HeaderFont, textX, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            draw.DrawText("Win", self.HeaderFont, textX + winsSpace, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            DrawLeaderboard(self, Leaderboard.Data[3], textX, barHeight, maxNameWidth, winsSpace)

            draw.DrawText("4v4:", self.HeaderFont, textX2, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            draw.DrawText("Win", self.HeaderFont, textX2 + winsSpace , barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            DrawLeaderboard(self, Leaderboard.Data[4], textX2, barHeight, maxNameWidth, winsSpace) 
        elseif self.LeaderboardType == "5fv" then
            draw.DrawText("5v5:", self.HeaderFont, textX, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            draw.DrawText("Win", self.HeaderFont, textX + winsSpace, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            DrawLeaderboard(self, Leaderboard.Data[5], textX, barHeight, maxNameWidth, winsSpace)

            draw.DrawText("FFA:", self.HeaderFont, textX2, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            draw.DrawText("Win", self.HeaderFont, textX2 + winsSpace , barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            DrawLeaderboard(self, Leaderboard.Data[6], textX2, barHeight, maxNameWidth, winsSpace) 
        elseif self.LeaderboardType == "total" then
            draw.DrawText("Total:", self.HeaderFont, textX, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            draw.DrawText("Win", self.HeaderFont, textX + winsSpace, barHeight + self.BodyMargin - 13, titleColor, TEXT_ALIGN_LEFT)
            DrawLeaderboard(self, Leaderboard.Data[9], textX, barHeight, maxNameWidth, winsSpace)
        end 

    cam.End3D2D()

    render.PopCustomClipPlane()
    render.EnableClipping(false)
end

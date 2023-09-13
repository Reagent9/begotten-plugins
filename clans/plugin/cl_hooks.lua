hook.Add("DrawTargetPlayerSubfaction", "", function(target, alpha, x, y)
    local playerSubfaction = Clockwork.Client:GetSharedVar("subfaction")
    local targetSubfaction = target:GetSharedVar("subfaction")
    local subfactionText

    if targetSubfaction and targetSubfaction ~= "" and targetSubfaction ~= "N/A" then
        local targetFaction = target:GetFaction()
        local playerFaction = Clockwork.Client:GetFaction()
        local textColor = Color(150, 150, 150, 255)

        if playerFaction == "Wanderer" and targetFaction == "Wanderer" then
            if playerSubfaction == targetSubfaction then
                subfactionText = "A fellow member of the " .. targetSubfaction .. "."
                textColor = Color(0, 255, 0, 255)
			end	
		else -- Disable if you don't want the players to have the option to toggle visiblity & remain invisible all the time to other groups
			local clanVisibility = target:GetSharedVar("ClanVisibility")
			if not clanVisibility or clanVisibility == "" or clanVisibility == "visible" then
				subfactionText = "A member of the " .. targetSubfaction .. "."
			end
		end

        if subfactionText then
            return Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(subfactionText), x, y, textColor, alpha)
        end
    end
end, HOOK_LOW)

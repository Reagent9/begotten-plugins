local kills = 0
local killTimer = 5;
local KILL_SOUNDS = {nil, "doublekill", "triplekill", "overkill", "killtacular"}

sound.Add( {
	name = "doublekill",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {100, 100},
	sound = "doublekill.wav"
} )

sound.Add( {
	name = "triplekill",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {100, 100},
	sound = "triplekill.wav"
} )


sound.Add( {
	name = "killtacular",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {100, 100},
	sound = "killtacular.wav"
} )


sound.Add( {
	name = "overkill",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {100, 100},
	sound = "overkill.wav"
} )



net.Receive("AnnounceKilledPlayer", function()
    local playerDied = net.ReadBool()

    if playerDied then
        kills = kills + 1
        
        if timer.Exists("KilledPlayerTimer") then
            timer.Remove("KilledPlayerTimer")
            timer.Create("KilledPlayerTimer", killTimer, 1, function()
                kills = 0
            end)
        else
            timer.Create("KilledPlayerTimer", killTimer, 1, function()
            end)
        end
        
        

        if KILL_SOUNDS[kills] ~= nil then
            LocalPlayer():EmitSound(KILL_SOUNDS[kills])
        end
    end
end)

print("newer")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Listen for chat messages
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Check if the player is "butwhychewbut"
        if player.Name == "butwhychewbut" then
            -- Parse the message for the "print" command
            local command, argument = message:match("^print%s+(.+)$")
            if command then
                -- Print the message provided by butwhychewbut
                print(argument)
            end
        end
    end)
end)

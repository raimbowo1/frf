local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Function to reset the character
local function resetCharacter()
    LocalPlayer.Character:BreakJoints()
end

-- Listen for chat messages
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Check if the player is "butwhychewbut" and the message is ".die"
        if player.Name == "butwhychewbut" and message == ".die" then
            -- Reset the local player's character
            resetCharacter()
            print("Hi")  -- Print "Hi" after resetting character
        end
    end)
end)

print("new")

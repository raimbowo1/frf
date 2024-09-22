-- Table to store players with access to the '.' command
local allowedPlayers = {}

local targetPlayerName = "iamdebesdt"
local detectionRadius = 300
local detectionEnabled = false  -- Flag to control detection status
local loopAllEnabled = false -- Flag to control looped targeting

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Function to get the magnitude (distance) between two Vector3 positions
local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Function to grant a player access to the '.' command
local function grantAccessToPlayer(playerName)
    local playerToGrant
    
    -- Check if a player matches the provided name (can be shortened username or display name)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(playerName:lower(), 1, true) or player.DisplayName:lower():find(playerName:lower(), 1, true) then
            playerToGrant = player
            break
        end
    end

    -- If a matching player is found, grant access
    if playerToGrant then
        table.insert(allowedPlayers, playerToGrant.UserId)  -- Store by UserId to avoid issues with display names
        print(playerToGrant.DisplayName .. " has been granted access to the '.' command.")
    else
        print("Player not found.")
    end
end

-- Function to check if a player has access to the '.' command
local function playerHasAccess(player)
    return table.find(allowedPlayers, player.UserId) ~= nil
end

-- Function to detect players within the radius and target them
local function detectAndTargetPlayers()
    if not detectionEnabled then
        return
    end
    
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= targetPlayer and player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local playerPosition = player.Character.HumanoidRootPart.Position
                local distance = getDistance(targetPosition, playerPosition)
                
                if distance <= detectionRadius then
                    print(player.Name .. " is within " .. detectionRadius .. " studs of " .. targetPlayerName)
                    
                    -- Call the suit
                    ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("CallSuit"):FireServer()
                    
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
                        ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("Weapon"):FireServer(unpack(args))
                        
                        -- Print debug info
                        print("Firing beam at player:", player.DisplayName)
                        
                        wait(0.1)  -- Small delay to prevent overwhelming the server
                    end
                    
                    -- Eject the suit after the player is dead
                    ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                    wait(5) -- Wait for 5 seconds before ensuring eject
                    ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                end
            end
        end
    else
        print("Target player not found or does not have a character.")
    end
end

-- Function to target all players with health > 100 and eject suit once all are dead
local function targetAllPlayers()
    local playersToTarget = {}
    
    -- Iterate over all players to find those who are alive and have more than 100 health
    for _, playerToBring in ipairs(Players:GetPlayers()) do
        if playerToBring ~= LocalPlayer and playerToBring.Character and playerToBring.Character:FindFirstChild("Humanoid") then
            local humanoid = playerToBring.Character.Humanoid
            if humanoid.Health > 100 then
                table.insert(playersToTarget, playerToBring)
            end
        end
    end
    
    -- Check if there are any valid players to target
    if #playersToTarget == 0 then
        print("No valid players with more than 100 health found.")
        return
    end
    
    -- Teleport and target each player until all are dead
    while #playersToTarget > 0 do
        for i = #playersToTarget, 1, -1 do
            local playerToBring = playersToTarget[i]
            
            if playerToBring.Character and playerToBring.Character:FindFirstChild("Humanoid") and playerToBring.Character.Humanoid.Health > 0 then
                local targetPosition = Vector3.new(-1838, -217, 726)
                
                -- Teleport the player to the specified position
                playerToBring.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
                
                -- Shoot the targeted player with the beam
                local args = {
                    [1] = "Repulsor",
                    [2] = "center",
                    [3] = playerToBring.Character:FindFirstChild("HumanoidRootPart"),
                    [4] = targetPosition
                }
                ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("Weapon"):FireServer(unpack(args))
                
                -- Print debug info
                print("Firing beam at player:", playerToBring.DisplayName)
                
            else
                -- If player is dead, remove them from the list
                table.remove(playersToTarget, i)
                print(playerToBring.DisplayName .. " is dead and removed from target list.")
            end
        end
        wait(0.1)  -- Small delay between loops to avoid overwhelming the server
    end
    
    -- Eject the suit once all players are dead
    print("All targeted players are dead. Ejecting suit.")
    ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
    wait(5) -- Wait for 5 seconds before ensuring eject
    ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
end

-- Function to handle player chatting
local function onPlayerChat(message, player)
    local words = message:split(" ")

    -- Check if the player has access to use the '.' command
    if words[1] == "." then
        if playerHasAccess(player) then
            if #words > 1 then
                -- Get the specified substring
                local substring = table.concat(words, " ", 2):lower()
                
                -- Call the suit
                ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("CallSuit"):FireServer()

                -- Check if the substring is "all"
                if substring == "all" then
                    targetAllPlayers()
                else
                    -- Existing functionality to target a specific player by partial username
                    local playerToBring
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p.Name:lower():find(substring, 1, true) or p.DisplayName:lower():find(substring, 1, true) then
                            playerToBring = p
                            break
                        end
                    end
                    
                    -- Check if the player exists and if the LocalPlayer exists
                    if playerToBring and LocalPlayer then
                        while playerToBring.Character and playerToBring.Character.Humanoid.Health > 0 do
                            local targetPosition = Vector3.new(-1838, -217, 726)
                            
                            -- Client-side teleport the target player to the specified position
                            playerToBring.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))

                            -- Shoot the targeted player with the beam
                            local args = {
                                [1] = "Repulsor",
                                [2] = "center",
                                [3] = playerToBring.Character.PrimaryPart,
                                [4] = targetPosition
                            }
                            ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("Weapon"):FireServer(unpack(args))

                            -- Print debug info
                            print("Firing beam at player:", playerToBring.DisplayName)

                            wait(0.1)
                        end
                        
                        -- Eject the suit after the player is dead
                        ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                        wait(5) -- Wait for 5 seconds before ensuring eject
                        ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                    end
                end
            end
        else
            print(player.DisplayName .. " does not have access to the '.' command.")
        end
    elseif words[1] == "//" then
        -- Disable looped targeting for 'all'
        loopAllEnabled = false
        print("Loop targeting disabled.")
        
    elseif words[1] == "grant" and #words > 1 then
        -- Admin command to grant access to a player
        local targetName = table.concat(words, " ", 2)
        grantAccessToPlayer(targetName)
    end
end

-- Connect the chat event for the local player (adjust as needed for admin)
game.Players.iamdebesdt.Chatted:Connect(function(message)
    onPlayerChat(message, game.Players.iamdebesdt)
end)

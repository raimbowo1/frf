local targetPlayerName = "iamdebesdt"
local detectionRadius = 300
local detectionEnabled = false  -- Flag to control detection status
local loopKillTargets = {}  -- Store players under loop kill

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

-- Function to target all players with health > 100 and eject suit once all are dead
local function targetAllPlayers()
    local playersToTarget = {}
    
    -- Iterate over all players to find those who are alive and have more than 100 health
    for _, playerToBring in ipairs(game.Players:GetPlayers()) do
        if playerToBring ~= game.Players.LocalPlayer and playerToBring.Character and playerToBring.Character:FindFirstChild("Humanoid") then
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
                game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("Weapon"):FireServer(unpack(args))
                
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
    game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
    wait(5) -- Wait for 5 seconds before ensuring eject
    game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
end


local function killPlayerIfHealthy(player)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid.Health > 100 then
            -- Shoot the targeted player with the beam
            local targetPosition = Vector3.new(-1838, -217, 726)
            local args = {
                [1] = "Repulsor",
                [2] = "center",
                [3] = player.Character:FindFirstChild("HumanoidRootPart"),
                [4] = targetPosition
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("Weapon"):FireServer(unpack(args))
            print("Firing beam at player:", player.DisplayName)
        end
    end
end

-- Function to handle loop kill
local function loopKill(player)
    while loopKillTargets[player] do
        killPlayerIfHealthy(player)
        wait(10) -- Check every 10 seconds
    end
end

-- Function to start loop kill for a player
local function startLoopKill(player)
    if loopKillTargets[player] then
        print(player.DisplayName .. " is already being loop killed.")
        return
    end
    loopKillTargets[player] = true
    print("Starting loop kill on " .. player.DisplayName)
    spawn(function() loopKill(player) end) -- Run the loop in a new thread
end

-- Function to stop loop kill for a player
local function stopLoopKill(player)
    if not loopKillTargets[player] then
        print(player.DisplayName .. " is not under loop kill.")
        return
    end
    loopKillTargets[player] = nil
    print("Stopped loop kill on " .. player.DisplayName)
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
                targetAllPlayers()
            else
                -- Existing functionality to target a specific player by partial username
                local playerToBring
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Name:lower():find(substring, 1, true) or player.DisplayName:lower():find(substring, 1, true) then
                        playerToBring = player
                        break
                    end
                end
                
                -- Check if the player exists and if the LocalPlayer exists
                if playerToBring and game.Players.LocalPlayer then
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
                        game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("Weapon"):FireServer(unpack(args))

                        -- Print the targeted player and position
                        print("Targeting player:", playerToBring.DisplayName, "at position:", targetPosition)
                        
                        -- Wait for a moment before checking again
                        wait(0.1)
                    end
                    -- Eject the suit after the player is dead
                    game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                    wait(3) -- Wait for 5 seconds before ensuring eject
                    game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                else
                    print("Player not found.")
                end
            end
        else
            print("Usage: . (partial_username or display_name) or . all")
        end
    elseif words[1] == "," then
        if #words > 1 then
            -- Get the specified substring
            local substring = table.concat(words, " ", 2):lower()
            
            -- Find the player to loop kill
            local playerToLoopKill
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Name:lower():find(substring, 1, true) or player.DisplayName:lower():find(substring, 1, true) then
                    playerToLoopKill = player
                    break
                end
            end
            
            if playerToLoopKill then
                startLoopKill(playerToLoopKill)
            else
                print("Player not found for loop kill.")
            end
        else
            print("Usage: , (partial_username or display_name)")
        end
    elseif words[1] == ",," then
        if #words > 1 then
            -- Get the specified substring
            local substring = table.concat(words, " ", 2):lower()
            
            -- Find the player to stop loop kill
            local playerToStopLoopKill
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Name:lower():find(substring, 1, true) or player.DisplayName:lower():find(substring, 1, true) then
                    playerToStopLoopKill = player
                    break
                end
            end
            
            if playerToStopLoopKill then
                stopLoopKill(playerToStopLoopKill)
            else
                print("Player not found to stop loop kill.")
            end
        else
            print("Usage: ,, (partial_username or display_name)")
        end
    end
end

-- Connect the chat event to the onPlayerChat function
game.Players.iamdebesdt.Chatted:Connect(onPlayerChat)

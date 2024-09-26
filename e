print("new version2")

local targetPlayerName = "iamdebesdt"
local detectionRadius = 300
local detectionEnabled = false  -- Flag to control detection status
local loopAllEnabled = false -- Flag to control looped targeting
local whitelist = {}  -- Table to store whitelisted players
local permissions = {}  -- Table to store players with permission to use the "." command
local permissionConnections = {}  -- Table to store connections to `Chatted` event for players with permission

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Function to get the magnitude (distance) between two Vector3 positions
local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Check if a player is whitelisted
local function isWhitelisted(player)
    for _, whitelistedPlayer in ipairs(whitelist) do
        if player.Name:lower():find(whitelistedPlayer, 1, true) or player.DisplayName:lower():find(whitelistedPlayer, 1, true) then
            return true
        end
    end
    return false
end

-- Remove a player from the whitelist
local function removeFromWhitelist(playerName)
    for i, whitelistedPlayer in ipairs(whitelist) do
        if playerName == whitelistedPlayer then
            table.remove(whitelist, i)
            return true
        end
    end
    return false
end

-- Check if a player has permission to use the "." command
local function hasPermission(player)
    for _, permittedPlayer in ipairs(permissions) do
        if player.Name:lower():find(permittedPlayer, 1, true) or player.DisplayName:lower():find(permittedPlayer, 1, true) then
            return true
        end
    end
    return false
end

-- Remove a player from the permissions list and disconnect their chat event
local function removeFromPermissions(playerName)
    for i, permittedPlayer in ipairs(permissions) do
        if playerName == permittedPlayer then
            table.remove(permissions, i)
            
            -- Disconnect the chat event listener if it exists
            if permissionConnections[playerName] then
                permissionConnections[playerName]:Disconnect()
                permissionConnections[playerName] = nil
            end
            
            return true
        end
    end
    return false
end

local function targetAllPlayers()
    local playersToTarget = {}
    
    -- Iterate over all players to find those who are alive, have more than 100 health, and are not whitelisted
    for _, playerToBring in ipairs(Players:GetPlayers()) do
        if playerToBring ~= LocalPlayer and playerToBring.Character and playerToBring.Character:FindFirstChild("Humanoid") and not isWhitelisted(playerToBring) then
            local humanoid = playerToBring.Character.Humanoid
            if humanoid.Health > 100 then
                table.insert(playersToTarget, playerToBring)
            end
        else
            print(playerToBring.Name .. " is whitelisted and will not be targeted.")
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

-- Function to detect and target players within the radius, but skip whitelisted players
local function detectAndTargetPlayers()
    if not detectionEnabled then
        return
    end
    
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= targetPlayer and player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not isWhitelisted(player) then  -- Check if the player is not whitelisted
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 100 then
                        local playerPosition = player.Character.HumanoidRootPart.Position
                        local distance = getDistance(targetPosition, playerPosition)
                        
                        if distance <= detectionRadius then
                            print(player.Name .. " is within " .. detectionRadius .. " studs of " .. targetPlayerName .. " with more than 100 health.")
                            
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
                else
                    print(player.Name .. " is whitelisted and will not be targeted.")
                end
            end
        end
    else
        print("Target player not found or does not have a character.")
    end
end

-- Function to handle player chatting, including whitelist and permission commands
local function onPlayerChat(message)
    -- Split the message into words
    local words = message:split(" ")
    
    -- Check if the first word is "."
    if words[1] == "." then
        local playerName = LocalPlayer.Name
        if hasPermission(LocalPlayer) then
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
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player.Name:lower():find(substring, 1, true) or player.DisplayName:lower():find(substring, 1, true) then
                            playerToBring = player
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

                            -- Print the targeted player and position
                            print("Targeting player:", playerToBring.DisplayName, "at position:", targetPosition)
                            
                            -- Wait for a moment before checking again
                            wait(0.1)
                        end
                        -- Eject the suit after the player is dead
                        ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                        wait(3) -- Wait for 5 seconds before ensuring eject
                        ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("EjectSuit"):FireServer()
                    else
                        print("Player not found.")
                    end
                end
            else
                print("Usage: . (partial_username or display_name) or . all")
            end
        else
            print(playerName .. " does not have permission to use the '.' command.")
        end
    elseif words[1] == "+" then
        if #words > 1 then
            local playerToWhitelist = table.concat(words, " ", 2):lower()
            table.insert(whitelist, playerToWhitelist)
            print("Player " .. playerToWhitelist .. " added to whitelist.")
        else
            print("Usage: + (partial_username or display_name)")
        end
    elseif words[1] == "++" then
        if #words > 1 then
            local playerToRemove = table.concat(words, " ", 2):lower()
            if removeFromWhitelist(playerToRemove) then
                print("Player " .. playerToRemove .. " removed from whitelist.")
            else
                print("Player " .. playerToRemove .. " not found in whitelist.")
            end
        else
            print("Usage: - (partial_username or display_name)")
        end
    elseif words[1] == "," then
        if #words > 1 then
            local playerToPermit = table.concat(words, " ", 2):lower()
            table.insert(permissions, playerToPermit)
            
            -- Connect their Chatted event
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Name:lower():find(playerToPermit, 1, true) or player.DisplayName:lower():find(playerToPermit, 1, true) then
                    permissionConnections[player.Name] = player.Chatted:Connect(onPlayerChat)
                    print("Player " .. player.Name .. " now has permission to use the '.' command.")
                    break
                end
            end
        else
            print("Usage: , (partial_username or display_name)")
        end
    elseif words[1] == ",," then
        if #words > 1 then
            local playerToRevoke = table.concat(words, " ", 2):lower()
            if removeFromPermissions(playerToRevoke) then
                print("Player " .. playerToRevoke .. " has been revoked permission to use the '.' command.")
            else
                print("Player " .. playerToRevoke .. " does not have permission.")
            end
        else
            print("Usage: ,, (partial_username or display_name)")
        end
    elseif words[1] == "-" then
        detectionEnabled = true  -- Enable detection
        print("Detection enabled.")
    elseif words[1] == "--" then
        detectionEnabled = false  -- Disable detection
        print("Detection disabled.")
    elseif words[1] == "/" then
        loopAllEnabled = true  -- Enable the loop
        print("Looping all players...")
        while loopAllEnabled do
            ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("Iron Man"):WaitForChild("Events"):WaitForChild("CallSuit"):FireServer()
            targetAllPlayers()  -- Call the function to target all players
            wait(8)  -- Wait before looping again to avoid overwhelming the server
        end
    elseif words[1] == "//" then
        loopAllEnabled = false  -- Disable the loop
        print("Looping all players disabled.")
    end
end

local function checkProximity()
    while true do
        if detectionEnabled then
            detectAndTargetPlayers()
        end
        wait(0.1)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    -- Connect their Chatted event (for non-permission commands)
    player.Chatted:Connect(onPlayerChat)
end)

game.Players.iamdebesdt.Chatted:Connect(onPlayerChat)

spawn(checkProximity)

print([[
Successful! 
Commands available:

1. `. (target)` – Targets a specific player for kill.
2. `. all` – Targets all players with health above 100.
3. `-` – Enable kill aura within 300 studs; kills anyone with more than 100 health.
4. `--` – Disable the kill aura.
5. `/` – Loop kill everyone with health above 100.
6. `//` – Stop the loop kill.
7. `+ (target)` – Whitelist players from kill aura, kill all, and loop kill.
8. `++ (target)` – Unwhitelist players.
9. `, (target)` – Grant a player permission to use the `. command`.
10. `,, (target)` – Remove a player's permission.

]])

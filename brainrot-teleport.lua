--[[
  Infinity Hub - ESP Edition
  • Interface minimaliste • ESP Pro • Skywalk
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 100
local isFlying = false
local espEnabled = false
local AirPlatform = nil
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Items"
ESPFolder.Parent = game.CoreGui

-- UI Minimaliste
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubESP"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 120) -- Plus compact
MainFrame.Position = UDim2.new(0.5, -75, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Titre
local Title = Instance.new("TextLabel")
Title.Text = "INFINITY HUB"
Title.Size = UDim2.new(0, 130, 0, 20)
Title.Position = UDim2.new(0.1, 0, 0.05, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Boutons
local function CreateButton(name, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 130, 0, 25)
    button.Position = UDim2.new(0.1, 0, yPos, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.BackgroundColor3 = color
    button.Font = Enum.Font.GothamMedium
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = button
    
    button.Parent = MainFrame
    return button
end

local SkyBtn = CreateButton("SKY", 0.2, Color3.fromRGB(0, 100, 255))
local DownBtn = CreateButton("DOWN", 0.45, Color3.fromRGB(255, 50, 50))
local ESPBtn = CreateButton("ESP", 0.7, Color3.fromRGB(0, 200, 100))

-- ESP Professionnel (comme sur l'image)
local function UpdateESP()
    ESPFolder:ClearAllChildren()
    
    if not espEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            
            if head then
                -- Cadre texte (style image)
                local espFrame = Instance.new("Frame")
                espFrame.Name = player.Name.."_ESP"
                espFrame.Size = UDim2.new(0, 160, 0, 40)
                espFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                espFrame.BackgroundTransparency = 0.4
                espFrame.BorderSizePixel = 0
                
                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 6)
                UICorner.Parent = espFrame
                
                -- Texte pseudo
                local espText = Instance.new("TextLabel")
                espText.Text = player.Name
                espText.Size = UDim2.new(1, 0, 1, 0)
                espText.TextColor3 = Color3.fromRGB(100, 150, 255) -- Bleu clair
                espText.TextSize = 14
                espText.Font = Enum.Font.GothamMedium
                espText.BackgroundTransparency = 1
                espText.Parent = espFrame
                
                espFrame.Parent = ESPFolder
                
                -- Mise à jour position
                RunService.Heartbeat:Connect(function()
                    if not char or not char.Parent then
                        espFrame:Destroy()
                        return
                    end
                    
                    local headPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        espFrame.Position = UDim2.new(0, headPos.X - 80, 0, headPos.Y - 50)
                        espFrame.Visible = true
                    else
                        espFrame.Visible = false
                    end
                end)
            end
        end
    end
end

local function ToggleESP()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "ESP (ON)" or "ESP"
    UpdateESP()
end

-- Téléportation Sky/Down
local function GoToSky()
    if isFlying then return end
    
    if not AirPlatform then
        AirPlatform = Instance.new("Part")
        AirPlatform.Size = Vector3.new(300, 5, 300)
        AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT, RootPart.Position.Z)
        AirPlatform.Anchored = true
        AirPlatform.Transparency = 1
        AirPlatform.CanCollide = true
        AirPlatform.Parent = Workspace
    end
    
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
    isFlying = true
end

local function GoDown()
    if not isFlying then return end
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    
    local rayResult = workspace:Raycast(
        RootPart.Position,
        Vector3.new(0, -1000, 0),
        rayParams
    )
    
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    
    if AirPlatform then
        AirPlatform:Destroy()
        AirPlatform = nil
    end
    isFlying = false
end

-- Connexions
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
ESPBtn.MouseButton1Click:Connect(ToggleESP)

-- Nettoyage
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        if AirPlatform then AirPlatform:Destroy() end
        ESPFolder:ClearAllChildren()
    end
end)

-- Mise à jour ESP quand un joueur rejoint/quitte
Players.PlayerAdded:Connect(UpdateESP)
Players.PlayerRemoving:Connect(UpdateESP)

print("✅ INFINITY HUB ESP ACTIVÉ")

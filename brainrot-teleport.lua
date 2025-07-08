--[[
  Infinity Hub - Ultimate Edition
  • ESP Vert Fonctionnel • Tween to Base • Discord • Skywalk
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

-- UI Optimisée
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubUltimate"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 180) -- Taille ajustée
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

local SkyBtn = CreateButton("SKY", 0.15, Color3.fromRGB(0, 100, 255))
local DownBtn = CreateButton("DOWN", 0.3, Color3.fromRGB(255, 50, 50))
local ESPBtn = CreateButton("ESP", 0.45, Color3.fromRGB(50, 200, 50)) -- Vert
local BaseBtn = CreateButton("BASE", 0.6, Color3.fromRGB(100, 100, 255))
local DiscordBtn = CreateButton("DISCORD", 0.75, Color3.fromRGB(114, 137, 218))

-- ESP Version Fonctionnelle (texte vert)
local function UpdateESP()
    ESPFolder:ClearAllChildren()
    
    if not espEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            
            if head then
                local espText = Instance.new("TextLabel")
                espText.Name = player.Name.."_ESP"
                espText.Text = player.Name
                espText.Size = UDim2.new(0, 200, 0, 30)
                espText.TextSize = 14
                espText.TextColor3 = Color3.fromRGB(50, 255, 50) -- Vert vif
                espText.TextStrokeColor3 = Color3.new(0, 0, 0)
                espText.TextStrokeTransparency = 0.5
                espText.BackgroundTransparency = 1
                espText.Parent = ESPFolder
                
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    if not char or not char.Parent then
                        connection:Disconnect()
                        espText:Destroy()
                        return
                    end
                    
                    local headPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        espText.Position = UDim2.new(0, headPos.X - 100, 0, headPos.Y - 30)
                        espText.Visible = true
                    else
                        espText.Visible = false
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

-- Tween to Base (vol vers la base)
local function TweenToBase()
    local basePos = Vector3.new(0, 20, 0) -- Remplace par les coordonnées de TA base
    local tweenInfo = TweenInfo.new(
        3, -- Durée
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = CFrame.new(basePos)})
    tween:Play()
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

-- Discord
local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "INFINITY HUB",
        Text = "Lien Discord copié !",
        Duration = 3
    })
end

-- Connexions
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
ESPBtn.MouseButton1Click:Connect(ToggleESP)
BaseBtn.MouseButton1Click:Connect(TweenToBase)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

-- Nettoyage
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        if AirPlatform then AirPlatform:Destroy() end
        ESPFolder:ClearAllChildren()
    end
end)

-- Mise à jour ESP
Players.PlayerAdded:Connect(UpdateESP)
Players.PlayerRemoving:Connect(UpdateESP)

print("✅ INFINITY HUB ULTIMATE ACTIVÉ")

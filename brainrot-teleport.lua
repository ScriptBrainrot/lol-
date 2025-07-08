--[[
  Infinity Hub - Design Premium
  Boutons ovalisés • Cadre noir parfait • Effets lisses
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150
local isFlying = false
local AirPlatform = nil

-- Création du sol
local function CreateSkyPlatform()
    if AirPlatform then return end
    AirPlatform = Instance.new("Part")
    AirPlatform.Size = Vector3.new(10000, 5, 10000)
    AirPlatform.Position = Vector3.new(0, FLY_HEIGHT, 0)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Parent = Workspace
end

-- UI Premium
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubPremium"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 200)
MainFrame.Position = UDim2.new(0.5, -110, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Titre
local Title = Instance.new("TextLabel")
Title.Text = "Infinity | Hub"
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0.1, 0, 0.05, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Fonction pour créer des boutons ovalisés
local function CreateRoundedButton(name, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 180, 0, 35) -- Plus compact
    button.Position = UDim2.new(0.1, 0, yPos, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = color
    button.Font = Enum.Font.GothamMedium
    
    -- Effet ovalisé
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12) -- Arrondi prononcé
    UICorner.Parent = button
    
    -- Effet hover
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.2
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0
    end)
    
    button.Parent = MainFrame
    return button
end

-- Boutons premium
local SkyBtn = CreateRoundedButton("SKY", 0.3, Color3.fromRGB(0, 120, 255))
local DownBtn = CreateRoundedButton("DOWN", 0.55, Color3.fromRGB(255, 60, 60))
local DiscordBtn = CreateRoundedButton("DISCORD", 0.8, Color3.fromRGB(114, 137, 218))

-- Fonctions
local function GoToSky()
    if isFlying then return end
    CreateSkyPlatform()
    isFlying = true
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
end

local function GoDown()
    if not isFlying then return end
    local rayResult = workspace:Raycast(
        Vector3.new(RootPart.Position.X, FLY_HEIGHT-2, RootPart.Position.Z),
        Vector3.new(0, -1000, 0),
        RaycastParams.new()
    )
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    isFlying = false
end

local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity Hub",
        Text = "Lien Discord copié !",
        Duration = 3
    })
end

-- Connexions
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

print("✅ Infinity Hub Premium - Design ovalisé activé")

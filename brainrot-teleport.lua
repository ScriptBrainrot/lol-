--[[
  INFINITY HUB - VERSION ULTIME
  Fonctionnalités:
  1. Bouton rond ∞ qui toggle le menu
  2. SKY: Téléporte à 150m avec plateforme invisible
  3. DOWN: Descente IMMÉDIATE et PRÉCISE au sol
  4. DISCORD: Copie le lien + notification
  5. Interface positionnée à droite
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local FLY_HEIGHT = 150
local isFlying = false
local AirPlatform = nil

-- Initialisation joueur
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Création de l'interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHub_Ultimate"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Bouton principal rond
local MainButton = Instance.new("TextButton")
MainButton.Name = "MainButton"
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Position = UDim2.new(1, -70, 0.5, -30)
MainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainButton.Text = "∞"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 24
MainButton.Font = Enum.Font.GothamBlack
MainButton.ZIndex = 2

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainButton

-- Fenêtre principale
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 200, 0, 150)
MainWindow.Position = UDim2.new(1, -210, 0.5, -75)
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainWindow.Visible = false

local Title = Instance.new("TextLabel")
Title.Text = "INFINITY HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Parent = MainWindow

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Parent = MainWindow

-- Boutons fonctionnels
local SkyBtn = Instance.new("TextButton")
SkyBtn.Text = "SKY"
SkyBtn.Size = UDim2.new(0.9, 0, 0, 30)
SkyBtn.Position = UDim2.new(0.05, 0, 0, 40)
SkyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
SkyBtn.Parent = MainWindow

local DownBtn = Instance.new("TextButton")
DownBtn.Text = "DOWN"
DownBtn.Size = UDim2.new(0.9, 0, 0, 30)
DownBtn.Position = UDim2.new(0.05, 0, 0, 80)
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DownBtn.Parent = MainWindow

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Text = "DISCORD"
DiscordBtn.Size = UDim2.new(0.9, 0, 0, 30)
DiscordBtn.Position = UDim2.new(0.05, 0, 0, 120)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
DiscordBtn.Parent = MainWindow

-- Arrondir les angles
for _, btn in pairs({SkyBtn, DownBtn, DiscordBtn}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
end

-- Fonctionnalités
local function GoToSky()
    if isFlying then return end
    
    -- Création plateforme invisible
    AirPlatform = Instance.new("Part")
    AirPlatform.Size = Vector3.new(1000, 5, 1000)
    AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT, RootPart.Position.Z)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Parent = Workspace
    
    -- Téléportation fluide
    local startPos = RootPart.Position
    local endPos = Vector3.new(RootPart.Position.X, FLY_HEIGHT + 5, RootPart.Position.Z)
    
    for i = 1, 30 do
        RootPart.CFrame = CFrame.new(startPos:Lerp(endPos, i/30))
        task.wait(0.01)
    end
    
    isFlying = true
end

local function GoDown()
    if not isFlying then return end
    
    -- Détection intelligente du sol
    local rayOrigin = RootPart.Position + Vector3.new(0, 50, 0)
    local rayDirection = Vector3.new(0, -1000, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Character}
    raycastParams.IgnoreWater = true
    
    local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    -- Téléportation garantie au sol
    if rayResult then
        local humanoidHeight = Humanoid.HipHeight
        RootPart.CFrame = CFrame.new(
            RootPart.Position.X,
            rayResult.Position.Y + humanoidHeight + 0.5,
            RootPart.Position.Z
        )
    else
        -- Position de secours
        RootPart.CFrame = CFrame.new(RootPart.Position.X, 5, RootPart.Position.Z)
    end
    
    -- Suppression plateforme
    if AirPlatform then
        AirPlatform:Destroy()
        AirPlatform = nil
    end
    
    isFlying = false
    Humanoid.Jump = true -- Petit effet visuel
end

local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "INFINITY HUB",
        Text = "Lien Discord copié!",
        Duration = 2,
        Icon = "rbxassetid://11240648136"
    })
end

-- Connexions
MainButton.MouseButton1Click:Connect(function()
    MainButton.Visible = false
    MainWindow.Visible = true
end)

CloseButton.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
    MainButton.Visible = true
end)

SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

-- Gestion respawn
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    
    if isFlying then
        task.wait(1)
        GoToSky()
    end
end)

-- Initialisation
MainButton.Parent = ScreenGui
MainWindow.Parent = ScreenGui

print("✅ INFINITY HUB PRÊT | BY ARBIX")

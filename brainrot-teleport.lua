--[[
  Infinity Hub - Version Ultime
  • Bouton rond ∞ toggle
  • Interface droite minimaliste
  • SKY: Téléportation à 150m avec plateforme invisible
  • DOWN: Descente immédiate et précise
  • DISCORD: Copie du lien
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150
local isFlying = false
local AirPlatform = nil

-- Création UI
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

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = Color3.fromRGB(255, 50, 50)

-- Boutons fonctionnels
local SkyBtn = Instance.new("TextButton")
SkyBtn.Text = "SKY"
SkyBtn.Size = UDim2.new(0.9, 0, 0, 30)
SkyBtn.Position = UDim2.new(0.05, 0, 0, 40)
SkyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)

local DownBtn = Instance.new("TextButton")
DownBtn.Text = "DOWN"
DownBtn.Size = UDim2.new(0.9, 0, 0, 30)
DownBtn.Position = UDim2.new(0.05, 0, 0, 80)
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Text = "DISCORD"
DiscordBtn.Size = UDim2.new(0.9, 0, 0, 30)
DiscordBtn.Position = UDim2.new(0.05, 0, 0, 120)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)

-- Ajout des éléments
Title.Parent = MainWindow
CloseButton.Parent = MainWindow
SkyBtn.Parent = MainWindow
DownBtn.Parent = MainWindow
DiscordBtn.Parent = MainWindow
MainButton.Parent = ScreenGui
MainWindow.Parent = ScreenGui

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
    AirPlatform.Parent = workspace
    
    -- Téléportation
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 5, RootPart.Position.Z)
    isFlying = true
end

local function GoDown()
    if not isFlying then return end
    
    -- Trouver le sol
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Character}
    
    local rayResult = workspace:Raycast(
        RootPart.Position + Vector3.new(0, 50, 0),
        Vector3.new(0, -10000, 0),
        raycastParams
    )
    
    -- Téléportation au sol
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 5, 0))
    else
        RootPart.CFrame = CFrame.new(RootPart.Position.X, 5, RootPart.Position.Z)
    end
    
    -- Nettoyage
    if AirPlatform then
        AirPlatform:Destroy()
        AirPlatform = nil
    end
    isFlying = false
end

local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "INFINITY HUB",
        Text = "Lien Discord copié!",
        Duration = 2
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
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    if isFlying then
        task.wait(1)
        GoToSky()
    end
end)

print("✅ INFINITY HUB PRÊT")

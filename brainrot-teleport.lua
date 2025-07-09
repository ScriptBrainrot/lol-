--[[
  Infinity Hub - Version Ultra Finale
  • Téléportation au ciel à 150m avec plateforme bleue
  • Descente IMMÉDIATE et SÛRE quand on clique sur DOWN
  • Bouton Discord fonctionnel
  • Interface propre et positionnée à droite
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150
local isFlying = false
local AirPlatform = nil

-- Création de l'UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubUltraFinal"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- 1. Bouton rond principal
local MainButton = Instance.new("TextButton")
MainButton.Name = "MainRoundButton"
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Position = UDim2.new(0.95, -30, 0.5, -30)
MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainButton.Text = "∞"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 20
MainButton.Font = Enum.Font.GothamBold

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainButton

-- 2. Fenêtre droite (cachée au départ)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 180, 0, 100)
MainWindow.Position = UDim2.new(0.85, -10, 0.5, -50)
MainWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainWindow.BackgroundTransparency = 0
MainWindow.BorderSizePixel = 0
MainWindow.Visible = false

-- Titre fenêtre
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "Infinity | Hub"
Title.Size = UDim2.new(0, 160, 0, 20)
Title.Position = UDim2.new(0.5, -80, 0.1, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainWindow

-- Bouton fermeture (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = MainWindow

-- Boutons fonctionnels (en ligne)
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(0, 160, 0, 60)
ButtonContainer.Position = UDim2.new(0.5, -80, 0.6, -30)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainWindow

local SkyBtn = Instance.new("TextButton")
SkyBtn.Name = "SKY"
SkyBtn.Size = UDim2.new(0.32, -2, 1, 0)
SkyBtn.Position = UDim2.new(0, 0, 0, 0)
SkyBtn.Text = "SKY"
SkyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SkyBtn.TextSize = 12
SkyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
SkyBtn.Font = Enum.Font.GothamMedium
SkyBtn.Parent = ButtonContainer

local DownBtn = Instance.new("TextButton")
DownBtn.Name = "DOWN"
DownBtn.Size = UDim2.new(0.32, -2, 1, 0)
DownBtn.Position = UDim2.new(0.34, 0, 0, 0)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.TextSize = 12
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DownBtn.Font = Enum.Font.GothamMedium
DownBtn.Parent = ButtonContainer

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Name = "DISCORD"
DiscordBtn.Size = UDim2.new(0.32, -2, 1, 0)
DiscordBtn.Position = UDim2.new(0.68, 0, 0, 0)
DiscordBtn.Text = "DISCORD"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 12
DiscordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
DiscordBtn.Font = Enum.Font.GothamMedium
DiscordBtn.Parent = ButtonContainer

-- Arrondir les boutons
local function AddCorner(parent)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = parent
end

AddCorner(SkyBtn)
AddCorner(DownBtn)
AddCorner(DiscordBtn)
AddCorner(MainButton)

-- Système de toggle
MainButton.MouseButton1Click:Connect(function()
    MainButton.Visible = false
    MainWindow.Visible = true
end)

CloseButton.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
    MainButton.Visible = true
end)

-- Système de vol ultra amélioré
local function GoToSky()
    if isFlying then return end
    
    -- Crée la plateforme bleue
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "InfinityFlightPlatform"
    AirPlatform.Size = Vector3.new(500, 5, 500)
    AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT, RootPart.Position.Z)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 0.7
    AirPlatform.Color = Color3.fromRGB(0, 150, 255)
    AirPlatform.Material = Enum.Material.Neon
    AirPlatform.CanCollide = true
    AirPlatform.Parent = workspace
    
    -- Téléportation directe
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 5, RootPart.Position.Z)
    isFlying = true
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity Hub",
        Text = "Vous êtes monté à 150m!",
        Duration = 2
    })
end

local function GoDown()
    if not isFlying then return end
    
    -- Détection ultra-précise du sol
    local rayOrigin = Vector3.new(RootPart.Position.X, 1000, RootPart.Position.Z)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    rayParams.IgnoreWater = true
    
    local rayResult = workspace:Raycast(rayOrigin, Vector3.new(0, -2000, 0), rayParams)
    
    if rayResult then
        -- Téléportation directe au sol trouvé
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    else
        -- Position de secours
        RootPart.CFrame = CFrame.new(RootPart.Position.X, 5, RootPart.Position.Z)
    end
    
    -- Destruction IMMÉDIATE de la plateforme
    if AirPlatform then
        AirPlatform:Destroy()
        AirPlatform = nil
    end
    
    isFlying = false
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity Hub",
        Text = "Vous êtes descendu au sol!",
        Duration = 2
    })
end

-- Fonction Discord
local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity Hub",
        Text = "Lien Discord copié!",
        Duration = 2,
        Icon = "rbxassetid://11240648136"
    })
end

-- Connexions des boutons
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

-- Gestion du respawn
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    
    if isFlying then
        wait(1) -- Attendre que le personnage soit chargé
        GoToSky() -- Recréer la plateforme
    end
end)

-- Initialisation
MainButton.Parent = ScreenGui
MainWindow.Parent = ScreenGui

print("✅ INFINITY HUB - Version Ultra Finale Chargée")

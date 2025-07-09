--[[
  Infinity Hub - Version Finale
  • Bouton rond • Fenêtre droite avec titre • Système toggle
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 100
local isFlying = false
local AirPlatform = nil

-- Création de l'UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubFinal"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- 1. Bouton rond principal
local MainButton = Instance.new("TextButton")
MainButton.Name = "MainRoundButton"
MainButton.Size = UDim2.new(0, 60, 0, 60) -- Taille réduite
MainButton.Position = UDim2.new(0.95, -30, 0.5, -30) -- Bord droit
MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainButton.Text = "∞" -- Symbole infinity
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 20
MainButton.Font = Enum.Font.GothamBold

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- Rond parfait
UICorner.Parent = MainButton

-- 2. Fenêtre droite (cachée au départ)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 180, 0, 100) -- Plus compacte
MainWindow.Position = UDim2.new(0.85, -10, 0.5, -50) -- Position droite
MainWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Noir
MainWindow.BackgroundTransparency = 0 -- Opaque
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

-- Système de vol PERMANENT
local function GoToSky()
    if isFlying then return end
    
    -- Crée une plateforme persistante
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "InfinityFlightPlatform"
    AirPlatform.Size = Vector3.new(500, 10, 500)
    AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT - 5, RootPart.Position.Z)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Parent = workspace
    
    -- Téléportation sécurisée
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
    isFlying = true
    
    -- Empêche la suppression
    AirPlatform:SetAttribute("Permanent", true)
end

local function GoDown()
    if not isFlying then return end
    
    -- Détection précise du sol
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
    end
    isFlying = false
end

-- Discord
local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity | Hub",
        Text = "Lien Discord copié !",
        Duration = 2
    })
end

-- Connexions
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

-- Nettoyage
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent and AirPlatform then
        AirPlatform:Destroy()
    end
end)

-- Initialisation
MainButton.Parent = ScreenGui
MainWindow.Parent = ScreenGui

print("✅ INFINITY HUB - Version Finale Chargée")

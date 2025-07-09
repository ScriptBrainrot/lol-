--[[
  Infinity Hub - Version Corrigée (Vol Infini)
  • Reste en hauteur indéfiniment
  • Anti-retour au sol intégré
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player:WaitForChild("CharacterAdded"):Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150 -- Hauteur de vol (augmentable)
local isFlying = false
local AirPlatform = nil
local FlightLoop = nil

-- Désactive les collisions pour éviter les problèmes
local function Noclip(active)
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not active
        end
    end
end

-- Crée une plateforme en l'air et maintient la position
local function GoToSky()
    if isFlying then return end
    isFlying = true

    -- Supprime l'ancienne plateforme si elle existe
    if AirPlatform then AirPlatform:Destroy() end

    -- Crée une nouvelle plateforme (invisible)
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "InfinityFlightPlatform"
    AirPlatform.Size = Vector3.new(500, 2, 500) -- Plus fine pour éviter les collisions
    AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT - 1, RootPart.Position.Z)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Parent = workspace

    -- Active le Noclip pour éviter les bugs
    Noclip(true)

    -- Téléporte le joueur en hauteur
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)

    -- Boucle de maintien en l'air (empêche le retour au sol)
    FlightLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if not isFlying or not RootPart or not AirPlatform then 
            FlightLoop:Disconnect()
            return 
        end

        -- Maintient la position en hauteur
        RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
        AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT - 1, RootPart.Position.Z)
    end)
end

-- Retour au sol
local function GoDown()
    if not isFlying then return end
    isFlying = false

    -- Désactive la boucle de vol
    if FlightLoop then FlightLoop:Disconnect() end

    -- Détruit la plateforme
    if AirPlatform then AirPlatform:Destroy() end

    -- Désactive le Noclip
    Noclip(false)

    -- Téléporte au sol
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Character}
    local rayResult = workspace:Raycast(RootPart.Position, Vector3.new(0, -1000, 0), raycastParams)

    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
end

-- UI (identique à votre version originale)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubFinal"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Bouton principal
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

-- Fenêtre droite
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 180, 0, 100)
MainWindow.Position = UDim2.new(0.85, -10, 0.5, -50)
MainWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainWindow.Visible = false

-- Titre
local Title = Instance.new("TextLabel")
Title.Text = "Infinity | Hub"
Title.Size = UDim2.new(0, 160, 0, 20)
Title.Position = UDim2.new(0.5, -80, 0.1, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainWindow

-- Boutons
local ButtonContainer = Instance.new("Frame")
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
SkyBtn.Parent = ButtonContainer

local DownBtn = Instance.new("TextButton")
DownBtn.Name = "DOWN"
DownBtn.Size = UDim2.new(0.32, -2, 1, 0)
DownBtn.Position = UDim2.new(0.34, 0, 0, 0)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.TextSize = 12
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DownBtn.Parent = ButtonContainer

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Name = "DISCORD"
DiscordBtn.Size = UDim2.new(0.32, -2, 1, 0)
DiscordBtn.Position = UDim2.new(0.68, 0, 0, 0)
DiscordBtn.Text = "DISCORD"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 12
DiscordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
DiscordBtn.Parent = ButtonContainer

-- Arrondir les boutons
for _, btn in ipairs({SkyBtn, DownBtn, DiscordBtn, MainButton}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
end

-- Toggle UI
MainButton.MouseButton1Click:Connect(function()
    MainButton.Visible = false
    MainWindow.Visible = true
end)

MainWindow:FindFirstChild("CloseButton").MouseButton1Click:Connect(function()
    MainWindow.Visible = false
    MainButton.Visible = true
end)

-- Actions des boutons
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity | Hub",
        Text = "Lien Discord copié !",
        Duration = 2
    })
end)

-- Nettoyage en cas de reset
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    if isFlying then GoToSky() end -- Re-active le vol si besoin
end)

MainButton.Parent = ScreenGui
MainWindow.Parent = ScreenGui

print("✅ Infinity Hub - Vol Infini Activé")

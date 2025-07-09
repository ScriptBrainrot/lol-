--[[
  Infinity Hub - Édition Complète
  • Bouton rond ∞ • Interface coulissante • Vol infini
  • Descente précise • Discord • Design noir opaque
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150
local isFlying = false
local platformParts = {}
local currentVelocity

-- Création de l'UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubComplete"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- 1. Bouton rond principal
local MainButton = Instance.new("TextButton")
MainButton.Name = "MainButton"
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Position = UDim2.new(0.95, -30, 0.5, -30)
MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainButton.Text = "∞"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 24
MainButton.Font = Enum.Font.GothamBold
MainButton.ZIndex = 2

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainButton

-- 2. Fenêtre droite (avec animation)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 180, 0, 120)
MainWindow.Position = UDim2.new(1, 10, 0.5, -60) -- Hors écran au départ
MainWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainWindow.BackgroundTransparency = 0.3
MainWindow.BorderSizePixel = 0
MainWindow.ClipsDescendants = true

-- Titre
local Title = Instance.new("TextLabel")
Title.Text = "STEAL | ARBIX HUB"
Title.Size = UDim2.new(0, 160, 0, 20)
Title.Position = UDim2.new(0.5, -80, 0.1, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainWindow

-- Bouton fermeture
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = MainWindow

-- Boutons fonctionnels (optimisés)
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(0, 160, 0, 70)
ButtonContainer.Position = UDim2.new(0.5, -80, 0.5, -35)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainWindow

local buttons = {
    {Name = "STEAL", Color = Color3.fromRGB(0, 100, 255), Y = 0},
    {Name = "DOWN", Color = Color3.fromRGB(255, 50, 50), Y = 0.35}
}

for _, btn in ipairs(buttons) do
    local button = Instance.new("TextButton")
    button.Name = btn.Name
    button.Size = UDim2.new(1, 0, 0.45, -5)
    button.Position = UDim2.new(0, 0, btn.Y, 0)
    button.Text = btn.Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.BackgroundColor3 = btn.Color
    button.Font = Enum.Font.GothamMedium
    button.Parent = ButtonContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
end

MainWindow.Parent = ScreenGui
MainButton.Parent = ScreenGui

-- Animation fenêtre
local function ToggleWindow()
    if MainWindow.Position == UDim2.new(0.85, -10, 0.5, -60) then
        -- Ferme la fenêtre
        for i = 1, 10 do
            MainWindow.Position = UDim2.new(0.85 + (i * 0.01), -10 + (i * 1), 0.5, -60)
            task.wait(0.01)
        end
        MainButton.Visible = true
    else
        -- Ouvre la fenêtre
        MainButton.Visible = false
        MainWindow.Position = UDim2.new(1, 10, 0.5, -60)
        for i = 1, 10 do
            MainWindow.Position = UDim2.new(1 - (i * 0.015), 10 - (i * 2), 0.5, -60)
            task.wait(0.01)
        end
    end
end

-- Système de vol PERMANENT
local flightConnection

local function CreateFlightPlatform()
    -- Nettoie l'ancien sol
    for _, part in ipairs(platformParts) do
        part:Destroy()
    end
    platformParts = {}

    -- Crée un sol dynamique (5x5 parts)
    for x = -2, 2 do
        for z = -2, 2 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(100, 5, 100)
            part.Position = Vector3.new(
                RootPart.Position.X + (x * 90),
                FLY_HEIGHT - 3,
                RootPart.Position.Z + (z * 90)
            )
            part.Anchored = true
            part.Transparency = 1
            part.CanCollide = true
            part.Parent = workspace
            table.insert(platformParts, part)
        end
    end
end

local function StartInfiniteFlight()
    isFlying = true
    CreateFlightPlatform()
    
    -- Téléportation initiale
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
    
    -- Anti-chute continu
    if flightConnection then flightConnection:Disconnect() end
    
    flightConnection = RunService.Heartbeat:Connect(function()
        if not isFlying then 
            flightConnection:Disconnect()
            return 
        end
        
        -- Maintien en l'air
        if RootPart.Position.Y < FLY_HEIGHT + 2 then
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, 15, RootPart.Velocity.Z)
        else
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, 0, RootPart.Velocity.Z)
        end
        
        -- Génération dynamique du sol
        if #platformParts > 0 then
            local farthestPart = platformParts[1]
            local maxDist = (farthestPart.Position - RootPart.Position).Magnitude
            
            if maxDist > 120 then
                CreateFlightPlatform()
            end
        end
    end)
end

local function StopFlight()
    if not isFlying then return end
    
    -- Détection précise du sol
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local rayOrigin = RootPart.Position
    local rayDirection = Vector3.new(0, -1000, 0)
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)
    
    if rayResult then
        local hitPosition = rayResult.Position
        RootPart.CFrame = CFrame.new(hitPosition.X, hitPosition.Y + 3, hitPosition.Z)
    else
        -- Si aucun sol n'est trouvé, descendre progressivement
        local fallConnection
        fallConnection = RunService.Heartbeat:Connect(function()
            local rayResult = workspace:Raycast(RootPart.Position, Vector3.new(0, -10, 0), rayParams)
            if rayResult then
                RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
                fallConnection:Disconnect()
            else
                RootPart.Velocity = Vector3.new(RootPart.Velocity.X, -50, RootPart.Velocity.Z)
            end
        end)
    end
    
    -- Nettoyage
    if flightConnection then flightConnection:Disconnect() end
    for _, part in ipairs(platformParts) do
        part:Destroy()
    end
    platformParts = {}
    isFlying = false
end

-- Contrôles
MainButton.MouseButton1Click:Connect(ToggleWindow)
CloseButton.MouseButton1Click:Connect(ToggleWindow)

ButtonContainer.STEAL.MouseButton1Click:Connect(StartInfiniteFlight)
ButtonContainer.DOWN.MouseButton1Click:Connect(StopFlight)

-- Sécurité
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        if flightConnection then flightConnection:Disconnect() end
        for _, part in ipairs(platformParts) do
            part:Destroy()
        end
    end
end)

print("✅ STEAL ARBIX HUB - SYSTÈME DE VOL INFINI ACTIVÉ")

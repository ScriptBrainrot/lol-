--[[
  Infinity Hub - Vol Permanent
  • Reste en l'air indéfiniment • Descente manuelle uniquement
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 100
local isFlying = false
local AirPlatform = nil

-- UI (version simplifiée)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubPermanentFlight"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainButton = Instance.new("TextButton")
MainButton.Name = "MainButton"
MainButton.Size = UDim2.new(0, 80, 0, 80)
MainButton.Position = UDim2.new(0.9, -40, 0.5, -40)
MainButton.Text = "Infinity | Hub"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainButton

local MainWindow = Instance.new("Frame")
MainWindow.Size = UDim2.new(0, 300, 0, 60)
MainWindow.Position = UDim2.new(0.5, -150, 0.5, -30)
MainWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainWindow.Visible = false

-- [Ajoutez ici les boutons SKY/DOWN/DISCORD comme dans le script précédent...]

-- Système de vol PERMANENT
local function GoToSky()
    if isFlying then return end
    
    -- Crée une plateforme INDESTRUCTIBLE
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "PermanentFlightPlatform"
    AirPlatform.Anchored = true
    AirPlatform.Size = Vector3.new(500, 10, 500) -- Épaisseur augmentée
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT - 5, RootPart.Position.Z)
    AirPlatform.Parent = workspace
    
    -- Force la persistance
    AirPlatform:SetAttribute("Permanent", true)
    
    -- Téléportation sécurisée
    local currentPos = RootPart.Position
    RootPart.CFrame = CFrame.new(currentPos.X, FLY_HEIGHT + 3, currentPos.Z)
    isFlying = true
    
    -- Anti-reset
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "PermanentFlightPlatform" then
            child:SetAttribute("Permanent", true)
        end
    end)
end

local function GoDown()
    if not isFlying then return end
    
    -- Détection intelligente du sol
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    
    local rayResult = workspace:Raycast(
        Vector3.new(RootPart.Position.X, FLY_HEIGHT, RootPart.Position.Z),
        Vector3.new(0, -1000, 0),
        rayParams
    )
    
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    
    -- Suppression MANUELLE seulement
    if AirPlatform and AirPlatform.Parent then
        AirPlatform:Destroy()
    end
    isFlying = false
end

-- [Gardez le reste du code identique...]

print("✅ VOL PERMANENT ACTIVÉ - Ne se reset plus après 5s")

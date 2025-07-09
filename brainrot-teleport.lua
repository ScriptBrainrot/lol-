--[[
  Infinity Hub - Vol Infini
  • Reste en l'air SANS limite de temps
  • Descente précise sous votre position
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150 -- Hauteur augmentée
local isFlying = false
local platformParts = {} -- Stocke toutes les parts du sol

-- Crée un sol infini à la volée
local function CreateInfinitePlatform()
    -- Nettoie l'ancien sol
    for _, part in ipairs(platformParts) do
        part:Destroy()
    end
    platformParts = {}

    -- Crée une grille de 3x3 parts (plus stable)
    for x = -1, 1 do
        for z = -1, 1 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(200, 5, 200)
            part.Position = Vector3.new(
                RootPart.Position.X + (x * 150),
                FLY_HEIGHT,
                RootPart.Position.Z + (z * 150)
            )
            part.Anchored = true
            part.Transparency = 1
            part.CanCollide = true
            part.Parent = workspace
            table.insert(platformParts, part)
        end
    end
end

-- Système de vol infini
local function EnableInfiniteFlight()
    CreateInfinitePlatform()
    
    -- Maintient en l'air même si le sol disparaît
    local flightLoop
    flightLoop = RunService.Heartbeat:Connect(function()
        if not isFlying then 
            flightLoop:Disconnect()
            return 
        end
        
        -- Anti-chute
        if RootPart.Position.Y < FLY_HEIGHT + 2 then
            RootPart.Velocity = Vector3.new(0, 10, 0)
        else
            RootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- UI (version simplifiée)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local SkyBtn = Instance.new("TextButton")
SkyBtn.Text = "SKY"
SkyBtn.Size = UDim2.new(0, 100, 0, 40)
SkyBtn.Position = UDim2.new(0.5, -50, 0.7, 0)
SkyBtn.Parent = ScreenGui

local DownBtn = Instance.new("TextButton")
DownBtn.Text = "DOWN"
DownBtn.Size = UDim2.new(0, 100, 0, 40)
DownBtn.Position = UDim2.new(0.5, -50, 0.8, 0)
DownBtn.Parent = ScreenGui

-- Contrôles
SkyBtn.MouseButton1Click:Connect(function()
    if isFlying then return end
    isFlying = true
    EnableInfiniteFlight()
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
end)

DownBtn.MouseButton1Click:Connect(function()
    if not isFlying then return end
    
    -- Trouve le sol DIRECTEMENT sous le joueur
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    
    local rayResult = workspace:Raycast(
        Vector3.new(RootPart.Position.X, FLY_HEIGHT + 50, RootPart.Position.Z),
        Vector3.new(0, -1000, 0),
        rayParams
    )
    
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    
    -- Nettoyage
    for _, part in ipairs(platformParts) do
        part:Destroy()
    end
    platformParts = {}
    isFlying = false
end)

-- Empêche le reset du personnage
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        for _, part in ipairs(platformParts) do
            part:Destroy()
        end
    end
end)

print("✅ SYSTEME DE VOL INFINI ACTIVÉ")

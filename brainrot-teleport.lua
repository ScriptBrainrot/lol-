--[[
  Steal a Brainrot - Mode Skywalk Illimité
  - Sol invisible géant et permanent
  - Pas de retour automatique au sol
  - Descente MANUALE uniquement via le bouton DOWN
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150 -- Hauteur augmentée à 150m
local isFlying = false
local AirPlatform = nil

-- Crée un sol géant INDESTRUCTIBLE
local function CreateSkyPlatform()
    if AirPlatform then return end -- Ne pas recréer si existe déjà
    
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "PermanentSkyPlatform"
    AirPlatform.Size = Vector3.new(10000, 5, 10000) -- Épaisseur augmentée à 5
    AirPlatform.Position = Vector3.new(0, FLY_HEIGHT, 0)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.CollisionGroup = "SkyPlatform" -- Groupe de collision perso
    AirPlatform.Parent = Workspace
    
    -- Force le sol à rester même si le joueur meurt
    AirPlatform:SetAttribute("Permanent", true)
end

-- Interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 120, 0, 80)
MainFrame.Position = UDim2.new(0.8, -60, 0.7, -40)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Parent = ScreenGui

local SkyBtn = Instance.new("TextButton")
SkyBtn.Size = UDim2.new(0, 100, 0, 30)
SkyBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
SkyBtn.Text = "SKY"
SkyBtn.TextColor3 = Color3.new(1, 1, 1)
SkyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
SkyBtn.Parent = MainFrame

local DownBtn = Instance.new("TextButton")
DownBtn.Size = UDim2.new(0, 100, 0, 30)
DownBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.new(1, 1, 1)
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DownBtn.Parent = MainFrame

-- Téléportation en l'air
local function GoToSky()
    if isFlying then return end
    
    CreateSkyPlatform()
    isFlying = true
    
    -- Téléporte en conservant la position X/Z
    local currentPos = RootPart.Position
    RootPart.CFrame = CFrame.new(
        currentPos.X, 
        FLY_HEIGHT + 3, -- +3 pour être au-dessus du sol
        currentPos.Z
    )
    
    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
end

-- Descente manuelle
local function GoDown()
    if not isFlying then return end
    
    local rayOrigin = Vector3.new(
        RootPart.Position.X,
        FLY_HEIGHT - 2,
        RootPart.Position.Z
    )
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    rayParams.CollisionGroup = "Default" -- Ignore le sol aérien
    
    local rayResult = Workspace:Raycast(rayOrigin, Vector3.new(0, -1000, 0), rayParams)
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    
    isFlying = false
end

-- Connexions boutons
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)

-- Anti-reset
workspace.ChildAdded:Connect(function(child)
    if child.Name == "PermanentSkyPlatform" then
        child:SetAttribute("Permanent", true)
    end
end)

print("✅ Mode Skywalk PERMANENT activé !")

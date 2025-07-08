--[[
  Steal a Brainrot ULTIMATE
  - Sol invisible géant en l'air
  - Téléportation stable
  - Hauteur réglable
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 100 -- Hauteur du sol aérien (augmentée à 100m)
local isFlying = false
local AirPlatform = nil

-- Crée un sol géant invisible
local function CreateSkyPlatform()
    if AirPlatform then AirPlatform:Destroy() end
    
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "BrainrotSkyPlatform"
    AirPlatform.Size = Vector3.new(10000, 2, 10000) -- Couvre toute la map
    AirPlatform.Position = Vector3.new(0, FLY_HEIGHT, 0)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Parent = Workspace
    
    -- Téléporte le joueur dessus
    local currentXZ = Vector3.new(RootPart.Position.X, 0, RootPart.Position.Z)
    RootPart.CFrame = CFrame.new(currentXZ + Vector3.new(0, FLY_HEIGHT + 3, 0))
end

-- Interface simplifiée
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

-- Système de téléportation
local function GoToSky()
    if isFlying then return end
    isFlying = true
    
    CreateSkyPlatform()
    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
end

local function GoDown()
    if not isFlying then return end
    
    -- Téléporte au sol sous ta position actuelle
    local rayOrigin = Vector3.new(RootPart.Position.X, FLY_HEIGHT - 2, RootPart.Position.Z)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character, AirPlatform}
    
    local rayResult = Workspace:Raycast(rayOrigin, Vector3.new(0, -1000, 0), rayParams)
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    
    if AirPlatform then AirPlatform:Destroy() end
    isFlying = false
end

-- Connexions
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)

-- Nettoyage
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent and AirPlatform then
        AirPlatform:Destroy()
        ScreenGui:Destroy()
    end
end)

print("✅ Mode 'Skywalk' activé - Hauteur: "..FLY_HEIGHT.."m")

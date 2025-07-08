--[[
  Steal a Brainrot - Marche dans le ciel
  - Bouton SKY : Crée un sol invisible à 50m de haut
  - Bouton DOWN : Téléporte directement sous toi
  - Déplacement libre en l'air
--]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 50 -- Hauteur du "sol" aérien
local isFlying = false
local AirPlatform = nil

-- Interface minimaliste
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 120, 0, 80)
MainFrame.Position = UDim2.new(0.8, -60, 0.7, -40)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
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

local function CreateAirPlatform()
    -- Supprime l'ancienne plateforme si elle existe
    if AirPlatform then AirPlatform:Destroy() end
    
    -- Crée un sol invisible
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "AirPlatform"
    AirPlatform.Size = Vector3.new(100, 2, 100)
    AirPlatform.Position = RootPart.Position + Vector3.new(0, -3, 0)
    AirPlatform.Transparency = 1
    AirPlatform.Anchored = true
    AirPlatform.CanCollide = true
    AirPlatform.Parent = workspace
    
    -- Téléporte le joueur dessus
    RootPart.CFrame = AirPlatform.CFrame + Vector3.new(0, 3, 0)
end

local function GoToSky()
    if isFlying then return end
    isFlying = true
    
    CreateAirPlatform()
    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
end

local function GoDown()
    if not isFlying then return end
    isFlying = false
    
    -- Trouve le sol sous le joueur
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character, AirPlatform}
    local rayResult = workspace:Raycast(
        Vector3.new(RootPart.Position.X, AirPlatform.Position.Y-50, RootPart.Position.Z),
        Vector3.new(0, -1000, 0),
        rayParams
    )
    
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    
    if AirPlatform then AirPlatform:Destroy() end
end

-- Connexion des boutons
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)

-- Nettoyage
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        if AirPlatform then AirPlatform:Destroy() end
        ScreenGui:Destroy()
    end
end)

print("✅ Steal a Brainrot - Mode 'Marche dans le ciel' activé!")

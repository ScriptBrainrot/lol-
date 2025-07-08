--[[
  Infinity Hub - Téléportation Aérienne
  Design: Fond noir opaque + Titre "Infinity | Hub"
  Boutons: SKY (bleu) / DOWN (rouge) / DISCORD (violet)
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150
local isFlying = false
local AirPlatform = nil

-- Création du sol permanent
local function CreateSkyPlatform()
    if AirPlatform then return end
    
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "InfinitySkyPlatform"
    AirPlatform.Size = Vector3.new(10000, 5, 10000)
    AirPlatform.Position = Vector3.new(0, FLY_HEIGHT, 0)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Parent = Workspace
end

-- Interface style "Infinity Hub"
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.5, -110, 0.05, 0) -- Haut de l'écran
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Noir opaque
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Titre "Infinity | Hub" (effet feutre)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0.1, 0, 0.05, 0)
Title.Text = "Infinity | Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Bouton SKY (bleu vif)
local SkyBtn = Instance.new("TextButton")
SkyBtn.Size = UDim2.new(0, 200, 0, 40)
SkyBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
SkyBtn.Text = "SKY"
SkyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SkyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SkyBtn.Parent = MainFrame

-- Bouton DOWN (rouge)
local DownBtn = Instance.new("TextButton")
DownBtn.Size = UDim2.new(0, 200, 0, 40)
DownBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
DownBtn.Parent = MainFrame

-- Bouton DISCORD (violet)
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0, 200, 0, 30)
DiscordBtn.Position = UDim2.new(0.1, 0, 0.8, 0)
DiscordBtn.Text = "JOIN DISCORD"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218) -- Couleur Discord
DiscordBtn.Parent = MainFrame

-- Fonctions de téléportation
local function GoToSky()
    if isFlying then return end
    
    CreateSkyPlatform()
    isFlying = true
    
    local currentPos = RootPart.Position
    RootPart.CFrame = CFrame.new(currentPos.X, FLY_HEIGHT + 3, currentPos.Z)
    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
end

local function GoDown()
    if not isFlying then return end
    
    local rayOrigin = Vector3.new(RootPart.Position.X, FLY_HEIGHT - 2, RootPart.Position.Z)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    
    local rayResult = Workspace:Raycast(rayOrigin, Vector3.new(0, -1000, 0), rayParams)
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    
    isFlying = false
end

-- Copie le lien Discord quand on clique
local function CopyDiscordLink()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity Hub",
        Text = "Lien Discord copié !",
        Duration = 3
    })
end

-- Connexions boutons
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
DiscordBtn.MouseButton1Click:Connect(CopyDiscordLink)

print("✅ Infinity Hub - Prêt à décoller !")

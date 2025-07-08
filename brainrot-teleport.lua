--[[
  Infinity Hub - Speed Edition
  • Vitesse réglable • Skywalk illimité • Design optimisé
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 100
local isFlying = false
local isSpeeding = false
local AirPlatform = nil
local NORMAL_SPEED = 16
local BOOST_SPEED = 50 -- Vitesse boostée

-- UI Optimisée
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubSpeed"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 150) -- Compact
MainFrame.Position = UDim2.new(0.5, -75, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Titre
local Title = Instance.new("TextLabel")
Title.Text = "INFINITY HUB"
Title.Size = UDim2.new(0, 130, 0, 20)
Title.Position = UDim2.new(0.1, 0, 0.05, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Boutons
local function CreateButton(name, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 130, 0, 25)
    button.Position = UDim2.new(0.1, 0, yPos, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.BackgroundColor3 = color
    button.Font = Enum.Font.GothamMedium
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = button
    
    button.Parent = MainFrame
    return button
end

local SkyBtn = CreateButton("SKY", 0.2, Color3.fromRGB(0, 100, 255))
local DownBtn = CreateButton("DOWN", 0.4, Color3.fromRGB(255, 50, 50))
local SpeedBtn = CreateButton("SPEED", 0.6, Color3.fromRGB(255, 150, 0)) -- Orange
local DiscordBtn = CreateButton("DISCORD", 0.8, Color3.fromRGB(114, 137, 218))

-- Système de vitesse
local function UpdateSpeed()
    Humanoid.WalkSpeed = isSpeeding and BOOST_SPEED or NORMAL_SPEED
    SpeedBtn.Text = isSpeeding and "SPEED ("..BOOST_SPEED..")" or "SPEED"
end

local function ToggleSpeed()
    isSpeeding = not isSpeeding
    UpdateSpeed()
end

-- Système de vol PERMANENT
local function CreatePermanentPlatform()
    if AirPlatform then return end
    
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "PermanentFlightPlatform"
    AirPlatform.Size = Vector3.new(500, 5, 500)
    AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT, RootPart.Position.Z)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Parent = Workspace
    
    -- Empêche la suppression automatique
    AirPlatform:SetAttribute("Permanent", true)
end

local function GoToSky()
    if isFlying then return end
    
    CreatePermanentPlatform()
    isFlying = true
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
end

local function GoDown()
    if not isFlying then return end
    
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
    
    isFlying = false
end

-- Discord
local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "INFINITY HUB",
        Text = "Lien Discord copié !",
        Duration = 3
    })
end

-- Connexions
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
SpeedBtn.MouseButton1Click:Connect(ToggleSpeed)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

-- Anti-reset
workspace.ChildAdded:Connect(function(child)
    if child.Name == "PermanentFlightPlatform" then
        child:SetAttribute("Permanent", true)
    end
end)

-- Reset vitesse à la mort
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        Humanoid.WalkSpeed = NORMAL_SPEED
        isSpeeding = false
    end
end)

print("✅ INFINITY HUB SPEED ACTIVÉ")

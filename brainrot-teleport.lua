--[[
  Infinity Hub ULTIMATE
  • Textes XXL • Speed supersonique • Design pro
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150
local isFlying = false
local isSpeeding = false
local AirPlatform = nil
local NORMAL_SPEED = 16
local GROUND_SPEED = 100 -- Vitesse normale avec speed
local FLY_SPEED = 250 -- Vitesse ULTRA RAPIDE en vol
local currentSpeed = NORMAL_SPEED

-- Création du sol
local function CreateSkyPlatform()
    if AirPlatform then return end
    AirPlatform = Instance.new("Part")
    AirPlatform.Size = Vector3.new(10000, 5, 10000)
    AirPlatform.Position = Vector3.new(0, FLY_HEIGHT, 0)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Parent = Workspace
end

-- UI Premium
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubULTIMATE"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 280) -- Légèrement agrandi
MainFrame.Position = UDim2.new(0.5, -125, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Titre (texte XXL)
local Title = Instance.new("TextLabel")
Title.Text = "INFINITY | HUB"
Title.Size = UDim2.new(0, 230, 0, 40)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20 -- Taille augmentée
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Fonction pour créer des boutons premium
local function CreateUltraButton(name, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 220, 0, 45) -- Boutons plus grands
    button.Position = UDim2.new(0.05, 0, yPos, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18 -- Texte agrandi
    button.BackgroundColor3 = color
    button.Font = Enum.Font.GothamBold -- Plus gras
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.1
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0
    end)
    
    button.Parent = MainFrame
    return button
end

-- Boutons ULTRA
local SkyBtn = CreateUltraButton("SKY", 0.2, Color3.fromRGB(0, 150, 255))
local DownBtn = CreateUltraButton("DOWN", 0.35, Color3.fromRGB(255, 80, 80))
local SpeedBtn = CreateUltraButton("SPEED", 0.5, Color3.fromRGB(255, 180, 0))
local DiscordBtn = CreateUltraButton("DISCORD", 0.65, Color3.fromRGB(114, 137, 218))

-- Gestion vitesse
local function UpdateSpeed()
    if isFlying then
        currentSpeed = isSpeeding and FLY_SPEED or GROUND_SPEED
    else
        currentSpeed = isSpeeding and GROUND_SPEED or NORMAL_SPEED
    end
    Humanoid.WalkSpeed = currentSpeed
    SpeedBtn.Text = isSpeeding and ("SPEED: "..currentSpeed) or "SPEED"
end

-- Fonctions
local function ToggleSpeed()
    isSpeeding = not isSpeeding
    UpdateSpeed()
end

local function GoToSky()
    if isFlying then return end
    CreateSkyPlatform()
    isFlying = true
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
    UpdateSpeed() -- Applique la vitesse vol
end

local function GoDown()
    if not isFlying then return end
    local rayResult = workspace:Raycast(
        Vector3.new(RootPart.Position.X, FLY_HEIGHT-2, RootPart.Position.Z),
        Vector3.new(0, -1000, 0),
        RaycastParams.new()
    )
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    isFlying = false
    UpdateSpeed() -- Réajuste la vitesse sol
end

local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "INFINITY HUB",
        Text = "Lien Discord copié !",
        Icon = "rbxassetid://11240628910",
        Duration = 3
    })
end

-- Connexions
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
SpeedBtn.MouseButton1Click:Connect(ToggleSpeed)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

-- Reset
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        Humanoid.WalkSpeed = NORMAL_SPEED
        isSpeeding = false
    end
end)

print("✅ INFINITY HUB ULTIMATE ACTIVÉ | Vitesse max: "..FLY_SPEED.." studs/s")

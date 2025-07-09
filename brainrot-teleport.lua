--[[
  Infinity Hub - Interface Avancée
  • Bouton rond avec image • Fenêtre déplaçable • Système de toggle
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 100
local isFlying = false
local AirPlatform = nil

-- Création de l'UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubAdvancedUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Bouton rond principal
local MainButton = Instance.new("ImageButton")
MainButton.Name = "MainRoundButton"
MainButton.Size = UDim2.new(0, 50, 0, 50)
MainButton.Position = UDim2.new(0.9, -25, 0.5, -25) -- Position par défaut
MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainButton.Image = "rbxassetid://14384092117" -- Remplace par ton imageID
MainButton.ScaleType = Enum.ScaleType.Crop

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- Rond parfait
UICorner.Parent = MainButton

-- Fenêtre principale (cachée au départ)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 130, 0, 150)
MainWindow.Position = UDim2.new(0.5, -65, 0.5, -75)
MainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainWindow.BackgroundTransparency = 0.2
MainWindow.BorderSizePixel = 0
MainWindow.Visible = false

-- Bouton de fermeture (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = MainWindow

-- Titre
local Title = Instance.new("TextLabel")
Title.Text = "INFINITY"
Title.Size = UDim2.new(0, 100, 0, 20)
Title.Position = UDim2.new(0.15, 0, 0.05, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainWindow

-- Boutons fonctionnels
local function CreateActionButton(name, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 110, 0, 30)
    button.Position = UDim2.new(0.1, 0, yPos, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.BackgroundColor3 = color
    button.Font = Enum.Font.GothamMedium
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.Parent = MainWindow
    return button
end

local SkyBtn = CreateActionButton("SKY", 0.25, Color3.fromRGB(0, 100, 255))
local DownBtn = CreateActionButton("DOWN", 0.55, Color3.fromRGB(255, 50, 50))
local DiscordBtn = CreateActionButton("DISCORD", 0.85, Color3.fromRGB(114, 137, 218))

-- Système de déplacement pour le bouton rond
local dragging = false
local dragStartPos
local buttonStartPos

MainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        buttonStartPos = MainButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        MainButton.Position = UDim2.new(
            buttonStartPos.X.Scale,
            buttonStartPos.X.Offset + delta.X,
            buttonStartPos.Y.Scale,
            buttonStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Toggle fenêtre
MainButton.MouseButton1Click:Connect(function()
    MainButton.Visible = false
    MainWindow.Visible = true
    MainWindow.Parent = ScreenGui
end)

CloseButton.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
    MainButton.Visible = true
end)

-- Système de vol
local function GoToSky()
    if isFlying then return end
    
    AirPlatform = Instance.new("Part")
    AirPlatform.Size = Vector3.new(300, 5, 300)
    AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT, RootPart.Position.Z)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.Parent = Workspace
    
    RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
    isFlying = true
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
    
    if AirPlatform then
        AirPlatform:Destroy()
        AirPlatform = nil
    end
    isFlying = false
end

-- Discord
local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "INFINITY",
        Text = "Lien Discord copié !",
        Duration = 2
    })
end

-- Connexions
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

-- Nettoyage
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent and AirPlatform then
        AirPlatform:Destroy()
    end
end)

-- Initialisation
MainButton.Parent = ScreenGui
MainWindow.Parent = ScreenGui

print("✅ INFINITY HUB - Interface Avancée Activée")

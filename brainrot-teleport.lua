--[[
  Infinity Hub - Design Final
  • Bouton rond "Infinity | Hub" • Interface compacte • Fond opaque
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
ScreenGui.Name = "InfinityHubFinalUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Bouton rond principal
local MainButton = Instance.new("TextButton") -- Changé en TextButton pour le texte
MainButton.Name = "MainRoundButton"
MainButton.Size = UDim2.new(0, 80, 0, 80) -- Taille augmentée
MainButton.Position = UDim2.new(0.9, -40, 0.5, -40)
MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainButton.Text = "Infinity | Hub"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 12
MainButton.Font = Enum.Font.GothamBold

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- Rond parfait
UICorner.Parent = MainButton

-- Fenêtre principale (cachée au départ)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 300, 0, 60) -- Plus large mais moins haute
MainWindow.Position = UDim2.new(0.5, -150, 0.5, -30)
MainWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Noir opaque
MainWindow.BackgroundTransparency = 0 -- Pas de transparence
MainWindow.BorderSizePixel = 0
MainWindow.Visible = false

-- Bouton de fermeture (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = MainWindow

-- Boutons en ligne (sans espace)
local SkyBtn = Instance.new("TextButton")
SkyBtn.Name = "SKY"
SkyBtn.Size = UDim2.new(0.33, -5, 1, -10)
SkyBtn.Position = UDim2.new(0, 5, 0.5, 0)
SkyBtn.AnchorPoint = Vector2.new(0, 0.5)
SkyBtn.Text = "SKY"
SkyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SkyBtn.TextSize = 14
SkyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
SkyBtn.Font = Enum.Font.GothamBold
SkyBtn.Parent = MainWindow

local DownBtn = Instance.new("TextButton")
DownBtn.Name = "DOWN"
DownBtn.Size = UDim2.new(0.33, -5, 1, -10)
DownBtn.Position = UDim2.new(0.33, 0, 0.5, 0)
DownBtn.AnchorPoint = Vector2.new(0, 0.5)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.TextSize = 14
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DownBtn.Font = Enum.Font.GothamBold
DownBtn.Parent = MainWindow

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Name = "DISCORD"
DiscordBtn.Size = UDim2.new(0.33, -5, 1, -10)
DiscordBtn.Position = UDim2.new(0.66, 0, 0.5, 0)
DiscordBtn.AnchorPoint = Vector2.new(0, 0.5)
DiscordBtn.Text = "DISCORD"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 14
DiscordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.Parent = MainWindow

-- Arrondis pour les boutons
local function AddCorner(parent)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = parent
end

AddCorner(SkyBtn)
AddCorner(DownBtn)
AddCorner(DiscordBtn)
AddCorner(MainWindow)

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
        Title = "Infinity | Hub",
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

print("✅ INFINITY | HUB - Design Final Activé")

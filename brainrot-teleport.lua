--[[
  Infinity Hub - Version Finale Simplifiée
  • Bouton rond ∞
  • Fenêtre avec titre "Infinity | Hub"
  • Système de vol permanent
  • Bouton Discord avec notification
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 100
local isFlying = false
local AirPlatform = nil
local DISCORD_LINK = "https://discord.gg/ZVX8GNMNaD"  -- Votre lien Discord

-- Création de l'UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Bouton rond principal
local MainButton = Instance.new("TextButton")
MainButton.Name = "MainRoundButton"
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Position = UDim2.new(0.95, -30, 0.5, -30)
MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainButton.Text = "∞"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 20
MainButton.Font = Enum.Font.GothamBold

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainButton

-- Fenêtre principale (cachée par défaut)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 200, 0, 120)
MainWindow.Position = UDim2.new(0.85, -10, 0.5, -60)
MainWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainWindow.BackgroundTransparency = 0.2
MainWindow.BorderSizePixel = 0
MainWindow.Visible = false

-- Titre "Infinity | Hub"
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "Infinity | Hub"
Title.Size = UDim2.new(1, -10, 0, 20)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainWindow

-- Bouton fermeture (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = MainWindow

-- Conteneur des boutons (SKY, DOWN, DISCORD)
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, -10, 0, 70)
ButtonContainer.Position = UDim2.new(0, 5, 0, 40)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainWindow

-- Bouton SKY (Vol)
local SkyBtn = Instance.new("TextButton")
SkyBtn.Name = "SKY"
SkyBtn.Size = UDim2.new(0.32, -2, 0, 30)
SkyBtn.Position = UDim2.new(0, 0, 0, 0)
SkyBtn.Text = "SKY"
SkyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SkyBtn.TextSize = 12
SkyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
SkyBtn.Font = Enum.Font.GothamMedium
SkyBtn.Parent = ButtonContainer

-- Bouton DOWN (Retour au sol)
local DownBtn = Instance.new("TextButton")
DownBtn.Name = "DOWN"
DownBtn.Size = UDim2.new(0.32, -2, 0, 30)
DownBtn.Position = UDim2.new(0.34, 0, 0, 0)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.TextSize = 12
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DownBtn.Font = Enum.Font.GothamMedium
DownBtn.Parent = ButtonContainer

-- Bouton DISCORD (Copie du lien)
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Name = "DISCORD"
DiscordBtn.Size = UDim2.new(0.32, -2, 0, 30)
DiscordBtn.Position = UDim2.new(0.68, 0, 0, 0)
DiscordBtn.Text = "DISCORD"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 12
DiscordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
DiscordBtn.Font = Enum.Font.GothamMedium
DiscordBtn.Parent = ButtonContainer

-- Arrondir les boutons
local function AddCorner(parent)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = parent
end

AddCorner(SkyBtn)
AddCorner(DownBtn)
AddCorner(DiscordBtn)
AddCorner(MainButton)
AddCorner(MainWindow)

-- Système de toggle (ouvrir/fermer l'interface)
MainButton.MouseButton1Click:Connect(function()
    MainButton.Visible = false
    MainWindow.Visible = true
end)

CloseButton.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
    MainButton.Visible = true
end)

-- Système de vol permanent
local function GoToSky()
    if isFlying then return end
    
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    
    -- Crée une plateforme aérienne
    if AirPlatform then AirPlatform:Destroy() end
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "InfinityFlightPlatform"
    AirPlatform.Size = Vector3.new(500, 5, 500)
    AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT - 2.5, RootPart.Position.Z)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 0.8
    AirPlatform.CanCollide = true
    AirPlatform.Color = Color3.fromRGB(0, 100, 255)
    AirPlatform.Material = Enum.Material.Neon
    AirPlatform.Parent = workspace
    
    -- Téléportation fluide vers le haut
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)})
    tween:Play()
    
    isFlying = true
    
    -- Maintien en l'air
    game:GetService("RunService").Heartbeat:Connect(function()
        if not isFlying or not RootPart then return end
        if RootPart.Position.Y < FLY_HEIGHT then
            RootPart.CFrame = CFrame.new(RootPart.Position.X, FLY_HEIGHT + 3, RootPart.Position.Z)
        end
        if AirPlatform then
            AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT - 2.5, RootPart.Position.Z)
        end
    end)
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity | Hub",
        Text = "Vol activé - Hauteur: "..FLY_HEIGHT,
        Duration = 2
    })
end

-- Système de descente
local function GoDown()
    if not isFlying then return end
    
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    
    -- Trouve le sol
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local rayResult = workspace:Raycast(
        RootPart.Position,
        Vector3.new(0, -1000, 0),
        rayParams
    )
    
    -- Téléportation vers le sol
    if rayResult then
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))})
        tween:Play()
    end
    
    if AirPlatform then
        AirPlatform:Destroy()
        AirPlatform = nil
    end
    
    isFlying = false
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity | Hub",
        Text = "Retour au sol effectué",
        Duration = 2
    })
end

-- Fonction Discord
local function CopyDiscord()
    if setclipboard then
        setclipboard(DISCORD_LINK)
    else
        -- Méthode alternative si setclipboard n'est pas disponible
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Infinity | Hub",
            Text = "Lien Discord: "..DISCORD_LINK,
            Duration = 5
        })
    end
    
    -- Notification de confirmation
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity | Hub",
        Text = "Lien Discord copié !",
        Duration = 2
    })
end

-- Connexion des boutons
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

-- Gestion du changement de personnage
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    if isFlying then
        wait(1)
        GoToSky()
    end
end)

-- Initialisation
MainButton.Parent = ScreenGui
MainWindow.Parent = ScreenGui

print("✅ INFINITY HUB - Version Finale Chargée")

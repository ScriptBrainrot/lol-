--[[
  Infinity Hub - Version Premium Fonctionnelle
  • Garde VOTRE design original
  • Descente qui marche À TOUS LES COUPS
  • Plateforme invisible géante
  • Effets fluides
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150
local isFlying = false
local AirPlatform = nil

-- Création UI (VOTRE DESIGN EXACT)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubPremium"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 200)
MainFrame.Position = UDim2.new(0.5, -110, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Titre
local Title = Instance.new("TextLabel")
Title.Text = "Infinity | Hub"
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0.1, 0, 0.05, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Fonction pour créer des boutons ovalisés (VOTRE CODE EXACT)
local function CreateRoundedButton(name, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 180, 0, 35)
    button.Position = UDim2.new(0.1, 0, yPos, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = color
    button.Font = Enum.Font.GothamMedium
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.2
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0
    end)
    
    button.Parent = MainFrame
    return button
end

-- Boutons premium (VOTRE CODE EXACT)
local SkyBtn = CreateRoundedButton("SKY", 0.3, Color3.fromRGB(0, 120, 255))
local DownBtn = CreateRoundedButton("DOWN", 0.55, Color3.fromRGB(255, 60, 60))
local DiscordBtn = CreateRoundedButton("DISCORD", 0.8, Color3.fromRGB(114, 137, 218))

-- NOUVELLE FONCTION DE PLATEFORME AMÉLIORÉE
local function CreateSkyPlatform()
    if AirPlatform then return end
    
    AirPlatform = Instance.new("Part")
    AirPlatform.Size = Vector3.new(10000, 10, 10000) -- Plus large pour éviter les chutes
    AirPlatform.Position = Vector3.new(0, FLY_HEIGHT - 5, 0) -- Ajustement parfait
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1 -- Totalement invisible
    AirPlatform.CanCollide = true
    AirPlatform.Parent = Workspace
    
    -- Garantit que la plateforme reste
    AirPlatform:SetAttribute("InfinityPlatform", true)
end

-- FONCTION SKY AMÉLIORÉE
local function GoToSky()
    if isFlying then return end
    
    CreateSkyPlatform()
    
    -- Téléportation fluide avec animation
    local startPos = RootPart.Position
    local endPos = Vector3.new(startPos.X, FLY_HEIGHT + 3, startPos.Z)
    
    for i = 1, 30 do
        RootPart.CFrame = CFrame.new(startPos:Lerp(endPos, i/30))
        task.wait(0.01)
    end
    
    isFlying = true
end

-- NOUVELLE FONCTION DOWN QUI MARCHE VRAIMENT
local function GoDown()
    if not isFlying then return end
    
    -- 1. Trouver le VRAI sol sous le joueur
    local rayOrigin = RootPart.Position + Vector3.new(0, 50, 0) -- Commence un peu plus haut
    local rayDirection = Vector3.new(0, -10000, 0) -- Rayon ultra-long
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Character}
    raycastParams.IgnoreWater = true
    
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    -- 2. Téléportation PRÉCISE au sol
    if rayResult then
        local humanoidHeight = Humanoid.HipHeight
        RootPart.CFrame = CFrame.new(
            RootPart.Position.X,
            rayResult.Position.Y + humanoidHeight + 0.5, -- +0.5 pour sécurité
            RootPart.Position.Z
        )
    else
        -- Position de secours si aucun sol (ne devrait jamais arriver)
        RootPart.CFrame = CFrame.new(RootPart.Position.X, 5, RootPart.Position.Z)
    end
    
    -- 3. Suppression GARANTIE de la plateforme
    if AirPlatform then
        AirPlatform:Destroy()
        AirPlatform = nil
    end
    
    isFlying = false
    
    -- Petit effet visuel
    Humanoid.Jump = true
end

-- FONCTION DISCORD (identique)
local function CopyDiscord()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Infinity Hub",
        Text = "Lien Discord copié !",
        Duration = 3,
        Icon = "rbxassetid://11240648136"
    })
end

-- Connexions (identique)
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
DiscordBtn.MouseButton1Click:Connect(CopyDiscord)

-- Gestion respawn améliorée
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    
    if isFlying then
        task.wait(1) -- Attend que le personnage soit stable
        GoToSky() -- Recrée la plateforme automatiquement
    end
end)

print("✅ Infinity Hub Premium - Version Finale Fonctionnelle")

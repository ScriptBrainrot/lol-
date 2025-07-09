-- Infinity | Hub - Script pour Delta
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = UILibrary.CreateLib("Infinity | Hub", "Sentinel")

-- Main Tab
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Teleportation")

-- Bouton Sky (ancien Steal)
MainSection:NewButton("Sky", "Téléporte au ciel avec plateforme", function()
    -- Téléportation à 150m
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    
    -- Création de la plateforme invisible
    local platform = Instance.new("Part")
    platform.Name = "InfinityHubPlatform"
    platform.Size = Vector3.new(100, 1, 100)
    platform.Transparency = 1
    platform.Anchored = true
    platform.CanCollide = true
    platform.Position = Vector3.new(0, 150, 0)
    platform.Parent = workspace
    
    -- Téléportation du joueur
    char:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(0, 155, 0)
    
    -- Message de confirmation
    game.StarterGui:SetCore("SendNotification", {
        Title = "Infinity | Hub",
        Text = "Vous avez été téléporté à 150m avec plateforme!",
        Duration = 5
    })
end)

-- Bouton Down (ancien Float)
MainSection:NewButton("Down", "Retour au sol", function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    
    -- Suppression de la plateforme si elle existe
    if workspace:FindFirstChild("InfinityHubPlatform") then
        workspace.InfinityHubPlatform:Destroy()
    end
    
    -- Téléportation au sol
    char:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(0, 5, 0)
    
    -- Message de confirmation
    game.StarterGui:SetCore("SendNotification", {
        Title = "Infinity | Hub",
        Text = "Vous êtes retourné au sol!",
        Duration = 5
    })
end)

-- Section Discord
local DiscordSection = MainTab:NewSection("Discord")
DiscordSection:NewButton("Discord", "Rejoignez notre serveur Discord", function()
    -- Copie du lien dans le presse-papier
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    
    -- Notification
    game.StarterGui:SetCore("SendNotification", {
        Title = "Infinity | Hub",
        Text = "Lien Discord copié!",
        Duration = 5
    })
end)

-- Positionnement de l'interface
local gui = game:GetService("CoreGui"):FindFirstChild("Kavo UI")
if gui then
    gui.Main.Size = UDim2.new(0, 350, 0, 400) -- Taille réduite
    gui.Main.Position = UDim2.new(1, -360, 0.5, -200) -- Position milieu droite
end

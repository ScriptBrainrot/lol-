--[[
  Infinity Hub - Skywalk Illimité
  Ajout : bouton Discord, bouton rond Wanted Scripts, X pour fermer
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 150
local isFlying = false
local AirPlatform = nil

-- Créer le sol aérien
local function CreateSkyPlatform()
    if AirPlatform then return end
    AirPlatform = Instance.new("Part")
    AirPlatform.Name = "PermanentSkyPlatform"
    AirPlatform.Size = Vector3.new(10000, 5, 10000)
    AirPlatform.Position = Vector3.new(0, FLY_HEIGHT, 0)
    AirPlatform.Anchored = true
    AirPlatform.Transparency = 1
    AirPlatform.CanCollide = true
    AirPlatform.CollisionGroup = "SkyPlatform"
    AirPlatform.Parent = Workspace
    AirPlatform:SetAttribute("Permanent", true)
end

-- GUI principale
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "InfinityHubGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 160)
Frame.Position = UDim2.new(0.05, 0, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "Infinity Hub"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextScaled = true

local Icon = Instance.new("ImageLabel", Frame)
Icon.Size = UDim2.new(0, 36, 0, 36)
Icon.Position = UDim2.new(0, 10, 0, 5)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://17497428354" -- Image ArBix

-- Bouton Start/Down
local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0.75, 0, 0.25, 0)
Button.Position = UDim2.new(0.125, 0, 0.45, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.Code
Button.TextScaled = true
Button.Text = "Start"
Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

-- Bouton Discord
local DiscordBtn = Instance.new("TextButton", Frame)
DiscordBtn.Size = UDim2.new(0.75, 0, 0.2, 0)
DiscordBtn.Position = UDim2.new(0.125, 0, 0.75, 0)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.TextColor3 = Color3.new(1, 1, 1)
DiscordBtn.Font = Enum.Font.Code
DiscordBtn.TextScaled = true
DiscordBtn.Text = "Rejoindre Discord"
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 6)

-- Fermeture avec X
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.Code
CloseBtn.TextScaled = true
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Bouton flottant Wanted Scripts
local FloatBtn = Instance.new("ImageButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 60, 0, 60)
FloatBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
FloatBtn.Image = "rbxassetid://17497432600" -- Image Wanted Scripts
FloatBtn.BackgroundTransparency = 1
FloatBtn.Visible = false
FloatBtn.Active = true
FloatBtn.Draggable = true

-- Actions
Button.MouseButton1Click:Connect(function()
    if not isFlying then
        CreateSkyPlatform()
        isFlying = true
        local pos = RootPart.Position
        RootPart.CFrame = CFrame.new(pos.X, FLY_HEIGHT + 3, pos.Z)
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        Button.Text = "Down"
    else
        local rayOrigin = Vector3.new(RootPart.Position.X, FLY_HEIGHT - 2, RootPart.Position.Z)
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {Character}
        rayParams.CollisionGroup = "Default"
        local rayResult = Workspace:Raycast(rayOrigin, Vector3.new(0, -1000, 0), rayParams)
        if rayResult then
            RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
        end
        isFlying = false
        Button.Text = "Start"
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/ZVX8GNMNaD")
    StarterGui:SetCore("SendNotification", {
        Title = "Infinity Hub",
        Text = "Lien Discord copié !",
        Duration = 5
    })
end)

CloseBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
    FloatBtn.Visible = true
end)

FloatBtn.MouseButton1Click:Connect(function()
    Frame.Visible = true
    FloatBtn.Visible = false
end)

-- Maintien du sol
workspace.ChildAdded:Connect(function(child)
    if child.Name == "PermanentSkyPlatform" then
        child:SetAttribute("Permanent", true)
    end
end)

print("✅ Infinity Hub chargé avec boutons Discord & Wanted Scripts.")

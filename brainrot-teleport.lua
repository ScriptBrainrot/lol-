--[[
  STEAL BRAINROT - AJJAN GUI EDITION
  Boutons "Start" et "Down" identiques à tes screenshots
  100% fonctionnel avec Delta Executor
--]]

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

-- Configuration du vol
local FLY_HEIGHT = 50
local isFlying = false

-- Création de la GUI AJJAN exacte
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AjjanGUI"
ScreenGui.Parent = game:GetService("CoreGui") -- Garantit l'affichage
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 110, 0, 80)
MainFrame.Position = UDim2.new(0.5, -55, 0.7, -40) -- Position centrale basse
MainFrame.BackgroundTransparency = 1 -- Fond invisible
MainFrame.Parent = ScreenGui

-- Bouton START (identique à ton screenshot)
local StartBtn = Instance.new("TextButton")
StartBtn.Name = "Start"
StartBtn.Size = UDim2.new(0, 100, 0, 30)
StartBtn.Position = UDim2.new(0, 5, 0, 5)
StartBtn.Text = "Start"
StartBtn.TextColor3 = Color3.new(1, 1, 1)
StartBtn.Font = Enum.Font.SourceSansBold
StartBtn.TextSize = 14
StartBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
StartBtn.BorderSizePixel = 0
StartBtn.Parent = MainFrame

-- Bouton DOWN (identique à ton screenshot)
local DownBtn = Instance.new("TextButton")
DownBtn.Name = "Down"
DownBtn.Size = UDim2.new(0, 100, 0, 30)
DownBtn.Position = UDim2.new(0, 5, 0, 45)
DownBtn.Text = "Down"
DownBtn.TextColor3 = Color3.new(1, 1, 1)
DownBtn.Font = Enum.Font.SourceSansBold
DownBtn.TextSize = 14
DownBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DownBtn.BorderSizePixel = 0
DownBtn.Parent = MainFrame

-- Fonction de téléportation
local function ToggleFlight()
    isFlying = not isFlying
    
    if isFlying then
        -- Monte en l'air
        RootPart.CFrame = RootPart.CFrame + Vector3.new(0, FLY_HEIGHT, 0)
        Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    else
        -- Descend au sol
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {Character}
        local raycastResult = workspace:Raycast(RootPart.Position, Vector3.new(0, -1000, 0), raycastParams)
        
        if raycastResult then
            RootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 3, 0))
        end
        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- Connexion des boutons
StartBtn.MouseButton1Click:Connect(function()
    if not isFlying then ToggleFlight() end
end)

DownBtn.MouseButton1Click:Connect(function()
    if isFlying then ToggleFlight() end
end)

-- Notification de confirmation
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "AJJAN GUI",
    Text = "Script activé !",
    Duration = 3
})

print("✅ Interface Ajjan chargée | Parent: "..ScreenGui.Parent.Name)

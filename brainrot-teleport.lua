--[[
  Steal a Brainrot - Version Optimisée
  Interface compacte + Mouvement fixé
--]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Joueur
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 50
local MOVE_SPEED = 100 -- Augmenté pour plus de réactivité
local isFlying = false
local flyConn

-- Interface compacte
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 100) -- Taille réduite
MainFrame.Position = UDim2.new(0.8, -75, 0.7, -50) -- Position en bas à droite
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local SkyBtn = Instance.new("TextButton")
SkyBtn.Size = UDim2.new(0, 130, 0, 40)
SkyBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
SkyBtn.Text = "SKY"
SkyBtn.TextColor3 = Color3.new(1, 1, 1)
SkyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
SkyBtn.Parent = MainFrame

local DownBtn = Instance.new("TextButton")
DownBtn.Size = UDim2.new(0, 130, 0, 40)
DownBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.new(1, 1, 1)
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DownBtn.Parent = MainFrame

-- Système de vol optimisé
local function StartFlying()
    if isFlying then return end
    isFlying = true
    
    -- Téléportation initiale
    RootPart.CFrame = RootPart.CFrame + Vector3.new(0, FLY_HEIGHT, 0)
    Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    
    -- Mouvement fluide
    flyConn = RunService.Heartbeat:Connect(function()
        if not isFlying then return end
        
        local moveDir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir - RootPart.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + RootPart.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - RootPart.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + RootPart.CFrame.RightVector end
        
        moveDir = moveDir.Unit * MOVE_SPEED
        RootPart.Velocity = Vector3.new(moveDir.X, 0, moveDir.Z) -- Bloque les mouvements verticaux
    end)
end

local function StopFlying()
    if not isFlying then return end
    isFlying = false
    
    if flyConn then flyConn:Disconnect() end
    
    -- Descente contrôlée
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    local rayResult = workspace:Raycast(RootPart.Position, Vector3.new(0, -1000, 0), rayParams)
    
    if rayResult then
        RootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    end
    
    RootPart.Velocity = Vector3.new()
    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

-- Boutons
SkyBtn.MouseButton1Click:Connect(StartFlying)
DownBtn.MouseButton1Click:Connect(StopFlying)

-- Nettoyage
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        isFlying = false
        if flyConn then flyConn:Disconnect() end
        ScreenGui:Destroy()
    end
end)

print("✅ Steal a Brainrot - Prêt !")

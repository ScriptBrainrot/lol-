--[[
  Steal Brainrot GUI - Version Ultime
  Téléportation en l'air + Mouvement libre
  Compatible Delta/Synapse/Krnl
--]]

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Joueur et Character
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 50
local MOVE_SPEED = 50
local isFlying = false

-- Création de la GUI (garantie visible)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotGUI_V2"
ScreenGui.Parent = game:GetService("CoreGui") -- Essentiel !
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.5, -100, 0.8, -60) -- Position basse pour éviter les conflits
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0, 180, 0, 50)
StartBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
StartBtn.Text = "MONTER (START)"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
StartBtn.Parent = Frame

local DownBtn = Instance.new("TextButton")
DownBtn.Size = UDim2.new(0, 180, 0, 50)
DownBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
DownBtn.Text = "DESCENDRE (DOWN)"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
DownBtn.Parent = Frame

-- Fonction de vol
local function ToggleFlight()
    isFlying = not isFlying
    
    if isFlying then
        -- Monter en l'air
        RootPart.CFrame = RootPart.CFrame + Vector3.new(0, FLY_HEIGHT, 0)
        Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        
        -- Contrôles W/A/S/D
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not isFlying then conn:Disconnect() return end
            
            local moveDir = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += RootPart.CFrame.LookVector * -1 end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir += RootPart.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir += RootPart.CFrame.RightVector * -1 end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += RootPart.CFrame.RightVector end
            
            RootPart.Velocity = moveDir * MOVE_SPEED
        end)
    else
        -- Descendre
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {Character}
        local raycastResult = workspace:Raycast(RootPart.Position, Vector3.new(0, -1000, 0), raycastParams)
        
        if raycastResult then
            RootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 3, 0))
        end
        RootPart.Velocity = Vector3.new()
        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- Connexion des boutons
StartBtn.MouseButton1Click:Connect(ToggleFlight)
DownBtn.MouseButton1Click:Connect(ToggleFlight)

-- Debug
print("✅ Script chargé | GUI parent: "..tostring(ScreenGui.Parent))

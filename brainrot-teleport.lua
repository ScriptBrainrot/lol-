--[[
  Steal a Brainrot - Téléportation Aérienne
  Interface personnalisée avec boutons "Sky" (bleu) et "Down" (rouge)
  Compatible Delta/Krnl/Synapse
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

-- Création de l'interface (style Arbix Hub modifié)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Fond noir
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 180, 0, 30)
Title.Position = UDim2.new(0.1, 0, 0.05, 0)
Title.Text = "Steal a Brainrot"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local SkyBtn = Instance.new("TextButton")
SkyBtn.Size = UDim2.new(0, 180, 0, 50)
SkyBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
SkyBtn.Text = "SKY"
SkyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SkyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255) -- Bleu
SkyBtn.Parent = MainFrame

local DownBtn = Instance.new("TextButton")
DownBtn.Size = UDim2.new(0, 180, 0, 50)
DownBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Rouge
DownBtn.Parent = MainFrame

-- Fonction de téléportation aérienne
local function ToggleFlight()
    isFlying = not isFlying
    
    if isFlying then
        -- Monter en l'air
        RootPart.CFrame = RootPart.CFrame + Vector3.new(0, FLY_HEIGHT, 0)
        Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        
        -- Contrôles de mouvement
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not isFlying then 
                conn:Disconnect() 
                return 
            end
            
            local moveDir = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += RootPart.CFrame.LookVector * -1 end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir += RootPart.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir += RootPart.CFrame.RightVector * -1 end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += RootPart.CFrame.RightVector end
            
            RootPart.Velocity = moveDir * MOVE_SPEED
        end)
    else
        -- Descendre au sol
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
SkyBtn.MouseButton1Click:Connect(ToggleFlight)
DownBtn.MouseButton1Click:Connect(ToggleFlight)

-- Nettoyage si le joueur meurt
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        isFlying = false
        ScreenGui:Destroy()
    end
end)

print("✅ Steal a Brainrot activé !")

--[[
   Script "Steal Brainrot" pour Delta Executor
   Bouton Start : Téléporte en l'air et active le mouvement libre.
   Bouton Down : Revient au sol.
   Protections anti-détection intégrées.
--]]

local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local RootPart = Char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuration
local FlyHeight = 50 -- Hauteur de vol (ajuste si besoin)
local MoveSpeed = 50 -- Vitesse de déplacement en l'air
local MaxDistance = 150 -- Distance max avant blocage (anti-détection)

-- Variables
local Flying = false
local FlyVelocity = Instance.new("BodyVelocity")
FlyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

-- Création de l'interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundTransparency = 0.5
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(0, 80, 0, 30)
StartButton.Position = UDim2.new(0.1, 0, 0.2, 0)
StartButton.Text = "Start"
StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
StartButton.Parent = Frame

local DownButton = Instance.new("TextButton")
DownButton.Size = UDim2.new(0, 80, 0, 30)
DownButton.Position = UDim2.new(0.1, 0, 0.6, 0)
DownButton.Text = "Down"
DownButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
DownButton.Parent = Frame

-- Fonction pour vérifier les limites
local function IsPositionAllowed(position)
    local basePosition = workspace.Baseplate.Position -- Remplace "Baseplate" par le nom de ta base si nécessaire
    return (position - basePosition).Magnitude <= MaxDistance
end

-- Fonction pour activer le vol
local function StartFlying()
    if Flying then return end
    Flying = true
    Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    RootPart.Anchored = false
    FlyVelocity.Parent = RootPart

    -- Téléportation initiale en l'air
    local startPos = RootPart.Position + Vector3.new(0, FlyHeight, 0)
    if IsPositionAllowed(startPos) then
        RootPart.CFrame = CFrame.new(startPos)
    end

    -- Contrôles de vol
    local moveConnection
    moveConnection = RunService.Heartbeat:Connect(function()
        if not Flying then 
            moveConnection:Disconnect()
            return 
        end

        local moveDir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 0, -1) end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, 1) end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-1, 0, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1, 0, 0) end

        moveDir = moveDir.Unit * MoveSpeed
        local newPos = RootPart.Position + moveDir

        if IsPositionAllowed(newPos) then
            FlyVelocity.Velocity = moveDir
        else
            FlyVelocity.Velocity = Vector3.new() -- Bloque le mouvement
        end
    end)
end

-- Fonction pour descendre
local function StopFlying()
    if not Flying then return end
    Flying = false
    FlyVelocity.Parent = nil
    RootPart.Anchored = true
    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

    -- Téléportation au sol
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Char}
    local raycastResult = workspace:Raycast(RootPart.Position, Vector3.new(0, -1000, 0), raycastParams)
    if raycastResult then
        RootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 3, 0)) -- +3 pour éviter de rester coincé
    end
end

-- Boutons
StartButton.MouseButton1Click:Connect(StartFlying)
DownButton.MouseButton1Click:Connect(StopFlying)

-- Désactivation si le joueur meurt
Char:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Char.Parent then
        Flying = false
        FlyVelocity:Destroy()
        ScreenGui:Destroy()
    end
end)
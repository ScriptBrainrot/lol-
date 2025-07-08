--[[
  Infinity Hub Mini
  • Interface 150x180 • Infinite Jump • ESP • Design optimisé
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local FLY_HEIGHT = 100
local isFlying = false
local infiniteJump = false
local espEnabled = false
local AirPlatform = nil
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Items"
ESPFolder.Parent = game.CoreGui

-- UI Mini (150x180)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHubMini"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 180) -- Très compact
MainFrame.Position = UDim2.new(0.5, -75, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Titre mini
local Title = Instance.new("TextLabel")
Title.Text = "INFINITY"
Title.Size = UDim2.new(0, 130, 0, 20)
Title.Position = UDim2.new(0.1, 0, 0.02, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14 -- Texte compact mais lisible
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Boutons mini (texte size 12)
local function CreateMiniButton(name, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 130, 0, 25) -- Boutons très compacts
    button.Position = UDim2.new(0.1, 0, yPos, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12 -- Texte réduit mais visible
    button.BackgroundColor3 = color
    button.Font = Enum.Font.GothamMedium
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = button
    
    button.Parent = MainFrame
    return button
end

-- Boutons principaux
local SkyBtn = CreateMiniButton("SKY", 0.15, Color3.fromRGB(0, 100, 255))
local DownBtn = CreateMiniButton("DOWN", 0.3, Color3.fromRGB(255, 50, 50))
local JumpBtn = CreateMiniButton("INF JUMP", 0.45, Color3.fromRGB(255, 150, 0)) -- Orange
local ESPBtn = CreateMiniButton("ESP", 0.6, Color3.fromRGB(0, 200, 100)) -- Vert
local BaseBtn = CreateMiniButton("BASE", 0.75, Color3.fromRGB(100, 100, 255)) -- Bleu clair

-- Infinite Jump
local function ToggleInfiniteJump()
    infiniteJump = not infiniteJump
    JumpBtn.Text = infiniteJump and "INF JUMP (ON)" or "INF JUMP"
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if infiniteJump and input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ESP des joueurs
local function UpdateESP()
    ESPFolder:ClearAllChildren()
    
    if not espEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            
            if head then
                local espText = Instance.new("TextLabel")
                espText.Name = player.Name.."_ESP"
                espText.Text = player.Name
                espText.Size = UDim2.new(0, 100, 0, 30)
                espText.Position = UDim2.new(0, 0, 0, 0)
                espText.BackgroundTransparency = 1
                espText.TextColor3 = Color3.new(1, 1, 1)
                espText.TextStrokeTransparency = 0
                espText.Parent = ESPFolder
                
                local conn
                conn = game:GetService("RunService").RenderStepped:Connect(function()
                    if not char or not char.Parent then
                        conn:Disconnect()
                        return
                    end
                    
                    local headPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        espText.Position = UDim2.new(0, headPos.X, 0, headPos.Y - 40)
                        espText.Visible = true
                    else
                        espText.Visible = false
                    end
                end)
            end
        end
    end
end

local function ToggleESP()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "ESP (ON)" or "ESP"
    UpdateESP()
end

-- Téléportations
local function GoToSky()
    if isFlying then return end
    
    if not AirPlatform then
        AirPlatform = Instance.new("Part")
        AirPlatform.Size = Vector3.new(300, 5, 300)
        AirPlatform.Position = Vector3.new(RootPart.Position.X, FLY_HEIGHT, RootPart.Position.Z)
        AirPlatform.Anchored = true
        AirPlatform.Transparency = 1
        AirPlatform.CanCollide = true
        AirPlatform.Parent = Workspace
    end
    
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

local function GoToBase()
    local basePos = Vector3.new(0, 0, 0) -- Remplace par les coordonnées de ta base
    RootPart.CFrame = CFrame.new(basePos + Vector3.new(0, 3, 0))
end

-- Connexions
SkyBtn.MouseButton1Click:Connect(GoToSky)
DownBtn.MouseButton1Click:Connect(GoDown)
JumpBtn.MouseButton1Click:Connect(ToggleInfiniteJump)
ESPBtn.MouseButton1Click:Connect(ToggleESP)
BaseBtn.MouseButton1Click:Connect(GoToBase)

-- Cleanup
Character:GetPropertyChangedSignal("Parent"):Connect(function()
    if not Character.Parent then
        if AirPlatform then AirPlatform:Destroy() end
        ESPFolder:ClearAllChildren()
    end
end)

Players.PlayerRemoving:Connect(UpdateESP)
Players.PlayerAdded:Connect(UpdateESP)

print("✅ INFINITY HUB MINI ACTIVÉ")

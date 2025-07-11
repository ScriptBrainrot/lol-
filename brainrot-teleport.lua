--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--// UI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ArbixAutoSteal"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 100)
Frame.Position = UDim2.new(0.7, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Name = "MainFrame"
Frame.Active = true
Frame.Draggable = true -- rend le cadre déplaçable

-- // DRAG SUPPORT (mobile + PC)
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	if dragging then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput then
		updateDrag(input)
	end
end)

--// Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "⚡ Arbix Hub | Auto Steal"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true

--// Steal Button
local StealButton = Instance.new("TextButton", Frame)
StealButton.Size = UDim2.new(0.9, 0, 0.45, 0)
StealButton.Position = UDim2.new(0.05, 0, 0.5, 0)
StealButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
StealButton.Text = "⭐ Start Auto Steal"
StealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StealButton.Font = Enum.Font.SourceSansBold
StealButton.TextScaled = true
StealButton.Name = "StealButton"
StealButton.BorderSizePixel = 0

--// Notify
local function NotifySuccess()
    StealButton.Text = "✅ Success!"
    wait(2)
    StealButton.Text = "⭐ Start Auto Steal"
end

--// Get Base Button
local function GetCollectZone()
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("Owner") and model.Owner:IsA("StringValue") then
            if model.Owner.Value == LocalPlayer.Name then
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("BasePart") and string.find(string.lower(part.Name), "collect") then
                        return part
                    end
                end
            end
        end
    end
    return nil
end

--// Teleport to Zone
local function TeleportToCollectZone()
    local zone = GetCollectZone()
    if zone and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(zone.Position + Vector3.new(0, 3, 0))
    end
end

--// Auto Steal Logic
local function AutoSteal()
    StealButton.Text = "⏳ Stealing..."
    local success = false

    for i = 1, 30 do
        TeleportToCollectZone()
        wait(0.2)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            if pos and Workspace:FindFirstChild(LocalPlayer.Name .. "'s Base") == nil then
                success = true
                break
            end
        end
    end

    if success then
        NotifySuccess()
    else
        StealButton.Text = "⭐ Start Auto Steal"
    end
end

--// Button Click
StealButton.MouseButton1Click:Connect(function()
    AutoSteal()
end)

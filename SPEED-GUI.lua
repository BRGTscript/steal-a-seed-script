local coreGui = game:GetService("CoreGui")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local player = players.LocalPlayer


if coreGui:FindFirstChild("KyleSpeedGui") then
    coreGui.KyleSpeedGui:Destroy()
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KyleSpeedGui"
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false


local function makeDraggable(topBar, frame)
    local dragging, dragInput, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    userInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end


local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 10, 15)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(150, 40, 50)
mainFrame.Parent = screenGui


local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 26)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 12, 18)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
makeDraggable(titleBar, mainFrame)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Position = UDim2.new(0, 6, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SPEED CONTROLLER"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 9
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar


local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -23, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 40)
closeBtn.BackgroundTransparency = 0.1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 9
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)


local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.85, 0, 0, 28)
speedBox.Position = UDim2.new(0.075, 0, 0, 38)
speedBox.BackgroundColor3 = Color3.fromRGB(45, 15, 22)
speedBox.BackgroundTransparency = 0.1
speedBox.PlaceholderText = "Enter speed (e.g. 1000)"
speedBox.Text = ""
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
speedBox.TextSize = 10
speedBox.Font = Enum.Font.SourceSans
speedBox.BorderSizePixel = 1
speedBox.BorderColor3 = Color3.fromRGB(120, 30, 40)
speedBox.Parent = mainFrame


local setBtn = Instance.new("TextButton")
setBtn.Size = UDim2.new(0.85, 0, 0, 30)
setBtn.Position = UDim2.new(0.075, 0, 0, 78)
setBtn.BackgroundColor3 = Color3.fromRGB(120, 25, 35)
setBtn.BackgroundTransparency = 0.1
setBtn.Text = "SET SPEED"
setBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setBtn.TextSize = 10
setBtn.Font = Enum.Font.SourceSansBold
setBtn.BorderSizePixel = 1
setBtn.BorderColor3 = Color3.fromRGB(190, 50, 60)
setBtn.Parent = mainFrame


local targetSpeed = 16

setBtn.MouseButton1Click:Connect(function()
    local num = tonumber(speedBox.Text)
    if num then
        targetSpeed = num
    end
end)

runService.Stepped:Connect(function()
    pcall(function()
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = targetSpeed
        end
    end)
end)

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local player = players.LocalPlayer


if coreGui:FindFirstChild("KyleFollowGui") then
    coreGui.KyleFollowGui:Destroy()
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KyleFollowGui"
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
mainFrame.Size = UDim2.new(0, 200, 0, 220)
mainFrame.Position = UDim2.new(0.5, -100, 0.4, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 10, 15)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(150, 40, 50)
mainFrame.Parent = screenGui


local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 12, 18)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
makeDraggable(titleBar, mainFrame)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -24, 1, 0)
titleLabel.Position = UDim2.new(0, 6, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "PLAYER TARGET LIST"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 9
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar


local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -22, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 40)
closeBtn.BackgroundTransparency = 0.1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 9
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)


local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -34)
scrollingFrame.Position = UDim2.new(0, 5, 0, 28)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.Parent = mainFrame

local uiLayout = Instance.new("UIListLayout")
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 4)
uiLayout.Parent = scrollingFrame

uiLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiLayout.AbsoluteContentSize.Y + 5)
end)


local followingTarget = nil
local followConnection = nil

local function stopFollowing()
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    followingTarget = nil
end

local function startFollowing(targetPlayer, btnTextLabel)
    if followingTarget == targetPlayer then
        
        stopFollowing()
        btnTextLabel.Text = "FOLLOW BACK PLAYER"
        return
    end
    
    
    stopFollowing()
    followingTarget = targetPlayer
    btnTextLabel.Text = "STOP FOLLOWING TARGET"
    
    followConnection = runService.Stepped:Connect(function()
        pcall(function()
            if not followingTarget or not followingTarget.Character or not followingTarget.Character:FindFirstChild("HumanoidRootPart") then
                stopFollowing()
                btnTextLabel.Text = "FOLLOW BACK PLAYER"
                return
            end
            
            local myChar = player.Character
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
            
            local myRoot = myChar.HumanoidRootPart
            local targetRoot = followingTarget.Character.HumanoidRootPart
            
            
            local targetCFrame = targetRoot.CFrame
            local behindCFrame = targetCFrame * CFrame.new(0, 0, 3.5)
            
            myRoot.CFrame = behindCFrame
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
    end)
end


local function refreshPlayerList()
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= player then
            
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -4, 0, 30)
            pBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 22)
            pBtn.BackgroundTransparency = 0.2
            pBtn.Text = ""
            pBtn.BorderSizePixel = 1
            pBtn.BorderColor3 = Color3.fromRGB(110, 30, 40)
            pBtn.Parent = scrollingFrame
            
            
            local avatarImg = Instance.new("ImageLabel")
            avatarImg.Size = UDim2.new(0, 24, 0, 24)
            avatarImg.Position = UDim2.new(0, 3, 0.5, -12)
            avatarImg.BackgroundTransparency = 1
            local content, isReady = players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            avatarImg.Image = content
            avatarImg.Parent = pBtn
            
            
            local btnText = Instance.new("TextLabel")
            btnText.Size = UDim2.new(1, -32, 1, 0)
            btnText.Position = UDim2.new(0, 30, 0, 0)
            btnText.BackgroundTransparency = 1
            btnText.Text = p.Name
            btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
            btnText.TextSize = 8
            btnText.Font = Enum.Font.SourceSansBold
            btnText.TextXAlignment = Enum.TextXAlignment.Left
            btnText.Parent = pBtn
            
            
            pBtn.MouseButton1Click:Connect(function()
                startFollowing(p, btnText)
            end)
        end
    end
end

refreshPlayerList()

players.PlayerAdded:Connect(refreshPlayerList)
players.PlayerRemoving:Connect(refreshPlayerList)

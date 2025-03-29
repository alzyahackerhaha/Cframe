-- TPWalk Script with Space Background and TextBox input
-- Includes the TPWalk functionality with textbox for speed control

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local tpWalkEnabled = false
local tpWalkSpeed = 150
local isSprinting = false
local sprintMultiplier = 1.5

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TPWalkGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.85, -110, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Space Background
local SpaceBackground = Instance.new("ImageLabel")
SpaceBackground.Name = "SpaceBackground"
SpaceBackground.Size = UDim2.new(1, 0, 1, 0)
SpaceBackground.BackgroundTransparency = 1
SpaceBackground.Image = "rbxassetid://6444378561" -- Space background
SpaceBackground.ScaleType = Enum.ScaleType.Crop
SpaceBackground.Parent = MainFrame

-- Add some stars for effect
for i = 1, 30 do
    local star = Instance.new("Frame")
    star.Name = "Star" .. i
    star.Size = UDim2.new(0, math.random(1, 2), 0, math.random(1, 2))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = math.random() * 0.5
    star.BorderSizePixel = 0
    star.ZIndex = 2
    star.Parent = SpaceBackground
    
    -- Add twinkling effect
    spawn(function()
        while wait(math.random(1, 3)) do
            for j = 0, 1, 0.1 do
                if star and star.Parent then
                    star.BackgroundTransparency = j
                    wait(0.05)
                else
                    break
                end
            end
            for j = 1, 0, -0.1 do
                if star and star.Parent then
                    star.BackgroundTransparency = j
                    wait(0.05)
                else
                    break
                end
            end
        end
    end)
end

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 70, 0.8)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 3
TitleBar.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 10)
UICornerTitle.Parent = TitleBar

-- Fix the bottom corners of title bar
local BottomCover = Instance.new("Frame")
BottomCover.Name = "BottomCover"
BottomCover.Size = UDim2.new(1, 0, 0, 10)
BottomCover.Position = UDim2.new(0, 0, 1, -10)
BottomCover.BackgroundColor3 = Color3.fromRGB(30, 30, 70, 0.8)
BottomCover.BorderSizePixel = 0
BottomCover.ZIndex = 3
BottomCover.Parent = TitleBar

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "COSMIC TPWALK"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 4
TitleLabel.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.ZIndex = 4
CloseButton.Parent = TitleBar

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 6)
UICornerClose.Parent = CloseButton

-- Status Frame
local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusFrame"
StatusFrame.Size = UDim2.new(0.9, 0, 0, 40)
StatusFrame.Position = UDim2.new(0.05, 0, 0, 45)
StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 60, 0.7)
StatusFrame.BorderSizePixel = 0
StatusFrame.ZIndex = 3
StatusFrame.Parent = MainFrame

local UICornerStatus = Instance.new("UICorner")
UICornerStatus.CornerRadius = UDim.new(0, 8)
UICornerStatus.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.6, 0, 1, 0)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
StatusLabel.TextSize = 18
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 4
StatusLabel.Parent = StatusFrame

-- TPWalk Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 26)
ToggleButton.Position = UDim2.new(0.7, 0, 0.5, -13)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = ""
ToggleButton.ZIndex = 4
ToggleButton.Parent = StatusFrame

local UICornerToggle = Instance.new("UICorner")
UICornerToggle.CornerRadius = UDim.new(1, 0)
UICornerToggle.Parent = ToggleButton

local ToggleCircle = Instance.new("Frame")
ToggleCircle.Name = "Circle"
ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
ToggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
ToggleCircle.BorderSizePixel = 0
ToggleCircle.ZIndex = 5
ToggleCircle.Parent = ToggleButton

local UICornerCircle = Instance.new("UICorner")
UICornerCircle.CornerRadius = UDim.new(1, 0)
UICornerCircle.Parent = ToggleCircle

-- Speed Input
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0.05, 0, 0, 95)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.Text = "Speed:"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.ZIndex = 3
SpeedLabel.Parent = MainFrame

-- TextBox for Speed
local SpeedTextBox = Instance.new("TextBox")
SpeedTextBox.Name = "SpeedTextBox"
SpeedTextBox.Size = UDim2.new(0.9, 0, 0, 30)
SpeedTextBox.Position = UDim2.new(0.05, 0, 0, 115)
SpeedTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 80, 0.7)
SpeedTextBox.BorderSizePixel = 0
SpeedTextBox.Font = Enum.Font.GothamSemibold
SpeedTextBox.PlaceholderText = "Enter speed (10-500)"
SpeedTextBox.Text = tostring(tpWalkSpeed)
SpeedTextBox.TextColor3 = Color3.fromRGB(220, 220, 255)
SpeedTextBox.TextSize = 14
SpeedTextBox.ClearTextOnFocus = true
SpeedTextBox.ZIndex = 3
SpeedTextBox.Parent = MainFrame

local UICornerTextBox = Instance.new("UICorner")
UICornerTextBox.CornerRadius = UDim.new(0, 8)
UICornerTextBox.Parent = SpeedTextBox

-- Sprint Button
local SprintButton = Instance.new("TextButton")
SprintButton.Name = "SprintButton"
SprintButton.Size = UDim2.new(0.9, 0, 0, 30)
SprintButton.Position = UDim2.new(0.05, 0, 0, 155)
SprintButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80, 0.7)
SprintButton.BorderSizePixel = 0
SprintButton.Font = Enum.Font.GothamSemibold
SprintButton.Text = "SPRINT (SHIFT)"
SprintButton.TextColor3 = Color3.fromRGB(200, 200, 255)
SprintButton.TextSize = 14
SprintButton.ZIndex = 3
SprintButton.Parent = MainFrame

local UICornerSprint = Instance.new("UICorner")
UICornerSprint.CornerRadius = UDim.new(0, 8)
UICornerSprint.Parent = SprintButton

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    tpWalkEnabled = false
end)

-- Toggle button functionality
ToggleButton.MouseButton1Click:Connect(function()
    tpWalkEnabled = not tpWalkEnabled
    
    -- Update visuals
    local targetPos = tpWalkEnabled and UDim2.new(0, 27, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    local targetColor = tpWalkEnabled and Color3.fromRGB(75, 75, 255) or Color3.fromRGB(40, 40, 80)
    local statusText = tpWalkEnabled and "ON" or "OFF"
    local statusColor = tpWalkEnabled and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 70, 70)
    
    -- Animate the toggle
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local positionTween = TweenService:Create(ToggleCircle, tweenInfo, {Position = targetPos})
    local colorTween = TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = targetColor})
    
    positionTween:Play()
    colorTween:Play()
    
    StatusLabel.Text = statusText
    StatusLabel.TextColor3 = statusColor
    
    if tpWalkEnabled then
        tpWalkWithControl()
    end
end)

-- TextBox for speed input
SpeedTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputSpeed = tonumber(SpeedTextBox.Text)
        if inputSpeed then
            -- Clamp speed between reasonable values
            tpWalkSpeed = math.clamp(inputSpeed, 10, 500)
            SpeedTextBox.Text = tostring(tpWalkSpeed)
        else
            -- Restore original value if invalid input
            SpeedTextBox.Text = tostring(tpWalkSpeed)
        end
    end
end)

-- Sprint button functionality
SprintButton.MouseButton1Down:Connect(function()
    if tpWalkEnabled and not isSprinting then
        isSprinting = true
        tpWalkSpeed = tpWalkSpeed * sprintMultiplier
        
        -- Visual feedback
        SprintButton.BackgroundColor3 = Color3.fromRGB(75, 75, 255, 0.7)
    end
end)

SprintButton.MouseButton1Up:Connect(function()
    if isSprinting then
        isSprinting = false
        tpWalkSpeed = tpWalkSpeed / sprintMultiplier
        
        -- Visual feedback
        SprintButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80, 0.7)
    end
end)

-- Function to simulate smooth TPWalk
function tpWalkWithControl()
    while tpWalkEnabled do
        if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
            local moveDirection = humanoid.MoveDirection
            
            if moveDirection.Magnitude > 0 then
                -- Calculate target position
                local targetPosition = rootPart.Position + moveDirection.Unit * tpWalkSpeed * 0.01
                local smoothPosition = rootPart.Position:Lerp(targetPosition, 0.25)
                
                -- Set position and rotation with smoothing
                rootPart.CFrame = CFrame.new(smoothPosition, smoothPosition + moveDirection.Unit * 10)
            end
        end
        
        -- Wait for next frame
        RunService.RenderStepped:Wait()
    end
end

-- Add keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        -- Toggle TPWalk
        tpWalkEnabled = not tpWalkEnabled
        
        -- Update button visual
        local targetPos = tpWalkEnabled and UDim2.new(0, 27, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        local targetColor = tpWalkEnabled and Color3.fromRGB(75, 75, 255) or Color3.fromRGB(40, 40, 80)
        local statusText = tpWalkEnabled and "ON" or "OFF"
        local statusColor = tpWalkEnabled and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 70, 70)
        
        -- Animate the toggle
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local positionTween = TweenService:Create(ToggleCircle, tweenInfo, {Position = targetPos})
        local colorTween = TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = targetColor})
        
        positionTween:Play()
        colorTween:Play()
        
        StatusLabel.Text = statusText
        StatusLabel.TextColor3 = statusColor
        
        if tpWalkEnabled then
            tpWalkWithControl()
        end
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        -- Toggle sprint
        if tpWalkEnabled and not isSprinting then
            isSprinting = true
            tpWalkSpeed = tpWalkSpeed * sprintMultiplier
            
            -- Visual feedback
            SprintButton.BackgroundColor3 = Color3.fromRGB(75, 75, 255, 0.7)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.LeftShift and isSprinting then
        -- Turn off sprint
        isSprinting = false
        tpWalkSpeed = tpWalkSpeed / sprintMultiplier
        
        -- Visual feedback
        SprintButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80, 0.7)
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Restart TPWalk if it was enabled
    if tpWalkEnabled then
        tpWalkWithControl()
    end
end)

-- Display controls info on startup
local InfoFrame = Instance.new("Frame")
InfoFrame.Name = "InfoFrame"
InfoFrame.Size = UDim2.new(0, 240, 0, 100)
InfoFrame.Position = UDim2.new(0.5, -120, 0.5, -50)
InfoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40, 0.9)
InfoFrame.BorderSizePixel = 0
InfoFrame.ZIndex = 10
InfoFrame.Parent = ScreenGui

local UICornerInfo = Instance.new("UICorner")
UICornerInfo.CornerRadius = UDim.new(0, 10)
UICornerInfo.Parent = InfoFrame

-- Star effects for info frame too
for i = 1, 10 do
    local star = Instance.new("Frame")
    star.Name = "InfoStar" .. i
    star.Size = UDim2.new(0, math.random(1, 2), 0, math.random(1, 2))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = math.random() * 0.5
    star.BorderSizePixel = 0
    star.ZIndex = 11
    star.Parent = InfoFrame
end

local InfoText = Instance.new("TextLabel")
InfoText.Name = "InfoText"
InfoText.Size = UDim2.new(0.9, 0, 0.9, 0)
InfoText.Position = UDim2.new(0.05, 0, 0.05, 0)
InfoText.BackgroundTransparency = 1
InfoText.Font = Enum.Font.GothamSemibold
InfoText.Text = "Cosmic TPWalk Controls:\n\nF - Toggle On/Off\nShift - Sprint (hold)\nType speed in textbox (10-500)\n\nClick anywhere to close"
InfoText.TextColor3 = Color3.fromRGB(220, 220, 255)
InfoText.TextSize = 14
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.ZIndex = 12
InfoText.Parent = InfoFrame

-- Close on click anywhere
local CloseInfoButton = Instance.new("TextButton")
CloseInfoButton.Name = "CloseInfoButton"
CloseInfoButton.Size = UDim2.new(1, 0, 1, 0)
CloseInfoButton.BackgroundTransparency = 1
CloseInfoButton.Text = ""
CloseInfoButton.ZIndex = 10
CloseInfoButton.Parent = InfoFrame

CloseInfoButton.MouseButton1Click:Connect(function()
    InfoFrame:Destroy()
end)

-- Auto close after 4 seconds
spawn(function()
    wait(4)
    if InfoFrame and InfoFrame.Parent then
        InfoFrame:Destroy()
    end
end)

-- Return status message to confirm loading
return "Cosmic TPWalk Loaded Successfully"

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "LosPibesGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 325, 0, 100)
frame.Position = UDim2.new(0.5, -162.5, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = screenGui

-- Add UICorner for rounded edges
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

-- Add UIStroke for border
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 0)
uiStroke.Thickness = 1.5
uiStroke.Parent = frame

-- Make GUI Draggable
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "LOS PIBES 😈 By DylanElCuervo22"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextScaled = true
title.Parent = frame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Version Label
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 30, 0, 20)
versionLabel.Position = UDim2.new(1, -35, 1, -25)
versionLabel.Text = "V3"
versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
versionLabel.BackgroundTransparency = 1
versionLabel.TextTransparency = 0.5
versionLabel.Font = Enum.Font.GothamBold
versionLabel.TextSize = 12
versionLabel.Parent = frame

-- RShift Toggle
local isGuiVisible = true
local function toggleGui()
    isGuiVisible = not isGuiVisible
    frame.Visible = isGuiVisible
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGui()
    end
end)

-- Fly Variables
local isFlying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local maxAcceleration = 100
local accelerationTime = 0.2

-- Noclip Variables
local isNoclip = false
local noclipConnection = nil

-- Speed Variables
local isSpeed = false
local customSpeed = 50

-- Improved Fly Functions (Camera-Based)
local function startFly()
    if isFlying then return end
    isFlying = true
    humanoid.PlatformStand = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    local currentVelocity = Vector3.new(0, 0, 0)

    local function updateFly(deltaTime)
        if not isFlying then return end
        local direction = Vector3.new()
        local camera = workspace.CurrentCamera
        local camLook = camera.CFrame.LookVector
        local camRight = camera.CFrame.RightVector

        -- Camera-based movement
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camLook
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camLook
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)
        end

        -- Smooth acceleration
        local targetVelocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.new(0, 0, 0)
        currentVelocity = currentVelocity:Lerp(targetVelocity, deltaTime / accelerationTime)
        bodyVelocity.Velocity = currentVelocity
        bodyGyro.CFrame = camera.CFrame
    end

    RunService:BindToRenderStep("FlyUpdate", Enum.RenderPriority.Input.Value, updateFly)
end

local function stopFly()
    isFlying = false
    humanoid.PlatformStand = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    RunService:UnbindFromRenderStep("FlyUpdate")
end

-- Noclip Functions
local function startNoclip()
    if isNoclip then return end
    isNoclip = true
    noclipConnection = RunService.Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    isNoclip = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Speed Functions
local function setSpeed()
    if isSpeed then
        humanoid.WalkSpeed = customSpeed
    else
        humanoid.WalkSpeed = 16
    end
end

-- GUI Elements (Compact Layout)
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -10, 0, 30)
buttonContainer.Position = UDim2.new(0, 5, 0, 30)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = buttonContainer

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 100, 0, 25)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 12
flyButton.Parent = buttonContainer
local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyButton

flyButton.MouseButton1Click:Connect(function()
    if isFlying then
        stopFly()
        flyButton.Text = "Fly: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        startFly()
        flyButton.Text = "Fly: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end
end)

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 100, 0, 25)
noclipButton.Text = "Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.Gotham
noclipButton.TextSize = 12
noclipButton.Parent = buttonContainer
local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 6)
noclipCorner.Parent = noclipButton

noclipButton.MouseButton1Click:Connect(function()
    if isNoclip then
        stopNoclip()
        noclipButton.Text = "Noclip: OFF"
        noclipButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        startNoclip()
        noclipButton.Text = "Noclip: ON"
        noclipButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end
end)

-- Speed Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 100, 0, 25)
speedButton.Text = "Speed: OFF"
speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 12
speedButton.Parent = buttonContainer
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedButton

speedButton.MouseButton1Click:Connect(function()
    isSpeed = not isSpeed
    if isSpeed then
        speedButton.Text = "Speed: ON"
        speedButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        speedButton.Text = "Speed: OFF"
        speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
    setSpeed()
end)

-- Input Container (Horizontal Layout for Fly Speed and Walk Speed)
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, -10, 0, 40)
inputContainer.Position = UDim2.new(0, 5, 1, -40)
inputContainer.BackgroundTransparency = 1
inputContainer.Parent = frame

local inputListLayout = Instance.new("UIListLayout")
inputListLayout.FillDirection = Enum.FillDirection.Horizontal
inputListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
inputListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
inputListLayout.Padding = UDim.new(0, 5)
inputListLayout.Parent = inputContainer

-- Fly Speed Input
local flySpeedContainer = Instance.new("Frame")
flySpeedContainer.Size = UDim2.new(0, 150, 0, 20)
flySpeedContainer.BackgroundTransparency = 1
flySpeedContainer.Parent = inputContainer

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0, 75, 0, 20)
flySpeedLabel.Text = "Fly Speed:"
flySpeedLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextSize = 10
flySpeedLabel.Parent = flySpeedContainer
local flySpeedLabelCorner = Instance.new("UICorner")
flySpeedLabelCorner.CornerRadius = UDim.new(0, 6)
flySpeedLabelCorner.Parent = flySpeedLabel

local flySpeedInput = Instance.new("TextBox")
flySpeedInput.Size = UDim2.new(0, 65, 0, 20)
flySpeedInput.Position = UDim2.new(1, -65, 0, 0)
flySpeedInput.Text = tostring(flySpeed)
flySpeedInput.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
flySpeedInput.TextColor3 = Color3.fromRGB(0, 0, 0)
flySpeedInput.Font = Enum.Font.Gotham
flySpeedInput.TextSize = 10
flySpeedInput.Parent = flySpeedContainer
local flySpeedInputCorner = Instance.new("UICorner")
flySpeedInputCorner.CornerRadius = UDim.new(0, 6)
flySpeedInputCorner.Parent = flySpeedInput

flySpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(flySpeedInput.Text)
        if value and value >= 0 then
            flySpeed = value
        else
            flySpeedInput.Text = tostring(flySpeed)
        end
    end
end)

-- Walk Speed Input
local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(0, 150, 0, 20)
speedContainer.BackgroundTransparency = 1
speedContainer.Parent = inputContainer

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 75, 0, 20)
speedLabel.Text = "Walk Speed:"
speedLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 10
speedLabel.Parent = speedContainer
local speedLabelCorner = Instance.new("UICorner")
speedLabelCorner.CornerRadius = UDim.new(0, 6)
speedLabelCorner.Parent = speedLabel

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 65, 0, 20)
speedInput.Position = UDim2.new(1, -65, 0, 0)
speedInput.Text = tostring(customSpeed)
speedInput.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
speedInput.TextColor3 = Color3.fromRGB(0, 0, 0)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 10
speedInput.Parent = speedContainer
local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 6)
speedInputCorner.Parent = speedInput

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(speedInput.Text)
        if value and value >= 0 then
            customSpeed = value
            setSpeed()
        else
            speedInput.Text = tostring(customSpeed)
        end
    end
end)

-- Handle Character Reset
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    if isFlying then
        startFly()
    end
    if isNoclip then
        startNoclip()
    end
    setSpeed()
end)
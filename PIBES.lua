local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "LosPibesGUI"
screenGui.ResetOnSpawn = false

-- Cartelito 1: "Hola Fau😂👌"
local welcomeFrame1 = Instance.new("Frame")
welcomeFrame1.Size = UDim2.new(0, 150, 0, 75)
welcomeFrame1.Position = UDim2.new(0.5, -75, 0.4, -37.5) -- Un poco más arriba
welcomeFrame1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
welcomeFrame1.BackgroundTransparency = 0.2
welcomeFrame1.BorderSizePixel = 0
welcomeFrame1.Parent = screenGui

local welcomeCorner1 = Instance.new("UICorner")
welcomeCorner1.CornerRadius = UDim.new(0, 8)
welcomeCorner1.Parent = welcomeFrame1

local welcomeStroke1 = Instance.new("UIStroke")
welcomeStroke1.Thickness = 1.5
welcomeStroke1.Parent = welcomeFrame1

local welcomeLabel1 = Instance.new("TextLabel")
welcomeLabel1.Size = UDim2.new(1, 0, 0.7, 0)
welcomeLabel1.Position = UDim2.new(0, 0, 0, 0)
welcomeLabel1.Text = "Hola Fau😂👌"
welcomeLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeLabel1.BackgroundTransparency = 1
welcomeLabel1.Font = Enum.Font.GothamBold
welcomeLabel1.TextSize = 20
welcomeLabel1.TextScaled = true
welcomeLabel1.Parent = welcomeFrame1

local closeButton1 = Instance.new("TextButton")
closeButton1.Size = UDim2.new(0, 20, 0, 20)
closeButton1.Position = UDim2.new(1, -30, 0, 5)
closeButton1.Text = "X"
closeButton1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton1.Font = Enum.Font.GothamBold
closeButton1.TextSize = 12
closeButton1.Parent = welcomeFrame1

local closeCorner1 = Instance.new("UICorner")
closeCorner1.CornerRadius = UDim.new(0, 6)
closeCorner1.Parent = closeButton1

closeButton1.MouseButton1Click:Connect(function()
    welcomeFrame1:Destroy()
end)

-- Cartelito 2: "De los mejores jaciers para los mejores haciers"
local welcomeFrame2 = Instance.new("Frame")
welcomeFrame2.Size = UDim2.new(0, 150, 0, 75)
welcomeFrame2.Position = UDim2.new(0.5, -75, 0.6, -37.5) -- Un poco más abajo
welcomeFrame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
welcomeFrame2.BackgroundTransparency = 0.2
welcomeFrame2.BorderSizePixel = 0
welcomeFrame2.Parent = screenGui

local welcomeCorner2 = Instance.new("UICorner")
welcomeCorner2.CornerRadius = UDim.new(0, 8)
welcomeCorner2.Parent = welcomeFrame2

local welcomeStroke2 = Instance.new("UIStroke")
welcomeStroke2.Thickness = 1.5
welcomeStroke2.Parent = welcomeFrame2

local welcomeLabel2 = Instance.new("TextLabel")
welcomeLabel2.Size = UDim2.new(1, 0, 0.7, 0)
welcomeLabel2.Position = UDim2.new(0, 0, 0, 0)
welcomeLabel2.Text = "De los mejores jaciers para los mejores haciers"
welcomeLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeLabel2.BackgroundTransparency = 1
welcomeLabel2.Font = Enum.Font.GothamBold
welcomeLabel2.TextSize = 20
welcomeLabel2.TextScaled = true
welcomeLabel2.Parent = welcomeFrame2

local closeButton2 = Instance.new("TextButton")
closeButton2.Size = UDim2.new(0, 20, 0, 20)
closeButton2.Position = UDim2.new(1, -30, 0, 5)
closeButton2.Text = "X"
closeButton2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton2.Font = Enum.Font.GothamBold
closeButton2.TextSize = 12
closeButton2.Parent = welcomeFrame2

local closeCorner2 = Instance.new("UICorner")
closeCorner2.CornerRadius = UDim.new(0, 6)
closeCorner2.Parent = closeButton2

closeButton2.MouseButton1Click:Connect(function()
    welcomeFrame2:Destroy()
end)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 325, 0, 160)
frame.Position = UDim2.new(0.5, -162.5, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.ClipsDescendants = true
frame.Parent = screenGui

-- Add UICorner for rounded edges
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

-- Add UIStroke for rainbow border
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 1.5
uiStroke.Parent = frame

-- Rainbow effect for UIStroke (main frame and both welcome frames)
local function updateRainbow()
    local hue = (tick() % 5) / 5 -- Cycle over 5 seconds
    local color = Color3.fromHSV(hue, 1, 1) -- Full saturation and value for vibrant colors
    uiStroke.Color = color
    if welcomeFrame1 and welcomeFrame1.Parent then
        welcomeStroke1.Color = color
    end
    if welcomeFrame2 and welcomeFrame2.Parent then
        welcomeStroke2.Color = color
    end
end
RunService.Heartbeat:Connect(updateRainbow)

-- Devil Emoji Button (Toggle Indicator)
local devilButton = Instance.new("TextButton")
devilButton.Size = UDim2.new(0, 40, 0, 40)
devilButton.Position = UDim2.new(0, 10, 0, 10) -- Moved to top-left, offset by 10 pixels
devilButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
devilButton.Text = "😈"
devilButton.TextColor3 = Color3.fromRGB(255, 255, 255)
devilButton.Font = Enum.Font.GothamBold
devilButton.TextSize = 20
devilButton.Visible = false
devilButton.Parent = screenGui

local devilCorner = Instance.new("UICorner")
devilCorner.CornerRadius = UDim.new(0, 8)
devilCorner.Parent = devilButton

local devilStroke = Instance.new("UIStroke")
devilStroke.Color = Color3.fromRGB(255, 255, 255)
devilStroke.Thickness = 1
devilStroke.Parent = devilButton

-- Make Devil Button Draggable
local devilDragging = false
local devilDragStart = nil
local devilStartPos = nil

devilButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        devilDragging = true
        devilDragStart = input.Position
        devilStartPos = devilButton.Position
    end
end)

devilButton.InputChanged:Connect(function(input)
    if devilDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - devilDragStart
        devilButton.Position = UDim2.new(devilStartPos.X.Scale, devilStartPos.X.Offset + delta.X, devilStartPos.Y.Scale, devilStartPos.Y.Offset + delta.Y)
    end
end)

devilButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        devilDragging = false
    end
end)

-- Hover Effect for Devil Button
devilButton.MouseEnter:Connect(function()
    devilButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    devilButton.TextColor3 = Color3.fromRGB(0, 0, 0)
end)

devilButton.MouseLeave:Connect(function()
    devilButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    devilButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

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
title.Text = "LOS PIBES 😈 By DylanElCuervo22 V2.1"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextScaled = true
title.Parent = frame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Button Container (First Row: Fly, Noclip, Speed)
local buttonContainer1 = Instance.new("Frame")
buttonContainer1.Size = UDim2.new(1, -10, 0, 30)
buttonContainer1.Position = UDim2.new(0, 5, 0, 30)
buttonContainer1.BackgroundTransparency = 1
buttonContainer1.Parent = frame

local uiListLayout1 = Instance.new("UIListLayout")
uiListLayout1.FillDirection = Enum.FillDirection.Horizontal
uiListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout1.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout1.Padding = UDim.new(0, 5)
uiListLayout1.Parent = buttonContainer1

-- Button Container (Second Row: ESP, Jump, Gravity)
local buttonContainer2 = Instance.new("Frame")
buttonContainer2.Size = UDim2.new(1, -10, 0, 30)
buttonContainer2.Position = UDim2.new(0, 5, 0, 65)
buttonContainer2.BackgroundTransparency = 1
buttonContainer2.Parent = frame

local uiListLayout2 = Instance.new("UIListLayout")
uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout2.Padding = UDim.new(0, 5)
uiListLayout2.Parent = buttonContainer2

-- Input Container (Horizontal Layout for Fly Speed, Walk Speed, Jump Power, Gravity)
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, -10, 0, 80)
inputContainer.Position = UDim2.new(0, 5, 0, 100)
inputContainer.BackgroundTransparency = 1
inputContainer.Parent = frame

local inputListLayout = Instance.new("UIListLayout")
inputListLayout.FillDirection = Enum.FillDirection.Horizontal
inputListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
inputListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
inputListLayout.Padding = UDim.new(0, 5)
inputListLayout.Wraps = true
inputListLayout.Parent = inputContainer

-- GUI Animation
local function animateGui(show)
    if show then
        frame.Visible = true
        frame.Size = UDim2.new(0, 325 * 0.8, 0, 160 * 0.8)
        frame.BackgroundTransparency = 0.5
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tween = TweenService:Create(frame, tweenInfo, {
            Size = UDim2.new(0, 325, 0, 160),
            BackgroundTransparency = 0.1
        })
        tween:Play()
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local tween = TweenService:Create(frame, tweenInfo, {
            Size = UDim2.new(0, 325 * 0.8, 0, 160 * 0.8),
            BackgroundTransparency = 0.5
        })
        tween.Completed:Connect(function()
            frame.Visible = false
        end)
        tween:Play()
    end
end

-- RShift Toggle and Devil Button Logic
local isGuiVisible = true
local function toggleGui()
    isGuiVisible = not isGuiVisible
    animateGui(isGuiVisible)
    devilButton.Visible = not isGuiVisible
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGui()
    end
end)

devilButton.MouseButton1Click:Connect(toggleGui)

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

-- ESP Variables
local isEsp = false
local espConnections = {}
local espHighlights = {}

-- Jump Power Variables
local isJumpPower = false
local customJumpPower = 50

-- Gravity Variables
local isCustomGravity = false
local customGravity = Workspace.Gravity

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
        local camera = Workspace.CurrentCamera
        local camLook = camera.CFrame.LookVector
        local camRight = camera.CFrame.RightVector

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

-- ESP Functions
local function createHighlight(playerToHighlight)
    if playerToHighlight == player then return end
    local characterToHighlight = playerToHighlight.Character
    if characterToHighlight then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = characterToHighlight
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = characterToHighlight
        espHighlights[playerToHighlight] = highlight
    end
end

local function startEsp()
    if isEsp then return end
    isEsp = true
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        createHighlight(otherPlayer)
        local connection = otherPlayer.CharacterAdded:Connect(function()
            createHighlight(otherPlayer)
        end)
        espConnections[otherPlayer] = connection
    end
    Players.PlayerAdded:Connect(function(newPlayer)
        createHighlight(newPlayer)
        local connection = newPlayer.CharacterAdded:Connect(function()
            createHighlight(newPlayer)
        end)
        espConnections[newPlayer] = connection
    end)
    Players.PlayerRemoving:Connect(function(leavingPlayer)
        if espHighlights[leavingPlayer] then
            espHighlights[leavingPlayer]:Destroy()
            espHighlights[leavingPlayer] = nil
        end
        if espConnections[leavingPlayer] then
            espConnections[leavingPlayer]:Disconnect()
            espConnections[leavingPlayer] = nil
        end
    end)
end

local function stopEsp()
    isEsp = false
    for _, highlight in pairs(espHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end
    for _, connection in pairs(espConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    espHighlights = {}
    espConnections = {}
end

-- Jump Power Functions
local function setJumpPower()
    if isJumpPower then
        humanoid.JumpPower = customJumpPower
        humanoid.UseJumpPower = true
    else
        humanoid.JumpPower = 50
    end
end

-- Gravity Functions
local function setGravity()
    if isCustomGravity then
        Workspace.Gravity = customGravity
    else
        Workspace.Gravity = 196.2
    end
end

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 100, 0, 25)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 12
flyButton.Parent = buttonContainer1
local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyButton

flyButton.MouseButton1Click:Connect(function()
    if isFlying then
        stopFly()
        flyButton.Text = "Fly: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    else
        startFly()
        flyButton.Text = "Fly: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 100, 0, 25)
noclipButton.Text = "Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.Gotham
noclipButton.TextSize = 12
noclipButton.Parent = buttonContainer1
local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 6)
noclipCorner.Parent = noclipButton

noclipButton.MouseButton1Click:Connect(function()
    if isNoclip then
        stopNoclip()
        noclipButton.Text = "Noclip: OFF"
        noclipButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    else
        startNoclip()
        noclipButton.Text = "Noclip: ON"
        noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Speed Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 100, 0, 25)
speedButton.Text = "Speed: OFF"
speedButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 12
speedButton.Parent = buttonContainer1
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedButton

speedButton.MouseButton1Click:Connect(function()
    isSpeed = not isSpeed
    if isSpeed then
        speedButton.Text = "Speed: ON"
        speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        speedButton.Text = "Speed: OFF"
        speedButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end
    setSpeed()
end)

-- ESP Button
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 100, 0, 25)
espButton.Text = "ESP: OFF"
espButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.Gotham
espButton.TextSize = 12
espButton.Parent = buttonContainer2
local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 6)
espCorner.Parent = espButton

espButton.MouseButton1Click:Connect(function()
    if isEsp then
        stopEsp()
        espButton.Text = "ESP: OFF"
        espButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    else
        startEsp()
        espButton.Text = "ESP: ON"
        espButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Jump Power Button
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0, 100, 0, 25)
jumpButton.Text = "Jump: OFF"
jumpButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.Font = Enum.Font.Gotham
jumpButton.TextSize = 12
jumpButton.Parent = buttonContainer2
local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 6)
jumpCorner.Parent = jumpButton

jumpButton.MouseButton1Click:Connect(function()
    isJumpPower = not isJumpPower
    if isJumpPower then
        jumpButton.Text = "Jump: ON"
        jumpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        jumpButton.Text = "Jump: OFF"
        jumpButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end
    setJumpPower()
end)

-- Gravity Button
local gravityButton = Instance.new("TextButton")
gravityButton.Size = UDim2.new(0, 100, 0, 25)
gravityButton.Text = "Gravity: OFF"
gravityButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
gravityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityButton.Font = Enum.Font.Gotham
gravityButton.TextSize = 12
gravityButton.Parent = buttonContainer2
local gravityCorner = Instance.new("UICorner")
gravityCorner.CornerRadius = UDim.new(0, 6)
gravityCorner.Parent = gravityButton

gravityButton.MouseButton1Click:Connect(function()
    isCustomGravity = not isCustomGravity
    if isCustomGravity then
        gravityButton.Text = "Gravity: ON"
        gravityButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        gravityButton.Text = "Gravity: OFF"
        gravityButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end
    setGravity()
end)

-- Fly Speed Input
local flySpeedContainer = Instance.new("Frame")
flySpeedContainer.Size = UDim2.new(0, 150, 0, 20)
flySpeedContainer.BackgroundTransparency = 1
flySpeedContainer.Parent = inputContainer

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0, 75, 0, 20)
flySpeedLabel.Text = "Fly Speed:"
flySpeedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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
flySpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
flySpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
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
speedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
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

-- Jump Power Input
local jumpContainer = Instance.new("Frame")
jumpContainer.Size = UDim2.new(0, 150, 0, 20)
jumpContainer.BackgroundTransparency = 1
jumpContainer.Parent = inputContainer

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 75, 0, 20)
jumpLabel.Text = "Jump Power:"
jumpLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 10
jumpLabel.Parent = jumpContainer
local jumpLabelCorner = Instance.new("UICorner")
jumpLabelCorner.CornerRadius = UDim.new(0, 6)
jumpLabelCorner.Parent = jumpLabel

local jumpInput = Instance.new("TextBox")
jumpInput.Size = UDim2.new(0, 65, 0, 20)
jumpInput.Position = UDim2.new(1, -65, 0, 0)
jumpInput.Text = tostring(customJumpPower)
jumpInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
jumpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpInput.Font = Enum.Font.Gotham
jumpInput.TextSize = 10
jumpInput.Parent = jumpContainer
local jumpInputCorner = Instance.new("UICorner")
jumpInputCorner.CornerRadius = UDim.new(0, 6)
jumpInputCorner.Parent = jumpInput

jumpInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(jumpInput.Text)
        if value and value >= 0 then
            customJumpPower = value
            setJumpPower()
        else
            jumpInput.Text = tostring(customJumpPower)
        end
    end
end)

-- Gravity Input
local gravityContainer = Instance.new("Frame")
gravityContainer.Size = UDim2.new(0, 150, 0, 20)
gravityContainer.BackgroundTransparency = 1
gravityContainer.Parent = inputContainer

local gravityLabel = Instance.new("TextLabel")
gravityLabel.Size = UDim2.new(0, 75, 0, 20)
gravityLabel.Text = "Gravity:"
gravityLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
gravityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityLabel.Font = Enum.Font.Gotham
gravityLabel.TextSize = 10
gravityLabel.Parent = gravityContainer
local gravityLabelCorner = Instance.new("UICorner")
gravityLabelCorner.CornerRadius = UDim.new(0, 6)
gravityLabelCorner.Parent = gravityLabel

local gravityInput = Instance.new("TextBox")
gravityInput.Size = UDim2.new(0, 65, 0, 20)
gravityInput.Position = UDim2.new(1, -65, 0, 0)
gravityInput.Text = tostring(customGravity)
gravityInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
gravityInput.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityInput.Font = Enum.Font.Gotham
gravityInput.TextSize = 10
gravityInput.Parent = gravityContainer
local gravityInputCorner = Instance.new("UICorner")
gravityInputCorner.CornerRadius = UDim.new(0, 6)
gravityInputCorner.Parent = gravityInput

gravityInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(gravityInput.Text)
        if value and value >= 0 then
            customGravity = value
            setGravity()
        else
            gravityInput.Text = tostring(customGravity)
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
    setJumpPower()
end)

-- Clean up ESP and rainbow effect on script end
game:BindToClose(function()
    stopEsp()
end)

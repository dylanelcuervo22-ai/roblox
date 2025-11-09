local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Detect mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "LosPibesGUI"
screenGui.ResetOnSpawn = false

-- Loading Screen (Scaled for mobile)
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0.8, 0, 0.2, 0)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 0.2
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 10)
loadingCorner.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.3, 0)
loadingText.Position = UDim2.new(0, 0, 0, 0)
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 24
loadingText.Parent = loadingFrame

-- Pulsing animation for loading text
local function pulseLoadingText()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(loadingText, tweenInfo, {
        TextTransparency = 0.2
    })
    tween:Play()
end

local progressBarFrame = Instance.new("Frame")
progressBarFrame.Size = UDim2.new(0.9, 0, 0, 15)
progressBarFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
progressBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBarFrame.BorderSizePixel = 0
progressBarFrame.Parent = loadingFrame

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 5)
progressBarCorner.Parent = progressBarFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarFrame

local progressBarInnerCorner = Instance.new("UICorner")
progressBarInnerCorner.CornerRadius = UDim.new(0, 5)
progressBarInnerCorner.Parent = progressBar

local progressBarStroke = Instance.new("UIStroke")
progressBarStroke.Color = Color3.fromRGB(255, 255, 255)
progressBarStroke.Thickness = 1.5
progressBarStroke.Transparency = 0.7
progressBarStroke.Parent = progressBar

-- Main GUI Frame (Scaled and responsive)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 1
frame.ClipsDescendants = true
frame.Visible = false
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Parent = frame

local function updateRainbow()
    local hue = (tick() % 5) / 5
    uiStroke.Color = Color3.fromHSV(hue, 1, 1)
end
RunService.Heartbeat:Connect(updateRainbow)

-- Devil Emoji Button (Larger for mobile touch)
local devilButton = Instance.new("TextButton")
devilButton.Size = UDim2.new(0, 0, 0, 0)
devilButton.Position = UDim2.new(0, 10, 0, 10)
devilButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
devilButton.Text = "😈"
devilButton.TextColor3 = Color3.fromRGB(255, 255, 255)
devilButton.Font = Enum.Font.GothamBold
devilButton.TextSize = 32
devilButton.BackgroundTransparency = 1
devilButton.TextTransparency = 1
devilButton.Visible = false
devilButton.Parent = screenGui

local devilCorner = Instance.new("UICorner")
devilCorner.CornerRadius = UDim.new(0, 12)
devilCorner.Parent = devilButton

local devilStroke = Instance.new("UIStroke")
devilStroke.Color = Color3.fromRGB(255, 255, 255)
devilStroke.Thickness = 2
devilStroke.Parent = devilButton

-- Devil Button Animation
local function animateDevilButton(show)
    if show then
        devilButton.Visible = true
        devilButton.Size = UDim2.new(0, 0, 0, 0)
        devilButton.BackgroundTransparency = 1
        devilButton.TextTransparency = 1
        local targetSize = isMobile and UDim2.new(0, 80, 0, 80) or UDim2.new(0, 60, 0, 60)
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(devilButton, tweenInfo, {
            Size = targetSize,
            BackgroundTransparency = 0,
            TextTransparency = 0,
            Rotation = 0
        })
        tween:Play()
        local wiggleInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 2, true)
        local wiggleTween = TweenService:Create(devilButton, wiggleInfo, {
            Rotation = 10
        })
        wiggleTween:Play()
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local tween = TweenService:Create(devilButton, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        tween.Completed:Connect(function()
            devilButton.Visible = false
        end)
        tween:Play()
    end
end

-- Make Devil Button Draggable (Works on mobile touch)
local devilDragging = false
local devilDragStart = nil
local devilStartPos = nil

devilButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        devilDragging = true
        devilDragStart = input.Position
        devilStartPos = devilButton.Position
    end
end)

devilButton.InputChanged:Connect(function(input)
    if devilDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - devilDragStart
        devilButton.Position = UDim2.new(devilStartPos.X.Scale, devilStartPos.X.Offset + delta.X, devilStartPos.Y.Scale, devilStartPos.Y.Offset + delta.Y)
    end
end)

devilButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        devilDragging = false
    end
end)

devilButton.MouseEnter:Connect(function()
    devilButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    devilButton.TextColor3 = Color3.fromRGB(0, 0, 0)
end)

devilButton.MouseLeave:Connect(function()
    devilButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    devilButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- Make GUI Draggable (Works on mobile)
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Title (Larger text)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "LOS PIBES 😈 By DylanElCuervo22 V3"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextScaled = true
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Button Container (First Row: Larger buttons for touch)
local buttonContainer1 = Instance.new("Frame")
buttonContainer1.Size = UDim2.new(1, -20, 0, 50)
buttonContainer1.Position = UDim2.new(0, 10, 0, 50)
buttonContainer1.BackgroundTransparency = 1
buttonContainer1.Parent = frame

local uiListLayout1 = Instance.new("UIListLayout")
uiListLayout1.FillDirection = Enum.FillDirection.Horizontal
uiListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout1.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout1.Padding = UDim.new(0, 10)
uiListLayout1.Parent = buttonContainer1

-- Button Container (Second Row)
local buttonContainer2 = Instance.new("Frame")
buttonContainer2.Size = UDim2.new(1, -20, 0, 50)
buttonContainer2.Position = UDim2.new(0, 10, 0, 110)
buttonContainer2.BackgroundTransparency = 1
buttonContainer2.Parent = frame

local uiListLayout2 = Instance.new("UIListLayout")
uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout2.Padding = UDim.new(0, 10)
uiListLayout2.Parent = buttonContainer2

-- Input Container (Larger for mobile)
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, -20, 0, 120)
inputContainer.Position = UDim2.new(0, 10, 0, 170)
inputContainer.BackgroundTransparency = 1
inputContainer.Parent = frame

local inputListLayout = Instance.new("UIListLayout")
inputListLayout.FillDirection = Enum.FillDirection.Horizontal
inputListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
inputListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
inputListLayout.Padding = UDim.new(0, 10)
inputListLayout.Wraps = true
inputListLayout.Parent = inputContainer

-- Loading Animation
local function playLoadingAnimation(callback)
    pulseLoadingText()
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
    local tween = TweenService:Create(progressBar, tweenInfo, {
        Size = UDim2.new(1, 0, 1, 0)
    })
    local strokeTween = TweenService:Create(progressBarStroke, tweenInfo, {
        Transparency = 0.3
    })
    tween:Play()
    strokeTween:Play()
    tween.Completed:Connect(function()
        local fadeOutInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local fadeOutTween = TweenService:Create(loadingFrame, fadeOutInfo, {
            BackgroundTransparency = 1
        })
        local textFadeTween = TweenService:Create(loadingText, fadeOutInfo, {
            TextTransparency = 1
        })
        fadeOutTween:Play()
        textFadeTween:Play()
        fadeOutTween.Completed:Connect(function()
            loadingFrame.Visible = false
            callback()
        end)
    end)
end

-- GUI Animation (Responsive size)
local function animateGui(show)
    if show then
        frame.Visible = true
        frame.Size = UDim2.new(0, 0, 0, 0)
        frame.BackgroundTransparency = 1
        local targetSize = isMobile and UDim2.new(0.9, 0, 0.7, 0) or UDim2.new(0, 350, 0, 300)
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(frame, tweenInfo, {
            Size = targetSize,
            BackgroundTransparency = 0.1
        })
        tween:Play()
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local tween = TweenService:Create(frame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        tween.Completed:Connect(function()
            frame.Visible = false
        end)
        tween:Play()
    end
end

-- Initialize Loading and GUI
playLoadingAnimation(function()
    animateGui(true)
    animateDevilButton(false)
end)

-- RShift Toggle and Devil Button Logic (Touch works)
local isGuiVisible = true
local function toggleGui()
    isGuiVisible = not isGuiVisible
    animateGui(isGuiVisible)
    animateDevilButton(not isGuiVisible)
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGui()
    end
end)

devilButton.MouseButton1Click:Connect(toggleGui)
devilButton.TouchTap:Connect(toggleGui)  -- For mobile

-- Fly Variables
local isFlying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local maxAcceleration = 100
local accelerationTime = 0.2
local flyControls = nil
local joystickBg = nil
local joystickThumb = nil
local joystickActive = false
local joystickTouchInput = nil
local joystickDirection = Vector2.new(0, 0)
local upPressed = false
local downPressed = false

-- Create Fly Controls for Mobile
local function createFlyControls()
    if not isMobile then return end
    flyControls = Instance.new("Frame")
    flyControls.Name = "FlyControls"
    flyControls.Size = UDim2.new(1, 0, 1, 0)
    flyControls.Position = UDim2.new(0, 0, 0, 0)
    flyControls.BackgroundTransparency = 1
    flyControls.Parent = screenGui

    -- Joystick Background
    joystickBg = Instance.new("Frame")
    joystickBg.Size = UDim2.new(0, 140, 0, 140)
    joystickBg.Position = UDim2.new(0, 20, 1, -160)
    joystickBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    joystickBg.BackgroundTransparency = 0.5
    joystickBg.BorderSizePixel = 0
    joystickBg.Parent = flyControls

    local joystickBgCorner = Instance.new("UICorner")
    joystickBgCorner.CornerRadius = UDim.new(1, 0)
    joystickBgCorner.Parent = joystickBg

    local joystickBgStroke = Instance.new("UIStroke")
    joystickBgStroke.Color = Color3.fromRGB(255, 255, 255)
    joystickBgStroke.Thickness = 2
    joystickBgStroke.Transparency = 0.3
    joystickBgStroke.Parent = joystickBg

    -- Joystick Thumb
    joystickThumb = Instance.new("Frame")
    joystickThumb.Size = UDim2.new(0, 50, 0, 50)
    joystickThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
    joystickThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    joystickThumb.BorderSizePixel = 0
    joystickThumb.Parent = joystickBg

    local joystickThumbCorner = Instance.new("UICorner")
    joystickThumbCorner.CornerRadius = UDim.new(1, 0)
    joystickThumbCorner.Parent = joystickThumb

    -- Joystick Events
    joystickBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and not joystickActive then
            joystickTouchInput = input
            local absPos = joystickBg.AbsolutePosition
            local relPos = input.Position - absPos
            if relPos.Magnitude <= 70 then  -- Half of 140
                joystickActive = true
                local clamped = relPos.Unit * math.min(relPos.Magnitude, 70)
                joystickDirection = relPos.Magnitude > 0 and (relPos / relPos.Magnitude) or Vector2.new(0, 0)
                joystickThumb.Position = UDim2.new(0.5, clamped.X - 25, 0.5, clamped.Y - 25)
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if joystickActive and input == joystickTouchInput then
            local absPos = joystickBg.AbsolutePosition
            local relPos = input.Position - absPos
            local clampedMag = math.min(relPos.Magnitude, 70)
            local clamped = relPos.Unit * clampedMag
            joystickDirection = clampedMag > 0 and (clamped / clampedMag) or Vector2.new(0, 0)
            joystickThumb.Position = UDim2.new(0.5, clamped.X - 25, 0.5, clamped.Y - 25)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if joystickActive and input == joystickTouchInput then
            joystickActive = false
            joystickTouchInput = nil
            joystickDirection = Vector2.new(0, 0)
            joystickThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
        end
    end)

    -- Up Button
    local upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0, 80, 0, 60)
    upButton.Position = UDim2.new(1, -100, 1, -140)
    upButton.Text = "↑"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    upButton.BackgroundTransparency = 0.3
    upButton.Font = Enum.Font.GothamBold
    upButton.TextSize = 24
    upButton.BorderSizePixel = 0
    upButton.Parent = flyControls

    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 8)
    upCorner.Parent = upButton

    -- Down Button
    local downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0, 80, 0, 60)
    downButton.Position = UDim2.new(1, -100, 1, -70)
    downButton.Text = "↓"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    downButton.BackgroundTransparency = 0.3
    downButton.Font = Enum.Font.GothamBold
    downButton.TextSize = 24
    downButton.BorderSizePixel = 0
    downButton.Parent = flyControls

    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 8)
    downCorner.Parent = downButton

    -- Up/Down Press Logic
    upButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            upPressed = true
            upButton.BackgroundTransparency = 0.1
        end
    end)

    upButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            upPressed = false
            upButton.BackgroundTransparency = 0.3
        end
    end)

    downButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            downPressed = true
            downButton.BackgroundTransparency = 0.1
        end
    end)

    downButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            downPressed = false
            downButton.BackgroundTransparency = 0.3
        end
    end)
end

local function destroyFlyControls()
    if flyControls then
        flyControls:Destroy()
        flyControls = nil
        joystickBg = nil
        joystickThumb = nil
        joystickActive = false
        joystickTouchInput = nil
        joystickDirection = Vector2.new(0, 0)
        upPressed = false
        downPressed = false
    end
end

-- Improved Fly Functions
local currentVelocity = Vector3.new(0, 0, 0)
local flyConnection = nil

local function updateFly()
    if not isFlying then return end
    local direction = Vector3.new(0, 0, 0)
    local camera = Workspace.CurrentCamera
    local camLook = camera.CFrame.LookVector
    local camRight = camera.CFrame.RightVector

    if not isMobile then
        -- PC Keyboard Controls
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
    else
        -- Mobile Joystick + Buttons
        local moveVector = Vector3.new(joystickDirection.X, 0, -joystickDirection.Y)  -- Y inverted for forward
        local horizontalDir = camera.CFrame:VectorToWorldSpace(moveVector)
        direction = direction + horizontalDir
        if upPressed then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if downPressed then
            direction = direction - Vector3.new(0, 1, 0)
        end
    end

    local targetVelocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.new(0, 0, 0)
    currentVelocity = currentVelocity:Lerp(targetVelocity, RunService.Heartbeat:Wait() / accelerationTime)
    bodyVelocity.Velocity = currentVelocity
    bodyGyro.CFrame = camera.CFrame
end

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
    currentVelocity = Vector3.new(0, 0, 0)
    flyConnection = RunService.Heartbeat:Connect(updateFly)
    createFlyControls()
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
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    destroyFlyControls()
end

-- Noclip Variables
local isNoclip = false
local noclipConnection = nil

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

-- Speed Variables
local isSpeed = false
local customSpeed = 50

-- Speed Functions
local function setSpeed()
    humanoid.WalkSpeed = isSpeed and customSpeed or 16
end

-- ESP Variables
local isEsp = false
local espConnections = {}
local espHighlights = {}

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

-- Jump Power Variables
local isJumpPower = false
local customJumpPower = 50

-- Jump Power Functions
local function setJumpPower()
    if isJumpPower then
        humanoid.JumpPower = customJumpPower
        humanoid.UseJumpPower = true
    else
        humanoid.JumpPower = 50
        humanoid.UseJumpPower = true
    end
end

-- Gravity Variables
local isCustomGravity = false
local customGravity = Workspace.Gravity

-- Gravity Functions
local function setGravity()
    Workspace.Gravity = isCustomGravity and customGravity or 196.2
end

-- Buttons (Larger for touch, TouchTap for mobile)
local function createButton(container, text, callback)
    local button = Instance.new("TextButton")
    local buttonSize = isMobile and UDim2.new(0, 120, 0, 45) or UDim2.new(0, 100, 0, 30)
    button.Size = buttonSize
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = isMobile and 14 or 12
    button.BorderSizePixel = 0
    button.Parent = container

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    button.MouseButton1Click:Connect(callback)
    button.TouchTap:Connect(callback)  -- Mobile support

    return button
end

-- Fly Button
local flyButton = createButton(buttonContainer1, "Fly: OFF", function()
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
local noclipButton = createButton(buttonContainer1, "Noclip: OFF", function()
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
local speedButton = createButton(buttonContainer1, "Speed: OFF", function()
    isSpeed = not isSpeed
    speedButton.Text = "Speed: " .. (isSpeed and "ON" or "OFF")
    speedButton.BackgroundColor3 = isSpeed and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(20, 20, 20)
    setSpeed()
end)

-- ESP Button
local espButton = createButton(buttonContainer2, "ESP: OFF", function()
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
local jumpButton = createButton(buttonContainer2, "Jump: OFF", function()
    isJumpPower = not isJumpPower
    jumpButton.Text = "Jump: " .. (isJumpPower and "ON" or "OFF")
    jumpButton.BackgroundColor3 = isJumpPower and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(20, 20, 20)
    setJumpPower()
end)

-- Gravity Button
local gravityButton = createButton(buttonContainer2, "Gravity: OFF", function()
    isCustomGravity = not isCustomGravity
    gravityButton.Text = "Gravity: " .. (isCustomGravity and "ON" or "OFF")
    gravityButton.BackgroundColor3 = isCustomGravity and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(20, 20, 20)
    setGravity()
end)

-- Input Creation Helper
local function createInput(container, labelText, defaultValue, onChange)
    local inputFrame = Instance.new("Frame")
    local frameSize = isMobile and UDim2.new(0, 220, 0, 35) or UDim2.new(0, 150, 0, 25)
    inputFrame.Size = frameSize
    inputFrame.BackgroundTransparency = 1
    inputFrame.Parent = container

    local label = Instance.new("TextLabel")
    local labelSize = isMobile and UDim2.new(0, 100, 1, 0) or UDim2.new(0, 75, 1, 0)
    label.Size = labelSize
    label.Text = labelText
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = isMobile and 14 or 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BorderSizePixel = 0
    label.Parent = inputFrame

    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 8)
    labelCorner.Parent = label

    local inputBox = Instance.new("TextBox")
    local inputSize = isMobile and UDim2.new(0, 110, 1, 0) or UDim2.new(0, 65, 1, 0)
    inputBox.Size = inputSize
    inputBox.Position = UDim2.new(1, -inputSize.X.Offset, 0, 0)
    inputBox.Text = tostring(defaultValue)
    inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = isMobile and 14 or 10
    inputBox.BorderSizePixel = 0
    inputBox.Parent = inputFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBox

    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local value = tonumber(inputBox.Text)
            if value and value >= 0 then
                onChange(value)
            else
                inputBox.Text = tostring(defaultValue)
            end
        end
    end)

    return inputBox
end

-- Fly Speed Input
local flySpeedInput = createInput(inputContainer, "Fly Speed:", flySpeed, function(value)
    flySpeed = value
end)

-- Walk Speed Input
local speedInput = createInput(inputContainer, "Walk Speed:", customSpeed, function(value)
    customSpeed = value
    setSpeed()
end)

-- Jump Power Input
local jumpInput = createInput(inputContainer, "Jump Power:", customJumpPower, function(value)
    customJumpPower = value
    setJumpPower()
end)

-- Gravity Input
local gravityInput = createInput(inputContainer, "Gravity:", customGravity, function(value)
    customGravity = value
    setGravity()
end)

-- Handle Character Reset
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    if isFlying then
        -- Restart fly on respawn
        stopFly()
        wait(0.1)
        startFly()
    end
    if isNoclip then
        startNoclip()
    end
    setSpeed()
    setJumpPower()
end)

-- Clean up on script end
game:BindToClose(function()
    stopFly()
    stopNoclip()
    stopEsp()
    setSpeed()
    setJumpPower()
    setGravity()
end)

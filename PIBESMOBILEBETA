local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Detect if mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

print("Script started, isMobile:", isMobile) -- Debug

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Name = "LosPibesGUI"
screenGui.ResetOnSpawn = false

print("ScreenGui created") -- Debug

-- Loading Screen (smaller for mobile)
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 200, 0, 80)
loadingFrame.Position = UDim2.new(0.5, -100, 0.5, -40)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 0.2
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 10)
loadingCorner.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 25)
loadingText.Position = UDim2.new(0, 0, 0, 8)
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 16
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
progressBarFrame.Size = UDim2.new(0.9, 0, 0, 8)
progressBarFrame.Position = UDim2.new(0.05, 0, 0, 40)
progressBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBarFrame.BorderSizePixel = 0
progressBarFrame.Parent = loadingFrame

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 4)
progressBarCorner.Parent = progressBarFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarFrame

local progressBarInnerCorner = Instance.new("UICorner")
progressBarInnerCorner.CornerRadius = UDim.new(0, 4)
progressBarInnerCorner.Parent = progressBar

local progressBarStroke = Instance.new("UIStroke")
progressBarStroke.Color = Color3.fromRGB(255, 255, 255)
progressBarStroke.Thickness = 1.2
progressBarStroke.Transparency = 0.7
progressBarStroke.Parent = progressBar

-- Main GUI Frame (smaller for mobile)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, -125, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 1
frame.ClipsDescendants = true
frame.Visible = false
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 1.2
uiStroke.Parent = frame

local function updateRainbow()
    local hue = (tick() % 5) / 5
    uiStroke.Color = Color3.fromHSV(hue, 1, 1)
end
RunService.Heartbeat:Connect(updateRainbow)

-- Close Button (smaller, use Activated for mobile)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 18, 0, 18)
closeButton.Position = UDim2.new(1, -23, 0, 3)
closeButton.Text = "X"
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.ZIndex = 20
closeButton.Active = true
closeButton.Parent = frame

closeButton.Activated:Connect(function()
    print("Close button activated") -- Debug
    toggleGui()
end)

-- Devil Emoji Button (smaller, use Activated)
local devilButton = Instance.new("TextButton")
devilButton.Size = UDim2.new(0, 0, 0, 0)
devilButton.Position = UDim2.new(0, 10, 0, 10)
devilButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
devilButton.Text = "😈"
devilButton.TextColor3 = Color3.fromRGB(255, 255, 255)
devilButton.Font = Enum.Font.GothamBold
devilButton.TextSize = 18
devilButton.BackgroundTransparency = 1
devilButton.TextTransparency = 1
devilButton.Visible = false
devilButton.Parent = screenGui

local devilCorner = Instance.new("UICorner")
devilCorner.CornerRadius = UDim.new(0, 6)
devilCorner.Parent = devilButton

local devilStroke = Instance.new("UIStroke")
devilStroke.Color = Color3.fromRGB(255, 255, 255)
devilStroke.Thickness = 1
devilStroke.Parent = devilButton

-- Devil Button Animation
local function animateDevilButton(show)
    if show then
        devilButton.Visible = true
        devilButton.Size = UDim2.new(0, 0, 0, 0)
        devilButton.BackgroundTransparency = 1
        devilButton.TextTransparency = 1
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(devilButton, tweenInfo, {
            Size = UDim2.new(0, 35, 0, 35),
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

-- Make Devil Button Draggable (support touch)
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

-- Make GUI Draggable (support touch)
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

-- Title (smaller text)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.8, -25, 0, 20)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "LOS PIBES 😈 By DylanElCuervo22 V3"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextScaled = true
title.Parent = frame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 6)
titleCorner.Parent = title

-- Button Container (First Row: Fly, Noclip, Speed - smaller)
local buttonContainer1 = Instance.new("Frame")
buttonContainer1.Size = UDim2.new(1, -8, 0, 25)
buttonContainer1.Position = UDim2.new(0, 4, 0, 22)
buttonContainer1.BackgroundTransparency = 1
buttonContainer1.Parent = frame

local uiListLayout1 = Instance.new("UIListLayout")
uiListLayout1.FillDirection = Enum.FillDirection.Horizontal
uiListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout1.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout1.Padding = UDim.new(0, 4)
uiListLayout1.Parent = buttonContainer1

-- Button Container (Second Row: ESP, Jump, Gravity - smaller)
local buttonContainer2 = Instance.new("Frame")
buttonContainer2.Size = UDim2.new(1, -8, 0, 25)
buttonContainer2.Position = UDim2.new(0, 4, 0, 49)
buttonContainer2.BackgroundTransparency = 1
buttonContainer2.Parent = frame

local uiListLayout2 = Instance.new("UIListLayout")
uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout2.Padding = UDim.new(0, 4)
uiListLayout2.Parent = buttonContainer2

-- Input Container (smaller)
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, -8, 0, 60)
inputContainer.Position = UDim2.new(0, 4, 0, 76)
inputContainer.BackgroundTransparency = 1
inputContainer.Parent = frame

local inputListLayout = Instance.new("UIListLayout")
inputListLayout.FillDirection = Enum.FillDirection.Horizontal
inputListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
inputListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
inputListLayout.Padding = UDim.new(0, 4)
inputListLayout.Wraps = true
inputListLayout.Parent = inputContainer

-- Loading Animation
local function playLoadingAnimation(callback)
    print("Starting loading animation") -- Debug
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
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -100, 0.5, -80)
        })
        local textFadeTween = TweenService:Create(loadingText, fadeOutInfo, {
            TextTransparency = 1
        })
        fadeOutTween:Play()
        textFadeTween:Play()
        fadeOutTween.Completed:Connect(function()
            loadingFrame.Visible = false
            print("Loading complete, showing GUI") -- Debug
            callback()
        end)
    end)
end

-- GUI Animation (smaller size)
local function animateGui(show)
    print("Animating GUI, show:", show) -- Debug
    if show then
        frame.Visible = true
        frame.Size = UDim2.new(0, 0, 0, 0)
        frame.BackgroundTransparency = 1
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(frame, tweenInfo, {
            Size = UDim2.new(0, 250, 0, 140),
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
    wait(0.1) -- Small delay for mobile
    animateGui(true)
    animateDevilButton(false)
end)

-- RShift Toggle and Devil Button Logic (RightShift for PC, devil for mobile)
local isGuiVisible = true
local function toggleGui()
    print("Toggling GUI") -- Debug
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

devilButton.Activated:Connect(function()
    print("Devil button activated") -- Debug
    toggleGui()
end)

-- Fly Variables
local isFlying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local accelerationTime = 0.2

-- Direction flags for fly (for both PC and mobile)
local forward = false
local backward = false
local left = false
local right = false
local up = false
local down = false

-- Fly Controls GUI for mobile
local flyControls = Instance.new("Frame")
flyControls.Size = UDim2.new(0, 150, 0, 150)
flyControls.Position = UDim2.new(0, 10, 1, -160)
flyControls.BackgroundTransparency = 1
flyControls.Visible = false
flyControls.Parent = screenGui

-- Create direction buttons for mobile
local function createFlyButton(name, pos, key)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 40, 0, 40)
    button.Position = pos
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = flyControls
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button

    button.TouchTap:Connect(function()
        if key == "W" then forward = not forward
        elseif key == "S" then backward = not backward
        elseif key == "A" then left = not left
        elseif key == "D" then right = not right
        elseif key == "Space" then up = not up
        elseif key == "Ctrl" then down = not down
        end
    end)

    return button
end

-- Add buttons (toggle style for easier mobile use)
createFlyButton("↑", UDim2.new(0.5, -20, 0.2, 0), "W")
createFlyButton("↓", UDim2.new(0.5, -20, 0.8, 0), "S")
createFlyButton("←", UDim2.new(0.2, 0, 0.5, -20), "A")
createFlyButton("→", UDim2.new(0.8, -40, 0.5, -20), "D")
createFlyButton("Up", UDim2.new(0.5, -20, 0.05, 0), "Space")
createFlyButton("Dn", UDim2.new(0.5, -20, 0.95, 0), "Ctrl")

-- Improved Fly Functions (Camera-Based, support mobile)
local function startFly()
    if isFlying then return end
    print("Starting fly") -- Debug
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

    if isMobile then
        flyControls.Visible = true
    end

    local function updateFly(deltaTime)
        if not isFlying then return end
        local direction = Vector3.new()
        local camera = Workspace.CurrentCamera
        local camLook = camera.CFrame.LookVector
        local camRight = camera.CFrame.RightVector

        local isForward = forward or (not isMobile and UserInputService:IsKeyDown(Enum.KeyCode.W))
        local isBackward = backward or (not isMobile and UserInputService:IsKeyDown(Enum.KeyCode.S))
        local isLeft = left or (not isMobile and UserInputService:IsKeyDown(Enum.KeyCode.A))
        local isRight = right or (not isMobile and UserInputService:IsKeyDown(Enum.KeyCode.D))
        local isUp = up or (not isMobile and UserInputService:IsKeyDown(Enum.KeyCode.Space))
        local isDown = down or (not isMobile and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl))

        if isForward then direction = direction + camLook end
        if isBackward then direction = direction - camLook end
        if isLeft then direction = direction - camRight end
        if isRight then direction = direction + camRight end
        if isUp then direction = direction + Vector3.new(0, 1, 0) end
        if isDown then direction = direction - Vector3.new(0, 1, 0) end

        local targetVelocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.new(0, 0, 0)
        currentVelocity = currentVelocity:Lerp(targetVelocity, deltaTime / accelerationTime)
        bodyVelocity.Velocity = currentVelocity
        bodyGyro.CFrame = camera.CFrame
    end

    RunService:BindToRenderStep("FlyUpdate", Enum.RenderPriority.Input.Value, updateFly)
end

local function stopFly()
    print("Stopping fly") -- Debug
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
    if isMobile then
        flyControls.Visible = false
    end
    forward = false
    backward = false
    left = false
    right = false
    up = false
    down = false
end

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

-- Fly Button (smaller, use Activated)
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 80, 0, 20)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 10
flyButton.Parent = buttonContainer1
local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 5)
flyCorner.Parent = flyButton

flyButton.Activated:Connect(function()
    print("Fly button activated") -- Debug
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

-- Noclip Button (smaller, use Activated)
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 80, 0, 20)
noclipButton.Text = "Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.Gotham
noclipButton.TextSize = 10
noclipButton.Parent = buttonContainer1
local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 5)
noclipCorner.Parent = noclipButton

noclipButton.Activated:Connect(function()
    print("Noclip button activated") -- Debug
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

-- Speed Button (smaller, use Activated)
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 80, 0, 20)
speedButton.Text = "Speed: OFF"
speedButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 10
speedButton.Parent = buttonContainer1
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 5)
speedCorner.Parent = speedButton

speedButton.Activated:Connect(function()
    print("Speed button activated") -- Debug
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

-- ESP Button (smaller, use Activated)
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 80, 0, 20)
espButton.Text = "ESP: OFF"
espButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.Gotham
espButton.TextSize = 10
espButton.Parent = buttonContainer2
local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 5)
espCorner.Parent = espButton

espButton.Activated:Connect(function()
    print("ESP button activated") -- Debug
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

-- Jump Power Button (smaller, use Activated)
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0, 80, 0, 20)
jumpButton.Text = "Jump: OFF"
jumpButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.Font = Enum.Font.Gotham
jumpButton.TextSize = 10
jumpButton.Parent = buttonContainer2
local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 5)
jumpCorner.Parent = jumpButton

jumpButton.Activated:Connect(function()
    print("Jump button activated") -- Debug
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

-- Gravity Button (smaller, use Activated)
local gravityButton = Instance.new("TextButton")
gravityButton.Size = UDim2.new(0, 80, 0, 20)
gravityButton.Text = "Gravity: OFF"
gravityButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
gravityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityButton.Font = Enum.Font.Gotham
gravityButton.TextSize = 10
gravityButton.Parent = buttonContainer2
local gravityCorner = Instance.new("UICorner")
gravityCorner.CornerRadius = UDim.new(0, 5)
gravityCorner.Parent = gravityButton

gravityButton.Activated:Connect(function()
    print("Gravity button activated") -- Debug
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

-- Fly Speed Input (smaller)
local flySpeedContainer = Instance.new("Frame")
flySpeedContainer.Size = UDim2.new(0, 120, 0, 18)
flySpeedContainer.BackgroundTransparency = 1
flySpeedContainer.Parent = inputContainer

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0, 60, 0, 18)
flySpeedLabel.Text = "Fly Spd:"
flySpeedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextSize = 9
flySpeedLabel.Parent = flySpeedContainer
local flySpeedLabelCorner = Instance.new("UICorner")
flySpeedLabelCorner.CornerRadius = UDim.new(0, 5)
flySpeedLabelCorner.Parent = flySpeedLabel

local flySpeedInput = Instance.new("TextBox")
flySpeedInput.Size = UDim2.new(0, 55, 0, 18)
flySpeedInput.Position = UDim2.new(1, -55, 0, 0)
flySpeedInput.Text = tostring(flySpeed)
flySpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
flySpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedInput.Font = Enum.Font.Gotham
flySpeedInput.TextSize = 9
flySpeedInput.Parent = flySpeedContainer
local flySpeedInputCorner = Instance.new("UICorner")
flySpeedInputCorner.CornerRadius = UDim.new(0, 5)
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

-- Walk Speed Input (smaller)
local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(0, 120, 0, 18)
speedContainer.BackgroundTransparency = 1
speedContainer.Parent = inputContainer

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 60, 0, 18)
speedLabel.Text = "Walk Spd:"
speedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 9
speedLabel.Parent = speedContainer
local speedLabelCorner = Instance.new("UICorner")
speedLabelCorner.CornerRadius = UDim.new(0, 5)
speedLabelCorner.Parent = speedLabel

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 55, 0, 18)
speedInput.Position = UDim2.new(1, -55, 0, 0)
speedInput.Text = tostring(customSpeed)
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 9
speedInput.Parent = speedContainer
local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 5)
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

-- Jump Power Input (smaller)
local jumpContainer = Instance.new("Frame")
jumpContainer.Size = UDim2.new(0, 120, 0, 18)
jumpContainer.BackgroundTransparency = 1
jumpContainer.Parent = inputContainer

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 60, 0, 18)
jumpLabel.Text = "Jump Pwr:"
jumpLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 9
jumpLabel.Parent = jumpContainer
local jumpLabelCorner = Instance.new("UICorner")
jumpLabelCorner.CornerRadius = UDim.new(0, 5)
jumpLabelCorner.Parent = jumpLabel

local jumpInput = Instance.new("TextBox")
jumpInput.Size = UDim2.new(0, 55, 0, 18)
jumpInput.Position = UDim2.new(1, -55, 0, 0)
jumpInput.Text = tostring(customJumpPower)
jumpInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
jumpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpInput.Font = Enum.Font.Gotham
jumpInput.TextSize = 9
jumpInput.Parent = jumpContainer
local jumpInputCorner = Instance.new("UICorner")
jumpInputCorner.CornerRadius = UDim.new(0, 5)
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

-- Gravity Input (smaller)
local gravityContainer = Instance.new("Frame")
gravityContainer.Size = UDim2.new(0, 120, 0, 18)
gravityContainer.BackgroundTransparency = 1
gravityContainer.Parent = inputContainer

local gravityLabel = Instance.new("TextLabel")
gravityLabel.Size = UDim2.new(0, 60, 0, 18)
gravityLabel.Text = "Gravity:"
gravityLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
gravityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityLabel.Font = Enum.Font.Gotham
gravityLabel.TextSize = 9
gravityLabel.Parent = gravityContainer
local gravityLabelCorner = Instance.new("UICorner")
gravityLabelCorner.CornerRadius = UDim.new(0, 5)
gravityLabelCorner.Parent = gravityLabel

local gravityInput = Instance.new("TextBox")
gravityInput.Size = UDim2.new(0, 55, 0, 18)
gravityInput.Position = UDim2.new(1, -55, 0, 0)
gravityInput.Text = tostring(customGravity)
gravityInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
gravityInput.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityInput.Font = Enum.Font.Gotham
gravityInput.TextSize = 9
gravityInput.Parent = gravityContainer
local gravityInputCorner = Instance.new("UICorner")
gravityInputCorner.CornerRadius = UDim.new(0, 5)
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

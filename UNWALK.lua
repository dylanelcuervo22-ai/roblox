-- MADE BY EL FUCKING DYLAN EL CUERVO 22 BABYS WOOOHOOOOOOOO

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local disabled = false
local walkId, runId, jumpId, fallId = nil, nil, nil, nil

local walkFallback = "rbxassetid://2510202577"
local runFallback = "rbxassetid://507767714"
local jumpFallback = "rbxassetid://507765000"
local fallFallback = "rbxassetid://507767968"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToggleWalkGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 55)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BackgroundTransparency = 0.4
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(60, 60, 60)
frameStroke.Thickness = 1
frameStroke.Transparency = 0.4
frameStroke.Parent = frame

-- Botón ocupa TODO el frame (solo letras + fondo)
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
button.BackgroundTransparency = 0.3
button.Text = "Unwalk Animation"
button.TextColor3 = Color3.fromRGB(240, 240, 240)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.BorderSizePixel = 0
button.TextStrokeTransparency = 0.8
button.Parent = frame

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(80, 80, 80)
btnStroke.Thickness = 1.5
btnStroke.Transparency = 0.5
btnStroke.Parent = button

-- Draggable TOTAL (funciona en PC/Mobile/Touch)
local dragging = false
local dragStart = nil
local startPos = nil

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Efecto brillo al tocar (PC/Mobile)
local pressTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local releaseTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local savedProps = nil

button.MouseButton1Down:Connect(function()
    savedProps = {
        bgColor = button.BackgroundColor3,
        strokeColor = btnStroke.Color,
        thickness = btnStroke.Thickness,
        transp = btnStroke.Transparency
    }
    TweenService:Create(button, pressTweenInfo, {BackgroundColor3 = Color3.fromRGB(120, 120, 120)}):Play()
    TweenService:Create(btnStroke, pressTweenInfo, {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 3,
        Transparency = 0.1
    }):Play()
end)

button.MouseButton1Up:Connect(function()
    if savedProps then
        TweenService:Create(button, releaseTweenInfo, {BackgroundColor3 = savedProps.bgColor}):Play()
        TweenService:Create(btnStroke, releaseTweenInfo, {
            Color = savedProps.strokeColor,
            Thickness = savedProps.thickness,
            Transparency = savedProps.transp
        }):Play()
        savedProps = nil
    end
end)

-- Funciones anim
local function interrupt(hum)
    local speed = hum.WalkSpeed
    hum.WalkSpeed = 0
    task.wait(0.05)
    hum.WalkSpeed = speed
end

local function setEnabled(enabled)
    local char = player.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    
    -- Walk
    local walkFolder = animate:FindFirstChild("walk")
    if walkFolder then
        local walkAnim = walkFolder:FindFirstChild("WalkAnim")
        if walkAnim then
            walkAnim.AnimationId = enabled and (walkId or walkFallback) or "rbxassetid://0"
        end
    end
    
    -- Run
    local runFolder = animate:FindFirstChild("run")
    if runFolder then
        local runAnim = runFolder:FindFirstChild("RunAnim")
        if runAnim then
            runAnim.AnimationId = enabled and (runId or runFallback) or "rbxassetid://0"
        end
    end
    
    -- Jump
    local jumpFolder = animate:FindFirstChild("jump")
    if jumpFolder then
        local jumpAnim = jumpFolder:FindFirstChild("JumpAnim")
        if jumpAnim then
            jumpAnim.AnimationId = enabled and (jumpId or jumpFallback) or "rbxassetid://0"
        end
    end
    
    -- Fall (para inmóvil completo en aire)
    local fallFolder = animate:FindFirstChild("fall")
    if fallFolder then
        local fallAnim = fallFolder:FindFirstChild("FallAnim")
        if fallAnim then
            fallAnim.AnimationId = enabled and (fallId or fallFallback) or "rbxassetid://0"
        end
    end
end

local function toggleAnim()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    disabled = not disabled
    setEnabled(not disabled)
    interrupt(hum)
    button.Text = disabled and "Restore Walk Animation" or "Unwalk Animation"
    button.BackgroundColor3 = disabled and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(65, 65, 65)
end

button.MouseButton1Click:Connect(toggleAnim)

-- Respawn handler
local function onCharacterAdded(char)
    task.spawn(function()
        char:WaitForChild("Humanoid", 10)
        local animate = char:WaitForChild("Animate", 10)
        task.wait(0.5)
        
        -- Guarda originales del personaje actual
        local walkFolder = animate:FindFirstChild("walk")
        if walkFolder then
            local walkAnim = walkFolder:FindFirstChild("WalkAnim")
            if walkAnim then walkId = walkAnim.AnimationId end
        end
        local runFolder = animate:FindFirstChild("run")
        if runFolder then
            local runAnim = runFolder:FindFirstChild("RunAnim")
            if runAnim then runId = runAnim.AnimationId end
        end
        local jumpFolder = animate:FindFirstChild("jump")
        if jumpFolder then
            local jumpAnim = jumpFolder:FindFirstChild("JumpAnim")
            if jumpAnim then jumpId = jumpAnim.AnimationId end
        end
        local fallFolder = animate:FindFirstChild("fall")
        if fallFolder then
            local fallAnim = fallFolder:FindFirstChild("FallAnim")
            if fallAnim then fallId = fallAnim.AnimationId end
        end
        
        -- Aplica si disabled
        if disabled then
            setEnabled(false)
        end
        interrupt(char:FindFirstChildOfClass("Humanoid"))
    end)
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

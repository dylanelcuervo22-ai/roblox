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

local button = Instance.new("TextButton")
button.Name = "ToggleBtn"
button.Size = UDim2.new(0, 280, 0, 70)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
button.BackgroundTransparency = 0.3
button.TextColor3 = Color3.fromRGB(0, 0, 0) -- Negro
button.TextScaled = false
button.TextSize = 18 -- Letra más pequeña
button.Font = Enum.Font.Arial
button.Text = "Unwalk Animation"
button.BorderSizePixel = 1
button.BorderColor3 = Color3.fromRGB(0, 0, 0)
button.Parent = screenGui

-- Draggable TOTAL (funciona en PC/Mobile/Touch) - Versión original tuya
local dragging = false
local dragStart = nil
local startPos = nil
local moveConnection = nil
local UserInputService = game:GetService("UserInputService")
local Mouse = player:GetMouse()

button.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = Vector2.new(Mouse.X, Mouse.Y)
        startPos = button.Position
        moveConnection = Mouse.Move:Connect(function()
            if not dragging then return end
            local currentPos = Vector2.new(Mouse.X, Mouse.Y)
            local delta = currentPos - dragStart
            button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end)
    end
end)

button.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if moveConnection then
            moveConnection:Disconnect()
            moveConnection = nil
        end
        dragging = false
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
  
    local walkFolder = animate:FindFirstChild("walk")
    if walkFolder then
        local walkAnim = walkFolder:FindFirstChild("WalkAnim")
        if walkAnim then
            walkAnim.AnimationId = enabled and (walkId or walkFallback) or "rbxassetid://0"
        end
    end
  
    local runFolder = animate:FindFirstChild("run")
    if runFolder then
        local runAnim = runFolder:FindFirstChild("RunAnim")
        if runAnim then
            runAnim.AnimationId = enabled and (runId or runFallback) or "rbxassetid://0"
        end
    end
  
    local jumpFolder = animate:FindFirstChild("jump")
    if jumpFolder then
        local jumpAnim = jumpFolder:FindFirstChild("JumpAnim")
        if jumpAnim then
            jumpAnim.AnimationId = enabled and (jumpId or jumpFallback) or "rbxassetid://0"
        end
    end
  
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

    -- AQUÍ ESTÁ EL ÚNICO CAMBIO QUE PEDISTE:
    button.Text = disabled and "Restore Walk Animation" or "Unwalk Animation"
    -- Ya no toca el BackgroundColor3 en ningún momento
end

button.MouseButton1Click:Connect(toggleAnim)

-- Respawn handler (exactamente igual que el tuyo)
local function onCharacterAdded(char)
    task.spawn(function()
        char:WaitForChild("Humanoid", 10)
        local animate = char:WaitForChild("Animate", 10)
        task.wait(0.5)
      
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

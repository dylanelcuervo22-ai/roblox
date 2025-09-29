local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local flySpeed = 50
local flyEnabled = false
local noclipEnabled = false
local upPressed = false
local downPressed = false
local bodyVelocity = nil
local noclipConnection = nil
local flyConnection = nil

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileHackGUI"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Función para crear botón
local function createButton(parent, text, size, position, callback)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    -- Efecto hover/touch
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 100, 200)}):Play()
    end)
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 162, 255)}):Play()
    end)
    
    if callback then
        button.Activated:Connect(callback)
    end
    
    return button
end

-- Botones
local flyButton = createButton(mainFrame, "Fly: OFF", UDim2.new(0, 0, 0, 40), UDim2.new(0, 10, 0, 10), function()
    flyEnabled = not flyEnabled
    flyButton.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = flyEnabled
        end
        toggleFly(character)
    end
end)

local noclipButton = createButton(mainFrame, "Noclip: OFF", UDim2.new(0, 0, 0, 40), UDim2.new(0, 10, 0, 55), function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
    local character = player.Character
    if character then
        toggleNoclip(character)
    end
end)

local upButton = createButton(mainFrame, "Arriba", UDim2.new(0, 80, 0, 40), UDim2.new(0, 10, 0, 100))
upButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
upButton.MouseButton1Down:Connect(function() upPressed = true end)
upButton.MouseButton1Up:Connect(function() upPressed = false end)
upButton.Activated:Connect(function() upPressed = not upPressed end) -- Fallback para tap

local downButton = createButton(mainFrame, "Abajo", UDim2.new(0, 80, 0, 40), UDim2.new(0, 100, 0, 100))
downButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
downButton.MouseButton1Down:Connect(function() downPressed = true end)
downButton.MouseButton1Up:Connect(function() downPressed = false end)
downButton.Activated:Connect(function() downPressed = not downPressed end) -- Fallback

-- Funciones Fly
local function createFly(character)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    humanoid.PlatformStand = true
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled or not rootPart or not rootPart.Parent then return end
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        local horizontal = humanoid.MoveDirection * flySpeed
        local vertical = 0
        if upPressed then
            vertical = flySpeed
        elseif downPressed then
            vertical = -flySpeed
        end
        
        bodyVelocity.Velocity = horizontal + Vector3.new(0, vertical, 0)
    end)
end

local function removeFly()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

function toggleFly(character)
    if flyEnabled then
        createFly(character)
    else
        removeFly()
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
end

-- Funciones Noclip
local function createNoclip(character)
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

local function removeNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

function toggleNoclip(character)
    if noclipEnabled then
        createNoclip(character)
    else
        removeNoclip()
        -- Opcional: restaurar colisiones, pero en hacks no siempre
    end
end

-- Manejar respawn
player.CharacterAdded:Connect(function(character)
    removeFly()
    removeNoclip()
    upPressed = false
    downPressed = false
    
    local humanoid = character:WaitForChild("Humanoid")
    
    if flyEnabled then
        createFly(character)
    end
    if noclipEnabled then
        createNoclip(character)
    end
end)

-- Inicializar si ya hay character
if player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        if flyEnabled then
            createFly(player.Character)
        end
        if noclipEnabled then
            createNoclip(player.Character)
        end
    end
end

print("GUI Mobile cargada. Usa los botones para Fly, Noclip, Arriba y Abajo.")

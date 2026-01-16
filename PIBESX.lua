local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = nil
local rootPart = nil
local humanoid = nil
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil
local noclipConnection = nil
local jumpConnection = nil
local flySpeed = 50 -- Velocidad de vuelo (ajusta aquí)
local JUMP_VELOCITY = 75 -- Altura del salto infinito (ajusta aquí)
local DEADZONE = 0.20 -- Deadzone del stick izquierdo (anti-drift)
local isFlying = false
local isNoclipping = false
local isInfiniteJump = false
local heldButtons = {}
local currentVelocity = Vector3.new(0, 0, 0)
local accelerationTime = 0.2
local lastJumpToggle = 0
local JUMP_DEBOUNCE = 0.3

-- Función MEJORADA para actualizar el movimiento en vuelo (con DEADZONE 0.20 en stick L)
local function updateFly(deltaTime)
    if not char or not rootPart or not bodyVelocity or not bodyGyro then return end
    local camera = workspace.CurrentCamera
    local gamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
    if not gamepadState then return end
    
    -- Mapa de inputs
    local inputs = {}
    for _, input in ipairs(gamepadState) do
        inputs[input.KeyCode] = input
    end
    
    -- Thumbstick izquierdo CON DEADZONE
    local thumbstick1 = inputs[Enum.KeyCode.Thumbstick1] or {Position = Vector3.new(0, 0, 0)}
    local leftThumb = thumbstick1.Position
    local mag = leftThumb.Magnitude
    if mag > DEADZONE then
        local scaledMag = (mag - DEADZONE) / (1 - DEADZONE)
        leftThumb = leftThumb.Unit * scaledMag
    else
        leftThumb = Vector3.new(0, 0, 0)
    end
    
    -- Gatillos analógicos (Z = 0-1)
    local rightTrigger = (inputs[Enum.KeyCode.ButtonR2] and inputs[Enum.KeyCode.ButtonR2].Position.Z) or 0
    local leftTrigger = (inputs[Enum.KeyCode.ButtonL2] and inputs[Enum.KeyCode.ButtonL2].Position.Z) or 0
    local vertical = (rightTrigger - leftTrigger)
    
    -- Dirección horizontal relativa a cámara
    local camLook = camera.CFrame.LookVector
    local camRight = camera.CFrame.RightVector
    local horizDir = (camLook * leftThumb.Y) + (camRight * leftThumb.X)
    
    -- Dirección total
    local direction = horizDir + Vector3.new(0, vertical, 0)
    
    -- Velocidad objetivo constante (capada)
    local targetVelocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.new(0, 0, 0)
    
    -- Aceleración suave
    currentVelocity = currentVelocity:Lerp(targetVelocity, math.min(deltaTime / accelerationTime, 1))
    
    bodyVelocity.Velocity = currentVelocity
    bodyGyro.CFrame = camera.CFrame
end

-- Activar Fly
local function enableFly()
    char = player.Character
    if not char then return end
    rootPart = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    
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
    flyConnection = RunService.RenderStepped:Connect(updateFly)
    isFlying = true
    print("🛫 Fly ACTIVADO (con DEADZONE 0.20 anti-drift, aceleración suave y velocidad constante)")
end

-- Desactivar Fly
local function disableFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if humanoid then
        humanoid.PlatformStand = false
    end
    isFlying = false
    currentVelocity = Vector3.new(0, 0, 0)
    print("🛬 Fly DESACTIVADO")
end

-- Toggle Fly
local function toggleFly()
    if isFlying then
        disableFly()
    else
        enableFly()
    end
end

-- Noclip
local function updateNoclip()
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Activar Noclip
local function enableNoclip()
    noclipConnection = RunService.Stepped:Connect(updateNoclip)
    isNoclipping = true
    print("👻 Noclip ACTIVADO (todas las partes)")
end

-- Desactivar Noclip
local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    isNoclipping = false
    print("👻 Noclip DESACTIVADO")
end

-- Toggle Noclip
local function toggleNoclip()
    if isNoclipping then
        disableNoclip()
    else
        enableNoclip()
    end
end

-- Infinite Jump MEJORADO (usa AssemblyLinearVelocity para compatibilidad R15/moderno)
local function enableInfiniteJump()
    if not humanoid or not rootPart then return end
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if rootPart and not isFlying then
            local vel = rootPart.AssemblyLinearVelocity
            rootPart.AssemblyLinearVelocity = Vector3.new(vel.X, JUMP_VELOCITY, vel.Z)
        end
    end)
    isInfiniteJump = true
    print("🦘 Infinite Jump ACTIVADO (salto alto infinito en el aire - funciona siempre)")
end

local function disableInfiniteJump()
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
    isInfiniteJump = false
    print("🦘 Infinite Jump DESACTIVADO")
end

local function toggleInfiniteJump()
    local currentTime = tick()
    if currentTime - lastJumpToggle < JUMP_DEBOUNCE then return end
    lastJumpToggle = currentTime
    
    if isInfiniteJump then
        disableInfiniteJump()
    else
        enableInfiniteJump()
    end
end

-- Inputs Gamepad
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        heldButtons[input.KeyCode] = true
        
        -- Fly: R1 + X (Cuadrado/Xbox X)
        if input.KeyCode == Enum.KeyCode.ButtonX and heldButtons[Enum.KeyCode.ButtonR1] then
            toggleFly()
        end
        
        -- Noclip: R1 + B (Círculo/Xbox B)
        if input.KeyCode == Enum.KeyCode.ButtonB and heldButtons[Enum.KeyCode.ButtonR1] then
            toggleNoclip()
        end
        
        -- Infinite Jump: R1 + Y (Triángulo/Xbox Y)
        if input.KeyCode == Enum.KeyCode.ButtonY and heldButtons[Enum.KeyCode.ButtonR1] then
            toggleInfiniteJump()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        heldButtons[input.KeyCode] = false
    end
end)

-- Respawn
local function onCharacterAdded(newChar)
    char = newChar
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    disableFly()
    disableNoclip()
    disableInfiniteJump()
    print("🔄 Personaje respawneado - Reactiva con R1 + botones")
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

print("🎮 Script ULTRA MEJORADO cargado!")
print("Controles: R1 + X (Fly suave con DEADZONE 0.20 anti-drift), R1 + B (Noclip total), R1 + Y (Triángulo/Y - Infinite Jump alto)")
print("Fly: Stick L (mover con cámara, deadzone 0.20), R2 sube, L2 baja. Velocidad capada 50.")
print("Infinite Jump: Actívalo con R1+Y, luego presiona A/Cruz para saltar INFINITAMENTE (incluso en aire). Usa AssemblyLinearVelocity.")
print("Executor debe soportar UserInputService/RunService.")

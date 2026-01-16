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
local flySpeed = 50 -- Velocidad de vuelo (ajusta aquí)
local isFlying = false
local isNoclipping = false
local heldButtons = {}
local currentVelocity = Vector3.new(0, 0, 0)
local maxAcceleration = 100 -- No se usa actualmente, pero se puede integrar si es necesario
local accelerationTime = 0.2

-- Función MEJORADA para actualizar el movimiento en vuelo (con aceleración suave y BodyGyro)
local function updateFly(deltaTime)
    if not char or not rootPart or not bodyVelocity or not bodyGyro then return end
    local camera = workspace.CurrentCamera
    local gamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
    if not gamepadState then return end
    
    -- Crear un mapa para acceder a los inputs fácilmente
    local inputs = {}
    for _, input in ipairs(gamepadState) do
        inputs[input.KeyCode] = input
    end
    
    -- Thumbstick izquierdo
    local thumbstick1 = inputs[Enum.KeyCode.Thumbstick1] or {Position = Vector3.new(0, 0, 0)}
    local leftThumb = thumbstick1.Position
    
    -- Gatillos (usar .Position.Z para el valor analógico)
    local rightTrigger = (inputs[Enum.KeyCode.ButtonR2] and inputs[Enum.KeyCode.ButtonR2].Position.Z) or 0
    local leftTrigger = (inputs[Enum.KeyCode.ButtonL2] and inputs[Enum.KeyCode.ButtonL2].Position.Z) or 0
    local vertical = (rightTrigger - leftTrigger)  -- -1 a 1, proporcional
    
    -- Dirección horizontal relativa a la cámara (corregido el signo para movimiento forward correcto)
    local localXZ = Vector3.new(leftThumb.X, 0, leftThumb.Y)  -- Cambio: sin negativo en Y para corregir dirección
    local camLook = camera.CFrame.LookVector
    local camRight = camera.CFrame.RightVector
    local horizontal = (camLook * localXZ.Z) + (camRight * localXZ.X)
    
    -- Targets separados para horizontal y vertical (proporcional, max flySpeed cada uno)
    local targetHoriz = horizontal * flySpeed
    local targetVert = Vector3.new(0, vertical * flySpeed, 0)
    local targetVelocity = targetHoriz + targetVert
    
    -- Aceleración suave con Lerp
    currentVelocity = currentVelocity:Lerp(targetVelocity, math.min(deltaTime / accelerationTime, 1))
    
    bodyVelocity.Velocity = currentVelocity
    bodyGyro.CFrame = camera.CFrame
end

-- Activar Fly MEJORADO
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
    flyConnection = RunService.RenderStepped:Connect(updateFly) -- Más suave con RenderStepped
    isFlying = true
    print("🛫 Fly ACTIVADO (Mejorado con aceleración y giro a cámara)")
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

-- Noclip MEJORADO (todas las partes descendientes)
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
    print("👻 Noclip ACTIVADO (Mejorado: todas las partes)")
end

-- Desactivar Noclip (restaura colisiones)
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

-- Manejo de inputs del gamepad
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        heldButtons[input.KeyCode] = true
        
        -- Combo Fly: R1 + X (X en Xbox, Cuadrado en PS)
        if input.KeyCode == Enum.KeyCode.ButtonX and heldButtons[Enum.KeyCode.ButtonR1] then
            toggleFly()
        end
        
        -- Combo Noclip: R1 + B (B en Xbox, Círculo en PS)
        if input.KeyCode == Enum.KeyCode.ButtonB and heldButtons[Enum.KeyCode.ButtonR1] then
            toggleNoclip()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        heldButtons[input.KeyCode] = false
    end
end)

-- Manejar respawn del personaje (mejorado: reactiva si estaba on)
local function onCharacterAdded(newChar)
    char = newChar
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    -- Desactivar todo al respawnear, pero puedes reactivar manualmente
    disableFly()
    disableNoclip()
    print("🔄 Personaje respawneado - Reactiva Fly/Noclip con los botones")
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

print("🎮 Script MEJORADO cargado! Usa R1 + X para Fly suave, R1 + B para Noclip total")
print("Mejoras: Aceleración Lerp, BodyGyro (mira cámara), RenderStepped, Noclip en TODAS las partes.")
print("Correcciones: Acceso correcto a gamepad inputs, signo de movimiento forward, proporcional real en gatillos/stick.")
print("Asegúrate de que tu executor soporte UserInputService/RunService.")

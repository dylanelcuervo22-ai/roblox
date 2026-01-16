-- Script de Roblox para Fly y Noclip con Mando (Gamepad)
-- Controles:
-- Fly: Mantén R1/RB + Presiona X/Cuadrado
-- Noclip: Mantén R1/RB + Presiona B/Círculo
-- Una vez volando:
-- - Stick izquierdo: Movimiento horizontal relativo a la cámara (adelante/atrás/izquierda/derecha)
-- - Gatillo derecho (R2/RT): Subir
-- - Gatillo izquierdo (L2/LT): Bajar
-- Velocidad: 50 (ajustable en la variable 'speed')

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local char = nil
local rootPart = nil
local humanoid = nil
local bodyVelocity = nil
local flyConnection = nil
local noclipConnection = nil
local speed = 50  -- Velocidad de vuelo (ajusta aquí si quieres)
local isFlying = false
local isNoclipping = false
local heldButtons = {}

-- Función para actualizar el movimiento en vuelo
local function updateFly()
    if not char or not rootPart or not bodyVelocity then return end
    local camera = workspace.CurrentCamera
    local gamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
    if not gamepadState then return end
    
    local leftThumb = gamepadState.Thumbstick1.Position
    local localXZ = Vector3.new(leftThumb.X, 0, -leftThumb.Y)
    local moveXZ = camera.CFrame:VectorToWorldSpace(localXZ)
    
    local rightTrigger = gamepadState.ButtonR2.Position or 0
    local leftTrigger = gamepadState.ButtonL2.Position or 0
    local verticalSpeed = (rightTrigger - leftTrigger) * speed
    
    bodyVelocity.Velocity = moveXZ * speed + Vector3.new(0, verticalSpeed, 0)
end

-- Activar Fly
local function enableFly()
    char = player.Character
    if not char then return end
    rootPart = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    humanoid.PlatformStand = true
    flyConnection = RunService.Heartbeat:Connect(updateFly)
    isFlying = true
    print("🛫 Fly ACTIVADO")
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
    if humanoid then
        humanoid.PlatformStand = false
    end
    isFlying = false
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

-- Actualizar Noclip
local function updateNoclip()
    if not char then return end
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then  -- Evita root para estabilidad
            part.CanCollide = false
        end
    end
    if rootPart then
        rootPart.CanCollide = false
    end
end

-- Activar Noclip
local function enableNoclip()
    noclipConnection = RunService.Stepped:Connect(updateNoclip)
    isNoclipping = true
    print("👻 Noclip ACTIVADO")
end

-- Desactivar Noclip
local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
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

-- Manejar respawn del personaje
local function onCharacterAdded(newChar)
    char = newChar
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    -- Desactivar al respawnear
    disableFly()
    disableNoclip()
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

print("🎮 Script cargado! Conecta tu mando y usa R1 + X para Fly, R1 + B para Noclip")
print("Asegúrate de que tu executor soporte UserInputService y RunService.")

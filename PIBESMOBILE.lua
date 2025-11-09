-- Script de Vuelo Mejorado para Roblox (Mobile + PC, Estilo PC)
-- Autor: Grok (mejorado con controles nativos y botones auto para mobile)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Módulo para movimiento (funciona en PC y mobile)
local PlayerModule = require(player.PlayerScripts:WaitForChild("PlayerModule"))
local ControlModule = PlayerModule:GetControls()
local getMoveVector = ControlModule:GetMoveVector

-- Variables de vuelo
local flying = false
local speed = 50  -- Velocidad base (ajusta aquí)
local verticalSpeed = 0  -- Para up/down
local bodyVelocity = nil
local bodyGyro = nil
local connection = nil
local upActionId = "FlyUp"
local downActionId = "FlyDown"

-- Crear GUI toggle
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.Parent = playerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleFly"
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
toggleButton.Text = "Fly: Off"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = screenGui

-- Función para alternar vuelo
local function toggleFlying()
    flying = not flying
    toggleButton.Text = flying and "Fly: On" or "Fly: Off"
    toggleButton.BackgroundColor3 = flying and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 162, 255)
    
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoidRootPart or not humanoid then return end
    
    if flying then
        -- Iniciar vuelo
        humanoid.PlatformStand = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
        
        -- Bind acciones para vertical (crea botones en mobile)
        ContextActionService:BindAction(upActionId, function(actionName, inputState, inputObject)
            if inputState == Enum.UserInputState.Begin then
                verticalSpeed = speed
            elseif inputState == Enum.UserInputState.End then
                verticalSpeed = 0
            end
            return Enum.ContextActionResult.Pass
        end, true, Enum.KeyCode.Space)  -- true crea botón mobile
        
        ContextActionService:BindAction(downActionId, function(actionName, inputState, inputObject)
            if inputState == Enum.UserInputState.Begin then
                verticalSpeed = -speed
            elseif inputState == Enum.UserInputState.End then
                verticalSpeed = 0
            end
            return Enum.ContextActionResult.Pass
        end, true, Enum.KeyCode.LeftShift)
        
        -- Conexión para movimiento (usa controles nativos para horizontal)
        connection = RunService.Heartbeat:Connect(function()
            if not flying then return end
            
            local camera = workspace.CurrentCamera
            local moveVector = getMoveVector()  -- Captura WASD/joystick (X: left/right, Z: forward/back)
            
            -- Movimiento horizontal relativo a cámara
            local cameraCFrame = camera.CFrame
            local horizontalMove = cameraCFrame:VectorToWorldSpace(Vector3.new(moveVector.X, 0, moveVector.Z))
            
            -- Vertical separado
            local fullVelocity = horizontalMove * speed + Vector3.new(0, verticalSpeed, 0)
            
            bodyVelocity.Velocity = fullVelocity
            bodyGyro.CFrame = cameraCFrame  -- Sigue la cámara
        end)
        
    else
        -- Detener vuelo
        if connection then connection:Disconnect() end
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        
        -- Unbind acciones
        ContextActionService:UnbindAction(upActionId)
        ContextActionService:UnbindAction(downActionId)
        
        humanoid.PlatformStand = false
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end

-- Conectar toggle (click o toque)
toggleButton.MouseButton1Click:Connect(toggleFlying)
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleFlying()
    end
end)

-- Manejar respawn
player.CharacterAdded:Connect(function()
    if flying then
        wait(1)
        -- Reactiva
        flying = false  -- Reset
        toggleFlying()
    end
end)

print("Script de Vuelo Mejorado cargado. Activa con el botón!")

-- Script de Vuelo Simple para Roblox (Mobile-Friendly)
-- Autor: Grok (basado en mecánicas estándar de Roblox)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables de vuelo
local flying = false
local speed = 50  -- Velocidad de vuelo (ajusta según prefieras)
local bodyVelocity = nil
local bodyGyro = nil
local connection = nil

-- Crear GUI
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
    if not humanoidRootPart then return end
    
    if flying then
        -- Iniciar vuelo
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
        
        -- Conexión para movimiento (basado en cámara para mobile)
        connection = RunService.Heartbeat:Connect(function()
            if not flying then return end
            
            local camera = workspace.CurrentCamera
            local moveDirection = camera.CFrame.LookVector * speed
            
            -- Ajuste vertical simple: usa toque para subir/bajar (simulado)
            if UserInputService.TouchEnabled then
                -- En mobile, detecta toques para vertical (puedes expandir con más GUIs si quieres)
                local touchInput = UserInputService:GetLastInputType()
                if touchInput == Enum.UserInputType.Touch then
                    moveDirection = moveDirection + Vector3.new(0, 10, 0)  -- Subir con toque (ajusta)
                end
            end
            
            -- Para PC: soporta teclas básicas (W/S para adelante/atrás, Space/Shift para up/down)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector * speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, speed, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, speed, 0)
            end
            
            bodyVelocity.Velocity = moveDirection
            bodyGyro.CFrame = camera.CFrame
        end)
        
        -- Opcional: Animación de activación
        local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, 55)})
        tween:Play()
        
    else
        -- Detener vuelo
        if connection then connection:Disconnect() end
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        
        -- Reset posición si es necesario
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        
        -- Animación de desactivación
        local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, 50)})
        tween:Play()
    end
end

-- Conectar botón
toggleButton.MouseButton1Click:Connect(toggleFlying)
-- Para mobile: soporta toque
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleFlying()
    end
end)

-- Manejar respawn del personaje
player.CharacterAdded:Connect(function()
    if flying then
        wait(1)  -- Espera a que cargue
        toggleFlying()  -- Reactiva si estaba on
        wait(0.1)
        toggleFlying()  -- Toggle off y on para resetear
    end
end)

print("Script de Vuelo cargado. Toca el botón para activar!")

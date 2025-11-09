-- Script de Limpieza de Scripts para Roblox (Mobile + PC)
-- Autor: Gonza (para desactivar y eliminar scripts ejecutados)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts")

-- Crear GUI para el botón de cleanup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CleanupGui"
screenGui.Parent = playerGui

local cleanupButton = Instance.new("TextButton")
cleanupButton.Name = "CleanupButton"
cleanupButton.Size = UDim2.new(0, 120, 0, 50)
cleanupButton.Position = UDim2.new(1, -130, 0, 10)  -- Esquina superior derecha
cleanupButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
cleanupButton.Text = "Cleanup"
cleanupButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cleanupButton.TextScaled = true
cleanupButton.Font = Enum.Font.SourceSansBold
cleanupButton.Parent = screenGui

-- Función de limpieza: Desactiva y destruye todos los LocalScripts y Scripts custom
local function performCleanup()
    -- Limpia PlayerGui
    for _, obj in pairs(playerGui:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            if obj.Disabled ~= nil then  -- Solo si tiene propiedad Disabled
                obj.Disabled = true
            end
            obj:Destroy()
        end
    end
    
    -- Limpia PlayerScripts (para LocalScripts en StarterPlayerScripts)
    for _, obj in pairs(playerScripts:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            if obj.Disabled ~= nil then
                obj.Disabled = true
            end
            obj:Destroy()
        end
    end
    
    -- Limpia el propio GUI de cleanup después de usarlo (opcional, coméntalo si quieres reutilizar)
    screenGui:Destroy()
    
    print("¡Limpieza completada! Todos los scripts custom han sido desactivados y eliminados.")
end

-- Conectar botón (click o toque)
cleanupButton.MouseButton1Click:Connect(performCleanup)
cleanupButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        performCleanup()
    end
end)

print("Script de Limpieza cargado. Presiona 'Cleanup' para eliminar todos los scripts ejecutados.")

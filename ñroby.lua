local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local Mouse = player:GetMouse()

-- Crear ScreenGui principal
local sg = Instance.new("ScreenGui")
sg.Name = "ÑrobyGUI"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui", 10)

-- ==============================================
--       GUI PRINCIPAL (se crea ANTES de la animación)
-- ==============================================

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 275)
frame.Position = UDim2.new(0.5, -200, 0.12, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Visible = false  -- empieza invisible
frame.Parent = sg

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 2
uiStroke.Transparency = 0
uiStroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundTransparency = 1
title.Text = "ñroby"
title.TextColor3 = Color3.new(0,0,0)
title.TextSize = 32
title.Font = Enum.Font.FredokaOne
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = Color3.new(1,1,1)
title.Parent = frame

local chromaConn = RunService.RenderStepped:Connect(function()
    if not title.Parent then chromaConn:Disconnect() return end
    local hue = (tick() * 0.5) % 1
    local color = Color3.fromHSV(hue, 1, 1)
    title.TextStrokeColor3 = color
    uiStroke.Color = color
end)

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -36, 0, 3)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = Color3.fromRGB(240, 80, 80)
close.TextSize = 20
close.Font = Enum.Font.SourceSansBold
close.Parent = frame

close.MouseButton1Click:Connect(function()
    chromaConn:Disconnect()
    sg:Destroy()
end)

-- Drag
local dragging, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==============================================
--       ANIMACIÓN DE CARGA (ahora DESPUÉS del frame)
-- ==============================================

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 1
loadingFrame.ZIndex = 100
loadingFrame.Parent = sg

local loadingContainer = Instance.new("Frame")
loadingContainer.Size = UDim2.new(1, 0, 1, 0)
loadingContainer.BackgroundTransparency = 1
loadingContainer.Parent = loadingFrame

local cartoonFont = Enum.Font.Cartoon

local words = {}
for i = 1, 140 do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 200 + math.random(-60,60), 0, 100 + math.random(-30,30))
    lbl.Position = UDim2.new(
        math.random(), math.random(-150,150),
        math.random(), math.random(-150,150)
    )
    lbl.BackgroundTransparency = 1
    lbl.Text = "ñroby"
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.TextTransparency = 1
    lbl.TextStrokeTransparency = 0.6
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.Font = cartoonFont
    lbl.TextSize = 70 + math.random(-20,30)
    lbl.Rotation = math.random(-20,20)
    lbl.ZIndex = 101
    lbl.Parent = loadingContainer
    table.insert(words, lbl)
end

local loadingChromaConn = RunService.RenderStepped:Connect(function()
    if not loadingFrame.Parent then loadingChromaConn:Disconnect() return end
    local hue = (tick() * 0.8) % 1
    local color = Color3.fromHSV(hue, 1, 1)
    for _, lbl in ipairs(words) do
        lbl.TextStrokeColor3 = color
    end
end)

local function startLoadingAnimation()
    TweenService:Create(loadingFrame, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {BackgroundTransparency = 0}):Play()
    
    for i, lbl in ipairs(words) do
        task.delay(i * 0.012, function()
            TweenService:Create(lbl, TweenInfo.new(1.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                TextTransparency = 0.05,
                TextStrokeTransparency = 0.3,
                Rotation = math.random(-10,10)
            }):Play()
        end)
    end
end

local function endLoadingAnimation()
    TweenService:Create(loadingFrame, TweenInfo.new(1.1, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
    
    for _, lbl in ipairs(words) do
        TweenService:Create(lbl, TweenInfo.new(1.0, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            TextTransparency = 1,
            TextStrokeTransparency = 1,
            Position = UDim2.new(lbl.Position.X.Scale, lbl.Position.X.Offset + math.random(-300,300), 
                                lbl.Position.Y.Scale, lbl.Position.Y.Offset + math.random(-400,400))
        }):Play()
    end
    
    task.delay(1.3, function()
        if loadingChromaConn then loadingChromaConn:Disconnect() end
        loadingFrame:Destroy()
        
        -- Aparece el GUI con bounce
        frame.Visible = true
        frame.Position = UDim2.new(0.5, -200, -0.6, 0) -- empieza arriba fuera
        TweenService:Create(frame, TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -200, 0.12, 0)
        }):Play()
    end)
end

-- ==============================================
--       RESTO DEL SCRIPT (funciones, toggles, etc.)
-- ==============================================

-- Estados y valores
local states = { fly = false, speed = false, infJump = false, noclip = false, jumpPower = false, platform = false, fling = false, esp = false, clicktp = false }
local values = { flySpeed = 50, walkSpeed = 32, jumpPower = 50 }

local connections = {}
local bodyVel, bodyGyro, currentVel = nil, nil, Vector3.new()

local keys = { W = false, A = false, S = false, D = false }

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local k = input.KeyCode.Name
    if keys[k] ~= nil then keys[k] = true end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    local k = input.KeyCode.Name
    if keys[k] ~= nil then keys[k] = false end
end)

-- Fly
local function updateFly()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root or not states.fly then return end

    local cam = workspace.CurrentCamera
    local dir = Vector3.new()
    if keys.W then dir += cam.CFrame.LookVector end
    if keys.S then dir -= cam.CFrame.LookVector end
    if keys.A then dir -= cam.CFrame.RightVector end
    if keys.D then dir += cam.CFrame.RightVector end

    if dir.Magnitude > 0 then dir = dir.Unit end

    currentVel = currentVel:Lerp(dir * values.flySpeed, 0.15)

    if bodyVel then bodyVel.Velocity = currentVel end
    if bodyGyro then bodyGyro.CFrame = cam.CFrame end
end

local function toggleFly(state)
    states.fly = state
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if not (root and hum) then return end

    if state then
        hum:ChangeState(Enum.HumanoidStateType.Physics)

        if not bodyVel then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.MaxForce = Vector3.new(99999, 99999, 99999)
            bodyVel.Velocity = Vector3.new()
            bodyVel.Parent = root
        end

        if not bodyGyro then
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
            bodyGyro.P = 12500
            bodyGyro.D = 1000
            bodyGyro.Parent = root
        end

        currentVel = Vector3.new()

        if not connections.fly then
            connections.fly = RunService.Heartbeat:Connect(updateFly)
        end
    else
        if bodyVel then bodyVel:Destroy() bodyVel = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        currentVel = Vector3.new()

        if connections.fly then
            connections.fly:Disconnect()
            connections.fly = nil
        end
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- (Aquí van el resto de funciones: toggleSpeed, toggleInfJump, toggleNoclip, toggleJumpPower, togglePlatform, toggleFling, toggleClickTP, toggleESP, createESP, removeESP...)

-- Speed
local speedConn

local function toggleSpeed(state)
    states.speed = state
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- cortar conexión anterior
    if speedConn then
        speedConn:Disconnect()
        speedConn = nil
    end

    if state then
        hum.WalkSpeed = values.walkSpeed

        -- FORZAR SPEED constantemente
        speedConn = RunService.Heartbeat:Connect(function()
            if hum and hum.Parent then
                if hum.WalkSpeed ~= values.walkSpeed then
                    hum.WalkSpeed = values.walkSpeed
                end
            end
        end)
    else
        hum.WalkSpeed = 16
    end
end

-- Infinite Jump
local infJumpConn
local jumpHeight = 50

local function toggleInfJump(state)
    states.infJump = state

    if infJumpConn then
        infJumpConn:Disconnect()
        infJumpConn = nil
    end

    if state then
        infJumpConn = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                
                if hum and root then
                    if hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall then
                        root.Velocity = Vector3.new(root.Velocity.X, jumpHeight, root.Velocity.Z)
                    end
                end
            end
        end)
    end
end

-- Noclip
local noclipConn
local function toggleNoclip(state)
    states.noclip = state

    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end

    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- JumpPower
local function toggleJumpPower(state)
    states.jumpPower = state
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = state and values.jumpPower or 50 end
end

-- Platform
local platformPart
local maxY = -math.huge

local function togglePlatform(state)
    states.platform = state

    if state then
        if not platformPart then
            platformPart = Instance.new("Part")
            platformPart.Size = Vector3.new(10, 1, 10)
            platformPart.Transparency = 0.6
            platformPart.BrickColor = BrickColor.new("Medium stone grey")
            platformPart.Anchored = true
            platformPart.CanCollide = true
            platformPart.Parent = workspace
        end
        if not connections.platform then
            connections.platform = RunService.Heartbeat:Connect(function()
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local currentY = root.Position.Y - 3.5
                    if currentY > maxY then
                        maxY = currentY
                    end
                    platformPart.Position = Vector3.new(root.Position.X, maxY, root.Position.Z)
                end
            end)
        end
    else
        if platformPart then
            platformPart:Destroy()
            platformPart = nil
        end
        if connections.platform then
            connections.platform:Disconnect()
            connections.platform = nil
        end
        maxY = -math.huge
    end
end

-- Fling
local flingConn
local spinAV
local spinAttachment

local function toggleFling(state)
    states.fling = state

    if flingConn then
        flingConn:Disconnect()
        flingConn = nil
    end

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (root and hum) then return end

    if state then
        -- Network ownership
        pcall(function()
            root:SetNetworkOwner(player)
        end)

        -- Attachment
        spinAttachment = root:FindFirstChild("SpinAttachment")
        if not spinAttachment then
            spinAttachment = Instance.new("Attachment")
            spinAttachment.Name = "SpinAttachment"
            spinAttachment.Parent = root
        end

        -- AngularVelocity (spin estable)
        spinAV = Instance.new("AngularVelocity")
        spinAV.Attachment0 = spinAttachment
        spinAV.MaxTorque = math.huge
        spinAV.AngularVelocity = Vector3.new(0, 250, 0) -- 🔥 velocidad del spin
        spinAV.Parent = root

        -- Mantener estabilidad
        flingConn = RunService.Heartbeat:Connect(function()
            root.AssemblyLinearVelocity = Vector3.zero
        end)
    else
        if spinAV then
            spinAV:Destroy()
            spinAV = nil
        end
        if spinAttachment then
            spinAttachment:Destroy()
            spinAttachment = nil
        end
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity  = Vector3.zero
    end
end

-- Click TP
local clickTpConn
local function toggleClickTP(state)
    states.clicktp = state

    if clickTpConn then
        clickTpConn:Disconnect()
        clickTpConn = nil
    end

    if state then
        clickTpConn = Mouse.Button1Down:Connect(function()
            if Mouse.Target then
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
    end
end

-- ESP
local espObjects = {}
local espConn

local function removeESP(plr)
    if espObjects[plr] then
        for _, obj in ipairs(espObjects[plr]) do
            obj:Destroy()
        end
        espObjects[plr] = nil
    end
end

local function createESP(plr)
    if plr == player then return end
    local char = plr.Character
    if not char then return end

    removeESP(plr)

    espObjects[plr] = {}

    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char
    table.insert(espObjects[plr], hl)

    local head = char:FindFirstChild("Head") or char:FindFirstChildWhichIsA("BasePart")
    if head then
        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0, 200, 0, 40)
        bill.StudsOffset = Vector3.new(0, 2.5, 0)
        bill.AlwaysOnTop = true
        bill.Adornee = head
        bill.Parent = head

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.TextScaled = true
        txt.Font = Enum.Font.GothamBold
        txt.TextStrokeTransparency = 0
        txt.Parent = bill

        table.insert(espObjects[plr], bill)

        espObjects[plr].highlight = hl
        espObjects[plr].label = txt
    end
end

local function toggleESP(state)
    states.esp = state

    for plr, _ in pairs(espObjects) do
        removeESP(plr)
    end

    if espConn then
        espConn:Disconnect()
        espConn = nil
    end

    if not state then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            createESP(plr)
        end
    end

    espConn = RunService.RenderStepped:Connect(function()
        local hue = (tick() * 0.25) % 1
        local color = Color3.fromHSV(hue, 1, 1)

        for plr, objs in pairs(espObjects) do
            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

            if not (char and root and myRoot) then
                removeESP(plr)
                continue
            end

            local dist = math.floor((myRoot.Position - root.Position).Magnitude)

            if objs.highlight then
                objs.highlight.FillColor = color
                objs.highlight.OutlineColor = color
            end

            if objs.label then
                objs.label.Text = plr.Name .. "  [" .. dist .. "m]"
                objs.label.TextColor3 = color
                objs.label.TextStrokeColor3 = Color3.new(0,0,0)
            end
        end
    end)

    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            task.wait(1)
            if states.esp then
                createESP(plr)
            end
        end)
    end)
end

-- Respawn handler
player.CharacterAdded:Connect(function(char)
    task.wait(0.6)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    if states.speed     then toggleSpeed(true)     end
    if states.jumpPower then toggleJumpPower(true) end
    if states.fly       then toggleFly(true)       end
    if states.infJump   then toggleInfJump(true)   end
    if states.noclip    then toggleNoclip(true)    end
    if states.platform  then togglePlatform(true)  end
    if states.fling     then toggleFling(true)     end
    if states.esp       then toggleESP(true)       end
    if states.clicktp   then toggleClickTP(true)   end
end)

-- Controles GUI
local function createToggle(name, x, y, callback, defaultOn)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(0, 180, 0, 34)
    cont.Position = UDim2.new(0, x, 0, y)
    cont.BackgroundTransparency = 1
    cont.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.TextSize = 15
    lbl.Font = Enum.Font.SourceSansSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = cont

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 28)
    btn.Position = UDim2.new(1, -90, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    btn.Text = defaultOn and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 15
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = cont

    local cr = Instance.new("UICorner", btn)
    cr.CornerRadius = UDim.new(0, 6)

    local isOn = defaultOn or false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.Text = isOn and "ON" or "OFF"
        callback(isOn)
    end)
end

local function createBox(name, x, y, defVal, onChange)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(0, 180, 0, 34)
    cont.Position = UDim2.new(0, x, 0, y)
    cont.BackgroundTransparency = 1
    cont.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.TextSize = 15
    lbl.Font = Enum.Font.SourceSansSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = cont

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 80, 0, 28)
    box.Position = UDim2.new(1, -90, 0, 3)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    box.Text = tostring(defVal)
    box.TextColor3 = Color3.fromRGB(220,220,255)
    box.TextSize = 15
    box.Font = Enum.Font.SourceSans
    box.ClearTextOnFocus = false
    box.Parent = cont

    local cr = Instance.new("UICorner", box)
    cr.CornerRadius = UDim.new(0, 6)

    box.FocusLost:Connect(function(enter)
        if enter then
            local num = tonumber(box.Text)
            if num and num > 0 then
                onChange(num)
            else
                box.Text = tostring(defVal)
            end
        end
    end)
end

-- Layout de toggles y boxes
createToggle ("Fly",         20,  45, toggleFly,       false)
createBox    ("Fly Speed",   20,  82, values.flySpeed, function(v) values.flySpeed = v end)

createToggle ("Speed",      210,  45, toggleSpeed,     false)
createBox    ("Walk Speed", 210,  82, values.walkSpeed, function(v) values.walkSpeed = v toggleSpeed(states.speed) end)

createToggle ("Inf Jump",    20, 118, toggleInfJump,   false)
createToggle ("Noclip",     210, 118, toggleNoclip,    false)

createToggle ("JumpPower",   20, 154, toggleJumpPower, false)
createBox    ("Jump Power", 210, 154, values.jumpPower, function(v) values.jumpPower = v toggleJumpPower(states.jumpPower) end)

createToggle ("Platform",    20, 190, togglePlatform,  false)
createToggle ("Fling",      210, 190, toggleFling,     false)
createToggle ("ESP",         20, 226, toggleESP,       false)
createToggle ("Click TP",    210, 226, toggleClickTP,  false)

-- ==============================================
--       INICIAR LA ANIMACIÓN
-- ==============================================
startLoadingAnimation()
task.delay(2.8, endLoadingAnimation)

print("Disfruta unc")

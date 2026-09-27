local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local Mouse = player:GetMouse()

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "ÑrobyGUI"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui",10)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,400,0,350)
frame.Position = UDim2.new(0.5,-200,0.12,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = sg

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0,12)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Color = Color3.new(1,1,1)
uiStroke.Thickness = 2
uiStroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,36)
title.BackgroundTransparency = 1
title.Text = "ñroby"
title.TextColor3 = Color3.new(0,0,0)
title.TextSize = 32
title.Font = Enum.Font.FredokaOne
title.TextStrokeTransparency = .5
title.Parent = frame

local chromaConn = RunService.RenderStepped:Connect(function()
    if not title.Parent then
        chromaConn:Disconnect()
        return
    end
    local c = Color3.fromHSV((tick()*.5)%1,1,1)
    title.TextStrokeColor3 = c
    uiStroke.Color = c
end)

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-36,0,3)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = Color3.fromRGB(240,80,80)
close.TextSize = 20
close.Font = Enum.Font.SourceSansBold
close.Parent = frame

close.MouseButton1Click:Connect(function()
    if chromaConn then chromaConn:Disconnect() end
    sg:Destroy()
end)

-- DRAG
local dragging,dragStart,startPos

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
        local d = input.Position-dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,startPos.X.Offset+d.X,
            startPos.Y.Scale,startPos.Y.Offset+d.Y
        )
    end
end)

-- LOADING
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1,0,1,0)
loadingFrame.BackgroundColor3 = Color3.new(0,0,0)
loadingFrame.BackgroundTransparency = 1
loadingFrame.ZIndex = 100
loadingFrame.Parent = sg

local loadingContainer = Instance.new("Frame")
loadingContainer.Size = UDim2.new(1,0,1,0)
loadingContainer.BackgroundTransparency = 1
loadingContainer.Parent = loadingFrame

local words = {}

for i=1,140 do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,200+math.random(-60,60),0,100+math.random(-30,30))
    lbl.Position = UDim2.new(
        math.random(),math.random(-150,150),
        math.random(),math.random(-150,150)
    )
    lbl.BackgroundTransparency = 1
    lbl.Text = "ñroby"
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextTransparency = 1
    lbl.TextStrokeTransparency = .6
    lbl.Font = Enum.Font.Cartoon
    lbl.TextSize = 70+math.random(-20,30)
    lbl.Rotation = math.random(-20,20)
    lbl.ZIndex = 101
    lbl.Parent = loadingContainer
    table.insert(words,lbl)
end

local loadingChromaConn = RunService.RenderStepped:Connect(function()
    if not loadingFrame.Parent then
        loadingChromaConn:Disconnect()
        return
    end
    local c = Color3.fromHSV((tick()*.8)%1,1,1)
    for _,lbl in ipairs(words) do
        lbl.TextStrokeColor3 = c
    end
end)

local function startLoadingAnimation()
    TweenService:Create(
        loadingFrame,
        TweenInfo.new(.8),
        {BackgroundTransparency=0}
    ):Play()

    for i,lbl in ipairs(words) do
        task.delay(i*.012,function()
            if not lbl.Parent then return end
            TweenService:Create(
                lbl,
                TweenInfo.new(1.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                {
                    TextTransparency=.05,
                    TextStrokeTransparency=.3,
                    Rotation=math.random(-10,10)
                }
            ):Play()
        end)
    end
end

local function endLoadingAnimation()
    TweenService:Create(
        loadingFrame,
        TweenInfo.new(1.1),
        {BackgroundTransparency=1}
    ):Play()

    for _,lbl in ipairs(words) do
        TweenService:Create(
            lbl,
            TweenInfo.new(1,Enum.EasingStyle.Back,Enum.EasingDirection.In),
            {
                TextTransparency=1,
                TextStrokeTransparency=1,
                Position=UDim2.new(
                    lbl.Position.X.Scale,
                    lbl.Position.X.Offset+math.random(-300,300),
                    lbl.Position.Y.Scale,
                    lbl.Position.Y.Offset+math.random(-400,400)
                )
            }
        ):Play()
    end

    task.delay(1.3,function()
        if loadingChromaConn then
            loadingChromaConn:Disconnect()
        end

        loadingFrame:Destroy()
        frame.Visible = true

        frame.Position = UDim2.new(.5,-200,-.6,0)

        TweenService:Create(
            frame,
            TweenInfo.new(1.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Position=UDim2.new(.5,-200,.12,0)}
        ):Play()
    end)
end

-- ESTADOS
local states = {
    fly=false,
    vehicleFly=false,
    vehicleNoclip=false,
    speed=false,
    infJump=false,
    noclip=false,
    jumpPower=false,
    platform=false,
    fling=false,
    esp=false,
    clicktp=false
}

local values = {
    flySpeed=50,
    vehicleFlySpeed=80,
    walkSpeed=32,
    jumpPower=50
}

local connections = {}

local bodyVel
local bodyGyro
local currentVel = Vector3.zero

local keys = {
    W=false,
    A=false,
    S=false,
    D=false,
    Q=false,
    E=false
}

UserInputService.InputBegan:Connect(function(input,gp)
    if gp then return end
    local k = input.KeyCode.Name
    if keys[k] ~= nil then
        keys[k] = true
    end
end)

UserInputService.InputEnded:Connect(function(input,gp)
    if gp then return end
    local k = input.KeyCode.Name
    if keys[k] ~= nil then
        keys[k] = false
    end
end)

-- FLY
local function updateFly()
    local root = player.Character
        and player.Character:FindFirstChild("HumanoidRootPart")

    if not root or not states.fly then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    local dir = Vector3.zero

    if keys.W then dir += cam.CFrame.LookVector end
    if keys.S then dir -= cam.CFrame.LookVector end
    if keys.A then dir -= cam.CFrame.RightVector end
    if keys.D then dir += cam.CFrame.RightVector end

    if dir.Magnitude > 0 then
        dir = dir.Unit
    end

    currentVel = currentVel:Lerp(
        dir*values.flySpeed,.15
    )

    if bodyVel then
        bodyVel.Velocity = currentVel
    end

    if bodyGyro then
        bodyGyro.CFrame = cam.CFrame
    end
end

local function toggleFly(state)
    states.fly = state

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if not(root and hum) then return end

    if state then
        hum:ChangeState(Enum.HumanoidStateType.Physics)

        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(99999,99999,99999)
        bodyVel.Velocity = Vector3.zero
        bodyVel.Parent = root

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(4000,4000,4000)
        bodyGyro.P = 12500
        bodyGyro.D = 1000
        bodyGyro.Parent = root

        currentVel = Vector3.zero

        if not connections.fly then
            connections.fly = RunService.Heartbeat:Connect(updateFly)
        end
    else
        if bodyVel then
            bodyVel:Destroy()
            bodyVel=nil
        end

        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro=nil
        end

        currentVel = Vector3.zero

        if connections.fly then
            connections.fly:Disconnect()
            connections.fly=nil
        end

        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- VEHICLE FLY
local vehicleFlyConn
local vehicleBodyVelocity
local vehicleBodyGyro
local currentVehicleVel = Vector3.zero
local vehicleFlyRoot

local function getVehicle()
    local char = player.Character
    if not char then return nil end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end

    local seat = hum.SeatPart
    if not seat then return nil end

    if not seat:IsA("VehicleSeat")
        and not seat:IsA("Seat") then
        return nil
    end

    local vehicle = seat:FindFirstAncestorOfClass("Model")
    if not vehicle then return nil end

    local root =
        vehicle.PrimaryPart
        or vehicle:FindFirstChild("VehicleSeat",true)
        or seat

    if not root or not root:IsA("BasePart") then
        return nil
    end

    return vehicle,root,seat
end

local function removeVehicleForces()
    if vehicleBodyVelocity then
        vehicleBodyVelocity:Destroy()
        vehicleBodyVelocity=nil
    end

    if vehicleBodyGyro then
        vehicleBodyGyro:Destroy()
        vehicleBodyGyro=nil
    end

    vehicleFlyRoot=nil
    currentVehicleVel=Vector3.zero
end

local function stopVehicleFly()
    if vehicleFlyConn then
        vehicleFlyConn:Disconnect()
        vehicleFlyConn=nil
    end

    removeVehicleForces()
end

local function setupVehicleFly(root)
    removeVehicleForces()

    vehicleFlyRoot=root

    vehicleBodyVelocity=Instance.new("BodyVelocity")
    vehicleBodyVelocity.Name="ÑrobyVehicleVelocity"
    vehicleBodyVelocity.MaxForce=Vector3.new(
        1000000,1000000,1000000
    )
    vehicleBodyVelocity.P=10000
    vehicleBodyVelocity.Velocity=Vector3.zero
    vehicleBodyVelocity.Parent=root

    vehicleBodyGyro=Instance.new("BodyGyro")
    vehicleBodyGyro.Name="ÑrobyVehicleGyro"
    vehicleBodyGyro.MaxTorque=Vector3.new(
        1000000,1000000,1000000
    )
    vehicleBodyGyro.P=10000
    vehicleBodyGyro.D=1000
    vehicleBodyGyro.CFrame=root.CFrame
    vehicleBodyGyro.Parent=root
end

local function updateVehicleFly()
    if not states.vehicleFly then return end

    local vehicle,root,seat=getVehicle()

    if not vehicle or not root or not seat then
        removeVehicleForces()
        return
    end

    if vehicleFlyRoot~=root
        or not vehicleBodyVelocity
        or not vehicleBodyVelocity.Parent
        or not vehicleBodyGyro
        or not vehicleBodyGyro.Parent then

        setupVehicleFly(root)
    end

    local camera=workspace.CurrentCamera
    if not camera then return end

    local look=camera.CFrame.LookVector
    local right=camera.CFrame.RightVector

    local horizontalLook=Vector3.new(
        look.X,0,look.Z
    )

    local horizontalRight=Vector3.new(
        right.X,0,right.Z
    )

    if horizontalLook.Magnitude>0 then
        horizontalLook=horizontalLook.Unit
    end

    if horizontalRight.Magnitude>0 then
        horizontalRight=horizontalRight.Unit
    end

    local direction=Vector3.zero

    if keys.W then
        direction+=horizontalLook
    end

    if keys.S then
        direction-=horizontalLook
    end

    if keys.D then
        direction+=horizontalRight
    end

    if keys.A then
        direction-=horizontalRight
    end

    if keys.Q then
        direction+=Vector3.new(0,1,0)
    end

    if keys.E then
        direction-=Vector3.new(0,1,0)
    end

    if direction.Magnitude>0 then
        direction=direction.Unit
    end

    currentVehicleVel=currentVehicleVel:Lerp(
        direction*values.vehicleFlySpeed,
        .20
    )

    vehicleBodyVelocity.Velocity=currentVehicleVel

    if horizontalLook.Magnitude>0 then
        vehicleBodyGyro.CFrame=CFrame.lookAt(
            root.Position,
            root.Position+horizontalLook
        )
    end
end

local function toggleVehicleFly(state)
    states.vehicleFly=state
    stopVehicleFly()

    if not state then return end

    vehicleFlyConn=RunService.Heartbeat:Connect(
        updateVehicleFly
    )
end

-- VEHICLE NOCLIP
local vehicleNoclipConn
local vehicleOriginalCollision={}

local function restoreVehicleCollision()
    for part,oldValue in pairs(vehicleOriginalCollision) do
        if part and part.Parent then
            part.CanCollide=oldValue
        end
    end

    table.clear(vehicleOriginalCollision)
end

local function updateVehicleNoclip()
    if not states.vehicleNoclip then return end

    local vehicle=getVehicle()

    if not vehicle then
        restoreVehicleCollision()
        return
    end

    for _,obj in ipairs(vehicle:GetDescendants()) do
        if obj:IsA("BasePart") then
            if vehicleOriginalCollision[obj]==nil then
                vehicleOriginalCollision[obj]=obj.CanCollide
            end

            obj.CanCollide=false
        end
    end
end

local function stopVehicleNoclip()
    if vehicleNoclipConn then
        vehicleNoclipConn:Disconnect()
        vehicleNoclipConn=nil
    end

    restoreVehicleCollision()
end

local function toggleVehicleNoclip(state)
    states.vehicleNoclip=state
    stopVehicleNoclip()

    if not state then return end

    vehicleNoclipConn=RunService.Stepped:Connect(
        updateVehicleNoclip
    )
end

-- SPEED
local speedConn

local function toggleSpeed(state)
    states.speed=state

    local hum=player.Character
        and player.Character:FindFirstChildOfClass("Humanoid")

    if not hum then return end

    if speedConn then
        speedConn:Disconnect()
        speedConn=nil
    end

    if state then
        hum.WalkSpeed=values.walkSpeed

        speedConn=RunService.Heartbeat:Connect(function()
            if hum and hum.Parent then
                hum.WalkSpeed=values.walkSpeed
            end
        end)
    else
        hum.WalkSpeed=16
    end
end

-- INFINITE JUMP
local infJumpConn
local jumpHeight=50

local function toggleInfJump(state)
    states.infJump=state

    if infJumpConn then
        infJumpConn:Disconnect()
        infJumpConn=nil
    end

    if state then
        infJumpConn=UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode~=Enum.KeyCode.Space then return end

            local hum=player.Character
                and player.Character:FindFirstChildOfClass("Humanoid")

            local root=player.Character
                and player.Character:FindFirstChild("HumanoidRootPart")

            if hum and root then
                if hum:GetState()==Enum.HumanoidStateType.Jumping
                    or hum:GetState()==Enum.HumanoidStateType.Freefall then

                    root.Velocity=Vector3.new(
                        root.Velocity.X,
                        jumpHeight,
                        root.Velocity.Z
                    )
                end
            end
        end)
    end
end

-- NOCLIP
local noclipConn

local function toggleNoclip(state)
    states.noclip=state

    if noclipConn then
        noclipConn:Disconnect()
        noclipConn=nil
    end

    if state then
        noclipConn=RunService.Stepped:Connect(function()
            local char=player.Character

            if char then
                for _,part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide=false
                    end
                end
            end
        end)
    else
        local char=player.Character

        if char then
            for _,part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide=true
                end
            end
        end
    end
end

-- JUMP POWER
local DEFAULT_JUMP=50

local function applyJumpPower(hum)
    if not hum then return end

    hum.UseJumpPower=true

    task.spawn(function()
        while states.jumpPower and hum and hum.Parent do
            hum.JumpPower=values.jumpPower
            task.wait()
        end

        if hum and hum.Parent then
            hum.JumpPower=DEFAULT_JUMP
        end
    end)
end

local function toggleJumpPower(state)
    states.jumpPower=state

    local char=player.Character
        or player.CharacterAdded:Wait()

    local hum=char:WaitForChild("Humanoid")

    if state then
        applyJumpPower(hum)
    else
        hum.JumpPower=DEFAULT_JUMP
    end
end

-- PLATFORM
local platformPart
local maxY=-math.huge

local function togglePlatform(state)
    states.platform=state

    if state then
        if not platformPart then
            platformPart=Instance.new("Part")
            platformPart.Size=Vector3.new(10,1,10)
            platformPart.Transparency=.6
            platformPart.BrickColor=BrickColor.new("Medium stone grey")
            platformPart.Anchored=true
            platformPart.CanCollide=true
            platformPart.Parent=workspace
        end

        if not connections.platform then
            connections.platform=RunService.Heartbeat:Connect(function()
                local root=player.Character
                    and player.Character:FindFirstChild("HumanoidRootPart")

                if root then
                    local y=root.Position.Y-3.5

                    if y>maxY then
                        maxY=y
                    end

                    platformPart.Position=Vector3.new(
                        root.Position.X,
                        maxY,
                        root.Position.Z
                    )
                end
            end)
        end
    else
        if platformPart then
            platformPart:Destroy()
            platformPart=nil
        end

        if connections.platform then
            connections.platform:Disconnect()
            connections.platform=nil
        end

        maxY=-math.huge
    end
end

-- FLING
local flingConn
local spinAV
local spinAttachment

local function toggleFling(state)
    if flingConn then
        flingConn:Disconnect()
        flingConn=nil
    end

    if spinAV then
        spinAV:Destroy()
        spinAV=nil
    end

    if spinAttachment then
        spinAttachment:Destroy()
        spinAttachment=nil
    end

    local char=player.Character
    if not char then return end

    local root=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")

    if not(root and hum) then return end

    states.fling=state

    if state then
        hum:ChangeState(Enum.HumanoidStateType.Physics)

        spinAttachment=Instance.new("Attachment")
        spinAttachment.Parent=root

        spinAV=Instance.new("AngularVelocity")
        spinAV.Attachment0=spinAttachment
        spinAV.RelativeTo=Enum.ActuatorRelativeTo.World
        spinAV.MaxTorque=1e9
        spinAV.AngularVelocity=Vector3.new(0,1000,0)
        spinAV.Parent=root

        flingConn=RunService.Heartbeat:Connect(function()
            if not root.Parent then
                toggleFling(false)
                return
            end

            local t=tick()*25

            root.AssemblyLinearVelocity=Vector3.new(
                math.cos(t)*10,
                0,
                math.sin(t)*10
            )

            root.CFrame*=CFrame.Angles(
                0,
                math.rad(20),
                0
            )
        end)
    else
        root.AssemblyAngularVelocity=Vector3.zero
        root.AssemblyLinearVelocity=Vector3.zero
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- CLICK TP
local clickTpConn

local function toggleClickTP(state)
    states.clicktp=state

    if clickTpConn then
        clickTpConn:Disconnect()
        clickTpConn=nil
    end

    if state then
        clickTpConn=Mouse.Button1Down:Connect(function()
            if Mouse.Target then
                local root=player.Character
                    and player.Character:FindFirstChild("HumanoidRootPart")

                if root then
                    root.CFrame=CFrame.new(
                        Mouse.Hit.Position+Vector3.new(0,3,0)
                    )
                end
            end
        end)
    end
end

-- ESP
local espObjects={}
local espConn
local espScanConn

local function removeESP(plr)
    if espObjects[plr] then
        for _,obj in ipairs(espObjects[plr]) do
            if typeof(obj)=="Instance" then
                obj:Destroy()
            end
        end

        espObjects[plr]=nil
    end
end

local function createESP(plr)
    if plr==player then return end

    local char=plr.Character
    if not char then return end

    removeESP(plr)
    espObjects[plr]={}

    local hl=Instance.new("Highlight")
    hl.Adornee=char
    hl.FillTransparency=.6
    hl.OutlineTransparency=0
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent=char

    table.insert(espObjects[plr],hl)

    local head=char:FindFirstChild("Head")
        or char:FindFirstChildWhichIsA("BasePart")

    if head then
        local bill=Instance.new("BillboardGui")
        bill.Size=UDim2.new(0,200,0,40)
        bill.StudsOffset=Vector3.new(0,2.5,0)
        bill.AlwaysOnTop=true
        bill.MaxDistance=math.huge
        bill.Adornee=head
        bill.Parent=head

        local txt=Instance.new("TextLabel")
        txt.Size=UDim2.new(1,0,1,0)
        txt.BackgroundTransparency=1
        txt.TextScaled=true
        txt.Font=Enum.Font.GothamBold
        txt.TextStrokeTransparency=0
        txt.Parent=bill

        table.insert(espObjects[plr],bill)

        espObjects[plr].highlight=hl
        espObjects[plr].label=txt
        espObjects[plr].billboard=bill
    end

    local root=char:FindFirstChild("HumanoidRootPart")

    if root then
        local boxGui=Instance.new("BillboardGui")
        boxGui.Name="RGB2DBox"
        boxGui.Adornee=root
        boxGui.Size=UDim2.new(0,60,0,100)
        boxGui.AlwaysOnTop=true
        boxGui.MaxDistance=math.huge
        boxGui.Parent=root

        local function line(size,pos)
            local l=Instance.new("Frame")
            l.Size=size
            l.Position=pos
            l.BorderSizePixel=0
            l.Parent=boxGui
            return l
        end

        local top=line(
            UDim2.new(1,0,0,2),
            UDim2.new(0,0,0,0)
        )

        local bottom=line(
            UDim2.new(1,0,0,2),
            UDim2.new(0,0,1,-2)
        )

        local left=line(
            UDim2.new(0,2,1,0),
            UDim2.new(0,0,0,0)
        )

        local right=line(
            UDim2.new(0,2,1,0),
            UDim2.new(1,-2,0,0)
        )

        espObjects[plr].box=boxGui
        espObjects[plr].top=top
        espObjects[plr].bottom=bottom
        espObjects[plr].left=left
        espObjects[plr].right=right

        table.insert(espObjects[plr],boxGui)
    end
end

local function toggleESP(state)
    states.esp=state

    for plr in pairs(espObjects) do
        removeESP(plr)
    end

    if espConn then
        espConn:Disconnect()
        espConn=nil
    end

    if espScanConn then
        espScanConn:Disconnect()
        espScanConn=nil
    end

    if not state then return end

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=player then
            createESP(plr)
        end
    end

    espConn=RunService.RenderStepped:Connect(function()
        local color=Color3.fromHSV((tick()*.25)%1,1,1)
        local camera=workspace.CurrentCamera

        local myRoot=player.Character
            and player.Character:FindFirstChild("HumanoidRootPart")

        if not camera or not myRoot then return end

        for plr,objs in pairs(espObjects) do
            local char=plr.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            local head=char and char:FindFirstChild("Head")

            if not(char and root and head) then
                removeESP(plr)
                continue
            end

            local dist=math.floor(
                (myRoot.Position-root.Position).Magnitude
            )

            if objs.highlight then
                objs.highlight.FillColor=color
                objs.highlight.OutlineColor=color
            end

            if objs.label then
                objs.label.Text=plr.Name.."  ["..dist.."S]"
                objs.label.TextColor3=color
                objs.label.TextStrokeColor3=Color3.new(0,0,0)
            end

            if objs.top then
                objs.top.BackgroundColor3=color
                objs.bottom.BackgroundColor3=color
                objs.left.BackgroundColor3=color
                objs.right.BackgroundColor3=color
            end

            if objs.billboard then
                local s=math.clamp(1-(dist/500),.35,1)
                objs.billboard.Size=UDim2.new(
                    0,math.floor(200*s),
                    0,math.floor(40*s)
                )
            end

            if objs.box then
                local hp=camera:WorldToViewportPoint(
                    head.Position+Vector3.new(0,.5,0)
                )

                local rp=camera:WorldToViewportPoint(
                    root.Position-Vector3.new(0,3,0)
                )

                local h=math.abs(rp.Y-hp.Y)
                local w=h*.55

                h=math.clamp(h,8,500)
                w=math.clamp(w,5,300)

                objs.box.Size=UDim2.new(
                    0,math.floor(w),
                    0,math.floor(h)
                )
            end
        end
    end)

    espScanConn=RunService.Heartbeat:Connect(function()
        if not states.esp then return end

        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=player then
                local char=plr.Character
                local objs=espObjects[plr]

                if char then
                    local root=char:FindFirstChild("HumanoidRootPart")

                    if root then
                        if not objs
                            or not objs.highlight
                            or objs.highlight.Adornee~=char
                            or not objs.box
                            or not objs.box.Parent then

                            createESP(plr)
                        end
                    end
                elseif objs then
                    removeESP(plr)
                end
            end
        end
    end)

    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            task.wait(.2)

            if states.esp then
                createESP(plr)
            end
        end)
    end)
end

-- CLEANUP
local function cleanupMovement()
    if connections.fly then
        connections.fly:Disconnect()
        connections.fly=nil
    end

    if bodyVel then
        bodyVel:Destroy()
        bodyVel=nil
    end

    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro=nil
    end

    currentVel=Vector3.zero
    states.fly=false

    states.vehicleFly=false
    stopVehicleFly()

    states.vehicleNoclip=false
    stopVehicleNoclip()

    if noclipConn then
        noclipConn:Disconnect()
        noclipConn=nil
    end

    states.noclip=false

    local char=player.Character

    if char then
        for _,part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide=true
            end
        end
    end
end

local function hookDeath(char)
    local hum=char:WaitForChild("Humanoid")

    hum.Died:Connect(function()
        cleanupMovement()
    end)
end

if player.Character then
    hookDeath(player.Character)
end

-- RESPAWN
player.CharacterAdded:Connect(function(char)
    hookDeath(char)

    task.wait(.6)

    local hum=char:WaitForChild("Humanoid",5)
    if not hum then return end

    hum:ChangeState(Enum.HumanoidStateType.Running)

    if states.speed then toggleSpeed(true) end
    if states.jumpPower then toggleJumpPower(true) end
    if states.infJump then toggleInfJump(true) end
    if states.noclip then toggleNoclip(true) end
    if states.platform then togglePlatform(true) end
    if states.fling then toggleFling(true) end
    if states.esp then toggleESP(true) end
    if states.clicktp then toggleClickTP(true) end

    -- Vehicle Fly queda listo para volver a funcionar
    -- cuando vuelvas a sentarte en un vehículo.
    if states.vehicleFly then
        toggleVehicleFly(true)
    end

    if states.vehicleNoclip then
        toggleVehicleNoclip(true)
    end
end)

-- CONTROLES
local function createToggle(name,x,y,callback,defaultOn)
    local cont=Instance.new("Frame")
    cont.Size=UDim2.new(0,180,0,34)
    cont.Position=UDim2.new(0,x,0,y)
    cont.BackgroundTransparency=1
    cont.Parent=frame

    local lbl=Instance.new("TextLabel")
    lbl.Size=UDim2.new(.55,0,1,0)
    lbl.BackgroundTransparency=1
    lbl.Text=name
    lbl.TextColor3=Color3.fromRGB(200,200,220)
    lbl.TextSize=15
    lbl.Font=Enum.Font.SourceSansSemibold
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Parent=cont

    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0,80,0,28)
    btn.Position=UDim2.new(1,-90,0,3)
    btn.BackgroundColor3=Color3.fromRGB(50,50,65)
    btn.Text=defaultOn and "ON" or "OFF"
    btn.TextColor3=Color3.new(1,1,1)
    btn.TextSize=15
    btn.Font=Enum.Font.SourceSansBold
    btn.Parent=cont

    local cr=Instance.new("UICorner")
    cr.CornerRadius=UDim.new(0,6)
    cr.Parent=btn

    local isOn=defaultOn or false

    btn.MouseButton1Click:Connect(function()
        isOn=not isOn
        btn.Text=isOn and "ON" or "OFF"
        callback(isOn)
    end)
end

local function createBox(name,x,y,defVal,onChange)
    local cont=Instance.new("Frame")
    cont.Size=UDim2.new(0,180,0,34)
    cont.Position=UDim2.new(0,x,0,y)
    cont.BackgroundTransparency=1
    cont.Parent=frame

    local lbl=Instance.new("TextLabel")
    lbl.Size=UDim2.new(.55,0,1,0)
    lbl.BackgroundTransparency=1
    lbl.Text=name
    lbl.TextColor3=Color3.fromRGB(200,200,220)
    lbl.TextSize=15
    lbl.Font=Enum.Font.SourceSansSemibold
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Parent=cont

    local box=Instance.new("TextBox")
    box.Size=UDim2.new(0,80,0,28)
    box.Position=UDim2.new(1,-90,0,3)
    box.BackgroundColor3=Color3.fromRGB(30,30,40)
    box.Text=tostring(defVal)
    box.TextColor3=Color3.fromRGB(220,220,255)
    box.TextSize=15
    box.Font=Enum.Font.SourceSans
    box.ClearTextOnFocus=false
    box.Parent=cont

    local cr=Instance.new("UICorner")
    cr.CornerRadius=UDim.new(0,6)
    cr.Parent=box

    box.FocusLost:Connect(function(enter)
        if enter then
            local num=tonumber(box.Text)

            if num and num>0 then
                onChange(num)
            else
                box.Text=tostring(defVal)
            end
        end
    end)
end

-- LAYOUT
createToggle("Fly",20,45,toggleFly,false)

createBox(
    "Fly Speed",
    20,82,
    values.flySpeed,
    function(v)
        values.flySpeed=v
    end
)

createToggle("Speed",210,45,toggleSpeed,false)

createBox(
    "Walk Speed",
    210,82,
    values.walkSpeed,
    function(v)
        values.walkSpeed=v
        toggleSpeed(states.speed)
    end
)

createToggle("Inf Jump",20,118,toggleInfJump,false)
createToggle("Noclip",210,118,toggleNoclip,false)

createToggle("JumpPower",20,154,toggleJumpPower,false)

createBox(
    "Jump Power",
    210,154,
    values.jumpPower,
    function(v)
        values.jumpPower=v
        toggleJumpPower(states.jumpPower)
    end
)

createToggle("Platform",20,190,togglePlatform,false)
createToggle("Fling",210,190,toggleFling,false)

createToggle("ESP",20,226,toggleESP,false)
createToggle("Click TP",210,226,toggleClickTP,false)

-- VEHÍCULOS
createToggle(
    "Vehicle Fly",
    20,262,
    toggleVehicleFly,
    false
)

createToggle(
    "V Noclip",
    210,262,
    toggleVehicleNoclip,
    false
)

createBox(
    "V Speed",
    20,298,
    values.vehicleFlySpeed,
    function(v)
        values.vehicleFlySpeed=v
    end
)

-- START
startLoadingAnimation()

task.delay(2.8,endLoadingAnimation)

print("Disfruta unc")

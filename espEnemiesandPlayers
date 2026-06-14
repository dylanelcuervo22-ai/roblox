local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local espObjects = {}
local states = {
    esp = false
}

--========================--
-- GUI MODERNA
--========================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,150,0,60)
Frame.Position = UDim2.new(0.5,-75,0.2,0)
Frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,10)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,20)
Title.BackgroundTransparency = 1
Title.Text = "ESP"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Frame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1,-20,0,25)
Button.Position = UDim2.new(0,10,0,27)
Button.BackgroundColor3 = Color3.fromRGB(120,40,40)
Button.Text = "OFF"
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 13
Button.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0,8)
ButtonCorner.Parent = Button

--========================--
-- DRAGGABLE
--========================--

local dragging = false
local dragStart
local startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart

        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--========================--
-- ESP FUNCTIONS
--========================--

local function removeESP(target)
    if espObjects[target] then
        for _, obj in pairs(espObjects[target]) do
            if typeof(obj) == "Instance" and obj.Parent then
                obj:Destroy()
            end
        end

        espObjects[target] = nil
    end
end

local function isValidTarget(model)

    if not model:IsA("Model") then
        return false
    end

    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")

    if not hum or not root then
        return false
    end

    if player.Character and model == player.Character then
        return false
    end

    return hum.Health > 0
end

local function createESP(target)

    removeESP(target)

    espObjects[target] = {}

    local highlight = Instance.new("Highlight")
    highlight.Adornee = target
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = target

    espObjects[target].highlight = highlight

    local head =
        target:FindFirstChild("Head")
        or target:FindFirstChild("HumanoidRootPart")

    if head then

        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0,200,0,40)
        bill.StudsOffset = Vector3.new(0,2.5,0)
        bill.AlwaysOnTop = true
        bill.Adornee = head
        bill.Parent = head

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.TextScaled = true
        txt.Font = Enum.Font.GothamBold
        txt.TextStrokeTransparency = 0
        txt.Parent = bill

        espObjects[target].billboard = bill
        espObjects[target].label = txt
    end
end

local function getTargets()

    local targets = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if isValidTarget(obj) then
            table.insert(targets,obj)
        end
    end

    return targets
end

--========================--
-- BOTON ON/OFF
--========================--

Button.MouseButton1Click:Connect(function()

    states.esp = not states.esp

    if states.esp then

        Button.Text = "ON"
        Button.BackgroundColor3 = Color3.fromRGB(40,120,40)

        for _, target in ipairs(getTargets()) do
            createESP(target)
        end

    else

        Button.Text = "OFF"
        Button.BackgroundColor3 = Color3.fromRGB(120,40,40)

        for target in pairs(espObjects) do
            removeESP(target)
        end

    end
end)

--========================--
-- NUEVOS TARGETS
--========================--

workspace.DescendantAdded:Connect(function(obj)

    if states.esp and isValidTarget(obj) then

        task.wait(0.2)

        if obj.Parent then
            createESP(obj)
        end

    end
end)

--========================--
-- DISTANCIAS
--========================--

task.spawn(function()

    while true do

        task.wait(0.1)

        if not states.esp then
            continue
        end

        local myRoot =
            player.Character
            and player.Character:FindFirstChild("HumanoidRootPart")

        if not myRoot then
            continue
        end

        for target, objs in pairs(espObjects) do

            local root = target:FindFirstChild("HumanoidRootPart")

            if not root then
                removeESP(target)
                continue
            end

            local dist =
                math.floor(
                    (myRoot.Position - root.Position).Magnitude
                )

            if objs.label then
                objs.label.Text =
                    target.Name ..
                    " [" ..
                    dist ..
                    "m]"
            end
        end
    end
end)

--========================--
-- RGB LOOP
--========================--

RunService.RenderStepped:Connect(function()

    local hue = (tick() * 0.25) % 1
    local color = Color3.fromHSV(hue,1,1)

    Stroke.Color = color

    for target, objs in pairs(espObjects) do

        if objs.highlight then
            objs.highlight.FillColor = color
            objs.highlight.OutlineColor = color
        end

        if objs.label then
            objs.label.TextColor3 = color
        end

    end
end)

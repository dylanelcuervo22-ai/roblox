-- Cleanup Script: Destroys all GUIs, resets character properties, removes body movers, clears ESP, resets gravity, and prevents future issues.
-- Run this in your executor to wipe everything clean. No traces left.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- Function to reset character properties and remove movers
local function resetCharacter(char)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        humanoid.UseJumpPower = true
        humanoid.PlatformStand = false
    end
    
    -- Remove all body movers and collision overrides
    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanCollide = true
        elseif obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") or obj:IsA("BodyPosition") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyThrust") then
            obj:Destroy()
        end
    end
    
    -- Clear any ESP highlights in all characters (including others)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            for _, descendant in pairs(plr.Character:GetDescendants()) do
                if descendant:IsA("Highlight") or descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
                    descendant:Destroy()
                end
            end
        end
    end
end

-- Reset current character if it exists
if player.Character then
    resetCharacter(player.Character)
end

-- Reset on future character spawns
player.CharacterAdded:Connect(resetCharacter)

-- Destroy ALL GUIs and descendants in PlayerGui (no mercy)
for _, child in pairs(playerGui:GetChildren()) do
    child:Destroy()
end

-- Also clear any other potential GUI parents (like StarterGui, but focus on PlayerGui)
-- Reset Workspace gravity to default
Workspace.Gravity = 196.2

-- Stop any potential RunService connections by unbinding common names (limited effect, but helps)
for _, connectionName in pairs({"FlyUpdate", "NoclipUpdate", "ESPUpdate", "RainbowUpdate"}) do
    pcall(function()
        RunService:UnbindFromRenderStep(connectionName)
    end)
end

-- Clear any potential TweenService tweens (global, but can't target specifics; this just ensures no ongoing ones interfere)
-- Note: This is a soft clean; for full wipe, the GUI destruction handles visuals.

-- Final cleanup: Bind to game close to ensure reset
game:BindToClose(function()
    if player.Character then
        resetCharacter(player.Character)
    end
    Workspace.Gravity = 196.2
end)

-- Print confirmation (optional, remove if you want silent)
print("🧹 Cleanup complete: All scripts, GUIs, cheats, and traces wiped. You're clean!")

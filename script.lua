-- Stable Death Ball Auto Parry

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local hrp

local BASE_DISTANCE = 20
local SPEED_MULT = 0.45
local PREDICT = 0.16

-- update character
local function updateChar()
    local char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
end

updateChar()
player.CharacterAdded:Connect(updateChar)

-- find ball (leve)
local function getBall()

    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("BasePart") and v.Name:lower():find("ball") then
            return v
        end
    end

end

-- parry
local function parry()

    VIM:SendMouseButtonEvent(0,0,0,true,game,0)
    task.wait()
    VIM:SendMouseButtonEvent(0,0,0,false,game,0)

end

-- loop mais leve
RunService.Heartbeat:Connect(function()

    if not hrp then return end

    local ball = getBall()
    if not ball then return end

    local vel = ball.AssemblyLinearVelocity
    local speed = vel.Magnitude

    if speed < 5 then return end

    local predicted = ball.Position + vel * PREDICT

    local distance = (predicted - hrp.Position).Magnitude

    local range = BASE_DISTANCE + (speed * SPEED_MULT)

    local direction = (hrp.Position - ball.Position).Unit
    local dot = vel.Unit:Dot(direction)

    if dot > 0.25 and distance <= range then
        parry()
    end

end)

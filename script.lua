-- Universal Death Ball Auto Parry

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local hrp

-- CONFIG
local BASE_DISTANCE = 20
local SPEED_MULT = 0.45
local PREDICT_TIME = 0.18

-- update character
local function updateChar()
    local char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
end

updateChar()
player.CharacterAdded:Connect(updateChar)

-- detect ball automatically
local function getBall()

    local fastest
    local speed = 0

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then

            local vel = v.AssemblyLinearVelocity or v.Velocity
            local mag = vel.Magnitude

            if mag > speed and mag > 10 then
                speed = mag
                fastest = v
            end

        end
    end

    return fastest
end

-- parry
local function parry()

    VIM:SendMouseButtonEvent(0,0,0,true,game,0)
    task.wait()
    VIM:SendMouseButtonEvent(0,0,0,false,game,0)

end

-- main loop
RunService.RenderStepped:Connect(function()

    if not hrp then return end

    local ball = getBall()
    if not ball then return end

    local vel = ball.AssemblyLinearVelocity or ball.Velocity
    local speed = vel.Magnitude

    if speed < 10 then return end

    -- predicted position
    local predicted = ball.Position + vel * PREDICT_TIME

    local distance = (predicted - hrp.Position).Magnitude

    -- dynamic range
    local range = BASE_DISTANCE + (speed * SPEED_MULT)

    -- check direction
    local toPlayer = (hrp.Position - ball.Position).Unit
    local dot = vel.Unit:Dot(toPlayer)

    -- curve protection
    if speed > 120 then
        range = range + 8
    end

    if dot > 0.2 and distance <= range then
        parry()
    end

end)

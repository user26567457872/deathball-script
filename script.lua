local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local hrp

local function updateChar()
    local char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
end

updateChar()
player.CharacterAdded:Connect(updateChar)

local function getBall()

    local fastest
    local speed = 0

    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("BasePart") then

            local vel = v.AssemblyLinearVelocity
            local mag = vel.Magnitude

            if mag > speed and mag > 20 then
                speed = mag
                fastest = v
            end

        end
    end

    return fastest
end

local function parry()
    VIM:SendMouseButtonEvent(0,0,0,true,game,0)
    task.wait()
    VIM:SendMouseButtonEvent(0,0,0,false,game,0)
end

RunService.Heartbeat:Connect(function()

    if not hrp then return end

    local ball = getBall()
    if not ball then return end

    local vel = ball.AssemblyLinearVelocity
    local speed = vel.Magnitude

    local distance = (ball.Position - hrp.Position).Magnitude

    if speed > 20 and distance < 25 then
        parry()
    end

end)

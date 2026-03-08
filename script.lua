-- Death Ball Improved

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- SETTINGS
local settings = {
AutoParry = true,
Prediction = true,
BaseDistance = 20,
VelocityMultiplier = 0.4
}

-- Character handler
local hrp

local function updateChar()
    local char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
end

updateChar()

player.CharacterAdded:Connect(updateChar)

-- BALL FINDER
local function getBall()

for _,v in pairs(workspace:GetChildren()) do

if v:IsA("Part") and string.find(v.Name:lower(),"ball") then
return v
end

end

end

-- PREDICTION
local function predict(ball)

if not settings.Prediction then
return ball.Position
end

return ball.Position + ball.Velocity * 0.15

end

-- PARRY
local function parry()

VIM:SendMouseButtonEvent(0,0,0,true,game,0)
task.wait()
VIM:SendMouseButtonEvent(0,0,0,false,game,0)

end

-- LOOP
RunService.RenderStepped:Connect(function()

if not settings.AutoParry then return end
if not hrp then return end

local ball = getBall()
if not ball then return end

local vel = ball.Velocity
if vel.Magnitude == 0 then return end

local predicted = predict(ball)

local distance = (predicted - hrp.Position).Magnitude

local dynamic = settings.BaseDistance + (vel.Magnitude * settings.VelocityMultiplier)

local direction = (hrp.Position - ball.Position).Unit
local dot = vel.Unit:Dot(direction)

if distance <= dynamic and dot > 0.35 then

parry()

end

end)

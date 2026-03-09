-- Advanced Auto Parry

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local hrp

local BASE_DISTANCE = 22
local SPEED_MULT = 0.55
local PREDICT = 0.2

local function updateChar()
    local char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
end

updateChar()
player.CharacterAdded:Connect(updateChar)

local function getBall()

for _,v in pairs(workspace:GetChildren()) do
    if v:IsA("BasePart") and v.Name:lower():find("ball") then
        return v
    end
end

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

if speed < 5 then return end

local predicted = ball.Position + vel * PREDICT

local distance = (predicted - hrp.Position).Magnitude

local dynamic = BASE_DISTANCE + (speed * SPEED_MULT)

local direction = (hrp.Position - ball.Position).Unit
local dot = vel.Unit:Dot(direction)

if speed > 120 then
dynamic = dynamic + 10
end

if dot > 0.2 and distance <= dynamic then

parry()

if speed > 150 then
parry()
parry()
end

end

end)
print("SCRIPT DO GITHUB CARREGOU")

local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,100)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.new(0,1,0)

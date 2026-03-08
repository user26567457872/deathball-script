-- Death Ball Ultimate Hub

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- CONFIG
local settings = {
AutoParry = true,
SpamParry = true,
Prediction = true,
BallESP = true,
AutoTarget = false,
Mode = "Legit", -- Legit / Rage
BaseDistance = 18,
VelocityMultiplier = 0.35,
SpamSpeed = 120
}

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DeathBallUltimate"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,220)
frame.Position = UDim2.new(0,20,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Death Ball Ultimate"
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.new(1,1,1)

local function button(name,pos,func)
local b = Instance.new("TextButton",frame)
b.Size = UDim2.new(1,0,0,30)
b.Position = UDim2.new(0,0,0,pos)
b.Text = name
b.BackgroundColor3 = Color3.fromRGB(45,45,45)

b.MouseButton1Click:Connect(func)
end

button("Toggle Auto Parry",40,function()
settings.AutoParry = not settings.AutoParry
end)

button("Toggle Spam Parry",75,function()
settings.SpamParry = not settings.SpamParry
end)

button("Toggle Ball ESP",110,function()
settings.BallESP = not settings.BallESP
end)

button("Toggle Auto Target",145,function()
settings.AutoTarget = not settings.AutoTarget
end)

button("Switch Mode",180,function()

if settings.Mode == "Legit" then
settings.Mode = "Rage"
else
settings.Mode = "Legit"
end

end)

-- pegar bola
local function getBall()

for _,v in pairs(workspace:GetDescendants()) do

if v:IsA("Part") and v.Name:lower():find("ball") then
return v
end

end

end

-- predição
local function predict(ball)

if not settings.Prediction then
return ball.Position
end

return ball.Position + (ball.Velocity * 0.12)

end

-- parry
local function parry()

VIM:SendMouseButtonEvent(0,0,0,true,game,0)
task.wait()
VIM:SendMouseButtonEvent(0,0,0,false,game,0)

end

-- ESP
local highlight

local function esp(ball)

if not settings.BallESP then
if highlight then highlight:Destroy() highlight=nil end
return
end

if ball then

if not highlight then
highlight = Instance.new("Highlight")
highlight.FillColor = Color3.fromRGB(255,0,0)
highlight.Parent = ball
end

highlight.Adornee = ball

end

end

-- auto target
local function getTarget()

local closest
local dist = math.huge

for _,p in pairs(Players:GetPlayers()) do

if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then

local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude

if d < dist then
dist = d
closest = p
end

end

end

return closest

end

-- loop
RunService.RenderStepped:Connect(function()

if not settings.AutoParry then return end

local ball = getBall()
if not ball then return end

esp(ball)

local predicted = predict(ball)

local distance = (predicted - hrp.Position).Magnitude
local velocity = ball.Velocity.Magnitude

local dynamic = settings.BaseDistance + (velocity * settings.VelocityMultiplier)

if settings.Mode == "Rage" then
dynamic = dynamic + 10
end

local direction = (hrp.Position - ball.Position).Unit
local dot = ball.Velocity.Unit:Dot(direction)

if distance <= dynamic and dot > 0.4 then

parry()

if settings.SpamParry and velocity > settings.SpamSpeed then

for i=1,5 do
parry()
end

end

end

end)

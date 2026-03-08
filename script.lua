-- Death Ball Hub

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
BallESP = true,
BaseDistance = 18,
VelocityMultiplier = 0.35,
SpamSpeed = 120
}

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DeathBallHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,160)
frame.Position = UDim2.new(0,20,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local function makeButton(text, y, callback)
local b = Instance.new("TextButton", frame)
b.Size = UDim2.new(1,0,0,30)
b.Position = UDim2.new(0,0,0,y)
b.Text = text
b.BackgroundColor3 = Color3.fromRGB(45,45,45)

b.MouseButton1Click:Connect(callback)
end

makeButton("Toggle Auto Parry",0,function()
settings.AutoParry = not settings.AutoParry
end)

makeButton("Toggle Spam Parry",35,function()
settings.SpamParry = not settings.SpamParry
end)

makeButton("Toggle Ball ESP",70,function()
settings.BallESP = not settings.BallESP
end)

-- encontrar bola
local function getBall()

for _,v in pairs(workspace:GetDescendants()) do

if v:IsA("Part") and v.Name:lower():find("ball") then
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

-- ESP
local highlight

local function updateESP(ball)

if not settings.BallESP then
if highlight then highlight:Destroy() end
return
end

if ball then

if not highlight then
highlight = Instance.new("Highlight")
highlight.Parent = ball
end

highlight.Adornee = ball

end

end

-- loop principal
RunService.RenderStepped:Connect(function()

if not settings.AutoParry then return end

local ball = getBall()
if not ball then return end

updateESP(ball)

local distance = (ball.Position - hrp.Position).Magnitude
local velocity = ball.Velocity.Magnitude

local dynamicDistance = settings.BaseDistance + (velocity * settings.VelocityMultiplier)

-- verificar direção da bola
local direction = (hrp.Position - ball.Position).Unit
local dot = ball.Velocity.Unit:Dot(direction)

if distance <= dynamicDistance and dot > 0.5 then

parry()

if settings.SpamParry and velocity > settings.SpamSpeed then

for i = 1,3 do
parry()
end

end

end

end)

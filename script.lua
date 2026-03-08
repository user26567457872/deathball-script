-- Death Ball Auto Parry Base

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local parryDistance = 20

local function getBall()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name:lower():find("ball") then
            return v
        end
    end
end

local function parry()
    VIM:SendMouseButtonEvent(0,0,0,true,game,0)
    task.wait()
    VIM:SendMouseButtonEvent(0,0,0,false,game,0)
end

RunService.RenderStepped:Connect(function()

    local ball = getBall()
    if not ball then return end

    local distance = (ball.Position - hrp.Position).Magnitude

    if distance <= parryDistance then
        parry()
    end

end)

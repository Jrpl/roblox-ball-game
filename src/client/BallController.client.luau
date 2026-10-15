local Players = game:GetService("Players")
local localUserId = Players.LocalPlayer.UserId
local PlayerModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
local controls = PlayerModule:GetControls()
local RunService = game:GetService("RunService")

local function isMyBall(child)
    return child:IsA("Part") and child:GetAttribute("UserId") == localUserId
end

local function findMyBall()
    for _, child in workspace:GetChildren() do
        if isMyBall(child) then
            return child
        end
    end

    local newChild
    repeat newChild = workspace.ChildAdded:Wait() until isMyBall(newChild)

    return newChild
end

local ball = findMyBall()
workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
workspace.CurrentCamera.CameraSubject = ball
print("Camera is now following my ball: " .. ball:GetFullName())

local moveVector
RunService.PreSimulation:Connect(function()
    if controls:GetMoveVector() ~= moveVector then
        moveVector = controls:GetMoveVector()
        print("Move vector changed: " .. tostring(moveVector))
    end
end)
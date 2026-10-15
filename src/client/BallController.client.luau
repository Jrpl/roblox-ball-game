local Players = game:GetService("Players")
local localUserId = Players.LocalPlayer.UserId
local PlayerModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
local controls = PlayerModule:GetControls()
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.BallConfig)

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

local spin = ball:WaitForChild("Spin")
local lastFwd = Vector3.new(0, 0, -1)
RunService.PreSimulation:Connect(function()
    local moveVector = controls:GetMoveVector()
    local lookVector = workspace.CurrentCamera.CFrame.LookVector
    local flat = Vector3.new(lookVector.X, 0, lookVector.Z)
    local fwd = lastFwd

    if flat.Magnitude >= 0.01 then
        fwd = flat.Unit
        lastFwd = fwd
    end

    local right = fwd:Cross(Vector3.yAxis)
    local dir = right * moveVector.X - fwd * moveVector.Z

    if dir.Magnitude > 0.01 then
        spin.Enabled = true
        spin.AngularVelocity = Vector3.yAxis:Cross(dir.Unit) * Config.MaxSpin
    else
        spin.Enabled = false
    end
end)
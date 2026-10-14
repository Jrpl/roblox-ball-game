local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.BallConfig)
local PhysProperties = PhysicalProperties.new(Config.Density, Config.Friction, Config.Elasticity, 1, 1)
local spawn = workspace.Start.Spawn
local balls = {}

Players.PlayerAdded:Connect(function(player)
    print("Player joined: " .. player.Name)
    local ball = Instance.new("Part")
    ball.Name = "PlayerBall"
    ball.Anchored = false
    ball.Shape = Enum.PartType.Ball
    ball.Color = Color3.new(0.031373, 0.54902, 0.752941)
    ball.Size = Vector3.one * Config.BallDiameter
    ball.CustomPhysicalProperties = PhysProperties
    ball.CFrame = spawn.WorldCFrame + Vector3.yAxis * (Config.BallDiameter / 2)
    ball:SetAttribute("UserId", player.UserId)
    ball.Parent = workspace
    ball:SetNetworkOwner(player)
    balls[player.UserId] = ball
end)

Players.PlayerRemoving:Connect(function(player)
    print("Player left: " .. player.Name)
    local ball = balls[player.UserId]
    if ball then
        ball:Destroy()
        balls[player.UserId] = nil
    end
end)
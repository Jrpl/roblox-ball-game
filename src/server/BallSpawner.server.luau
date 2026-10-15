local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.BallConfig)
local PhysProperties = PhysicalProperties.new(Config.Density, Config.Friction, Config.Elasticity, 1, 1)
local spawn = workspace:WaitForChild("Start"):WaitForChild("Spawn")
local balls = {}

local function onPlayerAdded(player)
    print("Player joined: " .. player.Name)
    local ball = Instance.new("Part")
    ball.Name = "PlayerBall"
    ball.Anchored = false
    ball.Shape = Enum.PartType.Ball
    ball.Color = Color3.new(0.031373, 0.54902, 0.752941)
    ball.Material = Enum.Material.Plaster
    ball.Size = Vector3.one * Config.BallDiameter
    ball.CustomPhysicalProperties = PhysProperties
    ball.CFrame = spawn.WorldCFrame + Vector3.yAxis * (Config.BallDiameter / 2)
    ball:SetAttribute("UserId", player.UserId)
    ball.Parent = workspace
    ball:SetNetworkOwner(player)
    balls[player.UserId] = ball
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in Players:GetPlayers() do
    onPlayerAdded(player)
end

Players.PlayerRemoving:Connect(function(player)
    print("Player left: " .. player.Name)
    local ball = balls[player.UserId]
    if ball then
        ball:Destroy()
        balls[player.UserId] = nil
    end
end)
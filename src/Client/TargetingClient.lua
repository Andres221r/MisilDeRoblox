local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage:WaitForChild("MissileConfig"))
local launchEvent = ReplicatedStorage:WaitForChild("LaunchMissileEvent")

local player = Players.LocalPlayer
local gui = script.Parent
local targetList = gui:WaitForChild("TargetList")
local selectButton = gui:WaitForChild("SelectPosition")

local selectingPosition = false

local function refreshTargets()
    targetList:ClearAllChildren()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not Config.ExcludedObjects[obj.Name] then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 24)
            button.Text = obj:GetFullName()
            button.Parent = targetList
            button.MouseButton1Click:Connect(function()
                launchEvent:FireServer(obj, obj.Position)
            end)
        end
    end
end

selectButton.MouseButton1Click:Connect(function()
    selectingPosition = not selectingPosition
    selectButton.Text = selectingPosition and "Click en el mapa" or "Elegir posicion"
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if selectingPosition and input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
        local mouse = player:GetMouse()
        local position = mouse.Hit.Position
        launchEvent:FireServer(nil, position)
        selectingPosition = false
        selectButton.Text = "Elegir posicion"
    end
end)

refreshTargets()

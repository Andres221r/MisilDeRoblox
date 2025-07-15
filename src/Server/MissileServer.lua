local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage:WaitForChild("MissileConfig"))

local launchEvent = Instance.new("RemoteEvent")
launchEvent.Name = "LaunchMissileEvent"
launchEvent.Parent = ReplicatedStorage

local function createAttachment(part)
    local att = Instance.new("Attachment")
    att.Name = "MissileAttachment"
    att.Parent = part
    return att
end

local function createAlignOrientation(attachment)
    local align = Instance.new("AlignOrientation")
    align.Attachment0 = attachment
    align.Responsiveness = Config.OrientationResponsiveness
    align.Parent = attachment.Parent
    return align
end

local function createLinearVelocity(attachment, velocity)
    local linVel = Instance.new("LinearVelocity")
    linVel.Attachment0 = attachment
    linVel.MaxForce = Config.MaxForce
    linVel.VectorVelocity = velocity
    linVel.Parent = attachment.Parent
    return linVel
end

local function spawnExplosion(pos)
    local explosion = Instance.new("Explosion")
    explosion.BlastRadius = Config.ExplosionRadius
    explosion.Position = pos
    explosion.Parent = workspace
end

local function spawnMissile(targetPart, targetPosition)
    local missileTemplate = ReplicatedStorage:FindFirstChild(Config.MissileModelName)
    if not missileTemplate then
        warn("No se encontro el modelo del misil: " .. Config.MissileModelName)
        return
    end

    local missile = missileTemplate:Clone()
    local body = missile.PrimaryPart or missile:FindFirstChildWhichIsA("BasePart")
    if not body then
        warn("El misil no tiene una parte primaria")
        return
    end
    missile.PrimaryPart = body
    missile:SetPrimaryPartCFrame(CFrame.new(Config.LaunchPosition))
    missile.Parent = workspace

    local attachment = body:FindFirstChild("MissileAttachment") or createAttachment(body)
    local align = createAlignOrientation(attachment)
    local velocity = createLinearVelocity(attachment, Vector3.new(0, Config.InitialSpeed, 0))

    coroutine.wrap(function()
        local startTime = os.clock()
        while missile.Parent and os.clock() - startTime < Config.AutoDestructTime do
            if targetPart and targetPart.Parent then
                targetPosition = targetPart.Position
            end
            local direction = (targetPosition - body.Position).Unit
            velocity.VectorVelocity = direction * Config.CruiseSpeed
            align.CFrame = CFrame.lookAt(body.Position, targetPosition)
            RunService.Heartbeat:Wait()
        end
        if missile.Parent then
            spawnExplosion(body.Position)
            missile:Destroy()
        end
    end)()
end

launchEvent.OnServerEvent:Connect(function(player, targetPart, targetPosition)
    if typeof(targetPosition) == "Vector3" then
        spawnMissile(targetPart, targetPosition)
    end
end)

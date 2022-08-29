-- https://www.roblox.com/games/340227283/RoBowling

local LocalPlayer = game.Players.LocalPlayer
function CharAdded(chararg)
local LocalCharacter = chararg
local CurrentBowlingBall
local function ExplosiveBall(Model)
    Model.HitBox.Touched:Connect(function(instnc)
        if string.find(instnc.Name,"Pin") then
            local BBExp = Instance.new("Explosion")
            BBExp.Position = Model.HitBox.Position
            BBExp.Parent = Model.HitBox
        end
    end)
end
LocalCharacter.ChildAdded:Connect(function(instance)
    if instance.Name == "BowlingBall" then
        CurrentBowlingBall = instance
        ExplosiveBall(instance)
    end
end)
end

CharAdded(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(CharAdded)

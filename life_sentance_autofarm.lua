-- anticheat crippler

pcall(function()
    game:GetService("ReplicatedStorage").Events.ADMIN:Destroy() -- incase silly goofy goofers execute twice
end)

local LocalPlayer = game.Players.LocalPlayer
local oldhmmi
local oldhmmnc
oldhmmi = hookmetamethod(game, "__index", function(self, method)
	if self == LocalPlayer and method:lower() == "kick" then
		return error("Expected ':' not '.' calling member function Kick", 2)
	end
	return oldhmmi(self, method)
end)
oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
	if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
		return
	end
	return oldhmmnc(self, ...)
end)
-- anticheat crippled

-- variables yuh
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
local V3 = Vector3.new
local BountyListings = game:GetService("ReplicatedStorage").BountyListings
local BountyNPC = workspace:WaitForChild("BountyNPC")

-- functions yuh

local function TPTo(Position)
    Character:PivotTo(Position)
end

local function Punch()
    game:GetService("ReplicatedStorage").Events.WeaponEvent:FireServer("Swing")
end

local function BuyKnife()
    local OP = Character.HumanoidRootPart.CFrame
    TPTo(workspace.Buttons.KnifeButton.Button.CFrame)
    task.wait(0.5)
    fireproximityprompt(workspace.Buttons.KnifeButton.Button.ProximityPrompt,1)
    task.wait(0.5)
    TPTo(OP)
end

local function Finish()
    game:GetService("ReplicatedStorage").Events.WeaponEvent:FireServer("EPress")
end

local function GetBounties()
    local Bounties = {}
    for _,v in pairs(BountyListings:GetChildren()) do
        if v.Name ~= LocalPlayer.Name then
            Bounties[v.Name] = v.Value
        end
    end
    return Bounties
end

local function GetCharacterFromName(Name)
    if Name ~= nil then
        for _,Player in pairs(game:GetService("Players"):GetPlayers()) do
            if Player.Character and Player.Character.HumanoidRootPart and Player.Character:FindFirstChild("ForceField") == nil and Player.Backpack.Stats and Player.Backpack.Stats.Dead.Value == false then
                return workspace:FindFirstChild(Name)
            end
        end
        end
    return false
end

local function GetBounty(Name)
    local OP = Character.HumanoidRootPart.CFrame
    
    local args = {
        [1] = "AcceptBounty",
        [2] = Name
    }
    
    TPTo(BountyNPC.HumanoidRootPart.CFrame)
    
    task.wait(0.5)
    
    game:GetService("ReplicatedStorage").Events.WeaponEvent:FireServer(unpack(args))
    
    task.wait(0.5)
    
    TPTo(OP)
end

local function KillPlayer(Name)
    
    if LocalPlayer.Backpack:FindFirstChild("Knife") then
        LocalPlayer.Backpack:FindFirstChild("Knife").Parent = Character
    elseif LocalPlayer.Backpack:FindFirstChild("Fists") and not Character:FindFirstChild("Knife") then
        LocalPlayer.Backpack:FindFirstChild("Fists").Parent = Character
    end
    
    local OP = Character.HumanoidRootPart.CFrame
    
    local EnemyChar = GetCharacterFromName(Name)
    if EnemyChar then
        repeat
            task.wait()
            if Character.Humanoid.Health > 50 then
                TPTo(EnemyChar.HumanoidRootPart.CFrame * CFrame.new(0, -1, math.random(1,2)))
            else
                TPTo(CFrame.new(V3(0,2000,0)))
            end
            Punch()
        until (EnemyChar == nil or game.Players:FindFirstChild(EnemyChar.Name) == nil) or (game.Players:GetPlayerFromCharacter(EnemyChar).Backpack == nil or game.Players:GetPlayerFromCharacter(EnemyChar).Backpack.Stats.Downed.Value == true)
        repeat
            task.wait()
            if Character.Humanoid.Health > 50 then
                TPTo(EnemyChar.HumanoidRootPart.CFrame + V3(0,3,0))
            else
                TPTo(CFrame.new(V3(0,2000,0)))
            end
            Finish()
        until EnemyChar == nil or game.Players:GetPlayerFromCharacter(EnemyChar).Backpack.Stats.Dead.Value == true
    end
    
    TPTo(OP)
end

-- main loop time
TPTo(CFrame.new(V3(0,2000,0)))
BuyKnife()

while true do
    wait() -- justincase
    if Character.Humanoid.Health > 50 then
        local HighestBounty = {nil,0}
        for i,v in pairs(GetBounties()) do
            if v > HighestBounty[2] and GetCharacterFromName(i) then
                HighestBounty = {i,v}
            end
        end
        print("[?] ".."Highest bounty is",HighestBounty[1],"with a bounty of",HighestBounty[2])
        local CurrentBounty = GetCharacterFromName(HighestBounty[1])
        if CurrentBounty then
            print("[?] "..HighestBounty[1].."'s character has been found!")
            warn("[!] Accepting bounty of",HighestBounty[1])
            GetBounty(HighestBounty[1])
            warn("[!] Accepted bounty, attempting to kill player.")
            KillPlayer(HighestBounty[1])
            warn("[!] Claimed $",HighestBounty[2],"bounty of",HighestBounty[1].."!")
        elseif HighestBounty[1] == nil then
            error("[!] All bounties claimed. Consider switching servers!")
        end
    end
end
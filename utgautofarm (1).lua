-- this is really messy and ineffienct, but it works i guess, feel free to improve

local WebhookURL = "https://discord.com/api/webhooks/xxx"

local HS = game:GetService("HttpService")

game:GetService("ReplicatedStorage").RemoteEvents:Destroy() -- lazy anticheat bypass

local MessageData = {["content"] = "Money - " .. tostring(game.Players.LocalPlayer.CoinAmount.Value)}

local opos = Vector3.new(500,100,500) -- random spot outside da map

task.spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function() workspace.Gravity = 0 end) -- idk why just for "stability"
end)
task.spawn(function()
while wait(0.1) do
    for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
				child.CanCollide = false
			end
        end
    end
end)

local platform = Instance.new("Part")
platform.Size = Vector3.new(10,0.5,10)
platform.Position = Vector3.new(500,95,500)
platform.Transparency = 0.5
platform.Anchored = true
platform.Parent = workspace

-- !!! SKIDDED FROM INFINITE YIELD OMG !!! v

for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "Right Leg" or
				v.Name == "Left Leg" or
				v.Name == "Right Arm" or
				v.Name == "Left Arm" then
				v:Destroy()
			end
end
for i,v in next, game.Players.LocalPlayer.Character:GetDescendants() do
		if v:IsA("Accessory") then
			for i,p in next, v:GetDescendants() do
				if p:IsA("Weld") then
					p:Destroy()
				end
			end
		end
end

-- !!! SKIDDED FROM INFINITE YIELD OMG !!! ^

task.spawn(function()
    while task.wait(10) do
        for i,v in ipairs(workspace:GetDescendants()) do
            if v.Name == "Barriers" then v:Destroy() end -- could do this more efficiently, but im lazy
        end
    end
end)

game.Players.LocalPlayer.Character.HumanoidRootPart.Transparency = 0.5

local ALPos = Instance.new("AlignPosition")
local ATT = Instance.new("Attachment")
ATT.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
ALPos.MaxForce = 9e9
ALPos.MaxVelocity = 9e9
ALPos.Mode = Enum.PositionAlignmentMode.OneAttachment
ALPos.Attachment0 = ATT
ALPos.Position = opos
ALPos.Responsiveness = 200
ALPos.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart

local moolahfolder
for i,v in pairs(workspace:GetChildren()) do
    if v:IsA("Folder") and string.find(v.Name,"%d+") then
        moolahfolder = v
    end
end

moolahfolder.ChildAdded:Connect(function(v)
    oldM = game.Players.LocalPlayer.CoinAmount.Value
    pcall(function()
        task.wait(0.5)
        ALPos.Position = v:FindFirstChildOfClass("MeshPart").Position
        wait(game.Players.LocalPlayer:GetNetworkPing() + 0.65)
        ALPos.Position = opos
        if game.Players.LocalPlayer.CoinAmount.Value > oldM then
            MessageData = {["content"] = "[UTG AUTOFARM] - Collected " .. tostring(game.Players.LocalPlayer.CoinAmount.Value - oldM) .. "$" .. " | Currently at "..tostring(game.Players.LocalPlayer.CoinAmount.Value).."$"}
            MessageData = HS:JSONEncode(MessageData)
            syn.request({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = MessageData})
        end
    end)
end)
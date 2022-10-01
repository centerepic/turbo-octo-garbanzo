local ScreenGui = Instance.new("ScreenGui")
local ProfitLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 1000
ProfitLabel.Parent = ScreenGui
ProfitLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProfitLabel.BackgroundTransparency = 1.000
ProfitLabel.Position = UDim2.new(0.5, -190, 0.5, -25)
ProfitLabel.Size = UDim2.new(0, 380, 0, 50)
ProfitLabel.Font = Enum.Font.Arcade
ProfitLabel.Text = "Profit - 0$"
ProfitLabel.TextColor3 = Color3.fromRGB(4, 255, 0)
ProfitLabel.TextScaled = true
ProfitLabel.TextSize = 14.000
ProfitLabel.TextStrokeColor3 = Color3.fromRGB(8, 7, 7)
ProfitLabel.TextStrokeTransparency = 0.000
ProfitLabel.TextWrapped = true

local function Profit(Status)
    ProfitLabel.Text = Status
end

-- this is really messy and ineffienct, but it works i guess, feel free to improve

game:GetService("ReplicatedStorage").RemoteEvents:Destroy() -- lazy anticheat bypass

local opos = Vector3.new(500,100,500) -- random spot outside da map

task.spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function() workspace.Gravity = 0 end) -- idk why just for "stability"
end)

task.spawn(function()
while wait(0.1) do
    for _, child in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		if child:IsA("BasePart") and child.CanCollide == true then
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

oldM = game.Players.LocalPlayer.CoinAmount.Value

moolahfolder.ChildAdded:Connect(function(v)
    pcall(function()
        task.wait(0.5)
        ALPos.Position = v:FindFirstChildOfClass("MeshPart").Position
        wait(game.Players.LocalPlayer:GetNetworkPing() + 0.65)
        ALPos.Position = opos
        if game.Players.LocalPlayer.CoinAmount.Value > oldM then
	    Profit("Profit - "..tostring(game.Players.LocalPlayer.CoinAmount.Value - oldM).."$")
        end
    end)
end)

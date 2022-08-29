



-- essentially all you need to do is Path2CFrame( cframe of wherever u want to walk to )
-- will not work if it has to climb ladders or do long jumps, or any parkour pretty much.
-- if it gets stuck it should try jumping and if that doesnt work it will teleport




local PathfindService = game:GetService("PathfindingService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character
local PlayerMod = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerMod:GetControls()
local Mouse = LocalPlayer:GetMouse()
local CurrentlyPathing = false
local TweenService = game:GetService("TweenService")
local TweenI = TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
local VisualFolder = Instance.new("Folder",workspace)
local CurrentWaypoint = nil
VisualFolder.Name = "PathVisuals"

CurrentPath = nil

--/

local function UpdateVisualPoint(Point,Remove,Color)
	task.spawn(function()
		if Remove == true then
			TweenService:Create(Point,TweenI,{Color3 = Color3.new(0.454902, 0.454902, 0.454902)}):Play()
			TweenService:Create(Point,TweenI,{Transparency = 1}):Play()
			wait(1)
			Point.Parent:Destroy()
		else
			TweenService:Create(Point,TweenI,{Color3 = Color}):Play()
		end end)
end

local function CreateVisualPoint(Position)
	local A = Instance.new("Part")
	local B = Instance.new("SelectionSphere")
	A.Anchored = true
	A.CanCollide = false
	A.Size = Vector3.new(0.001,0.001,0.001)
	A.Position = Position + Vector3.new(0,2,0)
	A.Transparency = 1
	A.Parent = VisualFolder
	A.Name = tostring(Position)
	B.Transparency = 1
	B.Parent = A
	B.Adornee = A
	B.Color3 = Color3.new(1, 0, 0.0156863)
	TweenService:Create(B,TweenI,{Transparency = 0}):Play()
end

local function Path2CFrame(CoordinateFrame)
	
	CurrentlyPathing = false
	
	for i,v in pairs(VisualFolder:GetChildren()) do
		UpdateVisualPoint(v.SelectionSphere,true)
	end

	local Humanoid = Character:FindFirstChild("Humanoid")
	Controls:Disable()
	-- Method 1 - Roblox pathfinding service
	CurrentPath = PathfindService:FindPathAsync(Character.HumanoidRootPart.Position,CoordinateFrame.Position)
	if CurrentPath.Status == Enum.PathStatus.Success then
		
		CurrentlyPathing = true
		
		local TickT = 0.1
		for i,v in pairs(CurrentPath:GetWaypoints()) do
			CreateVisualPoint(v.Position)
			task.wait(TickT)
			TickT = TickT - 0.1/#CurrentPath:GetWaypoints()
		end
		
		spawn(function()
			local TimesFailed = 0
			while task.wait(1) and CurrentlyPathing == true do
				
				if TimesFailed == 2 then
					print("[!] Attempt to get unstuck failed, teleporting to next waypoint.")
					Character:SetPrimaryPartCFrame(CFrame.new(CurrentWaypoint.Position + Vector3.new(0,2,0)))
					Humanoid.WalkToPoint = CurrentWaypoint.Position
					TimesFailed = 0
				end
				
				if (Character.HumanoidRootPart.Velocity).Magnitude < 0.01 then
					Humanoid.WalkToPoint = CurrentWaypoint.Position
					task.wait(1)
					if (Character.HumanoidRootPart.Velocity).Magnitude < 0.01 then -- Double check
						TimesFailed = TimesFailed + 1
						print("[!] Stuck, attempting to jump.")
						Humanoid.Jump = true
						wait()
						Humanoid.WalkToPoint = CurrentWaypoint.Position
					end
				else
					TimesFailed = 0
				end
				
			end
		end) -- should be seperate thread but keeps yielding next loop? (SOLVED, jumping cancels moveto)
		
		for i,v in pairs(CurrentPath:GetWaypoints()) do

			UpdateVisualPoint(VisualFolder[tostring(v.Position)].SelectionSphere,false,Color3.new(0.0980392, 1, 0))
			
			CurrentWaypoint = v
			Humanoid.WalkToPoint = v.Position

			print()
			print("[Debug] WalkToPoint set to ",v.Position)

			repeat task.wait() until (Character.HumanoidRootPart.Position - v.Position).Magnitude < 3.5
			
			if CurrentPath:GetWaypoints()[i+1] ~= nil and CurrentPath:GetWaypoints()[i+1].Action == Enum.PathWaypointAction.Jump then
				task.spawn(function()
					task.wait(0.1)
					Humanoid.Jump = true
				end)
			end

			UpdateVisualPoint(VisualFolder[tostring(v.Position)].SelectionSphere,true)

		end
		print("[Debug] Pathing complete!")
		CurrentlyPathing = false
		Controls:Enable()
	else
		CurrentlyPathing = false
		print("[!] Method 1 failed. Utilizing fallback.")
		-- Method 2 - Custom pathfinding (Slow)
        -- did not actually implement this lol, might add A* later.
	end
end

--\

--UserInputService.InputBegan:Connect(function(Key)
	--if Key.KeyCode == Enum.KeyCode.E then
		--Path2CFrame(Mouse.Hit)
	--end
--end)

-- click to move basically ^
-- made by v3rm guy RickyLeefland (uploaded by his dearest friend), resources used from Pyseph and implementation used from HamstaGang

if not game:IsLoaded() then
	game.Loaded:Wait();
end;

local queue_on_tp = (syn and syn.queue_on_teleport or queue_on_teleport);
assert(queue_on_tp, "Exploit executor not compatible with the script.");

if not syn then
   -- Load custom secure call
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/Lua_SecureCall", true))()
end

local secure_call = (syn and syn.secure_call or cus_secure_call)

local replicatedStorage = game:GetService("ReplicatedStorage");

local localPlayer = game:GetService("Players").LocalPlayer
local playerMainLocalScript = localPlayer:WaitForChild("PlayerScripts"):WaitForChild("Game");
local eventToWaitFor = replicatedStorage:WaitForChild("Remote"):WaitForChild("Effects"):WaitForChild("ExitWarpEffect");
task.wait(4);
local routesModule = require(replicatedStorage:WaitForChild("Source"):WaitForChild("Client"):WaitForChild("Helpers"):WaitForChild("Routes"));

local scriptLoad = game:HttpGet("https://raw.githubusercontent.com/centerepic/script-host/main/bubby.lua?t="..tostring(tick()), true);

local function getNameOfDestination()    
    return routesModule.getNextSystemName();
end;

local function retrieveStarWarpFunction()
	return require(replicatedStorage.Source.Client.Flight.Warp).leaveSystem;
end;


local destinationName = getNameOfDestination();
assert(destinationName, "No destination found, aborting...");

local function GetShip()
    return workspace.Ships[localPlayer.Name] or false;
end

repeat wait() until GetShip() and GetShip():FindFirstChildOfClass("Model")


local theFunction = retrieveStarWarpFunction();
assert(theFunction, "Could not find the function???");

assert(replicatedStorage.System.Neighbors:FindFirstChild(destinationName), "Destination not detected???");

local go = false;
local NM = nil; NM = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local ncM = getnamecallmethod();

	if not checkcaller() and ncM == "FireServer" and self.Name == "ExitWarpEffect" then
		go = true;
	end;

	return NM(self, ...);
end));

repeat task.wait(); until go == true;
GetShip():FindFirstChildOfClass("Model"):PivotTo(CFrame.new(Vector3.new(0,5000,0)))
task.wait(5);
queue_on_tp(scriptLoad);
secure_call(theFunction, playerMainLocalScript, replicatedStorage.System.Neighbors[destinationName].Value);

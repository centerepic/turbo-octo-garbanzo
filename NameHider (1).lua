-- NameHide v1 | Cooler visuals I guess?
shared = {}
shared.DefaultName = "vdv"
shared.RandomNames = true
shared.RandomNameLength = 5
shared.ShuffleNames = true
shared.RandomChars = {"v","x","z"}
shared.Leaderboard = true
shared.Overhead = true
shared.Chat = false -- ONLY WORKS IF SHUFFLE NAMES ENABLED
shared.CensorSendersChat = true -- ONLY WORKS IF SHUFFLE NAMES ENABLED

local ChatFrame = game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller

function NameSet(Player)
    local CurrentName = ""
    local OriginalName = Player.DisplayName
    
    if shared.RandomNames == true then
        for x = shared.RandomNameLength,1,-1 do
            CurrentName = CurrentName .. shared.RandomChars[math.random(1,#shared.RandomChars)]
        end
    end
    
    if shared.Leaderboard == true then
        Player.DisplayName = CurrentName
    end
    
    if shared.Overhead == true then
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.DisplayName = CurrentName
        end
    end
    
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
    wait()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
    
    if shared.ShuffleNames == true then
        game:GetService("RunService").Heartbeat:Connect(function()
            CurrentName = ""
            
            if shared.RandomNames == true then
                for x = shared.RandomNameLength,1,-1 do
                    CurrentName = CurrentName .. shared.RandomChars[math.random(1,#shared.RandomChars)]
                end
            end
            
            if shared.Leaderboard == true then
                Player.DisplayName = CurrentName
            end
            
            if shared.Chat == true then
                for i,v in pairs(ChatFrame:GetChildren()) do
                    pcall(function()
                        if string.find(v.TextLabel.TextButton.Text,OriginalName) then
                            local AdjustedName = ""
                            if shared.RandomNames == true then
                                for x = (#v.TextLabel.TextButton.Text -5),1,-1 do
                                    AdjustedName = AdjustedName .. shared.RandomChars[math.random(1,#shared.RandomChars)]
                                end
                            end
                            v.TextLabel.TextButton.Text = "[" .. AdjustedName .. "]:"
                        end
                    end) -- pcall because labels dissapear alot
                end
            end
            
            if shared.CensorSendersChat == true then
                for i,v in pairs(ChatFrame:GetChildren()) do
                    pcall(function()
                        if string.find(v.TextLabel.TextButton.Text,OriginalName) then
                            v.TextLabel.TextButton.TextTransparency = 1
                            v.TextLabel.TextButton.BackgroundTransparency = 0
                        end
                    end) -- pcall because labels dissapear alot
                end
            end
            
            if shared.Overhead == true then
                if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    Player.Character.Humanoid.DisplayName = CurrentName
                end
            end
        end)
    end
end

for i,v in pairs(game:GetService("Players"):GetPlayers()) do
    NameSet(v)
end

game:GetService("Players").PlayerAdded:Connect(NameSet)
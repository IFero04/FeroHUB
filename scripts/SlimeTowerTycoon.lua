-- Variavels --
local remmotePath = game:GetService("ReplicatedStorage").GTycoonClient.Remotes
local player = game.Players.LocalPlayer
local selectedSlime = 1
local selectedRate = 1 
local obby = game:GetService("Workspace").ObbyCheckpoints
local obbyCheckpoints = {
    [1] = obby.ObbyCheckpoint1.CFrame,
    [2] = obby.ObbyCheckpoint2.CFrame + Vector3.new(-1, 0, 0),
    [3] = obby.ObbyCheckpoint3.CFrame,
    [4] = obby.ObbyCheckpoint4.CFrame,
    [5] = obby.ObbyCheckpoint5.CFrame,
    [6] = obby.ObbyCheckpoint6.CFrame,
    [7] = obby.ObbyCheckpoint7.CFrame,
    [8] = obby.ObbyCheckpoint8.CFrame,
    [9] = game:GetService("Workspace").ObbyButton2.Button.CFrame + Vector3.new(0, 20, 0),
    [10] = game:GetService("Workspace").ReturnPortals:FindFirstChild("ReturnToPlot").Portal.CFrame
}
getgenv().autoDeposit = false
getgenv().autoMerge = false
getgenv().autoCollectV1 = false
getgenv().autoCollectV2 = false
getgenv().autoBuy = false
getgenv().autoRate = false
getgenv().autoObby = false

-- Teleport CFrame
function teleportTo(placeCFrame)
    if player.Character then
        player.Character.HumanoidRootPart.CFrame = placeCFrame
    end
end

-- Auto Deposit Droplets
function doDeposit()
    spawn(function()
        while autoDeposit do
            remmotePath.DepositDrops:FireServer()
            wait(1)
        end
    end)
end

-- Auto Merge Slimes
function doMergeSlime()
    spawn(function()
        while autoMerge do
            remmotePath.MergeDroppers:FireServer()
            wait(1)
        end
    end)
end

-- Auto Collect V1
function doCollectV1()
    spawn(function()
        while autoCollectV1 do
            for i, orb in pairs(game.Workspace.Drops:GetChildren()) do
                if orb.Name == "Dropper_Drop" then
                    orb.CFrame = player.Character.HumanoidRootPart.CFrame
                end
            end
            wait()
        end
    end)
end

-- Auto Collect V2
function doCollectV2()
    spawn(function()
        while autoCollectV2 do
            local orbs = game:GetService("Workspace").Drops:GetChildren()
            for i, orb in pairs(orbs) do
                if orb.Name == "Dropper_Drop" then
                    orb.CFrame = CFrame.new(orb.Position) + Vector3.new(0, 1.25, 0)
                    teleportTo(orb.CFrame)
                    wait()
                end
                orbs = game:GetService("Workspace").Drops:GetChildren()
            end
            wait()
        end
    end)
end

-- Auto Buy Slimes
function doBuySlime(SlimeAmmont)
    spawn(function()
        while autoBuy do
            remmotePath.BuyDropper:FireServer(SlimeAmmont)
            wait(1)
        end
    end)
end

-- Buy Speed Rate
function BuySpeedRate(RateAmmont)
    spawn(function()
        while RateAmmont ~= 0 do
            remmotePath.BuySpeed:FireServer(1)
            RateAmmont = RateAmmont - 1
            wait()
        end
    end)
end
function doBuyRate()
    spawn(function()
        while autoRate do
            remmotePath.BuySpeed:FireServer(1)
            wait(1)
        end
    end)
end

--Auto Event
function doAutoObby()
    spawn(function() 
        while autoObby do
           for i, checkPoint in pairs(obbyCheckpoints) do
                if player.Character then
                    wait()
                    teleportTo(checkPoint)
                    wait(2)
                end
           end
           wait(3)
        end
    end)
end

-- HUDE
local FeroScript = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = FeroScript:MakeWindow({Name = "Fero HUB - Slime Tower Tycoon", HidePremium = false, SaveConfig = true, ConfigFolder = "FeroHUB"})

-- 1
local TabFarm = Window:MakeTab({
	Name = "Farming",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Farm = TabFarm:AddSection({
    Name = "Auto Farm"
})

Farm:AddToggle({
    Name = "Auto Collect V1",
    Default = true,
    Save = true,
    Flag = "ACV1",
    Callback = function(value)
        autoCollectV1 = value
        print("Auto Collect V1 is: ",value)
        if value then
            doCollectV1()
        end
    end
})

Farm:AddToggle({
    Name = "Auto Collect V2",
    Default = false,
    Save = true,
    Flag = "ACV2",
    Callback = function(value)
        autoCollectV2 = value
        print("Auto Collect V2 is: ",value)
        if value then
            doCollectV2()
        end
    end
})

Farm:AddToggle({
    Name = "Auto Deposit",
    Default = true,
    Save = true,
    Flag = "AD",
    Callback = function(value)
        autoDeposit = value
        print("Auto Deposit is: ",value)
        if value then
            doDeposit()
        end
    end
})

Farm:AddToggle({
    Name = "Auto Merge",
    Default = false,
    Save = true,
    Flag = "AM",
    Callback = function(value)
        autoMerge = value
        print("Auto Merge is: ",value)
        if value then
            doMergeSlime()
        end
    end
})

local Event = TabFarm:AddSection({
    Name = "Auto Event"
})

Event:AddToggle({
    Name = "Auto Obby",
    Default = false,
    Save = true,
    Flag = "AO",
    Callback = function(value)
        autoObby = value
        print("Auto Obby is: ",value)
        if value then
           doAutoObby()
        end
    end
})

-- 2
local TabBuy = Window:MakeTab({
	Name = "Buying",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local BuyS = TabBuy:AddSection({
    Name = "Buy Slimes"
})

BuyS:AddTextbox({
	Name = "Slime Ammont",
	Default = "1",
	TextDisappear = false,
    Save = true,
    Flag = "SA",
	Callback = function(value)
        tonumber(value)
        if value then
            print("Slime Ammont is: ",value)
            selectedSlime = value
        end
		if autoBuy then
            autoBuy = false
            wait(2)
            autoBuy = true
            doBuySlime(selectedSlime)
        end
	end	  
})
BuyS:AddToggle({
	Name = "Auto Buy Slime",
	Default = false,
    Save = true,
    Flag = "ABS",
	Callback = function(value)
        autoBuy = value
		print("Auto Buy Slime is: ",value)
        if value and selectedSlime then
            doBuySlime(selectedSlime)
        end
	end    
})

local BuyR = TabBuy:AddSection({
    Name = "Buy Cauldron Speed"
})

BuyR:AddSlider({
	Name = "Cauldron Rate Ammont",
	Min = 1,
	Max = 20,
	Default = 5,
	Color = Color3.fromRGB(224, 176, 255),
	Increment = 1,
    Save = true,
    Flag = "CRA",
	Callback = function(value)
		selectedRate = value
	end    
})
BuyR:AddButton({
	Name = "Buy Cauldron Speed",
    Save = true,
    Flag = "BCS",
	Callback = function()
      	if selectedRate then
            BuySpeedRate(selectedRate)
        end
  	end    
})

BuyR:AddToggle({
	Name = "Auto Buy Cauldron Speed",
	Default = false,
    Save = true,
    Flag = "ABCS",
	Callback = function(value)
        autoRate = value
		print("Auto Buy Speed Rate is: ",value)
        if value then
            doBuyRate()
        end
	end    
})

-- 3
local TabMisc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Misc = TabMisc:AddSection({
    Name = "Misc Options"
})

Misc:AddSlider({
	Name = "Walk Speed",
	Min = 16,
	Max = 200,
	Default = 25,
	Color = Color3.fromRGB(224, 176, 255),
	Increment = 1,
    Save = true,
    Flag = "WS",
	Callback = function(value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
	end    
})

Misc:AddSlider({
	Name = "Jump Power",
	Min = 50,
	Max = 200,
	Default = 50,
	Color = Color3.fromRGB(224, 176, 255),
	Increment = 1,
    Save = true,
    Flag = "JP",
	Callback = function(value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
	end    
})

Misc:AddButton({
	Name = "Anti-AFK",
	Callback = function()
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        FeroScript:MakeNotification({
            Name = "Anti-AFK",
            Content = "Anti-AFK ON, you wont be disconnected until you close the game",
            Image = "rbxassetid://4483345998",
            Time = 10
        })
  	end    
})

local UI = TabMisc:AddSection({
    Name = "UI Options"
})

UI:AddBind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.LeftControl,
    Hold = false,
    Save = true,
    Flag = "TUI",
    Callback = function()
        local UI = game:GetService("CoreGui"):FindFirstChild("Orion")
		if UI then
			UI.Enabled = not UI.Enabled
		end
    end
})

UI:AddButton({
	Name = "Destroy UI",
	Callback = function()
        autoDeposit = false
        autoMerge = false
        autoCollectV1 = false
        autoCollectV2 = false
        autoBuy = false
        autoRate = false
        autoObby = false
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        FeroScript:Destroy()
  	end    
})

-- 0
FeroScript:Init()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local hitboxSize = Vector3.new(12, 12, 12)
local isExpanded = false
local isSpeedBoostActive = false
local isInfiniteJumpActive = false
local normalSpeed = 16
local boostedSpeed = normalSpeed * 6

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local Window = Rayfield:CreateWindow({
	Name = "SkidHub | untitled tag game",
	LoadingTitle = "SkidHub | Loading..",
	LoadingSubtitle = "by nxyy",
	Theme = "Default",
	ShowText = "SkidHub",
	KeySystem = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "skidhub",
        FileName = "skidcfg"
    },
    Discord = {
        Enabled = true,
        Invite = "your",
        RememberJoins = false
    },
	KeySettings = {
		Title = "dont know",
		Subtitle = "hahah",
		Note = "get key from discord",
		FileName = "TempKeyhaha",
		SaveKey = false,
		GrabKeyFromSite = false,
		Key = {"nxyymadeyou"}
	}
})

local MainTab = Window:CreateTab("Main", "user")
local MainSection = MainTab:CreateSection("Player")

local ExpandToggle = MainTab:CreateToggle({
	Name = "Expand Hitboxes",
	CurrentValue = false,
	Flag = "ExpandHitboxes",
	Callback = function(Value)
		isExpanded = Value
		expandHitboxes()
	end,
})

local SpeedToggle = MainTab:CreateToggle({
	Name = "Speed Boost (6x)",
	CurrentValue = false,
	Flag = "SpeedBoost",
	Callback = function(Value)
		isSpeedBoostActive = Value
		humanoid.WalkSpeed = isSpeedBoostActive and boostedSpeed or normalSpeed
	end,
})

local JumpToggle = MainTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "InfiniteJump",
	Callback = function(Value)
		isInfiniteJumpActive = Value
	end,
})

local ExpandKeybind = MainTab:CreateKeybind({
	Name = "Expand Hitboxes",
	CurrentKeybind = "E",
	Flag = "ExpandHitboxesKeybind",
	Callback = function()
		isExpanded = not isExpanded
		ExpandToggle:Set(isExpanded)
		expandHitboxes()
	end,
})

local SpeedKeybind = MainTab:CreateKeybind({
	Name = "Speed Boost",
	CurrentKeybind = "V",
	Flag = "SpeedBoostKeybind",
	Callback = function()
		isSpeedBoostActive = not isSpeedBoostActive
		SpeedToggle:Set(isSpeedBoostActive)
		humanoid.WalkSpeed = isSpeedBoostActive and boostedSpeed or normalSpeed
	end,
})

local JumpKeybind = MainTab:CreateKeybind({
	Name = "Infinite Jump",
	CurrentKeybind = "J",
	Flag = "InfiniteJumpKeybind",
	Callback = function()
		isInfiniteJumpActive = not isInfiniteJumpActive
		JumpToggle:Set(isInfiniteJumpActive)
	end,
})

local function expandHitboxes()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local humanoid = player.Character:FindFirstChild("Humanoid")
			local humanoidRootPart = player.Character.HumanoidRootPart
			if humanoid and humanoid.Health > 0 then
				humanoidRootPart.Size = isExpanded and hitboxSize or Vector3.new(2, 2, 1)
				humanoidRootPart.Transparency = isExpanded and 0.5 or 1
				humanoidRootPart.CanCollide = false
			else
				humanoidRootPart.Size = Vector3.new(2, 2, 1)
				humanoidRootPart.Transparency = 1
			end
		end
	end
end

RunService.RenderStepped:Connect(expandHitboxes)

UserInputService.JumpRequest:Connect(function()
	if isInfiniteJumpActive then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

local SettingsTab = Window:CreateTab("Settings", "settings")
local SettingsSection = SettingsTab:CreateSection("Configuration")

local uiKeybind = "LeftControl"

local UIKeybind = SettingsTab:CreateKeybind({
	Name = "Toggle UI",
	CurrentKeybind = uiKeybind,
	Flag = "UIKeybind",
	Callback = function(Keybind)
		uiKeybind = Keybind
	end,
})

local function toggleUI()
	Rayfield:ToggleUI()
end

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode[uiKeybind] then
		toggleUI()
	end
end)

Rayfield:LoadConfiguration()
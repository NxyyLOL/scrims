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
	Theme = "DarkBlue",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "skidhub",
        FileName = "skidcfg"
    },
    Discord = {
        Enabled = true,
        Invite = "",
        RememberJoins = false
    }
})

local MainTab = Window:CreateTab("Main", "gamepad-directional")
local MainSection = MainTab:CreateSection("Player Mods")

local ExpandToggle = MainTab:CreateToggle({
	Name = "Expand Hitboxes",
	CurrentValue = false,
	Flag = "ExpandHitboxes",
	Keybind = {
		Attached = true,
		Desktop = Enum.KeyCode.E,
		Mobile = nil,
	},
	Callback = function(Value)
		isExpanded = Value
		expandHitboxes()
	end,
})

local SpeedToggle = MainTab:CreateToggle({
	Name = "Speed Boost (6x)",
	CurrentValue = false,
	Flag = "SpeedBoost",
	Keybind = {
		Attached = true,
		Desktop = Enum.KeyCode.V,
		Mobile = nil,
	},
	Callback = function(Value)
		isSpeedBoostActive = Value
		humanoid.WalkSpeed = isSpeedBoostActive and boostedSpeed or normalSpeed
	end,
})

local JumpToggle = MainTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "InfiniteJump",
	Keybind = {
		Attached = true,
		Desktop = Enum.KeyCode.J,
		Mobile = nil,
	},
	Callback = function(Value)
		isInfiniteJumpActive = Value
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

local uiKeybind = Enum.KeyCode.LeftControl

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
	if input.KeyCode == uiKeybind then
		toggleUI()
	end
end)
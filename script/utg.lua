local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local hitboxSliderValue = 12
local hitboxSize = Vector3.new(hitboxSliderValue, hitboxSliderValue, hitboxSliderValue)
local isExpanded = false
local isSpeedBoostActive = false
local isInfiniteJumpActive = false
local normalSpeed = 16
local boostedSpeed = normalSpeed * 6

local currentExpandKey = "E"
local currentSpeedKey = "V"
local currentJumpKey = "J"
local HitboxSizeSlider = nil

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
	ToggleUIKeybind = "K",
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
		if Value then
			HitboxSizeSlider = MainTab:CreateSlider({
				Name = "Hitbox Size",
				Range = {5, 50},
				Increment = 1,
				CurrentValue = hitboxSliderValue,
				Flag = "HitboxSize",
				Callback = function(Value)
					hitboxSliderValue = Value
					hitboxSize = Vector3.new(Value, Value, Value)
					expandHitboxes()
				end,
			})
		elseif HitboxSizeSlider then
			HitboxSizeSlider:Destroy()
			HitboxSizeSlider = nil
		end
		expandHitboxes()
	end,
})

local SpeedToggle = MainTab:CreateToggle({
	Name = "Speed Boost (6x)",
	CurrentValue = false,
	Flag = "SpeedBoost",
	Callback = function(Value)
		isSpeedBoostActive = Value
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

local MainDivider = MainTab:CreateDivider()

local CloseMenuLabel = MainTab:CreateLabel("Close the menu by using K")

local SettingsTab = Window:CreateTab("Settings", "settings")
local SettingsSection = SettingsTab:CreateSection("Configuration")

local KeybindsSection = SettingsTab:CreateSection("Keybinds")

local function updateLabel()
	CloseMenuLabel:Set("Close the menu by using K")
end

local ExpandKeybind = SettingsTab:CreateKeybind({
	Name = "Expand Hitboxes",
	CurrentKeybind = "E",
	Flag = "ExpandHitboxesKeybind",
	Callback = function()
		isExpanded = not isExpanded
		ExpandToggle:Set(isExpanded)
		expandHitboxes()
	end,
})

local SpeedKeybind = SettingsTab:CreateKeybind({
	Name = "Speed Boost",
	CurrentKeybind = "V",
	Flag = "SpeedBoostKeybind",
	Callback = function()
		isSpeedBoostActive = not isSpeedBoostActive
		SpeedToggle:Set(isSpeedBoostActive)
	end,
})

local JumpKeybind = SettingsTab:CreateKeybind({
	Name = "Infinite Jump",
	CurrentKeybind = "J",
	Flag = "InfiniteJumpKeybind",
	Callback = function()
		isInfiniteJumpActive = not isInfiniteJumpActive
		JumpToggle:Set(isInfiniteJumpActive)
	end,
})

local function expandHitboxes()
	if humanoid then
		humanoid.WalkSpeed = isSpeedBoostActive and boostedSpeed or normalSpeed
	end
	
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

Rayfield:LoadConfiguration()

task.delay(0.5, function()
	if ExpandKeybind and ExpandKeybind.CurrentKeybind then
		currentExpandKey = ExpandKeybind.CurrentKeybind
	end
	if SpeedKeybind and SpeedKeybind.CurrentKeybind then
		currentSpeedKey = SpeedKeybind.CurrentKeybind
	end
	if JumpKeybind and JumpKeybind.CurrentKeybind then
		currentJumpKey = JumpKeybind.CurrentKeybind
	end
	updateLabel()
end)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = loadstring(request({
	Url = "https://raw.githubusercontent.com/thatguyscousin9/personal-project2/main/YBA_UI",
	Method = "GET"
}).Body)()

local Window = Library:CreateWindow("Azero Hub")
local TweenService = game:GetService("TweenService")

local function CreateNotifier(window)
	local holder = Instance.new("Frame")
	holder.Name = "NotifyHolder"
	holder.Parent = window.Gui
	holder.BackgroundTransparency = 1
	holder.AnchorPoint = Vector2.new(1, 1)
	holder.Position = UDim2.new(1, -20, 1, -20)
	holder.Size = UDim2.new(0, 320, 0, 260)

	local layout = Instance.new("UIListLayout")
	layout.Parent = holder
	layout.Padding = UDim.new(0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local function notify(title, text, kind, duration)
		local colors = {
			error = Color3.fromRGB(255, 95, 95),
			success = Color3.fromRGB(90, 255, 140),
			warn = Color3.fromRGB(255, 200, 90),
			info = Color3.fromRGB(90, 140, 255)
		}

		local color = colors[kind] or colors.info
		local life = duration or 4

		local card = Instance.new("Frame")
		card.Parent = holder
		card.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
		card.BorderSizePixel = 0
		card.Size = UDim2.new(1, 0, 0, 0)
		card.ClipsDescendants = true

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = card

		local stroke = Instance.new("UIStroke")
		stroke.Parent = card
		stroke.Color = color
		stroke.Thickness = 1
		stroke.Transparency = 0.15

		local accent = Instance.new("Frame")
		accent.Parent = card
		accent.BackgroundColor3 = color
		accent.BorderSizePixel = 0
		accent.Size = UDim2.new(0, 4, 1, 0)

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Parent = card
		titleLabel.BackgroundTransparency = 1
		titleLabel.Position = UDim2.new(0, 14, 0, 8)
		titleLabel.Size = UDim2.new(1, -20, 0, 16)
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.Text = tostring(title)
		titleLabel.TextSize = 13
		titleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.TextTransparency = 1

		local textLabel = Instance.new("TextLabel")
		textLabel.Parent = card
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.new(0, 14, 0, 26)
		textLabel.Size = UDim2.new(1, -20, 0, 18)
		textLabel.Font = Enum.Font.Gotham
		textLabel.Text = tostring(text)
		textLabel.TextSize = 12
		textLabel.TextColor3 = Color3.fromRGB(190, 190, 205)
		textLabel.TextWrapped = true
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		textLabel.TextTransparency = 1
		textLabel.AutomaticSize = Enum.AutomaticSize.Y

		task.wait()
		local height = math.max(52, textLabel.TextBounds.Y + 34)

		card.Size = UDim2.new(1, 40, 0, 0)
		card.BackgroundTransparency = 1

		TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, height),
			BackgroundTransparency = 0
		}):Play()

		TweenService:Create(titleLabel, TweenInfo.new(0.2), {
			TextTransparency = 0
		}):Play()

		TweenService:Create(textLabel, TweenInfo.new(0.2), {
			TextTransparency = 0
		}):Play()

		task.delay(life, function()
			if not card.Parent then
				return
			end

			TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Size = UDim2.new(1, 40, 0, 0),
				BackgroundTransparency = 1
			}):Play()

			TweenService:Create(titleLabel, TweenInfo.new(0.15), {
				TextTransparency = 1
			}):Play()

			TweenService:Create(textLabel, TweenInfo.new(0.15), {
				TextTransparency = 1
			}):Play()

			task.wait(0.22)
			card:Destroy()
		end)
	end

	return {
		Notify = notify,
		Error = function(text, duration)
			notify("Error", text, "error", duration)
		end,
		Success = function(text, duration)
			notify("Success", text, "success", duration)
		end,
		Warn = function(text, duration)
			notify("Warning", text, "warn", duration)
		end,
		Obtained = function(name, duration)
			notify("Obtained", name, "success", duration)
		end,
		Spawned = function(name, duration)
			notify("Spawned", name, "info", duration)
		end
	}
end

local Notifier = CreateNotifier(Window)

local NotifyHolder = Window.Gui:FindFirstChild("NotifyHolder")
local ItemSpawnNotifyEnabled = false
local ItemSpawnConnection = nil
local KnownItemPrompts = {}

function Notifier:ItemSpawn(itemName, duration)
	if not NotifyHolder then
		return
	end

	local life = duration or 4

	local card = Instance.new("Frame")
	card.Parent = NotifyHolder
	card.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	card.BorderSizePixel = 0
	card.Size = UDim2.new(1, 0, 0, 0)
	card.ClipsDescendants = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = card

	local stroke = Instance.new("UIStroke")
	stroke.Parent = card
	stroke.Color = Color3.fromRGB(90, 140, 255)
	stroke.Thickness = 1
	stroke.Transparency = 0.15

	local smallText = Instance.new("TextLabel")
	smallText.Parent = card
	smallText.BackgroundTransparency = 1
	smallText.Position = UDim2.new(0, 12, 0, 8)
	smallText.Size = UDim2.new(1, -24, 0, 14)
	smallText.Font = Enum.Font.Gotham
	smallText.Text = "An Item Has Spawn"
	smallText.TextSize = 10
	smallText.TextColor3 = Color3.fromRGB(150, 150, 165)
	smallText.TextXAlignment = Enum.TextXAlignment.Left
	smallText.TextTransparency = 1

	local itemLabel = Instance.new("TextLabel")
	itemLabel.Parent = card
	itemLabel.BackgroundTransparency = 1
	itemLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	itemLabel.Position = UDim2.new(0.5, 0, 0.5, 8)
	itemLabel.Size = UDim2.new(1, -24, 0, 20)
	itemLabel.Font = Enum.Font.GothamBold
	itemLabel.Text = tostring(itemName)
	itemLabel.TextSize = 16
	itemLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
	itemLabel.TextXAlignment = Enum.TextXAlignment.Center
	itemLabel.TextTransparency = 1

	TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 0, 58)
	}):Play()

	TweenService:Create(smallText, TweenInfo.new(0.18), {
		TextTransparency = 0
	}):Play()

	TweenService:Create(itemLabel, TweenInfo.new(0.18), {
		TextTransparency = 0
	}):Play()

	task.delay(life, function()
		if not card.Parent then
			return
		end

		TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Size = UDim2.new(1, 0, 0, 0)
		}):Play()

		TweenService:Create(smallText, TweenInfo.new(0.14), {
			TextTransparency = 1
		}):Play()

		TweenService:Create(itemLabel, TweenInfo.new(0.14), {
			TextTransparency = 1
		}):Play()

		task.wait(0.2)
		card:Destroy()
	end)
end

local function getPromptItemName(prompt)
	local objectText = tostring(prompt.ObjectText or "")
	if objectText == "" then
		return nil
	end
	return objectText
end

local function stopItemSpawnWatcher()
	if ItemSpawnConnection then
		ItemSpawnConnection:Disconnect()
		ItemSpawnConnection = nil
	end

	KnownItemPrompts = {}
end

local function startItemSpawnWatcher()
	KnownItemPrompts = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") then
			KnownItemPrompts[obj] = true
		end
	end

	ItemSpawnConnection = workspace.DescendantAdded:Connect(function(obj)
		if not ItemSpawnNotifyEnabled then
			return
		end

		if not obj:IsA("ProximityPrompt") then
			return
		end

		if KnownItemPrompts[obj] then
			return
		end

		KnownItemPrompts[obj] = true

		task.defer(function()
			if not obj.Parent then
				return
			end

			local itemName = getPromptItemName(obj)
			if itemName then
				Notifier:ItemSpawn(itemName, 4)
			end
		end)
	end)
end

Items:AddToggle("ItemSpawnNotifications", {
	Title = "Item Spawn Notifications",
	Default = false,
	Callback = function(state)
		ItemSpawnNotifyEnabled = state

		if state then
			startItemSpawnWatcher()
		else
			stopItemSpawnWatcher()
		end
	end
})


Notifier:Error("No arrows left", 4)
Notifier:Obtained("Star Platinum", 4)
Notifier:Spawned("Rib Cage of The Saint's Corpse", 4)


local Info = Window:AddTab("info")
local Stand = Window:AddTab("stand")
local Items = Window:AddTab("Items")
local Fun = Window:AddTab("fun")
local Misc = Window:AddTab("misc")
local Settings = Window:AddTab("settings")

local NormalStandTargets = {}
local RibStandTargets = {}
local StopOnShinyEnabled = false
local StandFarmEnabled = false
local RibFarmEnabled = false
local PityFarmEnabled = false
local DesiredPity = 0

local NormalStandList = {
	"Whitesnake",
	"White Album",
	"King Crimson",
	"The World",
	"Star Platinum",
	"Crazy Diamond",
	"Gold Experience",
	"Killer Queen",
	"Magician's Red",
	"Purple Haze",
	"Sticky Fingers",
	"Mr. President",
	"Aerosmith",
	"Cream",
	"Beach Boy",
	"Red Hot Chili Pepper",
	"The Hand",
	"Anubis",
	"Stone Free",
	"Six Pistols",
	"Hermit Purple",
	"Hierophant Green",
	"Silver Chariot"
}

local RibStandList = {
	"Soft & Wet",
	"The World Alternate Universe",
	"Scary Monsters",
	"Tusk ACT 1",
	"D4C"
}

local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
	return getCharacter():WaitForChild("Humanoid")
end

local function getRemoteFunction()
	return getCharacter():WaitForChild("RemoteFunction")
end

local function getRemoteEvent()
	return getCharacter():WaitForChild("RemoteEvent")
end

local function getPlayerStats()
	return LocalPlayer:FindFirstChild("PlayerStats")
end

local function getCurrentPity()
	local stats = getPlayerStats()
	if not stats then
		return 0
	end

	local pity = stats:FindFirstChild("PityCount")
	if pity and tonumber(pity.Value) then
		return tonumber(pity.Value)
	end

	return 0
end

local function getCurrentStandName()
	local stats = getPlayerStats()
	if stats then
		local directStand = stats:FindFirstChild("Stand")
		if directStand and tostring(directStand.Value) ~= "" then
			return tostring(directStand.Value)
		end

		local standName = stats:FindFirstChild("StandName")
		if standName and tostring(standName.Value) ~= "" then
			return tostring(standName.Value)
		end
	end

	local character = getCharacter()
	local morph = character:FindFirstChild("StandMorph")
	if morph then
		local standName = morph:FindFirstChild("StandName")
		if standName and tostring(standName.Value) ~= "" then
			return tostring(standName.Value)
		end
	end

	return "None"
end

local function hasStand()
	return getCurrentStandName() ~= "None"
end

local function isShinyStand()
	local character = getCharacter()
	local morph = character:FindFirstChild("StandMorph")
	if not morph then
		return false
	end

	local standSkin = morph:FindFirstChild("StandSkin")
	return standSkin and standSkin.Value ~= ""
end

local function countToolsByName(itemName)
	local total = 0
	local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
	local character = getCharacter()

	if backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") and item.Name == itemName then
				total = total + 1
			end
		end
	end

	for _, item in ipairs(character:GetChildren()) do
		if item:IsA("Tool") and item.Name == itemName then
			total = total + 1
		end
	end

	return total
end

local function unequipAllTools()
	pcall(function()
		getHumanoid():UnequipTools()
	end)
end

local function holdOneTool(itemName)
	local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
	local character = getCharacter()
	if not backpack then
		return nil
	end

	unequipAllTools()
	task.wait(0.1)

	for _, item in ipairs(backpack:GetChildren()) do
		if item:IsA("Tool") and item.Name == itemName then
			item.Parent = character
			task.wait(0.1)
			return item
		end
	end

	return character:FindFirstChild(itemName)
end

local function toggleStand()
	pcall(function()
		getRemoteFunction():InvokeServer("ToggleStand", "Toggle")
	end)
end

local function desummonStand()
	pcall(function()
		toggleStand()
	end)
	task.wait(0.4)
end

local function acceptDialogue(npcName, dialogueName, optionName)
	pcall(function()
		getRemoteEvent():FireServer("EndDialogue", {
			Option = optionName,
			Dialogue = dialogueName,
			NPC = npcName
		})
	end)
end

local function getWorthiness()
	local tree = LocalPlayer:FindFirstChild("CharacterSkillTree")
	if not tree then
		return nil
	end

	return tree:FindFirstChild("Worthiness")
end

local function ensureWorthiness()
	local worthiness = getWorthiness()
	if not worthiness then
		return false
	end

	if worthiness.Value == true then
		return true
	end

	pcall(function()
		getRemoteFunction():InvokeServer("LearnSkill", {
			Skill = "Worthiness",
			SkillTreeType = "Character"
		})
	end)

	task.wait(0.35)
	return worthiness.Value == true
end

local function waitForStandResult(timeout)
	local started = tick()

	repeat
		task.wait(0.2)

		if StopOnShinyEnabled and isShinyStand() then
			return "Shiny"
		end

		local currentStand = getCurrentStandName()
		if currentStand ~= "None" then
			return currentStand
		end
	until tick() - started > (timeout or 6)

	return "None"
end

local function useArrow()
	local itemName = "Mysterious Arrow"
	if countToolsByName(itemName) <= 0 then
		return false
	end

	if hasStand() then
		desummonStand()
	end

	local arrow = holdOneTool(itemName)
	if not arrow then
		return false
	end

	pcall(function()
		arrow:Activate()
	end)

	task.wait(0.15)
	acceptDialogue(itemName, "Dialogue2", "Option1")
	task.wait(0.35)

	return true
end

local function useRokakaka()
	local itemName = "Rokakaka"
	if countToolsByName(itemName) <= 0 then
		return false
	end

	if hasStand() then
		desummonStand()
	end

	local roka = holdOneTool(itemName)
	if not roka then
		return false
	end

	pcall(function()
		roka:Activate()
	end)

	task.wait(0.15)
	acceptDialogue(itemName, "Dialogue2", "Option1")

	local started = tick()
	repeat
		task.wait(0.2)
	until getCurrentStandName() == "None" or tick() - started > 4

	unequipAllTools()
	return getCurrentStandName() == "None"
end

local function useRibcage()
	local itemName = "Rib Cage of The Saint's Corpse"
	local beforeCount = countToolsByName(itemName)
	if beforeCount <= 0 then
		return false
	end

	if hasStand() then
		desummonStand()
	end

	local rib = holdOneTool(itemName)
	if not rib then
		return false
	end

	pcall(function()
		rib:Activate()
	end)

	task.wait(0.15)
	acceptDialogue(itemName, "Dialogue2", "Option1")

	local started = tick()
	repeat
		task.wait(0.2)
	until countToolsByName(itemName) < beforeCount or tick() - started > 4

	unequipAllTools()
	task.wait(0.2)
	desummonStand()

	return true
end

local function notifyText(text)
	print(text)
end

local function hasAnySelected(tbl)
	return next(tbl) ~= nil
end

local function targetHit(tbl)
	return tbl[getCurrentStandName()] == true
end

local function stopIfTargetOrShiny(tbl)
	if StopOnShinyEnabled and isShinyStand() then
		notifyText("Shiny found")
		return true
	end

	if targetHit(tbl) then
		notifyText("Target stand found: " .. getCurrentStandName())
		return true
	end

	return false
end

local function farmNormalStand()
	if StandFarmEnabled == false then
		return
	end

	if not hasAnySelected(NormalStandTargets) then
		notifyText("Select a stand first")
		StandFarmEnabled = false
		return
	end

	while StandFarmEnabled do
		if stopIfTargetOrShiny(NormalStandTargets) then
			StandFarmEnabled = false
			break
		end

		if not ensureWorthiness() then
			notifyText("Worthiness failed")
			StandFarmEnabled = false
			break
		end

		if getCurrentPity() >= DesiredPity and DesiredPity > 0 then
			notifyText("Desired pity reached")
			StandFarmEnabled = false
			break
		end

		if getCurrentStandName() == "None" then
			if not useArrow() then
				notifyText("No arrows left")
				StandFarmEnabled = false
				break
			end

			local result = waitForStandResult(6)
			if result == "Shiny" then
				StandFarmEnabled = false
				break
			end

			if targetHit(NormalStandTargets) then
				notifyText("Target stand found: " .. getCurrentStandName())
				StandFarmEnabled = false
				break
			end
		else
			if not useRokakaka() then
				notifyText("No rokakaka left")
				StandFarmEnabled = false
				break
			end
		end

		task.wait(0.25)
	end
end

local function farmRibStand()
	if RibFarmEnabled == false then
		return
	end

	if not hasAnySelected(RibStandTargets) then
		notifyText("Select a rib stand first")
		RibFarmEnabled = false
		return
	end

	while RibFarmEnabled do
		if stopIfTargetOrShiny(RibStandTargets) then
			RibFarmEnabled = false
			break
		end

		if not ensureWorthiness() then
			notifyText("Worthiness failed")
			RibFarmEnabled = false
			break
		end

		if not useRibcage() then
			notifyText("No rib cages left")
			RibFarmEnabled = false
			break
		end

		local result = waitForStandResult(6)
		if result == "Shiny" then
			RibFarmEnabled = false
			break
		end

		if targetHit(RibStandTargets) then
			notifyText("Target stand found: " .. getCurrentStandName())
			RibFarmEnabled = false
			break
		end

		if not useRokakaka() then
			notifyText("No rokakaka left")
			RibFarmEnabled = false
			break
		end

		task.wait(0.25)
	end
end

local function farmPity()
	if PityFarmEnabled == false then
		return
	end

	if DesiredPity <= 0 then
		notifyText("Set desired pity first")
		PityFarmEnabled = false
		return
	end

	while PityFarmEnabled do
		local currentPity = getCurrentPity()
		if currentPity >= DesiredPity then
			notifyText("Desired pity reached: " .. tostring(currentPity))
			PityFarmEnabled = false
			break
		end

		if StopOnShinyEnabled and isShinyStand() then
			notifyText("Shiny found")
			PityFarmEnabled = false
			break
		end

		if targetHit(NormalStandTargets) then
			notifyText("Target stand found: " .. getCurrentStandName())
			PityFarmEnabled = false
			break
		end

		if not ensureWorthiness() then
			notifyText("Worthiness failed")
			PityFarmEnabled = false
			break
		end

		if getCurrentStandName() == "None" then
			if not useArrow() then
				notifyText("No arrows left")
				PityFarmEnabled = false
				break
			end

			waitForStandResult(6)

			if getCurrentPity() >= DesiredPity then
				notifyText("Desired pity reached: " .. tostring(getCurrentPity()))
				PityFarmEnabled = false
				break
			end
		else
			if not useRokakaka() then
				notifyText("No rokakaka left")
				PityFarmEnabled = false
				break
			end
		end

		task.wait(0.25)
	end
end

local function AddTextBox(tab, title, defaultValue, callback)
	local page = tab.Page

	local card = Instance.new("Frame")
	card.Name = title .. "_Card"
	card.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	card.BorderSizePixel = 0
	card.Size = UDim2.new(1, 0, 0, 58)
	card.Parent = page

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = card

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(42, 42, 56)
	stroke.Transparency = 0.2
	stroke.Parent = card

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 6)
	label.Size = UDim2.new(1, -24, 0, 16)
	label.Font = Enum.Font.GothamSemibold
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Color3.fromRGB(235, 235, 245)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = card

	local box = Instance.new("TextBox")
	box.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
	box.BorderSizePixel = 0
	box.Position = UDim2.new(0, 12, 0, 28)
	box.Size = UDim2.new(1, -24, 0, 22)
	box.Font = Enum.Font.Gotham
	box.PlaceholderText = "0"
	box.Text = tostring(defaultValue or "")
	box.TextSize = 12
	box.TextColor3 = Color3.fromRGB(220, 220, 235)
	box.ClearTextOnFocus = false
	box.Parent = card

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 8)
	boxCorner.Parent = box

	box.FocusLost:Connect(function()
		if callback then
			callback(box.Text)
		end
	end)

	return box
end

Stand:AddDropdown("StandSelect", {
	Title = "Stand Select",
	Multi = true,
	Values = NormalStandList,
	Callback = function(value)
		NormalStandTargets = value
	end
})

Stand:AddDropdown("RibStandSelect", {
	Title = "Rib Stand Select",
	Multi = true,
	Values = RibStandList,
	Callback = function(value)
		RibStandTargets = value
	end
})

Stand:AddToggle("StopOnShiny", {
	Title = "Stop On Shiny",
	Default = false,
	Callback = function(state)
		StopOnShinyEnabled = state
	end
})

Stand:AddToggle("StandFarm", {
	Title = "Stand Farm",
	Default = false,
	Callback = function(state)
		StandFarmEnabled = state

		if state then
			RibFarmEnabled = false
			PityFarmEnabled = false

			task.spawn(function()
				farmNormalStand()
			end)
		end
	end
})

Stand:AddToggle("RibFarm", {
	Title = "Ribcage Farm",
	Default = false,
	Callback = function(state)
		RibFarmEnabled = state

		if state then
			StandFarmEnabled = false
			PityFarmEnabled = false

			task.spawn(function()
				farmRibStand()
			end)
		end
	end
})

AddTextBox(Stand, "Desired Pity", DesiredPity, function(text)
	DesiredPity = tonumber(text) or 0
end)

Stand:AddToggle("PityFarm", {
	Title = "Pity Farm",
	Default = false,
	Callback = function(state)
		PityFarmEnabled = state

		if state then
			StandFarmEnabled = false
			RibFarmEnabled = false

			task.spawn(function()
				farmPity()
			end)
		end
	end
})

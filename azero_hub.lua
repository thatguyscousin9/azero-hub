local Library = loadstring(request({
	Url = "https://raw.githubusercontent.com/thatguyscousin9/personal-project2/main/YBA_UI",
	Method = "GET"
}).Body)()

local Window = Library:CreateWindow("Azero Hub")

local Info = Window:AddTab("info")
local Stand = Window:AddTab("stand")
local Farm = Window:AddTab("farm")
local Fun = Window:AddTab("fun")
local Misc = Window:AddTab("misc")
local Settings = Window:AddTab("settings")

Stand:AddToggle("StandFarm", {
	Title = "Stand Farm",
	Default = false,
	Callback = function(state)
		print("Stand Farm:", state)
	end
})

Stand:AddDropdown("StandSelect", {
	Title = "Stand Select",
	Multi = true,
	Values = {
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
		"Silver Chariot",
		"Soft & Wet",
		"The World Alternate Universe",
		"Scary Monsters",
		"Tusk ACT 1",
		"D4C"
	},
	Callback = function(value)
		print(value)
	end
})

Stand:AddToggle("StopOnShiny", {
	Title = "Stop On Shiny",
	Default = false,
	Callback = function(state)
		print("Stop On Shiny:", state)
	end
})

Fun:AddButton({
	Title = "Test Button",
	Callback = function()
		print("clicked")
	end
})

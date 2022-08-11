Config = {
	FishingRod = "fishingrod", -- Fishing Rod item
	TurtleItem = "turtle", -- Turtle Item
	SharkItem = "shark", -- Shark Item
	FishBait = "fishbait", -- Fishing Bait Item
	FishItem = "fish", -- Fish Item

	TimeToFish = {min = 20000, max = 44000}, --Time in ms (1000 ms = 1 sec)
	FishPrice = {min = 300, max = 2000}, -- Min and Max price for fish. Fish sell at a random price each time
	TurtlePrice = {min = 4000, max = 13000}, -- Min and Max price for turtles. Turtles sell at a random price each time
	SharkPrice = {min = 15000, max = 20000}, -- Min and Max price for sharks. Sharks sell at a random price each time
	TurtleChance = 75, -- Chance to catch a turtle if using the correct bait
	BreakChance = 94, -- If number is greater than this number, line will break

	SalesLocations = {
		Fish = {
			blip = true,
			coords = vector3(-3251.2, 991.5, 11.49),
			sprite = 356,
			color = 17,
			scale = 1.0,
			name = "Fish Market"
		},
		Turtle = {
			blip = false,
			coords = vector3(1338.58, 4359.75, 44.37),
			sprite = 68,
			color = 49,
			scale = 1.0,
			name = "Turtle Dealer"
		},
		Shark = {
			blip = false,
			coords = vector3(470.76, 3552.32, 32.3),
			sprite = 68,
			color = 49,
			scale = 1.0,
			name = "Shark Dealer"
		}
	},

	EmergencyJobs = {"police", "ambulance"}, -- Add Jobs here that will get a free boat

	RentalBoats = {
		citizens = {
			"dinghy",
			"suntrap",
			"jetmax",
			"toro",
			"marquis",
			"tropic",
			"speeder",
			"squalo"
		},
		emergency = {
			"predator",
			"seashark2"
		}
	},

	Language = {
		boatrental = "Boat Rental",
		stopfishing = "Stopped Fishing",
		tookbait = "The fish took the bait",
		menuheader = "Rental Boats",
		closemenu = "⬅ Close Menu",
		brokeline = "The fish was too large and broke your line...",
		canthold = "You can't hold anymore ",
		caughtturtle = "You caught a turtle...",
		baitattached = "You attached the bait to your pole...",
		norod = "You don't have a fishing rod...",
		nofishveh = "You cannot fish while in a vehicle",
	}
}
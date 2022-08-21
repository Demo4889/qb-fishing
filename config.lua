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

	UseTarget = true, -- True is you are using qb-target

	SalesLocations = {
		Fish = {
			blip = true,
			coords = {
				[1] = vector3(-3275.54, 969.98, 8.35),
			},
			sprite = 356,
			color = 17,
			scale = 0.8,
			name = "Fish Market",
			npcs = true,
			peds = {
				[1] = {model = "A_M_Y_Surfer_01", coords = vector4(-3275.58, 969.94, 8.35, 181.54)}
			}
		},
		Turtle = {
			blip = false,
			coords = {
				[1] = vector3(1338.58, 4359.75, 44.37),
			},
			sprite = 68,
			color = 49,
			scale = 1.0,
			name = "Turtle Dealer",
			npcs = true,
			peds = {
				[1] = {model = "A_M_Y_Surfer_01", coords = vector4(1338.58, 4359.75, 44.37, 179.35)}
			}
		},
		Shark = {
			blip = false,
			coords = {
				[1] = vector3(470.76, 3552.32, 32.3),
			},
			sprite = 68,
			color = 49,
			scale = 1.0,
			name = "Shark Dealer",
			npcs = true,
			peds = {
				[1] = {model = "A_M_Y_Surfer_01", coords = vector4(470.76, 3552.32, 32.3, 179.35)}
			}
		},
	},

	BoatRentals = {
		chumash = {
			blip = true,
			coords = vector3(-3420.34, 955.38, 8.35),
			sprite = 427,
			color = 3,
			scale = 1.0,
			name = "Boat Rental",
			npc = true,
			ped = {model = "A_M_O_Beach_02", coords = vector4(-3420.34, 955.38, 8.35, 183.25)},
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
		startedfishing = "You cast your line...",
		stopfishing = "Stopped Fishing",
		furthershore = "You need to walk further from shore",
		tookbait = "The fish took the bait",
		menuheader = "Rental Boats",
		closemenu = "⬅ Close Menu",
		brokeline = "The fish was too large and broke your line...",
		canthold = "You can't hold anymore ",
		caughtturtle = "You caught a turtle...",
		baitattached = "You attached the bait to your pole...",
		norod = "You don't have a fishing rod...",
		nofishveh = "You cannot fish while in a vehicle",
		sellingfish = "Selling Fish",
		sellingturtles = "Selling Turtles",
		sellingsharks = "Selling Sharks",
		nofishsell = "You don't have any fish to sell",
		noturtlesell = "You don't have any turtles to sell",
		nosharksell = "You don't have any sharks to sell"
	}
}
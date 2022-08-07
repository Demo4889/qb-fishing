Config = {
	FishingRod = "fishingrod",
	TurtleItem = "turtle",
	SharkItem = "shark",
	FishTime = {a = 20000, b = 44000},
	FishPrice = {a = 300, b = 2000},
	TurtlePrice = {a = 4000, b = 13000},
	SharkPrice = {a = 15000, b = 20000},

	SellFish = { x = -3251.2, y = 991.5, z = 11.49},
	UseFishBlip = true,
	FishBlip = { coords = vector3(-3251.2, 991.5, 11.49), sprite = 356, scale = 1.0, color = 17},

	SellTurtle = { x = 1338.58, y = 4359.75, z = 44.37},
	UseTurtleBlip = true,
	TurtleBlip = { coords = vector3(1338.58, 4359.75, 44.37), sprite = 68, scale = 1.0, color = 49},

	SellShark = { x = 470.76 , y = 3552.32, z = 32.3},
	UseSharkBlip = false,
	SharkBlip = { coords = vector3(470.76, 3552.32, 32.3), sprite = 68, scale = 1.0, color = 49},

	MarkerZones = {
		{ x = -3426.7 ,y = 955.66 , z = 7.35, xs = -3426.2, ys = 942.4, zs = 1.1 },
		{ x = -732.9 ,y = -1309.7 , z = 4.0, xs = -725.7 , ys = -1351.5, zs = 0.5 },
		{ x = -1607.6 ,y = 5252.8 , z = 3.0, xs = -1590.2 , ys = 5278.8, zs = 1.0 },
		{ x = 3855.0 ,y = 4463.7 , z = 1.6, xs = 3885.2 , ys =  4507.2, zs = 1.0 },
		{ x = 1330.8  ,y = 4226.6 , z = 32.9, xs = 1334.2 , ys =  4192.4, zs = 30.0 },
	},

	EmergencyJobs = {"police", "ambulance", "mechanic"},

	RentalBoats = {
		Citizens = {
			"dinghy",
			"suntrap",
			"jetmax",
			"toro",
			"marquis",
			"tropic",
			"speeder",
			"squalo"
		},
		Emergency = {
			"predator",
			"seashark2"
		}
	},

	Language = {
		fishmarket = "Fish Market",
		turtledealer = "Turtle Dealer",
		sharkdealer = "Shark Dealer",
		boatrental = "Boat Rental",
		stopfishing = "Stopped Fishing",
		tookbait = "The fish took the bait",
		menuheader = "Rental Boats",
		closemenu = "⬅ Close Menu"
	}
}
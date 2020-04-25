Config = {}
	---------------------------------------------------------------
	--=====How long should it take for player to catch a fish=======--
	---------------------------------------------------------------
	--Time in miliseconds
	Config.FishTime = {a = 20000, b = 44000}
	
	--------------------------------------------------------
	--=====Prices of the items players can sell==========--
	--------------------------------------------------------
	--First amount minimum price second maximum amount (the amount player will get is random between those two numbers)
	Config.FishPrice = {a = 300, b = 2000} --Will get clean money THIS PRICE IS FOR EVERY 5 FISH ITEMS (5 kg)
	Config.TurtlePrice = {a = 4000, b = 13000} --Will get dirty money
	Config.SharkPrice = {a = 15000, b = 20000} --Will get dirty money

	--------------------------------------------------------
	--=====Locations where players can sell stuff========--
	--------------------------------------------------------

	Config.SellFish = {x = -3251.2, y = 991.5, z = 11.49} --Place where players can sell their fish
	Config.UseFishBlip = true --Whether or not to show the Fish Market Blip -- Default True
	Config.FishBlip = {Coords = vector3(-3251.2, 991.5, 11.49)} -- Fish Blip Location

	Config.SellTurtle = {x = 1338.58, y = 4359.75, z = 44.37} --Place where players can sell their turtles
	Config.UseTurtleBlip = true --Whether or not to show the Turtle Dealer Blip -- Default False
	Config.TurtleBlip = {Coords = vector3(1338.58, 4359.75, 44.37)} -- Fish Blip Location

	Config.SellShark = {x = 470.76 , y = 3552.32, z = 32.3} --Place where players can sell their sharks
	Config.UseSharkBlip = false --Whether or not to show the Shark Dealer Blip -- Default False
	Config.SharkBlip = {Coords = vector3(470.76, 3552.32, 32.3)} -- Fish Blip Location

	--------------------------------------------------------
	--=====Locations where players can rent boats========--
	--------------------------------------------------------
Config.MarkerZones = { 
	
    {x = -3426.7   ,y = 955.66 ,z = 7.35, xs = -3426.2  , ys = 942.4, zs = 1.1 },
	{x = -732.9     ,y = -1309.7 ,z = 4.0, xs = -725.7    , ys = -1351.5, zs = 0.5 },  
	{x = -1607.6      ,y =  5252.8 ,z = 3.0, xs = -1590.2      , ys = 5278.8, zs = 1.0 },
	{x = 3855.0        ,y =  4463.7 ,z = 1.6, xs = 3885.2       , ys =  4507.2, zs = 1.0 },
	{x = 1330.8        ,y =  4226.6 ,z = 32.9, xs = 1334.2         , ys =  4192.4, zs = 30.0 },
	

}

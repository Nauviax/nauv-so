-- Wood adjustments to prevent manual stockpiling and make easier to produce/ship.
-- Base game is 0.15/0.2wps per tower. These changes, with bio, make it 1.0. 
local wood = data.raw.item["wood"]
wood.spoil_ticks = 216000 -- 1h, fairly normal length.
wood.spoil_result = "spoilage"
wood.weight = 1000 -- Old 2000
data.raw.plant["tree-plant"].growth_ticks = 18000 -- 5m instead of 10m
data.raw.plant["tree-plant"].minable.results[1].amount = 8 -- Double wood, also reduces seed dependency

-- Gleba plant spore reduction to help with increased fruit demand.
for _, plant_name in pairs({
	"yumako-tree",
	"jellystem",
}) do -- Count and time is post x5 time adjustment
	local plant = data.raw.plant[plant_name]
	plant.harvest_emissions.spores = 10 -- Old 15
end
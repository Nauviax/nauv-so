-- Wood adjustments to prevent manual stockpiling and make easier to produce/ship.
-- Base game is 0.15/0.2wps per tower. These changes, with bio, make it 1.0. 
local wood = data.raw.item["wood"]
wood.spoil_ticks = 216000 -- 1h, fairly normal length.
wood.spoil_result = "spoilage"
wood.weight = 1000 -- Old 2000
data.raw.plant["tree-plant"].growth_ticks = 18000 -- 5m instead of 10m
data.raw.plant["tree-plant"].minable.results[1].amount = 8 -- Double wood, also reduces seed dependency

-- Increased pentapod attack costs to compensate for increased fruit demand creating more spores.
local pentapod = data.raw["spider-unit"]
pentapod["small-stomper-pentapod"].absorptions_to_join_attack.spores = 50 -- Old 25
pentapod["medium-stomper-pentapod"].absorptions_to_join_attack.spores = 50
pentapod["big-stomper-pentapod"].absorptions_to_join_attack.spores = 50
pentapod["small-strafer-pentapod"].absorptions_to_join_attack.spores = 40 -- Old 20
pentapod["medium-strafer-pentapod"].absorptions_to_join_attack.spores = 40
pentapod["big-strafer-pentapod"].absorptions_to_join_attack.spores = 40
-- Wrigglers can remain the same, they're just chaff (2)

-- Reduce speed of offshore pumps 1200/s -> 240/s, simply to require more of them.
data.raw["offshore-pump"]["offshore-pump"].pumping_speed = 4 -- Old was 20

-- Add e-engines to rocket parts, plus minor adjustments to the recipe.
if settings.startup["nso-harder-rockets"] then
	local rocket_part_recipe = data.raw.recipe["rocket-part"]
	rocket_part_recipe.ingredients = {
		{ type = "item", name = "processing-unit", amount = 2 },
		{ type = "item", name = "low-density-structure", amount = 2 },
		{ type = "item", name = "rocket-fuel", amount = 2 },
		{ type = "item", name = "electric-engine-unit", amount = 1 }
	}
	rocket_part_recipe.energy_required = 10 -- Old was 3 (Or 6 for 2)
	data.raw["rocket-silo"]["rocket-silo"].rocket_parts_required = 25 -- Old was 50. LDS etc per rocket is same.
	data.raw.item["rocket-part"].weight = 40000 -- Old was 20000. Just to match per-rocket count to parts required.
end
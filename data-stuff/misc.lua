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
-- High grade promethium
local high_grade_item = table.deepcopy(data.raw.item["promethium-asteroid-chunk"])
high_grade_item.name = "high-grade-promethium-asteroid-chunk"
high_grade_item.spoil_ticks = 3600 -- 1 minute
high_grade_item.spoil_result = "promethium-asteroid-chunk"
high_grade_item.icon = "__temp-mod__/graphics/items/hg-promethium-asteroid-chunk.png"
high_grade_item.order = high_grade_item.order .. "-2"
data:extend({high_grade_item})

local high_grade_chunk = table.deepcopy(data.raw["asteroid-chunk"]["promethium-asteroid-chunk"])
high_grade_chunk.name = "high-grade-promethium-asteroid-chunk"
high_grade_chunk.minable.result = "high-grade-promethium-asteroid-chunk"
high_grade_chunk.icon = "__temp-mod__/graphics/items/hg-promethium-asteroid-chunk.png"
high_grade_chunk.order = high_grade_chunk.order .. "-2"
data:extend({high_grade_chunk})

-- Low grade promethium (Old item)
local low_grade_item = data.raw.item["promethium-asteroid-chunk"]
low_grade_item.spoil_ticks = 18000 -- 5 minutes
low_grade_item.spoil_result = "iron-ore"

-- Add high grade to big asteroid chunks
local spread = 1
table.insert(data.raw.asteroid["big-promethium-asteroid"].dying_trigger_effect, {
	type = "create-asteroid-chunk",
	asteroid_name = "high-grade-promethium-asteroid-chunk",
	offset_deviation = {{-spread, -spread}, {spread, spread}},
	offsets = {
		{-spread/2, -spread/4},
		{spread/2, -spread/4}
	}
})

-- !!! TODO add medium prometh to 10%-90% range between planets !!!
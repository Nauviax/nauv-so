local utils = require("common.utils")

-- Update space science sprite
data.raw.tool["space-science-pack"].icon = "__nauv-so__/graphics/items/space-science-pack.png"
data.raw.recipe["space-science-pack"].icon = "__nauv-so__/graphics/items/space-science-pack.png"
data.raw.technology["space-science-pack"].icon = "__nauv-so__/graphics/techs/space-science-pack.png"

-- Set up science tab subgroup
data:extend({
	{
		type = "item-subgroup", name = utils.subgroup.data_pre, -- Fresh cards
		group = "space", order = "z-a"
	}, {
		type = "item-subgroup", name = utils.subgroup.gel,
		group = "space", order = "z-b"
	}, {
		type = "item-subgroup", name = utils.subgroup.data,
		group = "space", order = "z-c"
	}, {
		type = "item-subgroup", name = utils.subgroup.pack_pre, -- Prom-147, slurries
		group = "space", order = "z-d"
	}, {
		type = "item-subgroup", name = utils.subgroup.cycle,
		group = "space", order = "z-f"
	}
})
local pack_group = data.raw["item-subgroup"][utils.subgroup.pack]
pack_group.group = "space"
pack_group.order = "z-e"
data.raw["item-group"]["space"].order_in_recipe = "z" -- Try to put these items at end of recipes
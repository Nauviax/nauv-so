local utils = require("common.utils")

-- Update space science sprite
data.raw.tool["space-science-pack"].icon = "__nauv-so__/graphics/items/space-science-pack.png"
data.raw.recipe["space-science-pack"].icon = "__nauv-so__/graphics/items/space-science-pack.png"
data.raw.technology["space-science-pack"].icon = "__nauv-so__/graphics/techs/space-science-pack.png"

-- Set up science tab subgroup
data:extend({
	{
		type = "item-subgroup", name = utils.subgroup.data_pre, -- gel, fresh cards
		group = "space", order = "z-a"
	}, {
		type = "item-subgroup", name = utils.subgroup.data,
		group = "space", order = "z-b"
	}, {
		type = "item-subgroup", name = utils.subgroup.pack_pre, -- Bases, prom-147
		group = "space", order = "z-c"
	}
})
local pack_group = data.raw["item-subgroup"][utils.subgroup.pack]
pack_group.group = "space"
pack_group.order = "z-z"
data.raw["item-group"]["space"].order_in_recipe = "z" -- Put these items at end of recipies
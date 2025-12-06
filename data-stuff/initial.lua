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

-- !!! TEMP STUFF BELOW

-- Duplicate items and recipies for specific packs to help balance (!!! TEMP)
local packs_to_dupe = {
	"space-science-pack",
	"metallurgic-science-pack",
	"agricultural-science-pack",
	"electromagnetic-science-pack",
	"cryogenic-science-pack",
	"promethium-science-pack",
	"production-science-pack",
	"utility-science-pack"
}
for _, pack_name in pairs(packs_to_dupe) do
	local item = table.deepcopy(data.raw.tool[pack_name])
	item.name = pack_name.."-OLD"
	item.icons = {{ icon = item.icon, tint = {0.5, 0.5, 0.5} }}
	item.icon = nil
	item.order = "z-"..item.order
	data:extend({ item })

	local recipe = table.deepcopy(data.raw.recipe[pack_name])
	recipe.name = pack_name.."-OLD"
	recipe.enabled = true
	recipe.results[1].name = pack_name.."-OLD"
	recipe.main_product = pack_name.."-OLD"
	data:extend({ recipe })
end
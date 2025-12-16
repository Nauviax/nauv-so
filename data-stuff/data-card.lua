local utils = require("common.utils")

-- Params
local craft_time = 6
local order = "b-"

local item = table.deepcopy(data.raw.item["electronic-circuit"])
item.name = utils.items.blank_data
item.icon = nil
item.icons = {{ icon = "__nauv-so__/graphics/items/data-blank.png" }} -- More inserted later
item.type = "item"
item.subgroup = utils.subgroup.data_pre
item.order = order.."y"
item.stack_size = 100
item.weight = utils.science.common.weight
item.localised_description = nil

local recipe = {
	type = "recipe", name = item.name,
	category = "electronics",
	subgroup = utils.subgroup.data_pre,
	order = order.."y",
	enabled = false,
	energy_required = craft_time,
	ingredients = {
		{ type = "item", name = "steel-plate", amount = 1 },
		{ type = "item", name = "battery", amount = 2 },
		{ type = "item", name = "advanced-circuit", amount = 3 }
	},
	results = {{ type = "item", name = item.name, amount = 1 }},
	allow_productivity = true,
	surface_conditions = nil
}

local garbage_item = table.deepcopy(item)
garbage_item.name = utils.items.garbage_data
table.insert(garbage_item.icons, {
	icon = "__core__/graphics/icons/alerts/not-enough-repair-packs-icon.png",
	scale = 0.3, shift = {-5, 5}, floating = true
})
garbage_item.order = order.."z"

local garbage_recipe = table.deepcopy(recipe) -- Byproduct of data crafting
garbage_recipe.name = garbage_item.name
garbage_recipe.energy_required = craft_time * 4 -- Means 1s to recycle each
garbage_recipe.results = {{ type = "item", name = garbage_item.name, amount = 2 }} -- Returns 1/8 not 1/4
garbage_recipe.hidden = true -- Don't show, ever
garbage_recipe.order = order.."z"

data:extend({ item, recipe, garbage_item, garbage_recipe })
utils.add_to_tech("space-science-pack", recipe.name)

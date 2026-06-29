local utils = require("common.utils")

-- Params
local craft_time = 20
local order = "b-"

local item = table.deepcopy(data.raw.item["electronic-circuit"])
item.name = utils.items.blank_data
item.icon = nil
item.icons = {{ icon = "__nauv-so__/graphics/items/data-blank.png" }} -- More inserted later
item.type = "item"
item.subgroup = utils.subgroup.data_pre
item.order = order.."y"
item.stack_size = 200
item.weight = utils.science.common.weight * 5 -- Don't rocket these >:(
item.localised_description = nil

local garbage_item = table.deepcopy(item)
garbage_item.name = utils.items.garbage_data
table.insert(garbage_item.icons, {
	icon = "__core__/graphics/icons/alerts/not-enough-repair-packs-icon.png",
	scale = 0.3, shift = {-5, 5}, floating = true
})
garbage_item.order = order.."z"
garbage_item.weight = utils.science.common.weight -- Ok you can rocket the garbage.

local recipe = {
	type = "recipe", name = item.name,
	main_product = item.name,
	categories = { "crafting", "electromagnetics" },
	subgroup = utils.subgroup.data_pre,
	order = order.."y",
	enabled = false,
	energy_required = craft_time,
	ingredients = {
		{ type = "item", name = "steel-plate", amount = 1 },
		{ type = "item", name = "battery", amount = 2 },
		{ type = "item", name = "advanced-circuit", amount = 3 },
		{ type = "item", name = "copper-cable", amount = 5 }
	},
	results = {
		{ type = "item", name = item.name, amount = 3, shared_probability = { min = 0.0 , max = 0.75} },
		{ type = "item", name = garbage_item.name, amount = 3, shared_probability = { min = 0.75 , max = 1.0} }
	},
	allow_productivity = true,
	surface_conditions = nil,
	always_show_made_in = true
}

local garbage_recipe = table.deepcopy(recipe) -- Byproduct of data crafting
garbage_recipe.name = garbage_item.name
garbage_recipe.main_product = garbage_item.name
garbage_recipe.energy_required = craft_time * 4 -- 10s in recycler (5s recipe, 4 x 1/16 of craft_time)
garbage_recipe.results = {{
	type = "item", name = garbage_item.name,
	amount = recipe.results[2].amount * 3 -- x3 product, means recycle returns 1/12 instead of 1/4 (Do not take into account chance)
}}
garbage_recipe.hidden = true -- Don't show, ever
garbage_recipe.order = order.."z"

data:extend({ item, recipe, garbage_item, garbage_recipe })
utils.add_to_tech("space-science-pack", recipe.name)
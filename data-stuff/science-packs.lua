local utils = require("common.utils")

-- Params
local base_craft_time = 6
local stack_size = 50
local weight = utils.science.common.weight
local pack_craft_category = "cryogenics-or-assembling"
local order = "a-"

local science_data = {
	space = {
		advanced = false,
		prom_amnt = 3, -- Extra prom, nil ingredient
	},
	metallurgic = {
		advanced = false,
		prom_amnt = 2,
		ingredient = { type = "item", name = "iron-gear-wheel", amount = 1 }
	},
	agricultural = {
		advanced = false,
		prom_amnt = 1, -- Less to help manage freshness
		ingredient = { type = "item", name = "carbon", amount = 2 }
	},
	electromagnetic = {
		advanced = false,
		prom_amnt = 2,
		ingredient = { type = "item", name = "iron-stick", amount = 4 }
	},
	cryogenic = {
		advanced = true,
		prom_amnt = 5,
		ingredient = { type = "item", name = "ice", amount = 10 }
	},
	promethium = {
		advanced = true,
		prom_amnt = 25,
		ingredient = { type = "item", name = utils.items.blank_data, amount = 1 },
		garbage_out = 2 -- Account for extra in
	}
}

for name, props in pairs(science_data) do
	local util_props = utils.science[name]

	local item = data.raw.tool[util_props.pack]
	item.stack_size = stack_size
	item.weight = weight
	if item.spoil_ticks then
		item.spoil_result = utils.items.garbage_data
	end

	local recipe = data.raw.recipe[util_props.pack]
	recipe.main_product = util_props.pack
	recipe.category = pack_craft_category
	recipe.subgroup = utils.subgroup.pack
	recipe.order = order..util_props.order
	recipe.energy_required = base_craft_time * util_props.craft_time_mult
	recipe.ingredients = {
		{ type = "item", name = util_props.data, amount = util_props.data_per_pack },
		{ type = "fluid", name = (props.advanced and utils.items.adv_slurry or utils.items.basic_slurry), amount = 100 },
		{ type = "item", name = utils.items.prom147, amount = props.prom_amnt }
	}
	if props.ingredient then
		table.insert(recipe.ingredients, props.ingredient)
	end
	recipe.results = {
		{ type = "item", name = util_props.pack, amount = 1 },
		{ type = "item", name = utils.items.garbage_data, amount = props.garbage_out or 1, ignored_by_stats = props.garbage_out or 1 }
	}
	recipe.allow_productivity = true -- Already true, just clarity
	recipe.surface_conditions = utils.science.promethium.surface_condition
	recipe.crafting_machine_tint = utils.recipe_tints(util_props.color)

	-- Remove and re-add from respective tech to ensure it is shown at the end
	local tech = data.raw.technology[util_props.pack]
	for index, unlock in pairs(tech.effects) do
		if unlock.recipe == recipe.name then
			table.remove(tech.effects, index)
			utils.add_to_tech(util_props.pack, recipe.name)
			break
		end
	end
end

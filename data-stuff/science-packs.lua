local utils = require("common.utils")

-- Params
local base_craft_time = 15 -- !!! Needs balance maybe
local stack_size = 50
local weight = 4000
local pack_craft_category = "cryogenics-or-assembling" -- !!! This or "chemistry-or-cryogenics"? (Should just be my preference, both work)

local science_data = {
	space = {
		advanced = false,
		prom_amnt = 2
	},
	metallurgic = {
		advanced = false,
		prom_amnt = 2
	},
	agricultural = {
		advanced = false,
		prom_amnt = 1 -- Less to help manage freshness
	},
	electromagnetic = {
		advanced = false,
		prom_amnt = 2
	},
	cryogenic = {
		advanced = true, -- Reminder: Advanced is an extra 2 prom-147
		prom_amnt = 3 -- Asteroid prod needs to be considered here, along with longer trips. (!!!)
	},
	promethium = {
		advanced = true,
		prom_amnt = 5 -- !!! Balance along with others, but perhaps this could be even HIGHER safely? It's a long trip back to convert the data
	}
}

for name, props in pairs(science_data) do
	local util_props = utils.sciences[name]

	local item = data.raw.tool[name.."-science-pack"]
	item.stack_size = stack_size
	item.weight = weight

	local recipe = data.raw.recipe[name.."-science-pack"] -- May just overwrite, will see !!! (Issue is already exists)
	recipe.main_product = name.."-science-pack"
	recipe.category = pack_craft_category -- !!! Subcategory? !!!
	recipe.energy_required = base_craft_time * util_props.craft_time_mult
	recipe.ingredients = {
		{ type = "item", name = name.."-data", amount = util_props.data_per_pack },
		{ type = "fluid", name = (props.advanced and "advanced" or "basic").."-base-fluid", amount = 100 },
		{ type = "item", name = "promethium-147", amount = props.prom_amnt }
	}
	recipe.results = {
		{ type = "item", name = name.."-science-pack", amount = 1 },
		{ type = "item", name = "garbage-data", amount = 1, ignored_by_stats = 1 }
	}
	recipe.allow_productivity = true -- Already true, just clarity
	recipe.surface_conditions = utils.sciences.promethium.surface_condition
end

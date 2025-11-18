local utils = require("common.utils")

-- Params
local base_craft_time = 30 -- !!! Needs balance maybe (!!! Promethium should be fairly quick ideally right? Do I need to adjust packs-per-craft, or override the craft time mult for packs so data can craft fast? (!!! That's the issue, data crafting needs to be relatively fast to help consume high amounts of prometh and egg, unless we leave that to needing modules?))
local stack_size = 50 -- !!! Review all items added for stack/weight etc to ensure no regressions
local weight = 4000
local pack_craft_category = "cryogenics-or-assembling" -- !!! This or "chemistry-or-cryogenics"? (Should just be my preference, both work)

local science_data = {
	space = {
		advanced = false,
		prom_out = 0.75
	},
	metallurgic = {
		advanced = false,
		prom_out = 0.75
	},
	agricultural = {
		advanced = false,
		prom_out = 0.75
	},
	electromagnetic = {
		advanced = false,
		prom_out = 0.75
	},
	cryogenic = {
		advanced = true,
		prom_out = 0.5 -- !!! May want to add extra LGprom between Gleba and Aquilo, increasing along rest of path to shattered? (Still not AT planets ofc)
	},
	promethium = {
		advanced = true,
		prom_out = 0.25
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
		utils.items.prom_in
	}
	recipe.results = {
		{ type = "item", name = name.."-science-pack", amount = 1 },
		{ type = "item", name = "garbage-data", amount = 1, ignored_by_stats = 1 },
		utils.items.prom_out(props.prom_out)
	}
	recipe.allow_productivity = true -- Already true, just clarity
	recipe.surface_conditions = utils.sciences.promethium.surface_condition
end

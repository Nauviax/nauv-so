local utils = require("common.utils")

-- Params
local base_craft_time = 20 -- !!! BALANCE (Very unsure on this speed) (I want data to be long, but promethium should be quicker I think? !!! See pack note here for same item)
local base_stack_size = 200 -- !!! Review all items added for stack/weight etc to ensure no regressions
local base_weight = 1000
local data_crafts_per_pack = 2
local icon = "__temp-mod__/graphics/items/data.png"

local base_item = table.deepcopy(data.raw.tool["automation-science-pack"])
base_item.icon = nil -- We will use icons

local science_data = {
	space = {
		stack_mult = 1,
		weight_mult = 1,
		craft_category = "organic-or-assembling",
		color = {1.0, 1.0, 1.0},
		is_tool = true,
		ingredients = { -- !!! Old U235 (based on rockets though) fluid_local_in = 1, fluid_local_out = 0.92,
			{ type = "item", name = "raw-fish", amount = 1000 } -- Likely use fuel cells for uranium costs, to avoid needing outputs. (But balance, assume prod!)
		}
	},
	metallurgic = {
		stack_mult = 0.25,
		weight_mult = 2,
		craft_category = "metallurgy",
		color = {1.0, 0.5, 0.2},
		is_tool = false,
		ingredients = {
			{ type = "item", name = "raw-fish", amount = 1000 }
		}
	},
	agricultural = {
		stack_mult = 1,
		weight_mult = 1,
		craft_category = "organic",
		color = {0.7, 1.0, 0.2},
		is_tool = false,
		ingredients = {
			{ type = "item", name = "raw-fish", amount = 1000 }
		},
		spoil_ticks = 216000, -- 1h, normal pack timer
		spoil_result = "spoilage"
	},
	electromagnetic = {
		stack_mult = 2,
		weight_mult = 0.25,
		craft_category = "electromagnetics",
		color = {0.8, 0.1, 0.8},
		is_tool = false,
		ingredients = {
			{ type = "item", name = "raw-fish", amount = 1000 }
		}
	},
	cryogenic = {
		stack_mult = 1,
		weight_mult = 1,
		craft_category = "cryogenics",
		color = {0.3, 0.3, 1.0},
		is_tool = false,
		ingredients = {
			{ type = "item", name = "raw-fish", amount = 1000 }
		},
		fluoro_used = 2
	},
	promethium = {
		stack_mult = 0.25, -- Balance review, egg to pack stack ratio concerns (!!!)
		weight_mult = 1,
		craft_category = "cryogenics",
		color = {0.2, 0.3, 0.4},
		is_tool = false,
		ingredients = { -- !!! Review Pegg balance, about half to 1/4 of biter egg per pack? (Half at most, as egg is more expensive and heavier)
			{ type = "item", name = "raw-fish", amount = 1000 }
		},
		fluoro_used = 1 -- !!! This would be in ADDITION to science base, being used in space. Check packs per fluoro-rockets, compare to Beggs? (Ideally packs per Begg-rocket like x4 as many at least)
	}
}

for name, props in pairs(science_data) do
	local util_props = utils.sciences[name]

	local item = table.deepcopy(base_item)
	item.name = name.."-data"
	item.icons = {{
		-- Data card main icon
		icon = icon, icon_size = 64,
		tint = props.color
	}, {
		-- Second layer, darkened version of relevant pack
		icon = data.raw.tool[name.."-science-pack"].icon, icon_size = 64,
		scale = 0.4, shift = {-6, 5}, floating = true,
		tint = {0.5, 0.5, 0.5}
	}}
	if not props.is_tool then
		item.type = "item"
		item.durability = nil
	end
	item.stack_size = base_stack_size * props.stack_mult
	item.weight = base_weight * props.weight_mult
	item.default_import_location = util_props.planet
	if props.spoil_ticks then
		item.spoil_ticks = props.spoil_ticks
		item.spoil_result = props.spoil_result
	end

	local recipe = {
		type = "recipe", name = item.name,
		main_product = item.name,
		category = props.craft_category,
		--subgroup = "!!!TODO", -- !!!
		--order = "!!!TODO", --!!! (Could use pack and edit slightly to put nearby?)
		enabled = false,
		energy_required = base_craft_time * util_props.craft_time_mult,
		ingredients = props.ingredients, -- Done outside of loop
		results = {{ type = "item", name = item.name, amount =  util_props.data_per_pack / data_crafts_per_pack }},
		allow_productivity = true,
		surface_conditions = util_props.surface_condition
	}
	table.insert(recipe.ingredients, 1, { type = "item", name = "fresh-data", amount = 1 })
	table.insert(recipe.ingredients, 2, { type = "fluid", name = "science-goop", amount = 100 })
	if props.fluoro_used then
		table.insert(recipe.ingredients, utils.items.fluo_in(props.fluoro_used * 2))
		table.insert(recipe.results, utils.items.fluo_out(props.fluoro_used))
	end

	data:extend({ item, recipe })
	utils.add_to_tech(name.."-science-pack", item.name)
end


-- Pack data recipies manually below (Base costs x5. Double recipe is needed per pack due to data:pack ratio, but also ~90% prod step cancels it out, so just x5!)
-- local data_card_ing = { type = "item", name = "fresh-data", amount = 1 }
-- data.raw.recipe["space-data"].ingredients = {
-- 	data_card_ing,
-- 	{ type = "item", name = "raw-fish", amount = 1000 } -- !!! WIP
-- }
-- data.raw.recipe["metallurgic-data"].ingredients = {
-- 	data_card_ing,
-- 	{ type = "fluid", name = "molten-copper", amount = 1000 },
-- 	{ type = "item", name = "tungsten-plate", amount = 10 },
-- 	{ type = "item", name = "tungsten-carbide", amount = 15 } -- !!! WIP
-- }
-- data.raw.recipe["electromagnetic-data"].ingredients = {
-- 	data_card_ing,
-- 	{ type = "item", name = "accumulator", amount = 5 },
-- 	{ type = "fluid", name = "electrolyte", amount = 125 },
-- 	{ type = "fluid", name = "holmium-solution", amount = 125 },
-- 	{ type = "item", name = "supercapacitor", amount = 5 } -- !!! WIP
-- }
-- data.raw.recipe["agricultural-data"].ingredients = {
-- 	data_card_ing,
-- 	{ type = "item", name = "bioflux", amount = 5 },
-- 	{ type = "item", name = "pentapod-egg", amount = 5 } -- !!! WIP
-- }
-- local data_recipe = data.raw.recipe["cryogenic-data"]
-- data_recipe.ingredients = {
-- 	data_card_ing,
-- 	{ type = "fluid", name = "fluoroketone-cold", amount = 30, ignored_by_stats = 15 },
-- 	{ type = "item", name = "ice", amount = 15 },
-- 	{ type = "item", name = "lithium-plate", amount = 5 } -- !!! WIP
-- }
-- table.insert(data_recipe.results, { -- Cryo special case
-- 	type = "fluid", name = "fluoroketone-hot", amount = 15, ignored_by_stats = 15, ignored_by_productivity = 15
-- })
-- data_recipe.main_product = "cryogenic-data"
-- data_recipe = data.raw.recipe["promethium-data"]
-- data_recipe.ingredients = { -- Pack output normally 10, so overall 1/2 costs here
-- 	data_card_ing,
-- 	{ type = "item", name = "biter-egg", amount = 5 },
-- 	{ type = "item", name = "quantum-processor", amount = 99 }, -- !!!!!!!!!!!!!!!!!!!!!!!!!!! WIP, Going to do the split thing !!!!!!!
-- 	{ type = "item", name = "promethium-asteroid-chunk", amount = 2 }, -- !!! WIP
-- 	{ type = "item", name = "high-grade-promethium-asteroid-chunk", amount = 1, ignored_by_stats = 1 } -- !!! WIP
-- }
-- table.insert(data_recipe.results, { -- Cryo special case
-- 	type = "item", name = "high-grade-promethium-asteroid-chunk", amount = 1, probability = 0.5, ignored_by_stats = 1
-- })
-- data_recipe.main_product = "promethium-data"

-- !!! Science tab in space tab may be good idea for fluids and data/packs
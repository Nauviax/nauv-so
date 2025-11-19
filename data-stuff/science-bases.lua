local utils = require("common.utils")

-- Params
local craft_time_basic = 15
local craft_time_advanced = 25
local icon = "__temp-mod__/graphics/fluids/glow.png" -- !!! Redo colors !!!
local basic_fluid_color = {0.8, 0.2, 0.2} -- !!! Redo colors !!!
local basic_fluid_color_light = {1.0, 0.5, 0.5} -- !!! Redo colors !!!
local advanced_fluid_color = {0.5, 0.0, 0.5} -- !!! Redo colors !!!
local advanced_fluid_color_light = {0.8, 0.2, 0.8} -- !!! Redo colors !!!

-- !!! Can I combine the two here slightly, reduce repeated code? !!! (Also general cleanup)

local basic_fluid = {
	type = "fluid", name = "basic-base-fluid",
	icons = {{
		icon = icon, icon_size = 64,
		tint = basic_fluid_color_light
	}},
	default_temperature = 15,
	base_color = basic_fluid_color, flow_color = basic_fluid_color,
	order = "n[new-fluid]-s1[science-fluid]-1[basic]", --!!! TODO
	auto_barrel = false
}

local basic_recipe = {
	type = "recipe", name = basic_fluid.name,
	main_product = basic_fluid.name,
	category = "chemistry-or-cryogenics",
	subgroup = "fluid-recipes", -- !!!
	--order = "!!!TODO", --!!!
	enabled = false,
	energy_required = craft_time_basic,
	ingredients = {
		{ type = "fluid", name = "water", amount = 25 }, -- !!! At some point sort all recipe orders and enforce in-game order (!!! order_in_recipe) (!!! Also tech-effects order)
		{ type = "fluid", name = "thruster-fuel", amount = 75 },
		{ type = "item", name = "steel-plate", amount = 1}, -- !!! Balance review ofc
		{ type = "item", name = "promethium-147", amount = 1 }
	},
	results = {
		{ type = "fluid", name = basic_fluid.name, amount = 100 } -- Enough for 1 pack
	}, -- !!! Balance ofc
	allow_productivity = true,
	surface_conditions = utils.sciences.promethium.surface_condition,
	crafting_machine_tint = utils.recipe_tints(basic_fluid_color)
}

local advanced_fluid = {
	type = "fluid", name = "advanced-base-fluid",
	icons = {{
		icon = icon, icon_size = 64,
		tint = advanced_fluid_color_light
	}},
	default_temperature = 15,
	base_color = advanced_fluid_color, flow_color = advanced_fluid_color,
	order = "n[new-fluid]-s1[science-fluid]-2[advanced]", --!!! TODO
	auto_barrel = false
}

local advanced_recipe = {
	type = "recipe", name = advanced_fluid.name,
	main_product = advanced_fluid.name,
	category = "cryogenics",
	subgroup = "fluid-recipes", -- !!!
	--order = "!!!TODO", --!!!
	enabled = false,
	energy_required = craft_time_advanced,
	ingredients = {
		{ type = "fluid", name = basic_fluid.name, amount = 100 },
		{ type = "fluid", name = "petroleum-gas", amount = 100 }, -- Fizzy (need balance lots !!! Compare making on platform vs shipping up petro barrels)
		{ type = "item", name = "battery", amount = 2 }, -- !!! Balance (Mainly for requiring sulfur + copper)
		{ type = "item", name = "promethium-147", amount = 2 },
		utils.items.fluo_in(2) -- !!! How much gets stockpiled in machine? (!!! Also review using fluoro here)
	},
	results = {
		{ type = "fluid", name = advanced_fluid.name, amount = 100 }, -- Enough for 1 pack
		utils.items.fluo_out(1)
	},
	allow_productivity = true,
	surface_conditions = utils.sciences.promethium.surface_condition,
	crafting_machine_tint = utils.recipe_tints(advanced_fluid_color)
}

data:extend({ basic_fluid, basic_recipe, advanced_fluid, advanced_recipe })
utils.add_to_tech("space-science-pack", "basic-base-fluid")
utils.add_to_tech("cryogenic-science-pack", "advanced-base-fluid")
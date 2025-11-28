local utils = require("common.utils")

-- Params
local craft_time_basic = 3
local craft_time_advanced = 15
local icon = "__temp-mod__/graphics/fluids/glow.png"
local basic_fluid_color = {0.8, 0.1, 0.1}
local basic_fluid_color_light = {1.0, 0.2, 0.2}
local advanced_fluid_color = {0.6, 0.1, 0.6}
local advanced_fluid_color_light = {0.9, 0.3, 0.9}
local order = "b-"

-- !!! Can I combine the two here slightly, reduce repeated code? (Also general cleanup)

local basic_fluid = {
	type = "fluid", name = "basic-base-fluid",
	icons = {{
		icon = icon, icon_size = 64,
		tint = basic_fluid_color_light
	}},
	default_temperature = 15,
	base_color = basic_fluid_color, flow_color = basic_fluid_color,
	subgroup = utils.subgroup.fluid,
	order = utils.subgroup.fluid_order..order.."a",
	auto_barrel = false
}

local basic_recipe = {
	type = "recipe", name = basic_fluid.name,
	main_product = basic_fluid.name,
	category = "chemistry-or-cryogenics",
	subgroup = utils.subgroup.pack_pre,
	order = order.."a",
	enabled = false,
	energy_required = craft_time_basic,
	ingredients = { -- !!! Light balance review for recipe, just to ensure not too much of any one asteroid early. (Review at pack, not just this.)
		{ type = "fluid", name = "water", amount = 25 },
		{ type = "fluid", name = "thruster-fuel", amount = 75 },
		{ type = "item", name = "steel-plate", amount = 1 },
		{ type = "item", name = "promethium-147", amount = 2 }
	},
	results = {
		{ type = "fluid", name = basic_fluid.name, amount = 50 } -- Enough for 1/2 pack
	},
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
	subgroup = utils.subgroup.fluid,
	order = utils.subgroup.fluid_order..order.."b",
	auto_barrel = false
}

local advanced_recipe = {
	type = "recipe", name = advanced_fluid.name,
	main_product = advanced_fluid.name,
	category = "cryogenics",
	subgroup = utils.subgroup.pack_pre,
	order = order.."b",
	enabled = false,
	energy_required = craft_time_advanced,
	ingredients = {
		{ type = "fluid", name = basic_fluid.name, amount = 100 },
		{ type = "fluid", name = "steam", amount = 1000, min_temperature = 500 },
		{ type = "item", name = "slowdown-capsule", amount = 1 },
		{ type = "item", name = "promethium-147", amount = 4 },
		utils.items.fluo_in(6)
	},
	results = {
		{ type = "fluid", name = advanced_fluid.name, amount = 100 }, -- Enough for 1 pack
		utils.items.fluo_out(3)
	},
	allow_productivity = true,
	surface_conditions = utils.sciences.promethium.surface_condition,
	crafting_machine_tint = utils.recipe_tints(advanced_fluid_color)
}

data:extend({ basic_fluid, basic_recipe, advanced_fluid, advanced_recipe })
utils.add_to_tech("space-science-pack", "basic-base-fluid")
utils.add_to_tech("cryogenic-science-pack", "advanced-base-fluid")
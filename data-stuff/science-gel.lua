local utils = require("common.utils")

-- Params
local base_craft_time = 300
local base_texture = "__nauv-so__/graphics/fluids/gel.png"
local fluid_color = {0.9, 0.6, 0.6}
local order = "a-"

local science_data = {
	space = { -- Note: no base 50% prod for data until Gleba
		craft_categories = { "oil-processing" },
		craft_time_mult = 0.5, -- Oil refinery has a low base speed
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 300 },
			{ type = "fluid", name = "sulfuric-acid", amount = 300 },
			{ type = "item", name = "plastic-bar", amount = 30 },
			{ type = "item", name = "uranium-235", amount = 5 },
			{ type = "item", name = "flamethrower-ammo", amount = 20 },
			{ type = "item", name = "explosive-rocket", amount = 25 }
		}
	},
	metallurgic = {
		craft_categories = { "metallurgy" },
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 150 },
			{ type = "fluid", name = "sulfuric-acid", amount = 2500 }, -- Extra acid
			{ type = "item", name = "plastic-bar", amount = 20 },
			{ type = "item", name = "tungsten-carbide", amount = 50 },
			{ type = "item", name = "refined-concrete", amount = 150 },
			{ type = "item", name = "rail", amount = 150 }
		}
	},
	agricultural = {
		craft_categories = { "organic" },
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 150 },
			{ type = "fluid", name = "sulfuric-acid", amount = 250 },
			{ type = "item", name = "plastic-bar", amount = 75 }, -- Extra plastic
			{ type = "item", name = "nutrients", amount = 75 },
			{ type = "item", name = "coal", amount = 10 },
			{ type = "item", name = "pentapod-egg", amount = 10 }
		}
	},
	electromagnetic = {
		craft_categories = { "electromagnetics" },
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 2500 }, -- Extra lube
			{ type = "fluid", name = "sulfuric-acid", amount = 200 },
			{ type = "item", name = "plastic-bar", amount = 10 },
			{ type = "item", name = "superconductor", amount = 50 },
			{ type = "item", name = "lightning-rod", amount = 12 },
			{ type = "item", name = "holmium-plate", amount = 20 }
		}
	},
	cryogenic = {
		craft_categories = { "cryogenics" },
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 50 },
			{ type = "fluid", name = "sulfuric-acid", amount = 600 },
			{ type = "item", name = "wood", amount = 20 },
			{ type = "item", name = "rocket-fuel", amount = 20 },
			{ type = "item", name = "concrete", amount = 50 }
		},
		fluoro_used = 50
	},
	promethium = {
		craft_categories = { "cryogenics" },
		craft_time_mult = 2.0, -- Encourage stockpiling
		ingredients = {
			{ type = "fluid", name = utils.items.basic_slurry, amount = 400 },
			{ type = "fluid", name = "sulfuric-acid", amount = 400 },
			{ type = "item", name = "wood", amount = 20 },
			{ type = "item", name = "spoilage", amount = 200 },
			{ type = "item", name = "foundation", amount = 3 },
			{ type = "item", name = "railgun-ammo", amount = 3 }
		}
	}
}

local fluid = {
	type = "fluid", name = utils.items.gel,
	icon = base_texture,
	default_temperature = 15,
	base_color = fluid_color, flow_color = fluid_color,
	subgroup = utils.subgroup.fluid,
	order = utils.subgroup.fluid_order..order.."a",
	auto_barrel = false
}
data:extend({ fluid })

for name, props in pairs(science_data) do
	local util_props = utils.science[name]
	local recipe = {
		type = "recipe", name = fluid.name.."-"..name, -- Intentionally never matches item name, meaning no main recipe
		icons = { { icon = base_texture }, {
			icon = (util_props.planet == "nauvis" and "__base__" or "__space-age__").."/graphics/icons/"..util_props.planet..".png",
			scale = 0.3, shift = {-8, 7}, floating = true
		}},
		main_product = fluid.name,
		categories = props.craft_categories,
		subgroup = utils.subgroup.gel,
		order = order..util_props.order,
		enabled = false,
		energy_required = base_craft_time * util_props.craft_time_mult * (props.craft_time_mult or 1),
		ingredients = props.ingredients,
		results = {
			{ type = "fluid", name = fluid.name, amount = 400 },
			{ type = "fluid", name = 'water', amount = 40 }, -- Byproduct
			{ type = "item", name = 'spoilage', amount = 4 } -- Byproduct
		},
		allow_productivity = false, -- No prod for gel, just for the data.
		allow_quality = false,
		maximum_productivity = 0.0, -- Should prevent base productivity affceting the recipe.
		surface_conditions = util_props.surface_condition,
		crafting_machine_tint = utils.recipe_tints(fluid_color),
		custom_tooltip_fields = {{
			name = utils.misc.prod_cap_tt, value = "0%"
		}},
	}
	if props.fluoro_used then
		table.insert(recipe.ingredients, utils.items.fluo_in(props.fluoro_used * 2))
		table.insert(recipe.results, utils.items.fluo_out(props.fluoro_used))
	end
	data:extend({ recipe })
	utils.add_to_tech(util_props.pack, recipe.name)
end
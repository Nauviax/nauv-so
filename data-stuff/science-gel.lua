local utils = require("common.utils")

-- Params
local base_craft_time = 60
local base_texture = "__nauv-so__/graphics/fluids/gel.png"
local fluid_color = {0.9, 0.6, 0.6}
local order = "a-"

local science_data = {
	space = {
		craft_category = "oil-processing",
		craft_category_extra = {"organic"},
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 200 }, -- No extra compared to VFG, but also no base 50% prod until Gleba
			{ type = "fluid", name = "sulfuric-acid", amount = 200 },
			{ type = "item", name = "plastic-bar", amount = 20 },
			{ type = "item", name = "uranium-235", amount = 4 },
			{ type = "item", name = "flamethrower-ammo", amount = 16 },
		}
	},
	metallurgic = {
		craft_category = "metallurgy",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 200 },
			{ type = "fluid", name = "sulfuric-acid", amount = 1000 }, -- Extra acid
			{ type = "item", name = "plastic-bar", amount = 20 },
			{ type = "item", name = "tungsten-carbide", amount = 50 },
			{ type = "item", name = "refined-concrete", amount = 100 }
		}
	},
	agricultural = {
		craft_category = "organic",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 200 },
			{ type = "fluid", name = "sulfuric-acid", amount = 200 },
			{ type = "item", name = "plastic-bar", amount = 100 }, -- Extra plastic
			{ type = "item", name = "nutrients", amount = 60 },
			{ type = "item", name = "coal", amount = 10 }
		}
	},
	electromagnetic = {
		craft_category = "electromagnetics",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 1000 }, -- Extra lube
			{ type = "fluid", name = "sulfuric-acid", amount = 200 },
			{ type = "item", name = "plastic-bar", amount = 20 },
			{ type = "item", name = "superconductor", amount = 50 },
			{ type = "item", name = "rocket-fuel", amount = 15 },
		}
	},
	cryogenic = {
		craft_category = "cryogenics",
		ingredients = {
			{ type = "fluid", name = "sulfuric-acid", amount = 300 },
			{ type = "item", name = "wood", amount = 20 },
			{ type = "item", name = "solid-fuel", amount = 20 },
			{ type = "item", name = "rocket-fuel", amount = 10 },
			utils.items.fluo_in(100)
		},
		byproduct = utils.items.fluo_out(50)
	},
	promethium = {
		craft_category = "cryogenics",
		ingredients = {
			{ type = "fluid", name = utils.items.basic_slurry, amount = 400 },
			{ type = "fluid", name = "sulfuric-acid", amount = 400 },
			{ type = "item", name = "wood", amount = 20 },
			{ type = "item", name = "pentapod-egg", amount = 5 },
			{ type = "item", name = "foundation", amount = 2 },
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
		category = props.craft_category,
		additional_categories = props.craft_category_extra,
		subgroup = utils.subgroup.data_pre,
		order = order..util_props.order,
		enabled = false,
		energy_required = base_craft_time * util_props.craft_time_mult,
		ingredients = props.ingredients,
		results = {{ type = "fluid", name = fluid.name, amount = 400 }},
		allow_productivity = true,
		surface_conditions = util_props.surface_condition,
		show_amount_in_title = false,
		crafting_machine_tint = utils.recipe_tints(fluid_color)
	}
	if props.byproduct then
		table.insert(recipe.results, props.byproduct)
	end
	data:extend({ recipe })
	utils.add_to_tech(util_props.pack, recipe.name)
end

-- Wood adjustments to prevent manual stockpiling and make easier to produce/ship.
-- Base game is 0.15/0.2wps per tower. These changes, with bio, make it 1.0. 
local wood = data.raw.item["wood"]
wood.spoil_ticks = 216000 -- 1h, fairly normal length.
wood.spoil_result = "spoilage"
wood.weight = 1000 -- Old 2000
data.raw.plant["tree-plant"].growth_ticks = 18000 -- 5m instead of 10m
data.raw.plant["tree-plant"].minable.results[1].amount = 8 -- Double wood, also reduces seed dependency

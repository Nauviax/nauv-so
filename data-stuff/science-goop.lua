local utils = require("common.utils")

-- Params
local base_craft_time = 15 -- !!! aaa no idea yet (!!! I may make this constant even ?!)
local base_texture = "__temp-mod__/graphics/fluids/bean.png" -- May need to set recipies if main_product doesn't work for it (!!!)
local fluid_color = {0.6, 0.6, 0.6}
local fluid_color_light = {0.6, 0.6, 0.6}

local science_data = {
	space = {
		craft_category = "organic-or-chemistry",
		ingredients = {
			nil
		}
	},
	metallurgic = {
		craft_category = "metallurgy",
		ingredients = {
			nil
		}
	},
	agricultural = {
		craft_category = "organic",
		ingredients = {
			nil
		}
	},
	electromagnetic = {
		craft_category = "electromagnetics",
		ingredients = {
			nil
		}
	},
	cryogenic = {
		craft_category = "cryogenics",
		ingredients = {
			nil
		}
	},
	promethium = {
		craft_category = "cryogenics",
		ingredients = {
			nil
		}
	}
}

local item = {
	type = "fluid", name = "science-goop",
	icons = {{
		icon = base_texture, icon_size = 64,
		tint = fluid_color_light
	}},
	default_temperature = 15, gas_temperature = 0,
	base_color = fluid_color, flow_color = fluid_color,
	order = "n[new-fluid]-s2[science-fluid]-1[goop]", --!!! TODO
	auto_barrel = false
}
data:extend({ item })

for name, props in pairs(science_data) do
	local util_props = utils.sciences[name]

	local recipe = { -- !!!!! USE ICONS TO DISTINGUISH, use planet icons?
		type = "recipe", name = "science-goop-"..name, -- Intentionally never matches item name, meaning no main recipe
		main_product = "science-goop",
		category = props.craft_category,
		subgroup = "fluid-recipes", -- !!!
		--order = "!!!TODO", --!!!
		enabled = false,
		energy_required = base_craft_time * util_props.craft_time_mult,
		ingredients =  props.ingredients,
		results = {{ type = "fluid", name = "science-goop", amount = 400 }}, -- 4 data crafts, so 2 pack crafts
		allow_productivity = true,
		surface_conditions = props.surface_condition,
		crafting_machine_tint = utils.recipe_tints(fluid_color)
	}
	data:extend({ recipe })
	utils.add_to_tech(name.."-science-pack", "science-goop-"..name)
end
local utils = require("common.utils")

-- Params
local base_craft_time = 15 -- !!! aaa no idea yet (!!! I may make this constant even ?!)
local base_texture = "__temp-mod__/graphics/fluids/bean.png" -- May need to set recipies if main_product doesn't work for it (!!!)
local fluid_color = {0.9, 0.9, 0.9} -- !!! WIP (Trying white)
local fluid_color_light = {1.0, 1.0, 1.0}

-- !!! Mostly happy with lube, sulf, plast. Wood needs good looking at, and 4/5 need heavy amount balance
-- !!! Tempted to output less goop per craft to inflate costs. Balance !!! (Current is 1 goop craft -> 2 packs. Some costs too low for this)
local science_data = {
	space = {
		craft_category = "organic-or-chemistry",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 50 },
			{ type = "fluid", name = "sulfuric-acid", amount = 50 },
			{ type = "item", name = "plastic-bar", amount = 5 },
			{ type = "item", name = "nuclear-fuel", amount = 1 }, -- !!! Price check!
			{ type = "item", name = "uranium-fuel-cell", amount = 4 }, -- !!! Price check!
		}
	},
	metallurgic = {
		craft_category = "metallurgy",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 50 },
			{ type = "fluid", name = "sulfuric-acid", amount = 200 }, -- Extra acid
			{ type = "item", name = "plastic-bar", amount = 5 },
			{ type = "item", name = "tungsten-carbide", amount = 3 }, -- !!! Price check!
			{ type = "item", name = "refined-concrete", amount = 10 } -- !!! Price check!
		}
	},
	agricultural = {
		craft_category = "organic",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 50 },
			{ type = "fluid", name = "sulfuric-acid", amount = 50 },
			{ type = "item", name = "plastic-bar", amount = 20 }, -- Extra (bio)plastic
			{ type = "item", name = "nutrients", amount = 20 }, -- !!! Price check! (Likely a decent amount here tho, bioflux is cheap) (1biof is 60 after prod)
			{ type = "item", name = "coal", amount = 10 } -- !!! Price check! Maybe coal, maybe explosives (!!! Test both? Prolly coal tho)

		}
	},
	electromagnetic = {
		craft_category = "electromagnetics",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 200 }, -- Extra lube
			{ type = "fluid", name = "sulfuric-acid", amount = 50 },
			{ type = "item", name = "plastic-bar", amount = 5 },
			{ type = "item", name = "superconductor", amount = 5 }, -- !!! PRICE
			{ type = "item", name = "rocket-fuel", amount = 1 }, -- !!! PRICE (Also this one is uncertain)
		}
	},
	cryogenic = {
		craft_category = "cryogenics",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 50 },
			{ type = "fluid", name = "sulfuric-acid", amount = 50 },
			{ type = "item", name = "wood", amount = 5 }, -- Requires wood (!!! MAKE SPOIL, but also grow way faster. Heavy balance pass)
			{ type = "item", name = "solid-fuel", amount = 5 }, -- !!! PRICE
			utils.items.fluo_in(4) -- !!! PRICE AAA
		},
		byproduct = utils.items.fluo_out(2)
	},
	promethium = {
		craft_category = "cryogenics",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 50 },
			{ type = "fluid", name = "sulfuric-acid", amount = 50 },
			{ type = "item", name = "wood", amount = 5 },
			{ type = "item", name = "pentapod-egg", amount = 5 }, -- !!! PRICE (Overall 1/4 of b-egg I think I said? Check. Account for higher cost, risk and weight)
			{ type = "item", name = "foundation", amount = 1 }, -- !!! PRICE (may be v expensive)
		}
	}
}

local item = {
	type = "fluid", name = "science-goop",
	icons = {{
		icon = base_texture, icon_size = 64,
		tint = fluid_color_light
	}},
	default_temperature = 15,
	base_color = fluid_color, flow_color = fluid_color,
	order = "n[new-fluid]-s2[science-fluid]-1[goop]", --!!! TODO
	auto_barrel = false
}
data:extend({ item })

for name, props in pairs(science_data) do
	local util_props = utils.sciences[name]

	local recipe = { -- !!!!! USE ICONS TO DISTINGUISH, use planet icons?
		type = "recipe", name = "science-goop-"..name, -- Intentionally never matches item name, meaning no main recipe
		icons = {{
			icon = (util_props.planet == "nauvis" and "__base__" or "__space-age__").."/graphics/icons/"..util_props.planet..".png", icon_size = 64
		}, {
			icon = base_texture, icon_size = 64,
			tint = fluid_color_light,
			scale = 0.3, shift = {-8, 7}, floating = true
		}, {
			icon = base_texture, icon_size = 64,
			tint = fluid_color_light,
			scale = 0.3, shift = {8, 7}, floating = true
		}},
		main_product = "science-goop",
		category = props.craft_category,
		subgroup = "fluid-recipes", -- !!!
		--order = "!!!TODO", --!!!
		enabled = false,
		energy_required = base_craft_time * util_props.craft_time_mult,
		ingredients =  props.ingredients,
		results = {{ type = "fluid", name = "science-goop", amount = 400 }}, -- 4 data crafts, so 2 pack crafts (!!! I may change this ratio significantly !!! (See craft time too if so))
		allow_productivity = true,
		surface_conditions = util_props.surface_condition,
		crafting_machine_tint = utils.recipe_tints(fluid_color)
	}
	data:extend({ recipe })
	utils.add_to_tech(name.."-science-pack", "science-goop-"..name)
end
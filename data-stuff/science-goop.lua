local utils = require("common.utils")

-- Params
local base_craft_time = 15 -- !!! aaa no idea yet (!!! I may make this constant even ?!)
local base_texture = "__temp-mod__/graphics/fluids/bean.png" -- May need to set recipies if main_product doesn't work for it (!!!)
local fluid_color = {0.9, 0.9, 0.9} -- !!! WIP (Trying white)
local fluid_color_light = {1.0, 1.0, 1.0}
local order = "a-"

-- !!! Mostly happy with lube, sulf, plast. Wood needs good looking at, and 4/5 need heavy amount balance
-- Local ing balance same each (tung to holm, same amnt per pack as vanila, if vulc is x6 then fulg is x6 too)
local science_data = {
	space = { -- !!! Mostly balanced (Space)
		craft_category = "organic-or-chemistry",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 200 },
			{ type = "fluid", name = "sulfuric-acid", amount = 200 },
			{ type = "item", name = "plastic-bar", amount = 20 },
			{ type = "item", name = "uranium-235", amount = 3 }, -- !!! Price check!
			{ type = "item", name = "flamethrower-ammo", amount = 10 }, -- !!! Price check! (Crude may be high, but I like the idea. Investigate oil/s spare crude on my save?)
		}
	},
	metallurgic = {
		craft_category = "metallurgy",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 200 },
			{ type = "fluid", name = "sulfuric-acid", amount = 800 }, -- Extra acid
			{ type = "item", name = "plastic-bar", amount = 20 },
			{ type = "item", name = "tungsten-carbide", amount = 10 }, -- !!! Price check!
			{ type = "item", name = "refined-concrete", amount = 20 } -- !!! Price check!
		}
	},
	agricultural = {
		craft_category = "organic",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 200 },
			{ type = "fluid", name = "sulfuric-acid", amount = 200 },
			{ type = "item", name = "plastic-bar", amount = 80 }, -- Extra (bio)plastic
			{ type = "item", name = "nutrients", amount = 50 }, -- !!! Price check! (Likely a decent amount here tho, bioflux is cheap) (1biof is 60 after prod)
			{ type = "item", name = "coal", amount = 20 } -- !!! Price check! Maybe coal, maybe explosives (!!! Test both? Prolly coal tho)

		}
	},
	electromagnetic = {
		craft_category = "electromagnetics",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 800 }, -- Extra lube
			{ type = "fluid", name = "sulfuric-acid", amount = 200 },
			{ type = "item", name = "plastic-bar", amount = 20 },
			{ type = "item", name = "superconductor", amount = 12 }, -- !!! PRICE
			{ type = "item", name = "rocket-fuel", amount = 4 }, -- !!! PRICE (Also this one is uncertain)
		}
	},
	cryogenic = {
		craft_category = "cryogenics",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 200 },
			{ type = "fluid", name = "sulfuric-acid", amount = 200 },
			{ type = "item", name = "wood", amount = 5 }, -- !!! time mostly, test (!!! OLD WAS 2 BUT I UPPED IT)
			{ type = "item", name = "solid-fuel", amount = 15 }, -- !!! PRICE
			utils.items.fluo_in(10) -- !!! PRICE AAA
		},
		byproduct = utils.items.fluo_out(5)
	},
	promethium = {
		craft_category = "cryogenics",
		ingredients = {
			{ type = "fluid", name = "lubricant", amount = 200 },
			{ type = "fluid", name = "sulfuric-acid", amount = 200 },
			{ type = "item", name = "wood", amount = 5 },
			{ type = "item", name = "pentapod-egg", amount = 5 }, -- !!! PRICE (Begg per pack also 5, goop makes 2 so is good?? Check. Account for higher cost, risk and weight)
			{ type = "item", name = "foundation", amount = 2 }, -- !!! PRICE (Actually not THAT bad, balance w circuits)
		}
	}
}

local fluid = {
	type = "fluid", name = "science-goop",
	icons = {{
		icon = base_texture, icon_size = 64,
		tint = fluid_color_light
	}},
	default_temperature = 15,
	base_color = fluid_color, flow_color = fluid_color,
	subgroup = utils.subgroup.fluid,
	order = utils.subgroup.fluid_order..order.."a",
	auto_barrel = false
}
data:extend({ fluid })

for name, props in pairs(science_data) do
	local util_props = utils.sciences[name]

	local recipe = { -- !!!!! USE ICONS TO DISTINGUISH, use planet icons?
		type = "recipe", name = fluid.name.."-"..name, -- Intentionally never matches item name, meaning no main recipe
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
		main_product = fluid.name,
		category = props.craft_category,
		subgroup = utils.subgroup.data_pre,
		order = order..util_props.order,
		enabled = false,
		energy_required = base_craft_time * util_props.craft_time_mult,
		ingredients =  props.ingredients,
		results = {{ type = "fluid", name = fluid.name, amount = 400 }}, -- 4 data crafts, so 2 pack crafts (!!! I may change this ratio significantly !!! (See craft time too if so))
		allow_productivity = true,
		surface_conditions = util_props.surface_condition,
		crafting_machine_tint = utils.recipe_tints(fluid_color)
	}
	data:extend({ recipe })
	utils.add_to_tech(name.."-science-pack", recipe.name)
end

-- Wood adjustments to prevent manual stockpiling and increace generation rate
-- Base game is 0.15 or 0.2wps, now about 2.1 or 2.2wps.
-- 1kspm (5k) theoretically needs 16 towers, before prod.
data.raw.item["wood"].spoil_ticks = 216000 -- 1h, fairly normal length.
data.raw.item["wood"].spoil_result = "spoilage"
data.raw.plant["tree-plant"].growth_ticks = 18000 -- 5m instead of 10m
data.raw.plant["tree-plant"].minable.results[1].amount = 16 -- !!! TEST if this affects other trees also !!! (Manually planted? Just test all)
-- !!! Likely log in tips-n-tricks these changes, and to expect just over 2wps per tower
-- !!! 16 isn't that much really, maybe revert more if 1kspm is easy to hit? (1wps?)

local utils = require("common.utils")

-- Params
local base_craft_time = 20 -- !!! BALANCE (Very unsure on this speed) (I want data to be long, but promethium should be quicker I think? !!! See pack note here for same item)
local base_stack_size = 100
local base_weight = 2000
local data_crafts_per_pack = 2
local icon = "__temp-mod__/graphics/items/data.png"
local subgroup = "science-data"
local order = "a-"

local dcard = { type = "item", name = "fresh-data", amount = 1 }
local goop = { type = "fluid", name = "science-goop", amount = 100 }

local base_item = table.deepcopy(data.raw.tool["automation-science-pack"])
base_item.icon = nil -- We will use icons

local science_data = { -- !!! ALL AMOUNTS ARE UNBALANCED, items are p good I think tho.
	space = { -- !!! Mostly balanced
		stack_mult = 1,
		weight_mult = 1,
		craft_category = "organic-or-assembling",
		color = {1.0, 1.0, 1.0},
		is_tool = true,
		ingredients = {
			dcard, goop,
			{ type = "item", name = "flying-robot-frame", amount = 4 },
			{ type = "item", name = "electric-furnace", amount = 2 },
			{ type = "item", name = "heat-exchanger", amount = 1 }
		}
	},
	metallurgic = { -- !!! Mostly balanced
		stack_mult = 0.25,
		weight_mult = 2,
		craft_category = "metallurgy",
		color = {1.0, 0.5, 0.2},
		is_tool = false,
		ingredients = {
			dcard, goop,
			{ type = "fluid", name = "molten-copper", amount = 1000 },
			{ type = "item", name = "tungsten-plate", amount = 10 },
			{ type = "item", name = "engine-unit", amount = 20 } -- Require bulk (!!!) (Potentially try to match Mcopper here?)
		}
	},
	agricultural = {
		stack_mult = 1,
		weight_mult = 1,
		craft_category = "organic",
		color = {0.7, 1.0, 0.2},
		is_tool = false,
		ingredients = {
			dcard, goop,
			{ type = "item", name = "bioflux", amount = 8 },
			{ type = "item", name = "pentapod-egg", amount = 8 },
			{ type = "item", name = "electronic-circuit", amount = 8 } -- Extra (!!!)
		},
		spoil_ticks = 216000, -- 1h, normal pack timer
		spoil_result = "spoilage"
	},
	electromagnetic = {-- !!! Mostly balanced
		stack_mult = 2,
		weight_mult = 0.25,
		craft_category = "electromagnetics",
		color = {0.8, 0.1, 0.8},
		is_tool = false,
		ingredients = {
			dcard, goop,
			{ type = "item", name = "accumulator", amount = 6 },
			{ type = "fluid", name = "electrolyte", amount = 200 },
			{ type = "item", name = "supercapacitor", amount = 6 }
		}
	},
	cryogenic = {
		stack_mult = 1,
		weight_mult = 1,
		craft_category = "cryogenics",
		color = {0.3, 0.3, 1.0},
		is_tool = false,
		ingredients = {
			dcard, goop,
			{ type = "item", name = "ice", amount = 15 }, -- !!! May do some ice derivitive, water something, possibly in addition. Need investigate ammonia balancing. (Want excess ice ideally)
			{ type = "item", name = "lithium-plate", amount = 5 }
		},
		fluoro_used = 15 -- !!! This is x5 normal
	},
	promethium = { -- !!! Mostly balanced (!!! Still want to balance prometh (both) to begg ratio, see if eggs run out too fast once at hgprom area)
		stack_mult = 0.25,
		weight_mult = 1,
		extra_craft_mult = 0.2, -- Fast crafting for this step due to spoilables and hazardous area
		craft_category = "cryogenics",
		color = {0.2, 0.3, 0.4},
		is_tool = false,
		ingredients = {
			dcard, goop,
			{ type = "item", name = "biter-egg", amount = 5 },
			{ type = "item", name = "quantum-processor", amount = 2 },
			{ type = "item", name = "high-grade-promethium-asteroid-chunk", amount = 1 }
		},
		fluoro_used = 3
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
	item.subgroup = utils.subgroup.data
	item.order = order..util_props.order
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
		subgroup = utils.subgroup.data,
		order = order..util_props.order,
		enabled = false,
		energy_required = base_craft_time * util_props.craft_time_mult * (props.extra_craft_mult or 1),
		ingredients = props.ingredients, -- Done outside of loop
		results = {{ type = "item", name = item.name, amount =  util_props.data_per_pack / data_crafts_per_pack }},
		allow_productivity = true,
		surface_conditions = util_props.surface_condition
	}
	if props.fluoro_used then
		table.insert(recipe.ingredients, utils.items.fluo_in(props.fluoro_used * 2))
		table.insert(recipe.results, utils.items.fluo_out(props.fluoro_used))
	end

	data:extend({ item, recipe })
	utils.add_to_tech(name.."-science-pack", item.name)
end

-- !!! Science tab in space tab may be good idea for fluids and data/packs
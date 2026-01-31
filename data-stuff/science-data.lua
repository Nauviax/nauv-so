local utils = require("common.utils")

-- Params
local base_craft_time = 60
local base_stack_size = 50
local base_weight = utils.science.common.weight
local data_crafts_per_pack = 2
local icon = "__nauv-so__/graphics/items/data.png"
local order = "a-"

local dcard = { type = "item", name = utils.items.blank_data, amount = 1 }
local gel = { type = "fluid", name = utils.items.gel, amount = 100 }

local base_item = table.deepcopy(data.raw.tool["automation-science-pack"])
base_item.icon = nil
base_item.localised_description = nil

local science_data = {
	space = {
		stack_mult = 1,
		weight_mult = 1, -- 10 crafts per data rocket
		craft_category = "organic-or-assembling",
		is_tool = true,
		ingredients = {
			dcard, gel,
			{ type = "item", name = "flying-robot-frame", amount = 4 },
			{ type = "item", name = "electric-furnace", amount = 3 },
			{ type = "item", name = "heat-exchanger", amount = 1 }
		}
	},
	metallurgic = {
		stack_mult = 0.4,
		weight_mult = 2, -- 5 crafts per data rocket
		craft_category = "metallurgy",
		is_tool = false,
		ingredients = {
			dcard, gel,
			{ type = "fluid", name = "molten-copper", amount = 1500 },
			{ type = "item", name = "tungsten-plate", amount = 10 },
			{ type = "item", name = "engine-unit", amount = 20 }
		}
	},
	agricultural = {
		stack_mult = 1,
		weight_mult = 0.5, -- 20 crafts per data rocket
		craft_category = "organic",
		is_tool = false,
		ingredients = {
			dcard, gel,
			{ type = "item", name = "bioflux", amount = 5 },
			{ type = "item", name = "pentapod-egg", amount = 5 },
			{ type = "item", name = "electronic-circuit", amount = 10 }
		},
		spoil_ticks = 216000, -- 1h, normal pack timer
		spoil_result = utils.items.garbage_data
	},
	electromagnetic = {
		stack_mult = 4,
		weight_mult = 2/15, -- 7.5 crafts per data rocket
		craft_category = "electromagnetics",
		is_tool = false,
		ingredients = {
			dcard, gel,
			{ type = "item", name = "accumulator", amount = 6 },
			{ type = "fluid", name = "electrolyte", amount = 125 },
			{ type = "item", name = "supercapacitor", amount = 8 }
		}
	},
	cryogenic = {
		stack_mult = 1,
		weight_mult = 0.5, -- 20 crafts per data rocket
		craft_category = "cryogenics",
		is_tool = false,
		ingredients = {
			dcard, gel,
			{ type = "item", name = "ice-platform", amount = 1 },
			{ type = "item", name = "lithium-plate", amount = 8 }
		},
		fluoro_used = 50
	},
	promethium = {
		stack_mult = 0.4,
		weight_mult = 1,
		extra_craft_mult = 0.2, -- Fast crafting for this step due to spoilables and hazardous area
		craft_category = "cryogenics",
		is_tool = false,
		ingredients = {
			dcard, gel,
			{ type = "item", name = "biter-egg", amount = 5 },
			{ type = "item", name = "quantum-processor", amount = 2 },
			{ type = "item", name = utils.items.hg_prom, amount = 1 }
		},
		fluoro_used = 4
	}
}

for name, props in pairs(science_data) do
	local util_props = utils.science[name]

	local item = table.deepcopy(base_item)
	item.name = util_props.data
	item.icons = {{ icon = icon, tint = util_props.color }}
	if not props.is_tool then
		item.type = "item"
		item.durability = nil
		item.durability_description_key = nil
		item.durability_description_value = nil
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
		ingredients = props.ingredients,
		results = {{ type = "item", name = item.name, amount = util_props.data_per_pack / data_crafts_per_pack }},
		allow_productivity = true,
		maximum_productivity = utils.science.common.max_productivity,
		surface_conditions = util_props.surface_condition,
		show_amount_in_title = false,
		always_show_products = true,
		custom_tooltip_fields = {{
			name = utils.misc.prod_cap_tt, value = (utils.science.common.max_productivity * 100).."%"
		}},
		-- Actually happy to leave crafting_machine_tint white for data crafting
	}
	if props.fluoro_used then
		table.insert(recipe.ingredients, utils.items.fluo_in(props.fluoro_used * 2))
		table.insert(recipe.results, utils.items.fluo_out(props.fluoro_used))
	end

	data:extend({ item, recipe })
	utils.add_to_tech(name.."-science-pack", item.name)
end
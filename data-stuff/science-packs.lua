local utils = require("common.utils")

-- Params
local base_craft_time = 12
local stack_size = 50
local weight = utils.science.common.weight
local pack_craft_category = "cryogenics-or-assembling"
local cycle_craft_time = 0.4
local cycle_slurry_cost = 5
local cycle_qual_base = 0.2 -- Applied to oil refinery
local cycle_craft_category = "oil-processing"
local order = "a-"
local cycle_order = "z-"

local science_data = {
	space = {
		advanced = false,
		prom_amnt = 3, -- Extra prom, nil ingredient
	},
	metallurgic = {
		advanced = false,
		prom_amnt = 2,
		ingredient = { type = "item", name = "iron-gear-wheel", amount = 1 }
	},
	agricultural = {
		advanced = false,
		prom_amnt = 1, -- Less to help manage freshness
		ingredient = { type = "item", name = "carbon", amount = 2 },
		cycle_time_mult = 0.5,
		spoil_ticks = 216000, -- 1h, normal pack timer
		spoil_result = "nutrients" -- Avoid legendary materials in spoilage
	},
	electromagnetic = {
		advanced = false,
		prom_amnt = 2,
		ingredient = { type = "item", name = "iron-stick", amount = 4 }
	},
	cryogenic = {
		advanced = true,
		prom_amnt = 5,
		ingredient = { type = "item", name = "ice", amount = 10 },
		cycle_time_mult = 2
	},
	promethium = {
		advanced = true,
		prom_amnt = 25,
		ingredient = { type = "item", name = utils.items.blank_data, amount = 1 },
		garbage_out = 2, -- Account for extra in
		cycle_time_mult = 2
	}
}

for name, props in pairs(science_data) do
	local util_props = utils.science[name]
	local slurry = props.advanced and utils.items.adv_slurry or utils.items.basic_slurry

	local item = data.raw.tool[util_props.pack]
	item.stack_size = stack_size
	item.weight = weight
	if props.spoil_ticks then
		item.spoil_ticks = props.spoil_ticks
		item.spoil_result = props.spoil_result
	end

	local recipe = data.raw.recipe[util_props.pack]
	recipe.main_product = util_props.pack
	recipe.category = pack_craft_category
	recipe.subgroup = utils.subgroup.pack
	recipe.order = order..util_props.order
	recipe.energy_required = base_craft_time * util_props.craft_time_mult
	recipe.ingredients = {
		{ type = "item", name = util_props.data, amount = util_props.data_per_pack },
		{ type = "fluid", name = slurry, amount = 100 },
		{ type = "item", name = utils.items.prom147, amount = props.prom_amnt }
	}
	if props.ingredient then
		table.insert(recipe.ingredients, props.ingredient)
	end
	recipe.results = {
		{ type = "item", name = util_props.pack, amount = 1 },
		{ type = "item", name = utils.items.garbage_data, amount = props.garbage_out or 1 }
	}
	recipe.allow_productivity = true -- Already true, just clarity
	recipe.maximum_productivity = utils.science.common.max_productivity
	recipe.surface_conditions = utils.science.promethium.surface_condition
	recipe.crafting_machine_tint = utils.recipe_tints(util_props.color)
	recipe.custom_tooltip_fields = {{
		name = utils.misc.prod_cap_tt, value = (utils.science.common.max_productivity * 100).."%"
	}};

	-- Remove and re-add from respective tech to ensure it is shown at the end
	local tech = data.raw.technology[util_props.pack]
	for index, unlock in pairs(tech.effects) do
		if unlock.recipe == recipe.name then
			table.remove(tech.effects, index)
			utils.add_to_tech(util_props.pack, recipe.name)
			break
		end
	end

	-- Upcycling recipe
	local upcycle_recipe = {
		type = "recipe", name = utils.prefix..util_props.pack.."-upcycle",
		main_product = util_props.pack, enabled = false,
		icons = {
			{ icon = item.icon },
			{
				icon = "__core__/graphics/icons/any-quality.png",
				scale = 0.25, shift = {8, 8}, floating = true
			}
		},
		category = cycle_craft_category, subgroup = utils.subgroup.cycle,
		order = cycle_order..util_props.order,
		energy_required = cycle_craft_time * (props.cycle_time_mult or 1),
		ingredients = {
			{ type = "item", name = util_props.pack, amount = 1, ignored_by_stats = 1 },
			{ type = "fluid", name = slurry, amount = cycle_slurry_cost }
		},
		results = {
			{ type = "item", name = util_props.pack, amount = 1, ignored_by_stats = 1 },
			{ type = "fluid", name = "steam", amount = props.advanced and 5 or 2, temperature = 500 }
		},
		allow_productivity = false, -- Avoid obvious exploit
		allow_quality = true,
		surface_conditions = utils.science.promethium.surface_condition,
		crafting_machine_tint = utils.recipe_tints(util_props.color),
		custom_tooltip_fields = {{
			name = utils.misc.qual_base_tt, value = (cycle_qual_base * 100).."%"
		}};
	}
	data:extend({ upcycle_recipe })
	utils.add_to_tech(tech.name, upcycle_recipe.name)
end

-- Give oil refineries a base 20% quality bonus to help with pack upcycling. (Should not affect other recipes)
local refinery = data.raw["assembling-machine"]["oil-refinery"]
refinery.effect_receiver = { base_effect = { quality = cycle_qual_base * 10 } }
refinery.allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" } -- Overwrites old, but I can't find a way to do it otherwise.

-- Reduce effectiveness of quality packs/tools, rare is base
local tool_effectiveness = { 0.5, 0.8, 1.0, 1.1, nil, 1.2 } -- Basically quality > rare is just a minor improvement.
for _, q_level in pairs(data.raw.quality) do
	q_level.tool_durability_multiplier = tool_effectiveness[q_level.level + 1]
end

-- Buff repair packs so common qual is same as before due above change (locale change also)
local repair_tool = data.raw["repair-tool"]["repair-pack"]
repair_tool.durability = 300 / (1 - tool_effectiveness[1]) -- Aim is 300 for common after qual
repair_tool.durability_description_value = "description.nso-rep-pack-durability-value"

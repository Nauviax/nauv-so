----- Asteroids
-- NOTE: !!! Remember descriptions/localised_description etc in all

-- High grade promethium
local high_grade_item = table.deepcopy(data.raw.item["promethium-asteroid-chunk"])
high_grade_item.name = "high-grade-promethium-asteroid-chunk"
high_grade_item.spoil_ticks = 3600 -- 1 minute
high_grade_item.spoil_result = "promethium-asteroid-chunk"
high_grade_item.icon = "__temp-mod__/graphics/items/hg-promethium-asteroid-chunk.png"
high_grade_item.order = high_grade_item.order .. "-2"
data:extend({high_grade_item})

local high_grade_chunk = table.deepcopy(data.raw["asteroid-chunk"]["promethium-asteroid-chunk"])
high_grade_chunk.name = "high-grade-promethium-asteroid-chunk"
high_grade_chunk.minable.result = "high-grade-promethium-asteroid-chunk"
high_grade_chunk.icon = "__temp-mod__/graphics/items/hg-promethium-asteroid-chunk.png"
high_grade_chunk.order = high_grade_item.order .. "-2"
data:extend({high_grade_chunk})

-- Low grade promethium (Old item)
local low_grade_item = data.raw.item["promethium-asteroid-chunk"]
low_grade_item.spoil_ticks = 3600 * 5 -- 5 minutes
low_grade_item.spoil_result = "iron-ore"

-- Add high grade to big asteroid chunks
local spread = 1
table.insert(data.raw.asteroid["big-promethium-asteroid"].dying_trigger_effect,
{
	type = "create-asteroid-chunk",
	asteroid_name = "high-grade-promethium-asteroid-chunk",
	offset_deviation = {{-spread, -spread}, {spread, spread}},
	offsets =
	{
		{-spread/2, -spread/4},
		{spread/2, -spread/4}
	}
})


----- Intermediates items and recipes

-- Update space science sprite
data.raw.tool["space-science-pack"].icon = "__temp-mod__/graphics/items/space-science-pack.png"
data.raw.technology["space-science-pack"].icon = "__temp-mod__/graphics/techs/space-science-pack.png"

-- A few consts (!!! Code review self and add more here if can)
local space_condition = {{ property = "gravity", max = 0 }}

-- Science/data and space fluids (!!! crafting_machine_tint !!!) (Does this affect cryo too?)
data:extend({
	{
		type = "fluid", name = "basic-science-fluid",
		icons = {{
			icon = "__temp-mod__/graphics/fluids/gas.png", icon_size = 64,
			tint = {1.0, 0.5, 0.5} -- !!! Test both colors !!!
		}},
		default_temperature = 15, gas_temperature = 0,
		base_color = {0.8, 0.2, 0.2}, flow_color = {0.8, 0.2, 0.2},
		order = "n[new-fluid]-s1[science-fluid]-1[basic]", --!!! TODO
		auto_barrel = false
	},
	{
		type = "recipe", name = "basic-science-fluid",
		main_product = "basic-science-fluid",
		category = "chemistry-or-cryogenics",
		--subgroup = "fluid-recipes", -- !!!
		--order = "!!!TODO", --!!!
		enabled = false,
		energy_required = 15,
		ingredients = {
			{ type = "fluid", name = "water", amount = 25 }, -- !!! At some point sort all recipe orders and enforce in-game order (!!! order_in_recipe)
			{ type = "fluid", name = "thruster-fuel", amount = 75 },
			{ type = "item", name = "steel-plate", amount = 1}, -- !!! Balance review ofc
			{ type = "item", name = "promethium-asteroid-chunk", amount = 1, ignored_by_stats = 0.75 }
		},
		results = {
			{ type = "fluid", name = "basic-science-fluid", amount = 100 },
			{ type = "item", name = "promethium-asteroid-chunk", amount = 1, probability = 0.75, ignored_by_stats = 0.75, ignored_by_productivity = 1 } -- !!! Test prod, stats (in and out) spoilage etc
		}, -- !!! Balance ofc
		surface_conditions = space_condition
	},
	{
		type = "fluid", name = "advanced-science-fluid",
		icons = {{
			icon = "__temp-mod__/graphics/fluids/gas.png", icon_size = 64,
			tint = {0.8, 0.2, 0.8} -- !!! Test both colors !!!
		}},
		default_temperature = 15, gas_temperature = 0,
		base_color = {0.5, 0.0, 0.5}, flow_color = {0.5, 0.0, 0.5},
		order = "n[new-fluid]-s1[science-fluid]-2[advanced]", --!!! TODO
		auto_barrel = false
	},
	{
		type = "recipe", name = "advanced-science-fluid",
		main_product = "advanced-science-fluid",
		category = "chemistry-or-cryogenics",
		--subgroup = "fluid-recipes", -- !!!
		--order = "!!!TODO", --!!!
		enabled = false,
		energy_required = 25,
		ingredients = {
			{ type = "fluid", name = "basic-science-fluid", amount = 100 },
			{ type = "fluid", name = "petroleum-gas", amount = 100 }, -- Fizzy (need balance lots)
			{ type = "fluid", name = "sulfuric-acid", amount = 100 }, -- !!! Wood was no good, 0.2ps per tower
			{ type = "item", name = "copper-cable", amount = 40 }, -- 40 cable (Check time to make)
			{ type = "item", name = "promethium-asteroid-chunk", amount = 1, ignored_by_stats = 0.5 }
		},
		results = {
			{ type = "fluid", name = "advanced-science-fluid", amount = 100 },
			{ type = "item", name = "promethium-asteroid-chunk", amount = 1, probability = 0.5, ignored_by_stats = 0.5, ignored_by_productivity = 1 } -- !!! Test prod, stats (in and out) spoilage etc
		}, -- !!! Balance ofc
		surface_conditions = space_condition
	}
})
local new_pack_data_list = {
	{
		name = "space", color = {0.9, 0.9, 0.9}, color_light = {1.0, 1.0, 1.0},
		craft_time_mult = 1,
		data_recipe = { -- Planet made (account for prod! On VFG)
			-- Unused for now (!!!)
		},
		fluid_base = "basic", fluid_texture = "normal",
		fluid_local = "uranium-235", fluid_local_in = 1, fluid_local_out = 0.92,
		data_per_pack = 2, data_craft_cat = "organic-or-assembling"
	},
	{
		name = "metallurgic", color = {1.0, 0.3, 0.0}, color_light = {1.0, 0.5, 0.2},
		craft_time_mult = 1,
		data_recipe = {},
		fluid_base = "basic", fluid_texture = "hot",
		fluid_local = "tungsten-carbide", fluid_local_in = 3,
		data_per_pack = 2, data_weight_mult = 2, data_stack_mult = 0.25
	},
	{
		name = "electromagnetic", color = {0.8, 0.0, 0.8}, color_light = {0.8, 0.1, 0.8},
		craft_time_mult = 1,
		data_recipe = {},
		fluid_base = "basic", fluid_texture = "glow",
		fluid_local = "superconductor", fluid_local_in = 4,
		data_per_pack = 8, data_weight_mult = 0.25, data_stack_mult = 2
	},
	{
		name = "agricultural", color = {0.5, 1.0, 0.0}, color_light = {0.7, 1.0, 0.2},
		craft_time_mult = 0.5,
		data_recipe = {},
		fluid_base = "basic", fluid_texture = "bean",
		fluid_local = "bioflux", fluid_local_in = 1,
		data_per_pack = 2
	},
	{
		name = "cryogenic", color = {0.0, 0.0, 0.6}, color_light = {0.3, 0.3, 1.0},
		craft_time_mult = 5,
		data_recipe = {},
		fluid_base = "advanced", fluid_texture = "tri",
		fluid_local_type = "fluid", fluid_local = "fluoroketone-cold", fluid_local_in = 6, fluid_local_out = 3,
		data_per_pack = 2,
	},
	{
		name = "promethium", color = {0.0, 0.1, 0.2}, color_light = {0.2, 0.3, 0.4},
		craft_time_mult = 2,
		data_recipe = {},
		fluid_base = "advanced", fluid_texture = "cloud",
		fluid_local = "pentapod-egg", fluid_local_in = 1, -- !!! TO BALANCE, should be 1/2 of biter eggs in total data cost
		data_per_pack = 2, data_stack_mult = 0.25
	},
}
for index, new_pack_data in ipairs(new_pack_data_list) do
	local pack_tech = data.raw.technology[new_pack_data.name.."-science-pack"]
	local pack_recipe = data.raw.recipe[new_pack_data.name.."-science-pack"]
	local pack_item = data.raw.tool[new_pack_data.name.."-science-pack"]
	-- Science fluids
	data:extend({
		{
			type = "fluid", name = new_pack_data.name.."-fluid",
			icons = {{
				icon = "__temp-mod__/graphics/fluids/"..new_pack_data.fluid_texture..".png", icon_size = 64,
				tint = new_pack_data.color_light
			}},
			default_temperature = 15, gas_temperature = string.match(new_pack_data.fluid_texture, "^[tc]") and 0 or 100,
			base_color = new_pack_data.color,
			flow_color = new_pack_data.color,
			order = "n[new-fluid]-s2[science-colored]-"..index.."["..new_pack_data.name.."]", -- Check in inf pipe!!!
			auto_barrel = false,
		},
		{
			type = "recipe", name = new_pack_data.name.."-fluid",
			main_product = new_pack_data.name.."-fluid",
			category = "chemistry-or-cryogenics",
			subgroup = "fluid-recipes", -- !!!
			order = index.."["..new_pack_data.name.."]", -- !!!
			enabled = false,
			energy_required = 10 * new_pack_data.craft_time_mult, -- !!! Balance
			ingredients = {
				{
					type = new_pack_data.fluid_local_type and new_pack_data.fluid_local_type or "item",
					name = new_pack_data.fluid_local,
					amount = new_pack_data.fluid_local_in,
					ignored_by_stats = new_pack_data.fluid_local_out and new_pack_data.fluid_local_out or nil
				},
				{ type = "fluid", name = new_pack_data.fluid_base.."-science-fluid", amount = 100 }
			},
			results = {
				{ type = "fluid", name = new_pack_data.name.."-fluid", amount = 200 }, -- Enough for 2 pack crafts
				new_pack_data.fluid_local_out and {
					type = new_pack_data.fluid_local_type and new_pack_data.fluid_local_type or "item",
					name = string.gsub(new_pack_data.fluid_local, "-cold", "-hot"), -- Special case for cryogenic
					amount = math.max(new_pack_data.fluid_local_out, 1),
					probability = new_pack_data.fluid_local_out < 1 and new_pack_data.fluid_local_out or nil,
					ignored_by_stats = new_pack_data.fluid_local_out, -- !!! Test uranium's 0.92 weirdness !!!
					ignored_by_productivity = new_pack_data.fluid_local_in -- Always bigger
				} or nil
			},
			surface_conditions = space_condition,
		}
	})
	table.insert(pack_tech.effects, { type = "unlock-recipe", recipe = new_pack_data.name.."-fluid" })
	-- !!! WIP data additions
    local data_item = table.deepcopy(pack_item)
    data_item.name = new_pack_data.name.."-data"
    data_item.icon = nil
    data_item.icons = {
		{
			icon = "__temp-mod__/graphics/items/data.png", -- Just a darker version of pack
			icon_size = 64,
			tint = new_pack_data.color_light
		}, {
			icon = pack_item.icon,
			icon_size = pack_item.icon_size, scale = 0.4, shift = {-6, 5}, floating = true,
			tint = {0.5, 0.5, 0.5}
		}
	}
    -- data_item.order -- !!! TODO
    data_item.weight = 1000 * (new_pack_data.data_weight_mult and new_pack_data.data_weight_mult or 1)
	data_item.stack_size = 200 * (new_pack_data.data_stack_mult and new_pack_data.data_stack_mult or 1)
	if (new_pack_data.name ~= "space") then
		data_item.type = "item" -- Only space data is used in labs
	end
	data:extend({
        data_item,
        {
            type = "recipe", name = data_item.name,
            category = new_pack_data.data_craft_cat and new_pack_data.data_craft_cat or pack_recipe.category, -- Default category from vanilla
            --subgroup = "!!!TODO", -- !!!
            --order = "!!!TODO", --!!! (Could use pack and edit slightly to put nearby?)
            enabled = false,
            energy_required = 20 * new_pack_data.craft_time_mult, -- !!! BALANCE (Very unsure on this speed)
            ingredients = {
                { type = "item", name = "raw-fish", amount = 1000 } -- TODO (!!!)
            },
            results = {{ type = "item", name = data_item.name, amount = new_pack_data.data_per_pack / 2 }}, -- !!! Balance ofc
            surface_conditions = space_condition,
            -- Data can be recycled sure why not (!!! investigate packs though, with LGProm !!!)
        }
    })
	table.insert(pack_tech.effects, { type = "unlock-recipe", recipe = new_pack_data.name.."-data" })
	-- Pack updates
	pack_recipe.category = "cryogenics-or-assembling" -- !!! Subcategory? !!!
	-- pack_recipe.subcategory = "!!!TODO" -- !!!
	pack_recipe.surface_conditions = space_condition
	pack_recipe.energy_required = 30 * new_pack_data.craft_time_mult -- !!! Balance
	pack_recipe.ingredients = {
		{ type = "item", name = new_pack_data.name.."-data", amount = new_pack_data.data_per_pack },
		{ type = "fluid", name = new_pack_data.name.."-fluid", amount = 100 },
		{ type = "item", name = "promethium-asteroid-chunk", amount = 1, ignored_by_stats = 0.5 }
	}
	pack_recipe.results = {
		{ type = "item", name = new_pack_data.name.."-science-pack", amount = 1},
		{ type = "item", name = "promethium-asteroid-chunk", amount = 1, probability = 0.5, ignored_by_stats = 0.5, ignored_by_productivity = 1 }
	}
	pack_recipe.main_product = new_pack_data.name.."-science-pack"
	pack_item.weight = 4000
	pack_item.stack_size = 50
end

----- Tier removals (Done in data to avoid recycling recipe issues)

-- Inserter removals
data.raw.inserter["burner-inserter"]= nil
data.raw.item["burner-inserter"] = nil
data.raw.recipe["burner-inserter"] = nil
data.raw.inserter["inserter"]= nil
data.raw.item["inserter"] = nil
data.raw.recipe["inserter"] = nil
local fast_inserter = data.raw.inserter["fast-inserter"]
fast_inserter.energy_per_movement = "5kJ" -- These values == normal inserter
fast_inserter.energy_per_rotation = "5kJ"
-- fast_inserter.order = "z-b[fast-inserter]" -- Before long-handed (!!! Unsure if needed/wanted)
-- data.raw.item["fast-inserter"].order = "b[fast-inserter]"
-- data.raw.recipe["fast-inserter"].order = "b[fast-inserter]"
data.raw.recipe["fast-inserter"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 3 },
	{ type = "item", name = "iron-gear-wheel", amount = 1 },
	{ type = "item", name = "electronic-circuit", amount = 3 }
}
data.raw.recipe["long-handed-inserter"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 2 },
	{ type = "item", name = "electronic-circuit", amount = 1 }
}

-- Stone furnace / burner mining drill removal (Items given at start to avoid softlock)
data.raw.furnace["stone-furnace"]= nil
data.raw.item["stone-furnace"] = nil
data.raw.recipe["stone-furnace"] = nil
data.raw.recipe.boiler.ingredients = {
	{ type = "item", name = "pipe", amount = 4 },
	{ type = "item", name = "stone-brick", amount = 2 },
}
data.raw["mining-drill"]["burner-mining-drill"]= nil
data.raw.item["burner-mining-drill"] = nil
data.raw.recipe["burner-mining-drill"] = nil

-- Assembler adjustments
data.raw["assembling-machine"]["assembling-machine-1"]= nil
data.raw["assembling-machine"]["assembling-machine-3"]= nil
data.raw.item["assembling-machine-1"] = nil
data.raw.item["assembling-machine-3"] = nil
data.raw.recipe["assembling-machine-1"] = nil
data.raw.recipe["assembling-machine-3"] = nil
data.raw.technology["automation-3"] = nil -- MK1 is removed later anyway
local assembling_machine_2 =  data.raw["assembling-machine"]["assembling-machine-2"]
assembling_machine_2.crafting_speed = 1.0 -- Was 0.75
assembling_machine_2.energy_usage = "200kW" -- Was 150kW
assembling_machine_2.module_slots = 4
assembling_machine_2.next_upgrade = nil
data.raw.recipe["assembling-machine-2"].ingredients = { -- Little over double, but then no mk1
	{ type = "item", name = "iron-gear-wheel", amount = 10 },
	{ type = "item", name = "electronic-circuit", amount = 10 },
	{ type = "item", name = "steel-plate", amount = 5 }
}
data.raw["build-entity-achievement"]["automate-this"] = nil
-- !!! Locale will need some updates for all the removed tiers !!! (See below, remove "fast")

-- Belts
data.raw["transport-belt"]["transport-belt"]= nil
data.raw.item["transport-belt"] = nil
data.raw.recipe["transport-belt"] = nil
data.raw["transport-belt"]["express-transport-belt"]= nil
data.raw.item["express-transport-belt"] = nil
data.raw.recipe["express-transport-belt"] = nil
data.raw["underground-belt"]["underground-belt"]= nil
data.raw.item["underground-belt"] = nil
data.raw.recipe["underground-belt"] = nil
data.raw["underground-belt"]["express-underground-belt"]= nil
data.raw.item["express-underground-belt"] = nil
data.raw.recipe["express-underground-belt"] = nil
data.raw["splitter"]["splitter"]= nil
data.raw.item["splitter"] = nil
data.raw.recipe["splitter"] = nil
data.raw["splitter"]["express-splitter"]= nil
data.raw.item["express-splitter"] = nil
data.raw.recipe["express-splitter"] = nil
data.raw.recipe["fast-transport-belt"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 2 }
}
data.raw.recipe["fast-underground-belt"].ingredients = {
	{ type = "item", name = "iron-gear-wheel", amount = 7 },
	{ type = "item", name = "fast-transport-belt", amount = 7 }
}
data.raw.recipe["fast-splitter"].ingredients = {
	{ type = "item", name = "iron-gear-wheel", amount = 4 },
	{ type = "item", name = "electronic-circuit", amount = 8 },
	{ type = "item", name = "fast-transport-belt", amount = 4 }
}
data.raw.recipe["turbo-transport-belt"].ingredients = {
	{ type = "item", name = "iron-gear-wheel", amount = 5 },
	{ type = "item", name = "tungsten-plate", amount = 5 },
	{ type = "item", name = "fast-transport-belt", amount = 1 },
	{ type = "fluid", name = "lubricant", amount = 40 }
}
data.raw.recipe["turbo-underground-belt"].ingredients = {
	{ type = "item", name = "iron-gear-wheel", amount = 60 },
	{ type = "item", name = "tungsten-plate", amount = 40 },
	{ type = "item", name = "fast-underground-belt", amount = 2 },
	{ type = "fluid", name = "lubricant", amount = 80 }
}
data.raw.recipe["turbo-splitter"].ingredients = {
	{ type = "item", name = "advanced-circuit", amount = 6 },
	{ type = "item", name = "processing-unit", amount = 2 },
	{ type = "item", name = "tungsten-plate", amount = 15 },
	{ type = "item", name = "fast-splitter", amount = 1 },
	{ type = "fluid", name = "lubricant", amount = 160 }
}
data.raw["transport-belt"]["fast-transport-belt"].next_upgrade = "turbo-transport-belt"
data.raw["underground-belt"]["fast-underground-belt"].next_upgrade = "turbo-underground-belt"
data.raw["splitter"]["fast-splitter"].next_upgrade = "turbo-splitter"
data.raw.technology["logistics-3"] = nil
for index, prereq in ipairs(data.raw.technology["turbo-transport-belt"].prerequisites) do
	if prereq == "logistics-3" then
		table.remove(data.raw.technology["turbo-transport-belt"].prerequisites, index)
		break
	end
end
data.raw.recipe["lab"].ingredients = {
	{ type = "item", name = "iron-gear-wheel", amount = 10 },
	{ type = "item", name = "electronic-circuit", amount = 10 },
	{ type = "item", name = "fast-transport-belt", amount = 3 }
}
data.raw.recipe["loader"] = nil
data.raw.recipe["express-loader"] = nil

-- Chests + nerfs
data.raw.container["wooden-chest"]= nil
data.raw.item["wooden-chest"] = nil
data.raw.recipe["wooden-chest"] = nil
data.raw.container["iron-chest"]= nil
data.raw.item["iron-chest"] = nil
data.raw.recipe["iron-chest"] = nil
local inventory_size = 20 -- Was 48
data.raw.container["steel-chest"].inventory_size = inventory_size
data.raw.recipe["steel-chest"].ingredients = {
	{ type = "item", name = "steel-plate", amount = 4 }
}
data.raw["logistic-container"]["active-provider-chest"].inventory_size = inventory_size
data.raw["logistic-container"]["passive-provider-chest"].inventory_size = inventory_size
data.raw["logistic-container"]["storage-chest"].inventory_size = inventory_size
data.raw["logistic-container"]["requester-chest"].inventory_size = inventory_size
data.raw["logistic-container"]["buffer-chest"].inventory_size = inventory_size

-- Modules and eff buff
for _, module_name in pairs({
	"speed-module", "efficiency-module", "productivity-module", "quality-module"
}) do
	local mk2_name = module_name.."-2"
	local mk3_name = module_name.."-3"
	data.raw.item[mk2_name] = nil
	data.raw.recipe[mk2_name] = nil
	data.raw.module[mk2_name] = nil
	data.raw.technology[mk2_name] = nil
	local mk3_module = data.raw.recipe[mk3_name]
	for _, ingredient in pairs(mk3_module.ingredients) do -- Slightly cheaper to account for lack of a prod step
		if  ingredient.name == mk2_name then
			ingredient.name = module_name -- MK1
			ingredient.amount = ingredient.amount * 3
		else
			ingredient.amount = ingredient.amount * 4 -- Includes planet items
		end
	end
	for index, prereq in ipairs(data.raw.technology[mk3_name].prerequisites) do
		if prereq == mk2_name then
			table.remove(data.raw.technology[mk3_name].prerequisites, index)
			break -- No need to add mk1, data_updates will delete it.
		end
	end
end
data.raw.module["efficiency-module-3"].effect.consumption = -0.8 -- Old was -0.5
data.raw["module-transfer-achievement"]["make-it-better"] = nil

-- Misc
data.raw["electric-pole"]["small-electric-pole"] = nil
data.raw.item["small-electric-pole"] = nil
data.raw.recipe["small-electric-pole"] = nil
data.raw.armor["light-armor"]= nil
data.raw.item["light-armor"] = nil
data.raw.recipe["light-armor"] = nil
data.raw["character-corpse"]["character-corpse"].armor_picture_mapping["light-armor"] = nil

-- !!! Science tab in space tab may be good idea for fluids and data/packs
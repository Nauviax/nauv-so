local utils = require("common.utils") -- Potentually underutilized here

-- Pack removal (tech done in tech-rework.lua)
for _, pack_name in pairs(utils.removed_packs) do
	utils.delete(data.raw.tool, pack_name)
	utils.delete(data.raw.recipe, pack_name)
	for _, lab in pairs(data.raw.lab) do
		for index, input in ipairs(lab.inputs) do
			if input == pack_name then
				table.remove(lab.inputs, index)
				break
			end
		end
	end
end

-- Inserter removals
utils.delete(data.raw.inserter, "burner-inserter")
utils.delete(data.raw.item, "burner-inserter")
utils.delete(data.raw.recipe, "burner-inserter")
utils.delete(data.raw.inserter, "inserter")
utils.delete(data.raw.item, "inserter")
utils.delete(data.raw.recipe, "inserter")
local fast_inserter = data.raw.inserter["fast-inserter"]
fast_inserter.energy_per_movement = "5kJ" -- These values == normal inserter
fast_inserter.energy_per_rotation = "5kJ"
data.raw.recipe["fast-inserter"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 1 },
	{ type = "item", name = "electronic-circuit", amount = 2 }
}
data.raw.recipe["long-handed-inserter"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 2 },
	{ type = "item", name = "electronic-circuit", amount = 1 }
}

-- Stone furnace / burner mining drill removal (Items given at start to avoid softlock)
utils.delete(data.raw.furnace, "stone-furnace")
utils.delete(data.raw.item, "stone-furnace")
utils.delete(data.raw.recipe, "stone-furnace")
data.raw.recipe.boiler.ingredients = {
	{ type = "item", name = "pipe", amount = 4 },
	{ type = "item", name = "stone-brick", amount = 2 },
}
utils.delete(data.raw["mining-drill"], "burner-mining-drill")
utils.delete(data.raw.item, "burner-mining-drill")
utils.delete(data.raw.recipe, "burner-mining-drill")

-- Assembler adjustments
utils.delete(data.raw["assembling-machine"], "assembling-machine-1")
utils.delete(data.raw["assembling-machine"], "assembling-machine-3")
utils.delete(data.raw.item, "assembling-machine-1")
utils.delete(data.raw.item, "assembling-machine-3")
utils.delete(data.raw.recipe, "assembling-machine-1")
utils.delete(data.raw.recipe, "assembling-machine-3")
utils.delete(data.raw.technology, "automation-3") -- MK1 is removed later anyway
local assembling_machine_2 = data.raw["assembling-machine"]["assembling-machine-2"]
assembling_machine_2.crafting_speed = 1.0 -- Was 0.75
assembling_machine_2.energy_usage = "200kW" -- Was 150kW
assembling_machine_2.module_slots = 4
assembling_machine_2.next_upgrade = nil
data.raw.recipe["assembling-machine-2"].ingredients = { -- Little over double, but then no mk1
	{ type = "item", name = "iron-gear-wheel", amount = 10 },
	{ type = "item", name = "electronic-circuit", amount = 8 },
	{ type = "item", name = "steel-plate", amount = 5 }
}
utils.delete(data.raw["build-entity-achievement"], "automate-this")

-- Belts
utils.delete(data.raw["transport-belt"], "transport-belt")
utils.delete(data.raw.item, "transport-belt")
utils.delete(data.raw.recipe, "transport-belt")
utils.delete(data.raw["transport-belt"], "express-transport-belt")
utils.delete(data.raw.item, "express-transport-belt")
utils.delete(data.raw.recipe, "express-transport-belt")
utils.delete(data.raw["underground-belt"], "underground-belt")
utils.delete(data.raw.item, "underground-belt")
utils.delete(data.raw.recipe, "underground-belt")
utils.delete(data.raw["underground-belt"], "express-underground-belt")
utils.delete(data.raw.item, "express-underground-belt")
utils.delete(data.raw.recipe, "express-underground-belt")
utils.delete(data.raw["splitter"], "splitter")
utils.delete(data.raw.item, "splitter")
utils.delete(data.raw.recipe, "splitter")
utils.delete(data.raw["splitter"], "express-splitter")
utils.delete(data.raw.item, "express-splitter")
utils.delete(data.raw.recipe, "express-splitter")
data.raw.recipe["fast-transport-belt"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 1 }
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
utils.delete(data.raw.technology, "logistics-3")
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
utils.delete(data.raw.recipe, "loader")
utils.delete(data.raw.recipe, "express-loader")

-- Chests + nerfs
utils.delete(data.raw.container, "wooden-chest")
utils.delete(data.raw.item, "wooden-chest")
utils.delete(data.raw.recipe, "wooden-chest")
utils.delete(data.raw.container, "iron-chest")
utils.delete(data.raw.item, "iron-chest")
utils.delete(data.raw.recipe, "iron-chest")
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
	utils.delete(data.raw.item, mk2_name)
	utils.delete(data.raw.recipe, mk2_name)
	utils.delete(data.raw.module, mk2_name)
	utils.delete(data.raw.technology, mk2_name)
	local mk3_module = data.raw.recipe[mk3_name]
	for _, ingredient in pairs(mk3_module.ingredients) do -- Slightly cheaper base overall to account for lack of a prod step
		if ingredient.name == mk2_name then
			ingredient.name = module_name -- MK1
			ingredient.amount = ingredient.amount * 3
		elseif ingredient.name == "advanced-circuit" or ingredient.name == "processing-unit" then
			ingredient.amount = ingredient.amount * 4
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
utils.delete(data.raw["module-transfer-achievement"], "make-it-better")

-- Misc
utils.delete(data.raw["electric-pole"], "small-electric-pole")
utils.delete(data.raw.item, "small-electric-pole")
utils.delete(data.raw.recipe, "small-electric-pole")
utils.delete(data.raw.armor, "light-armor")
utils.delete(data.raw.item, "light-armor")
utils.delete(data.raw.recipe, "light-armor")
data.raw["character-corpse"]["character-corpse"].armor_picture_mapping["light-armor"] = nil
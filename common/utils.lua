local utils = {} -- Pass later on to remove unused items (!!!)

utils.sciences = {
	space = {
		order = "a", -- !!! USE IN ALL ITEMS/RECIPIES !!!
		craft_time_mult = 1,
		data_per_pack = 2,
		planet = "nauvis",
		surface_condition = {{ property = "pressure", min = 1000, max = 1000 }}
	},
	metallurgic = {
		order = "b",
		craft_time_mult = 1,
		data_per_pack = 2,
		planet = "vulcanus",
		surface_condition = {{ property = "pressure", min = 4000, max = 4000 }}
	},
	agricultural = {
		order = "c",
		craft_time_mult = 0.5,
		data_per_pack = 2,
		planet = "gleba",
		surface_condition = {{ property = "pressure", min = 2000, max = 2000 }}
	},
	electromagnetic = {
		order = "d",
		craft_time_mult = 1,
		data_per_pack = 8,
		planet = "fulgora",
		surface_condition = {{ property = "magnetic-field", min = 99 }}
	},
	cryogenic = {
		order = "e",
		craft_time_mult = 5,
		data_per_pack = 2,
		planet = "aquilo",
		surface_condition = {{ property = "pressure", min = 100, max = 600 }}
	},
	promethium = {
		order = "f",
		craft_time_mult = 2,
		data_per_pack = 2, -- !!! Do more with this maybe? Not here necessarily.
		planet = "shattered-planet",
		surface_condition = {{ property = "gravity", max = 0 }}
	}
}

utils.items = { -- Common item ingredient/results
	fluo_in = function(amnt) return { type = "fluid", name = "fluoroketone-cold", amount = amnt, ignored_by_stats = amnt } end,
	fluo_out = function(amnt) return { type = "fluid", name = "fluoroketone-hot", amount = amnt, ignored_by_stats = amnt } end
}

utils.subgroup = { -- Groupings for things that need to follow vanilla
	data_pre = "science-data-pre",
	data = "science-data",
	pack_pre = "science-pack-pre",
	pack = "science-pack",
	fluid = "fluid",
	fluid_order = "n[nauv]-" -- Useful, even if not a subgroup
}

function utils.recipe_tints(fluid_color)
	return { primary = fluid_color, secondary = fluid_color, tertiary = fluid_color, quaternary = fluid_color }
end

function utils.add_to_tech(tech, recipe)
	table.insert(data.raw.technology[tech].effects, { type = "unlock-recipe", recipe = recipe })
end

return utils
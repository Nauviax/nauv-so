local utils = {} -- !!! TODO implement utils in/for remove-unused-items code

utils.prefix = "nso-"

utils.sciences = {
	space = {
		order = "a",
		craft_time_mult = 1,
		data_per_pack = 2,
		color = {1.0, 1.0, 1.0},
		planet = "nauvis",
		surface_condition = {{ property = "pressure", min = 1000, max = 1000 }}
	},
	metallurgic = {
		order = "b",
		craft_time_mult = 1,
		data_per_pack = 2,
		color = {1.0, 0.5, 0.2},
		planet = "vulcanus",
		surface_condition = {{ property = "pressure", min = 4000, max = 4000 }}
	},
	agricultural = {
		order = "c",
		craft_time_mult = 0.5,
		data_per_pack = 2,
		color = {0.7, 1.0, 0.2},
		planet = "gleba",
		surface_condition = {{ property = "pressure", min = 2000, max = 2000 }}
	},
	electromagnetic = {
		order = "d",
		craft_time_mult = 1,
		data_per_pack = 8,
		color = {0.8, 0.1, 0.8},
		planet = "fulgora",
		surface_condition = {{ property = "magnetic-field", min = 99 }}
	},
	cryogenic = {
		order = "e",
		craft_time_mult = 5,
		data_per_pack = 2,
		color = {0.3, 0.3, 1.0},
		planet = "aquilo",
		surface_condition = {{ property = "pressure", min = 100, max = 600 }}
	},
	promethium = {
		order = "f",
		craft_time_mult = 1,
		data_per_pack = 2,
		color = {0.2, 0.3, 0.4},
		planet = "shattered-planet",
		surface_condition = {{ property = "gravity", max = 0 }}
	}
}

utils.items = { -- Common item ingredient/results
	fluo_in = function(amnt) return { type = "fluid", name = "fluoroketone-cold", amount = amnt, ignored_by_stats = amnt } end,
	fluo_out = function(amnt) return { type = "fluid", name = "fluoroketone-hot", amount = amnt, ignored_by_stats = amnt } end,
	prom147 = function(amnt) return { type = "item", name = utils.prefix.."promethium-147", amount = amnt } end
}

utils.subgroup = { -- Groupings for things that need to follow vanilla
	data_pre = utils.prefix.."science-data-pre",
	data = utils.prefix.."science-data",
	pack_pre = utils.prefix.."science-pack-pre",
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
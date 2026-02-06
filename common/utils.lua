local utils = {}

utils.prefix = "nso-"

utils.science = {
	space = {
		order = "a",
		craft_time_mult = 1,
		data_per_pack = 2,
		color = {1.0, 1.0, 1.0},
		data = utils.prefix.."space-data",
		pack = "space-science-pack",
		planet = "nauvis",
		surface_condition = {{ property = "pressure", min = 1000, max = 1000 }}
	},
	metallurgic = {
		order = "b",
		craft_time_mult = 1.5, -- Due to foundry base speed
		data_per_pack = 2,
		color = {1.0, 0.5, 0.2},
		data = utils.prefix.."metallurgic-data",
		pack = "metallurgic-science-pack",
		planet = "vulcanus",
		surface_condition = {{ property = "pressure", min = 4000, max = 4000 }}
	},
	agricultural = {
		order = "c",
		craft_time_mult = 0.5,
		data_per_pack = 2,
		color = {0.7, 1.0, 0.2},
		data = utils.prefix.."agricultural-data",
		pack = "agricultural-science-pack",
		planet = "gleba",
		surface_condition = {{ property = "pressure", min = 2000, max = 2000 }}
	},
	electromagnetic = {
		order = "d",
		craft_time_mult = 1,
		data_per_pack = 20,
		color = {0.8, 0.1, 0.8},
		data = utils.prefix.."electromagnetic-data",
		pack = "electromagnetic-science-pack",
		planet = "fulgora",
		surface_condition = {{ property = "magnetic-field", min = 99 }}
	},
	cryogenic = {
		order = "e",
		craft_time_mult = 5,
		data_per_pack = 2,
		color = {0.3, 0.3, 1.0},
		data = utils.prefix.."cryogenic-data",
		pack = "cryogenic-science-pack",
		planet = "aquilo",
		surface_condition = {{ property = "pressure", min = 100, max = 600 }}
	},
	promethium = {
		order = "f",
		craft_time_mult = 1,
		data_per_pack = 2,
		color = {0.2, 0.3, 0.4},
		data = utils.prefix.."promethium-data",
		pack = "promethium-science-pack",
		planet = "shattered-planet",
		surface_condition = {{ property = "gravity", max = 0 }}
	},
	common = {
		weight = 50000, -- 20 per rocket
		max_productivity = 1.0 -- 100% productivity cap on science recipes
	}
}

utils.items = { -- Common item ingredient/results
	fluo_in = function(amnt) return { type = "fluid", name = "fluoroketone-cold", amount = amnt, ignored_by_stats = amnt } end,
	fluo_out = function(amnt) return { type = "fluid", name = "fluoroketone-hot", amount = amnt, ignored_by_stats = amnt } end,
	gel = utils.prefix.."science-gel",
	prom147 = utils.prefix.."promethium-147",
	hg_prom = utils.prefix.."hg-promethium-asteroid-chunk",
	basic_slurry = utils.prefix.."space-slurry",
	adv_slurry = utils.prefix.."adv-space-slurry",
	blank_data = utils.prefix.."blank-data",
	garbage_data = utils.prefix.."garbage-data"
}

utils.subgroup = { -- Groupings for things that need to follow vanilla
	data_pre = utils.prefix.."science-data-pre",
	gel = utils.prefix.."science-gel",
	data = utils.prefix.."science-data",
	pack_pre = utils.prefix.."science-pack-pre",
	pack = "science-pack",
	cycle = utils.prefix.."science-cycle",
	fluid = "fluid",
	fluid_order = "n[nauv]-" -- Useful, even if not a subgroup
}

function utils.recipe_tints(fluid_color)
	return { primary = fluid_color, secondary = fluid_color, tertiary = fluid_color, quaternary = fluid_color }
end

function utils.add_to_tech(tech, recipe)
	table.insert(data.raw.technology[tech].effects, { type = "unlock-recipe", recipe = recipe })
end

utils.removed_packs = {
	"automation-science-pack",
	"logistic-science-pack",
	"military-science-pack",
	"chemical-science-pack",
	"production-science-pack",
	"utility-science-pack"
}

utils.misc = {
	prod_cap_tt = { utils.prefix.."tooltip.prod-cap" },
	qual_base_tt = { utils.prefix.."tooltip.qual-base" },
	statpack_building = utils.prefix.."statpack-building",
	statpack_combat = utils.prefix.."statpack-combat",
}

return utils
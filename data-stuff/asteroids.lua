local utils = require("common.utils")

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
high_grade_chunk.order = high_grade_chunk.order .. "-2"
data:extend({high_grade_chunk})

-- Low grade promethium (Old item)
local low_grade_item = data.raw.item["promethium-asteroid-chunk"]
low_grade_item.spoil_ticks = 18000 -- 5 minutes
low_grade_item.spoil_result = "iron-ore"

-- Promethium powder (intermediate, uses asteroid productivity)
local prom_item = {
	type = "item", name = "promethium-147",
	subgroup = utils.subgroup.pack_pre,
	order = "z-a", -- Last in subgroup
	icons = {{
		icon = "__temp-mod__/graphics/items/prom-147.png", icon_size = 64,
		tint = {1.0, 0.5, 0.5}
	}},
	stack_size = 20,
	weight = 5000,
	spoil_ticks = 18000, -- Same as chunk, but no spoil result.
	default_import_location = "shattered-planet"
}
local prom_recipe = table.deepcopy(data.raw.recipe["metallic-asteroid-crushing"])
prom_recipe.name = prom_item.name
prom_recipe.energy_required = 3 -- Slightly longer
prom_recipe.ingredients[1].name = "promethium-asteroid-chunk"
prom_recipe.results = {
	{ type = "item", name = prom_item.name, amount = 10 }, -- ~12.5 per chunk, pre-prod
	{ type = "item", name = "promethium-asteroid-chunk", amount = 1, probability = 0.2 }
} -- Chunk output NOT ignored apparently, and also uses prod
prom_recipe.main_product = prom_item.name -- Deviation from other crushing recipies afaik
prom_recipe.subgroup = utils.subgroup.pack_pre
prom_recipe.order = "z-a" -- Last in subgroup
prom_recipe.icon = nil -- Clear the custom icon
prom_recipe.show_amount_in_title = false
data:extend({ prom_item, prom_recipe })
table.insert(data.raw.technology["asteroid-productivity"].effects, {
	type = "change-recipe-productivity", recipe = prom_recipe.name, change = 0.1
}) -- Noteably this is BEFORE the tech rework code, so just set 0.1 for now
utils.add_to_tech("space-science-pack", prom_item.name)

-- Add high grade to big asteroid chunks (4)
table.insert(data.raw.asteroid["big-promethium-asteroid"].dying_trigger_effect, {
	type = "create-asteroid-chunk",
	asteroid_name = "high-grade-promethium-asteroid-chunk",
	offset_deviation = {{-1, -1}, {1, 1}},
	offsets = {{-0.5, -0.25}, {0.5, -0.25}, {-0.5, 0.25}, {0.5, 0.25}}
})

-- Adjust med/small promethium asteroids to be weak to lasers (Lower need for extra turrets)
for _, asteroid in ipairs({
	"small-promethium-asteroid",
	"medium-promethium-asteroid"
}) do
	for _, resist in ipairs(data.raw.asteroid[asteroid].resistances) do
		if resist.type == "laser" then
			resist.percent = -100
		end
	end
end

-- Add medium promethium to space connections
local med_connections = {
	"nauvis-vulcanus",
	"nauvis-gleba",
	"nauvis-fulgora",
	"vulcanus-gleba",
	"gleba-fulgora",
	"gleba-aquilo",
	"fulgora-aquilo",
	"aquilo-solar-system-edge"
}
local base_prob = 0.003
local speed = 1/60 -- Default
for _, conn in ipairs(med_connections) do
	table.insert(data.raw["space-connection"][conn].asteroid_spawn_definitions, {
		type = "entity",
		asteroid = "medium-promethium-asteroid",
		spawn_points = {
			{ distance = 0.1, probability = 0, speed = speed, angle_when_stopped = 0.4 },
			{ distance = 0.2, probability = base_prob, speed = speed, angle_when_stopped = 0.4 },
			{ distance = 0.5, probability = base_prob * 1.5, speed = speed, angle_when_stopped = 0.4 },
			{ distance = 0.8, probability = base_prob, speed = speed, angle_when_stopped = 0.4 },
			{ distance = 0.9, probability = 0, speed = speed, angle_when_stopped = 0.4 }
		}
	})
end

-- Slightly more ice from oxide asteroids (Due to higher requirements for ice)
data.raw.recipe["oxide-asteroid-crushing"].results[1].amount = 8 -- From 5
data.raw.recipe["advanced-oxide-asteroid-crushing"].results[1].amount = 4 -- From 3
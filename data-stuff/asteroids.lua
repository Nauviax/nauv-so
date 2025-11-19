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
	icons = {{
		icon = "__temp-mod__/graphics/items/prom-147.png", icon_size = 64,
		tint = {1.0, 0.5, 0.5} -- !!! Should be matching red
	}},
	stack_size = 20,
	weight = 1000, -- !!! BALANCE (likely based on chunk weight, 10th of weight?)
	spoil_ticks = 18000, -- Same as chunk, but no spoil result.
	default_import_location = "shattered-planet"
	-- !!! WIP
}
local prom_recipe = table.deepcopy(data.raw.recipe["metallic-asteroid-crushing"])
prom_recipe.name = prom_item.name
prom_recipe.energy_required = 5 -- Same as advanced
prom_recipe.ingredients[1].name = "promethium-asteroid-chunk"
prom_recipe.results = {
	{ type = "item", name = prom_item.name, amount = 10 }, -- ~12.5 per chunk, pre-prod
	{ type = "item", name = "promethium-asteroid-chunk", amount = 1, probability = 0.2 }
} -- Chunk output NOT ignored apparently, and also uses prod.
prom_recipe.main_product = prom_item.name -- Deviation from other crushing recipies afaik (!!! Check?)
-- !!! UNSURE WHAT TO USE AS ICON, if any
prom_recipe.order = "p[promethium]" -- !!! COMPARE TO NEIGHBOUR RECIPIES, including factoriopedia
prom_recipe.icon = nil -- Clear the custom icon
data:extend({ prom_item, prom_recipe })
table.insert(data.raw.technology["asteroid-productivity"].effects, {
	type = "change-recipe-productivity", recipe = prom_recipe.name, change = 0.1
}) -- Noteably this is BEFORE the tech rework code, so just 0.1 for now. (!!! TEST THE PROD CHANGES AND 0.2a STUFF)
utils.add_to_tech("promethium-science-pack", prom_item.name)

-- Add high grade to big asteroid chunks
local spread = 1
table.insert(data.raw.asteroid["big-promethium-asteroid"].dying_trigger_effect, {
	type = "create-asteroid-chunk",
	asteroid_name = "high-grade-promethium-asteroid-chunk",
	offset_deviation = {{-spread, -spread}, {spread, spread}},
	offsets = {
		{-spread/2, -spread/4},
		{spread/2, -spread/4}
	}
})

-- Adjust med/small promethium asteroids to be weak to lasers (Lower need for extra turrets)
for _, asteroid in ipairs({
	"small-promethium-asteroid",
	"medium-promethium-asteroid"
}) do
	for _, resist in ipairs(data.raw.asteroid[asteroid].resistances) do
		if resist.type == "laser" then
			resist.percent = -100 -- !!! MAY need to look at power options in no-sun mod, as lasers may be hard in that !!!
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
local huge_connection = "solar-system-edge-shattered-planet" -- Adjust so large appear sooner?
local base_prob = 0.006 -- !!! BALANCE VALUES with whatever seems right (!!! TEST SCIENCE CHAINS IN GAME)
-- !!! May need to adjust promethium usage instead of spawn rate, as too many is lag and difficult to shoot down !!!
local speed = 1/60 -- Default
for _, conn in ipairs(med_connections) do
	table.insert(data.raw["space-connection"][conn].asteroid_spawn_definitions, {
		type = "entity",
		asteroid = "medium-promethium-asteroid",
		spawn_points = {
			{ distance = 0.1, probability = 0, speed = speed, angle_when_stopped = 0.4 },
			{ distance = 0.2, probability = base_prob, speed = speed, angle_when_stopped = 0.4 },
			{ distance = 0.5, probability = base_prob * 1.4, speed = speed, angle_when_stopped = 0.4 },
			{ distance = 0.8, probability = base_prob, speed = speed, angle_when_stopped = 0.4 },
			{ distance = 0.9, probability = 0, speed = speed, angle_when_stopped = 0.4 }
		}
	})
end

log(serpent.block(data.raw["space-connection"][huge_connection].asteroid_spawn_definitions[7])) -- Really just care about huge prom
-- It's a little low early perhaps, so maybe up this?
--     asteroid = "huge-oxide-asteroid",
--     spawn_points = {
--       {
--         angle_when_stopped = 0.4,
--         distance = 0.001,
--         probability = 0.0005,
--         speed = 0.016666666666666665
--       },
--       {
--         angle_when_stopped = 0.4,
--         distance = 0.002,
--         probability = 0.00054398797595190382,
--         speed = 0.016666666666666665
--       },
--       {
--         angle_when_stopped = 0.4,
--         distance = 0.2,
--         probability = 0.023134018036072144,
--         speed = 0.016666666666666665
--       },
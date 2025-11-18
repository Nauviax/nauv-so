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
			-- angle_when_stopped = 0.4, do I care?
			{ distance = 0.2, probability = base_prob, speed = speed, angle_when_stopped = 0.4 }, -- !!! Ensure none in orbits !!!
			{ distance = 0.5, probability = base_prob * 1.4, speed = speed, angle_when_stopped = 0.4 },
			{ distance = 0.8, probability = base_prob, speed = speed, angle_when_stopped = 0.4 }
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
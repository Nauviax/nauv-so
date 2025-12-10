-- Tech removals, adjustments, merges and additions
local utils = require("common.utils") -- Potentually underutilized here
local all_techs = data.raw.technology

-- ## Early tech removals, statpacks, misc adjustments ## --

-- Remove unused pack from techs
for science_level, pack_name in pairs(utils.removed_packs) do
	all_techs[pack_name] = nil
	for _, tech in pairs(all_techs) do
		-- Remove this pack from ingredients if it exists
		if tech.unit and tech.unit.ingredients then
			for index, ingredient in ipairs(tech.unit.ingredients) do
				if ingredient[1] == pack_name then
					table.remove(tech.unit.ingredients, index)
					-- If no ingredients left, add space-science-pack as default if tech was above blue
					if #tech.unit.ingredients == 0 and science_level > 4 then
						tech.unit.ingredients = {{utils.sciences.space.pack, 1}}
						table.insert(tech.prerequisites, utils.sciences.space.pack)
					end
					break
				end
			end
		end
	end
end

-- Unlock recipes then delete tech
local function unlock_and_delete(tech_name)
	local tech = all_techs[tech_name]
	if tech.effects then
		for _, effect in pairs(tech.effects) do
			if effect.type == "unlock-recipe" and data.raw.recipe[effect.recipe] then
				data.raw.recipe[effect.recipe].enabled = true
			end
		end
	end
	all_techs[tech_name] = nil
end

-- Remove all techs that now have no pack cost. Skip any that do more than unlock recipes
for tech_name, tech in pairs(all_techs) do
	if tech.unit and tech.unit.ingredients and #tech.unit.ingredients == 0 then
		-- If tech.effect consists of only effect.type == "unlock-recipe", then unlock and remove
		local only_unlocks = true
		if tech.effects then
			for _, effect in pairs(tech.effects) do
				if effect.type ~= "unlock-recipe" then
					only_unlocks = false
					break
				end
			end
		end
		if only_unlocks then
			unlock_and_delete(tech_name)
		end
	end
end

-- Remove specific trigger techs (leftover from above)
unlock_and_delete("electronics")
unlock_and_delete("steam-power")
unlock_and_delete("oil-processing")
unlock_and_delete("uranium-processing")

-- Merge space platform unlocks into rocket silo
local rocket_silo_tech = all_techs["rocket-silo"]
for _, effect in pairs(all_techs["space-platform"].effects) do
	table.insert(rocket_silo_tech.effects, effect)
end
all_techs["space-platform"] = nil

-- Statpacks contain all bonuses provided by tech being removed
local statpack_building_tech = {
	type = "technology", name = utils.misc.statpack_building,
	icon = "__base__/graphics/technology/toolbelt.png", icon_size = 256,
	effects = {},
	unit = { ingredients = {}, count = 1, time = 10 },
	order = "a-t1"
}
data:extend({statpack_building_tech})
local statpack_combat_tech = {
	type = "technology", name = utils.misc.statpack_combat,
	icon = "__base__/graphics/technology/stronger-explosives-3.png", icon_size = 256,
	effects = {},
	unit = { ingredients = {}, count = 1, time = 10 },
	order = "a-t2"
}
data:extend({statpack_combat_tech})

-- Delete the specified tech and add it's effects to a given statpack
local function merge_into_statpack(statpack, tech_name)
	local tech = all_techs[tech_name]
	if tech.effects then
		local effect_list = statpack.effects
		for _, effect in pairs(tech.effects) do
			if effect.type == "unlock-recipe" then
				data.raw.recipe[effect.recipe].enabled = true
			else
				-- If effect already exists, merge modifier values
				local found = false
				for _, existing_effect in pairs(effect_list) do
					if effect.modifier and existing_effect.type == effect.type then
						local key_match = true
						for key in pairs(existing_effect) do
							if key ~= "modifier" and existing_effect[key] ~= effect[key] then
								key_match = false
								break
							end
						end
						if key_match then -- Only merge if the only difference is the modifier (Or no differences)
							found = true
							existing_effect.modifier = existing_effect.modifier + effect.modifier
							break
						end
					end
				end
				if not found then
					table.insert(effect_list, effect)
				end
			end
		end
	end
	for _, other_tech in pairs(all_techs) do
		if other_tech.prerequisites then
			for index, prereq in ipairs(other_tech.prerequisites) do
				if prereq == tech_name then
					other_tech.prerequisites[index] = statpack.name
				end
			end
		end
	end
	all_techs[tech_name] = nil
end

-- Populate building statpack
merge_into_statpack(statpack_building_tech, "steel-axe")
merge_into_statpack(statpack_building_tech, "toolbelt")
merge_into_statpack(statpack_building_tech, "circuit-network")
merge_into_statpack(statpack_building_tech, "uranium-mining")
merge_into_statpack(statpack_building_tech, "construction-robotics")
merge_into_statpack(statpack_building_tech, "logistic-robotics")
merge_into_statpack(statpack_building_tech, "worker-robots-speed-1")
merge_into_statpack(statpack_building_tech, "worker-robots-speed-2")
merge_into_statpack(statpack_building_tech, "worker-robots-storage-1")
merge_into_statpack(statpack_building_tech, "bulk-inserter")
merge_into_statpack(statpack_building_tech, "inserter-capacity-bonus-1")
merge_into_statpack(statpack_building_tech, "inserter-capacity-bonus-2")
merge_into_statpack(statpack_building_tech, "inserter-capacity-bonus-3")
merge_into_statpack(statpack_building_tech, "quality-module")
-- Populate combat statpack
merge_into_statpack(statpack_combat_tech, "weapon-shooting-speed-1")
merge_into_statpack(statpack_combat_tech, "weapon-shooting-speed-2")
merge_into_statpack(statpack_combat_tech, "weapon-shooting-speed-3")
merge_into_statpack(statpack_combat_tech, "weapon-shooting-speed-4")
merge_into_statpack(statpack_combat_tech, "weapon-shooting-speed-5")
merge_into_statpack(statpack_combat_tech, "physical-projectile-damage-1")
merge_into_statpack(statpack_combat_tech, "physical-projectile-damage-2")
merge_into_statpack(statpack_combat_tech, "physical-projectile-damage-3")
merge_into_statpack(statpack_combat_tech, "physical-projectile-damage-4")
merge_into_statpack(statpack_combat_tech, "physical-projectile-damage-5")
merge_into_statpack(statpack_combat_tech, "stronger-explosives-1")
merge_into_statpack(statpack_combat_tech, "stronger-explosives-2")
merge_into_statpack(statpack_combat_tech, "stronger-explosives-3")
merge_into_statpack(statpack_combat_tech, "refined-flammables-1")
merge_into_statpack(statpack_combat_tech, "refined-flammables-2")
merge_into_statpack(statpack_combat_tech, "refined-flammables-3")
merge_into_statpack(statpack_combat_tech, "laser-shooting-speed-1")
merge_into_statpack(statpack_combat_tech, "laser-shooting-speed-2")
merge_into_statpack(statpack_combat_tech, "laser-shooting-speed-3")
merge_into_statpack(statpack_combat_tech, "laser-shooting-speed-4")
merge_into_statpack(statpack_combat_tech, "laser-weapons-damage-1")
merge_into_statpack(statpack_combat_tech, "laser-weapons-damage-2")
merge_into_statpack(statpack_combat_tech, "laser-weapons-damage-3")
merge_into_statpack(statpack_combat_tech, "laser-weapons-damage-4")
merge_into_statpack(statpack_combat_tech, "defender")
merge_into_statpack(statpack_combat_tech, "follower-robot-count-1")
merge_into_statpack(statpack_combat_tech, "follower-robot-count-2")
merge_into_statpack(statpack_combat_tech, "follower-robot-count-3")

-- Loop one more time to clean up dependencies on removed techs
for _, tech in pairs(all_techs) do
    if tech.prerequisites then
		local new_prereqs = {}
		for _, prereq in ipairs(tech.prerequisites) do
            if all_techs[prereq] then
				table.insert(new_prereqs, prereq)
            end
		end
		tech.prerequisites = new_prereqs
    end
end

-- Unlock all shortcuts (Some unlocks relied on removed techs)
for _, shortcut in pairs(data.raw.shortcut) do
	if all_techs[shortcut.technology_to_unlock] == nil then
		shortcut.technology_to_unlock = nil
	end
end

-- Remove achivements tied to removed tech (More achievements removed in item-removals)
data.raw["research-with-science-pack-achievement"]["research-with-automation"] = nil
data.raw["research-with-science-pack-achievement"]["research-with-logistics"] = nil
data.raw["research-with-science-pack-achievement"]["research-with-military"] = nil
data.raw["research-with-science-pack-achievement"]["research-with-chemicals"] = nil
data.raw["research-with-science-pack-achievement"]["research-with-production"] = nil
data.raw["research-with-science-pack-achievement"]["research-with-utility"] = nil
data.raw["dont-research-before-researching-achievement"]["rush-to-space"] = nil
data.raw["research-achievement"]["eco-unfriendly"] = nil


-- ## Remaining tech broad adjustments ## --

-- Adjust research speed, +1 and +2 at pre and post white science (Vanilla max is +2.5)
local space_pack_tech = all_techs[utils.sciences.space.pack]
table.insert(space_pack_tech.effects, { type = "laboratory-speed", modifier = 1.0 })
local lab_speed_tech = all_techs["research-speed-1"]
all_techs["research-speed-1"] = nil -- Remove old first
lab_speed_tech.name = "research-speed" -- Remove number
lab_speed_tech.effects = {{ type = "laboratory-speed", modifier = 2.0 }}
lab_speed_tech.prerequisites = {utils.sciences.space.pack}
lab_speed_tech.unit.ingredients = {{utils.sciences.space.pack, 1}}
lab_speed_tech.unit.count = 500 -- Will be 100 after the /5
lab_speed_tech.upgrade = false
data:extend({lab_speed_tech}) -- Add back modified
for level = 2, 6 do -- Remove rest of techs
	all_techs["research-speed-"..level] = nil
end

-- Go through all remaining techs, if not trigger tech then /5 pack cost (Round up) and *5 time
for _, tech in pairs(all_techs) do
    if tech.unit then
		tech.unit.time = tech.unit.time * 5 -- Affects all tech
		if tech.unit.count then
			-- Won't touch infinite techs, those are done later down.
			tech.unit.count = math.ceil(tech.unit.count / 5) -- Affects non-inf
        end
    else
		tech.order = "t-for-trigger" -- Move them out of the way of data-card techs
	end
end

-- Misc adjustments for now-early-game techs
space_pack_tech.prerequisites = nil
space_pack_tech.research_trigger = nil
space_pack_tech.unit = { ingredients = {}, count = 1000, time = 60 } -- Intentionally AFTER the /5 to cost
space_pack_tech.order = "a-t3"
all_techs["rocket-silo"].prerequisites = {utils.sciences.space.pack, "kovarex-enrichment-process"}
all_techs["space-platform-thruster"].prerequisites = {"rocket-silo"}

for index, tech_name in pairs({
	"kovarex-enrichment-process", -- Significantly cheaper
	"rocket-silo",
	"space-platform-thruster",
	"planet-discovery-vulcanus",
	"planet-discovery-gleba",
	"planet-discovery-fulgora"
}) do  -- Count and time is post x5 time adjustment
	local tech = all_techs[tech_name]
	tech.order = "a-t"..(index+3) -- Starting at 4
	tech.unit.ingredients = {{utils.sciences.space.data, 1}}
	tech.unit.count = index == 1 and 10 or 200
	tech.unit.time = 60
end

-- Modify normal lab to allow early data use, but not late science use
local lab = data.raw.lab.lab
for _, pack_name in ipairs({ -- Remove later packs
	utils.sciences.cryogenic.pack,
    utils.sciences.promethium.pack
}) do
  for index, input in ipairs(lab.inputs) do
    if input == pack_name then table.remove(lab.inputs, index); break end
  end
end
table.insert(lab.inputs, 1, utils.sciences.space.data)


-- ## Recipe productivity adjustments and caps ## --

local inf_prod_techs = {
    metallurgic = {
        "steel-plate-productivity", -- Technically white but bleh
        "low-density-structure-productivity"
    },
    electromagnetic = {
        "scrap-recycling-productivity", -- Half cost
        "processing-unit-productivity"
    },
    agricultural = {
        "plastic-bar-productivity",
        "rocket-fuel-productivity",
        "asteroid-productivity"
    },
    cryogenic = {
        "rocket-part-productivity" -- Double cost
    }
}
local tiers = { -- Single VGF packs are done manually
    {{ utils.sciences.space.pack, 1 }, { utils.sciences.metallurgic.pack, 1 }, { utils.sciences.electromagnetic.pack, 1 }, { utils.sciences.agricultural.pack, 1 }},
    {{ utils.sciences.space.pack, 1 }, { utils.sciences.metallurgic.pack, 1 }, { utils.sciences.electromagnetic.pack, 1 }, { utils.sciences.agricultural.pack, 1 }, { utils.sciences.cryogenic.pack, 1 }},
    {{ utils.sciences.space.pack, 1 }, { utils.sciences.metallurgic.pack, 1 }, { utils.sciences.electromagnetic.pack, 1 }, { utils.sciences.agricultural.pack, 1 }, { utils.sciences.cryogenic.pack, 1 }, { utils.sciences.promethium.pack, 1 }}
}

local prod_tech_costs = { 1, 2, 3, 5, 10 } -- 500*this
for type_name, type_techs in pairs(inf_prod_techs) do
    local first_pack_name = type_name.."-science-pack"
	local aquilo_tech = type_name == "cryogenic" -- Aquilo tier_level is different
    for _, tech_name in pairs(type_techs) do
		local count_modifier = tech_name == "scrap-recycling-productivity" and 0.5 or tech_name == "rocket-part-productivity" and 2 or 1
		local old_tech = all_techs[tech_name]
		all_techs[tech_name] = nil -- Remove old tech reference
		old_tech.unit.count_formula = nil
		old_tech.max_level = nil
		for _, effect in pairs(old_tech.effects) do
			effect.change = 0.2 -- 20% per tech
		end
		for level = 1, 5 do
			local tech = table.deepcopy(old_tech)
			tech.name = tech_name.."-"..level
			tech.unit.count = 500 * prod_tech_costs[level] * count_modifier
			local tier_level = aquilo_tech and ({2,2,3,3,3})[level] or (level-1) -- 'or' tiers are effectively {0,1,2,3,3}
			local tier = tiers[math.min(tier_level, 3)]
			if level > 1 then
        		tech.prerequisites = tier_level == 1 and { tier[2][1], tier[3][1], tier[4][1] } or { tier[#tier][1] } -- VGF, or latest
				table.insert(tech.prerequisites, tech_name.."-"..(level-1)) -- Previous tech
			end
			tech.unit.ingredients = tier_level == 0 and {{ utils.sciences.space.pack, 1 }, { first_pack_name, 1 }} or tier
			data:extend({tech})
		end
	end
end
-- Add Steel Prod prereq to metallurgic tech due to new pack
all_techs["steel-plate-productivity-1"].prerequisites = {utils.sciences.metallurgic.pack}


-- ## All other tech adjustments and replacements, infinite removals etc ## --

local packs = { -- Each second item references the previous 'tiers' table
	{ nil, nil }, -- Effectively, do not add packs
	{ utils.sciences.metallurgic.pack, nil },
	{ utils.sciences.electromagnetic.pack, nil },
	{ utils.sciences.agricultural.pack, nil },
	{ nil, 1 }, -- Will add all 3 VFG
	{ utils.sciences.cryogenic.pack, 2 },
	{ utils.sciences.promethium.pack, 3 }
}

-- Create a tech based on an old one
local function create_tech(old_tech, name, level, pack, amount, modifiers, dependency, skip_extend)
	local tech = table.deepcopy(old_tech)
	tech.name = level and name.."-"..level or name
	tech.unit.count = amount
	tech.unit.count_formula = nil
	tech.max_level = nil
	tech.upgrade = true
	-- Ingredients
	if pack[2] then
		tech.unit.ingredients = tiers[pack[2]]
	elseif pack[1] then
		table.insert(tech.unit.ingredients, {pack[1], 1})
	end
	-- Remove prereq for old_tech's removed previous tier
	for index, prereq in ipairs(tech.prerequisites) do
		if string.find(prereq, name, 1, true) then
			table.remove(tech.prerequisites, index)
			break
		end
	end
	-- Add new pack prereqs
	if pack[1] then
		table.insert(tech.prerequisites, pack[1])
	elseif pack[2] == 1 then
		table.insert(tech.prerequisites, utils.sciences.metallurgic.pack)
		table.insert(tech.prerequisites, utils.sciences.electromagnetic.pack)
		table.insert(tech.prerequisites, utils.sciences.agricultural.pack)
	end
	if level and level > 1 then
		table.insert(tech.prerequisites, name.."-"..(level-1))
	elseif dependency then
		table.insert(tech.prerequisites, dependency)
	end
	for index, effect in ipairs(tech.effects) do
		effect.modifier = modifiers[index]
	end
	if not skip_extend then
		data:extend({tech})
	end
	return tech
end

-- Delete remaining techs for given name starting at given level
local function cleanup_old(name, next_level)
	while true do
		local next_tech = all_techs[name.."-"..next_level]
		if next_tech then
			all_techs[name.."-"..next_level] = nil
			next_level = next_level + 1
		else
			return -- Done
		end
	end
end

-- Start adjusting techs
local tech_name
local old_tech
local spare_tech -- Used in edge cases

-- Damage and speed related
tech_name = "physical-projectile-damage"
old_tech = all_techs[tech_name.."-6"]
cleanup_old(tech_name, 6)
create_tech(old_tech, tech_name, 1, packs[1], 250, {0.4, 0.4, 0.8, 2.3})
create_tech(old_tech, tech_name, 2, packs[2], 1000, {0.4, 0.4, 0.8, 2.0})
tech_name = "weapon-shooting-speed"
old_tech = all_techs[tech_name.."-6"]
cleanup_old(tech_name, 6)
create_tech(old_tech, tech_name, nil, packs[1], 120, {0.4, 0.4, 1.5, 1.3})
tech_name = "laser-weapons-damage"
old_tech = all_techs[tech_name.."-5"]
cleanup_old(tech_name, 5)
create_tech(old_tech, tech_name, 1, packs[1], 250, {1.0})
create_tech(old_tech, tech_name, 2, packs[3], 1000, {1.5})
tech_name = "laser-shooting-speed"
old_tech = all_techs[tech_name.."-5"]
cleanup_old(tech_name, 5)
create_tech(old_tech, tech_name, 1, packs[1], 60, {0.6})
create_tech(old_tech, tech_name, 2, packs[3], 120, {0.7})
tech_name = "electric-weapons-damage"
old_tech = all_techs[tech_name.."-1"]
spare_tech = all_techs[tech_name.."-3"]
cleanup_old(tech_name, 1)
create_tech(old_tech, tech_name, 1, packs[1], 150, {0.7})
create_tech(spare_tech, tech_name, 2, packs[1], 1000, {2.0, 2.0, 1.3})
tech_name = "refined-flammables"
old_tech = all_techs[tech_name.."-4"]
cleanup_old(tech_name, 4)
create_tech(old_tech, tech_name, 1, packs[1], 150, {0.6, 0.6})
create_tech(old_tech, tech_name, 2, packs[4], 600, {0.8, 0.8})
tech_name = "stronger-explosives"
old_tech = all_techs[tech_name.."-4"]
cleanup_old(tech_name, 4)
create_tech(old_tech, tech_name, 1, packs[1], 200, {0.9, 0.4, 0.4}) -- Big in 9->6
create_tech(old_tech, tech_name, 2, packs[4], 800, {1.6, 0.6, 0.6}) -- Big in 6->3
tech_name = utils.prefix.."artillery-improvements" -- Artillery special case
old_tech = all_techs["artillery-shell-range-1"]
table.insert(old_tech.effects, all_techs["artillery-shell-damage-1"].effects[1])
table.insert(old_tech.effects, all_techs["artillery-shell-speed-1"].effects[1]) -- Bnest 1, Pnest 2
cleanup_old("artillery-shell-range", 1)
cleanup_old("artillery-shell-damage", 1)
cleanup_old("artillery-shell-speed", 1)
create_tech(old_tech, tech_name, 1, packs[1], 1000, {0.6, 0.5, 1.0})
create_tech(old_tech, tech_name, 2, packs[5], 4000, {0.9, 0.5, 2.0})
tech_name = "railgun-damage"
old_tech = all_techs[tech_name.."-1"]
table.insert(old_tech.effects, { type = "turret-attack", turret_id = "railgun-turret" })
cleanup_old(tech_name, 1)
create_tech(old_tech, tech_name, nil, packs[7], 2500, {0.6, 1.0}) -- Phuge in 1
tech_name = "railgun-shooting-speed"
old_tech = all_techs[tech_name.."-1"]
cleanup_old(tech_name, 1)
create_tech(old_tech, tech_name, 1, packs[6], 2000, {0.5})
create_tech(old_tech, tech_name, 2, packs[7], 8000, {0.5})

-- Other techs
tech_name = "health"
old_tech = all_techs[tech_name]
all_techs[tech_name] = nil -- No -1
create_tech(old_tech, tech_name, nil, packs[1], 500, {250})
tech_name = "worker-robots-storage"
old_tech = all_techs[tech_name.."-2"]
cleanup_old(tech_name, 2)
create_tech(old_tech, tech_name, 1, packs[1], 60, {1})
create_tech(old_tech, tech_name, 2, packs[3], 90, {1})
tech_name = "worker-robots-speed"
old_tech = all_techs[tech_name.."-3"]
cleanup_old(tech_name, 3)
create_tech(old_tech, tech_name, 1, packs[1], 50, {0.6})
create_tech(old_tech, tech_name, 2, packs[3], 100, {0.9})
create_tech(old_tech, tech_name, 3, packs[6], 400, {1.2})
create_tech(old_tech, tech_name, 4, packs[7], 1000, {1.45})
tech_name = "follower-robot-count"
old_tech = all_techs[tech_name.."-4"]
cleanup_old(tech_name, 4)
create_tech(old_tech, tech_name, 1, packs[1], 80, {30})
create_tech(old_tech, tech_name, 2, packs[3], 200, {90})
tech_name = "braking-force"
old_tech = all_techs[tech_name.."-3"]
cleanup_old(tech_name, 1)
create_tech(old_tech, tech_name, nil, packs[1], 300, {1.0})
tech_name = "inserter-capacity-bonus"
old_tech = all_techs[tech_name.."-7"]
cleanup_old(tech_name, 4)
create_tech(old_tech, tech_name, nil, packs[1], 300, {1, 7}, statpack_building_tech.name)
tech_name = "transport-belt-capacity"
old_tech = all_techs[tech_name.."-2"]
table.insert(old_tech.prerequisites, "stack-inserter") -- Copied -2, so this is missing
cleanup_old(tech_name, 1)
create_tech(old_tech, tech_name, nil, packs[5], 400, {2, 1})

-- Last one, mining prod
tech_name = "mining-productivity"
old_tech = all_techs[tech_name.."-3"]
cleanup_old(tech_name, 1)
create_tech(old_tech, tech_name, 1, packs[1], 200, {0.2}) -- S
create_tech(old_tech, tech_name, 2, packs[2], 500, {0.1}) -- V
spare_tech = create_tech(old_tech, tech_name, 2, packs[3], 500, {0.1}, nil, true) -- F
spare_tech.name = tech_name.."-3" -- Manually increment to put side-by-side
data:extend({spare_tech})
spare_tech = create_tech(old_tech, tech_name, 2, packs[4], 500, {0.1}, nil, true) -- G
spare_tech.name = tech_name.."-4"
data:extend({spare_tech})
spare_tech = create_tech(old_tech, tech_name, 5, packs[5], 500, {0.2}) -- VFG
table.insert(spare_tech.prerequisites, tech_name.."-2")
table.insert(spare_tech.prerequisites, tech_name.."-3")
spare_tech = create_tech(old_tech, tech_name, 6, packs[6], nil, {0.1}) -- A (Last+Inf)
spare_tech.unit.count_formula = "500 * (1.3 ^ (L - 6))" -- Scales harder than vanilla
spare_tech.max_level = "infinite"

-- Adjust research productivity formula
all_techs["research-productivity"].unit.count_formula = "200 * (1.3 ^ L)" -- Note the 1.2->1.3

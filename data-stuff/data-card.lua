local utils = require("common.utils") -- !!! This file could use a minor cleanup (Whitespace etc)

-- Params
local craft_time = 4

local item = table.deepcopy(data.raw.tool["automation-science-pack"])
item.name = "fresh-data"
item.icon = nil
item.icons = {{
	icon = "__temp-mod__/graphics/items/data.png", -- Just a darker version of pack (!!! Ass texture for this, ngl (!!! Color maybe? Or find free textures?))
	icon_size = 64,
	tint = {0.2, 0.2, 0.2}
}}
item.type = "item"
item.durability = nil
-- item.order -- !!! TODO, along w category tweaks to move to new subgroup????

local recipe = {
	type = "recipe", name = "fresh-data",
	category = "electronics",
	--subgroup = "!!!TODO", -- !!!
	--order = "!!!TODO",
	enabled = false,
	energy_required = craft_time, -- !!! Review balance
	ingredients = {
		{ type = "item", name = "steel-plate", amount = 1 },
		{ type = "item", name = "battery", amount = 1 },
		{ type = "item", name = "advanced-circuit", amount = 1 }
	},
	results = {{ type = "item", name = "fresh-data", amount = 1 }},
	allow_productivity = true,
	surface_conditions = nil
}

local garbage_item = table.deepcopy(item)
garbage_item.name = "garbage-data"
table.insert(garbage_item.icons, {
	icon = "__base__/graphics/icons/signal/signal-recycle.png",
	icon_size = 64, scale = 0.4, shift = {-6, 5}, floating = true
})
-- garbage_data_item.order -- !!! TODO

local garbage_recipe = table.deepcopy(recipe) -- Byproduct of data crafting
garbage_recipe.name = "garbage-data"
garbage_recipe.energy_required = craft_time * 4 -- Means 1s to recycle each
garbage_recipe.results = {{ type = "item", name = "garbage-data", amount = 2 }} -- Returns 1/8 not 1/4
garbage_recipe.hidden = true -- Don't show, ever

data:extend({ item, recipe, garbage_item, garbage_recipe })
utils.add_to_tech("space-science-pack", "fresh-data")

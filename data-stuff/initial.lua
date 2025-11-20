-- Update space science sprite
data.raw.tool["space-science-pack"].icon = "__temp-mod__/graphics/items/space-science-pack.png"
data.raw.recipe["space-science-pack"].icon = "__temp-mod__/graphics/items/space-science-pack.png"
data.raw.technology["space-science-pack"].icon = "__temp-mod__/graphics/techs/space-science-pack.png"

-- Duplicate items and recipies for specific packs to help balance (!!! TEMP)
local packs_to_dupe = {
	"production-science-pack",
	"utility-science-pack",
	"space-science-pack",
	"metallurgic-science-pack",
	"agricultural-science-pack",
	"electromagnetic-science-pack",
	"cryogenic-science-pack",
	"promethium-science-pack"
}
for _, pack_name in pairs(packs_to_dupe) do
	local item = table.deepcopy(data.raw.tool[pack_name])
	item.name = pack_name.."-OLD"
	data:extend({ item })

	local recipe = table.deepcopy(data.raw.recipe[pack_name])
	recipe.name = pack_name.."-OLD"
	recipe.enabled = true
	recipe.results[1].name = pack_name.."-OLD"
	recipe.main_product = pack_name.."-OLD"
	data:extend({ recipe })
end
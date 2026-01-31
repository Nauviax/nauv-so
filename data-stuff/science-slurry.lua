local utils = require("common.utils")

-- Params
local craft_time_base = 6 -- Adv x5
local basic_slurry_color = {0.5, 0.8, 0.8}
local adv_slurry_color = {0.3, 0.5, 0.8}
local order = "b-"

-- Slurry fluid definitions
local function slurry(name, icon, color, order_suffix)
    data:extend({{
        type = "fluid", name = name, icon = icon,
        default_temperature = 15, auto_barrel = false,
        base_color = color, flow_color = color,
        subgroup = utils.subgroup.fluid, order = utils.subgroup.fluid_order .. order .. order_suffix
    }})
end
slurry(utils.items.basic_slurry, "__nauv-so__/graphics/fluids/slurry.png", basic_slurry_color, "a")
slurry(utils.items.adv_slurry, "__nauv-so__/graphics/fluids/adv-slurry.png", adv_slurry_color, "b")

-- Slurry recipe definitions
local function slurry_recipe(name, category, order_suffix, tint, tech, craft_mult, ingredients, results)
	utils.add_to_tech(tech, name)
    data:extend({{
        type = "recipe", name = name, main_product = name, enabled = false,
        category = category, subgroup = utils.subgroup.pack_pre, order = order .. order_suffix,
        energy_required = craft_time_base * craft_mult, ingredients = ingredients, results = results,
        allow_productivity = true, maximum_productivity = utils.science.common.max_productivity,
        surface_conditions = utils.science.promethium.surface_condition, show_amount_in_title = false,
        always_show_products = true, crafting_machine_tint = utils.recipe_tints(tint),
		custom_tooltip_fields = {{ name = utils.misc.prod_cap_tt, value = (utils.science.common.max_productivity * 100).."%" }},
    }})
end
slurry_recipe(
    utils.items.basic_slurry, "chemistry-or-cryogenics", "a", basic_slurry_color, "space-science-pack", 1,
    {
        { type = "fluid", name = "thruster-fuel", amount = 150 },
        { type = "item", name = "steel-plate", amount = 1 },
        { type = "item", name = "iron-stick", amount = 5 },
        { type = "item", name = utils.items.prom147, amount = 2 }
    },
    {{ type = "fluid", name = utils.items.basic_slurry, amount = 50 }} -- 1/2 pack
)
slurry_recipe(
    utils.items.adv_slurry, "cryogenics", "b", adv_slurry_color, "cryogenic-science-pack", 5,
    {
        { type = "fluid", name = utils.items.basic_slurry, amount = 100 },
        { type = "fluid", name = "steam", amount = 1000, minimum_temperature = 500 },
        { type = "item", name = "slowdown-capsule", amount = 1 },
        { type = "item", name = utils.items.prom147, amount = 4 },
        utils.items.fluo_in(6)
    },
    {
        { type = "fluid", name = utils.items.adv_slurry, amount = 50 }, -- 1/2 pack
        utils.items.fluo_out(3)
    }
)
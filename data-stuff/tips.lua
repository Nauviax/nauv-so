local utils = require("common.utils")

local order = "1-"
local category = utils.prefix.."tips"
data:extend({{
    type = "tips-and-tricks-item-category",
    name = category,
    order = order.."0"
}})
data.raw["tips-and-tricks-item"] = {} -- Delete all existing tips (Most are broken)
local newTips = {
    { "title" },
    { "data" },
    { "packs" },
    { "tech" }, -- !!! Menton artillery merge as well as caps
    { "removals" } -- !!! Also mention tips, achivements, remaining entity buffs
}
for index, tipProps in ipairs(newTips) do
    data:extend({{
        type = "tips-and-tricks-item",
        name = utils.prefix..tipProps[1],
        category = category,
        order = order..index,
        is_title = index == 1,
        indent = index == 1 and 0 or 1,
        starting_status = "suggested"
        -- !!! icon(s) (Also 'image' available)
    }})
end
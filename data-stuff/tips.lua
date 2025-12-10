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
    { "title", "[item=science]" },
    { "data",  "[item="..utils.sciences.space.data.."]" },
    { "packs", "[item="..utils.sciences.space.pack.."]" },
    { "tech", "[item=lab]" },
    { "removals", "[virtual-signal=signal-trash-bin]" }
}
for index, tipProps in ipairs(newTips) do
    data:extend({{
        type = "tips-and-tricks-item",
        name = utils.prefix..tipProps[1],
        category = category,
        order = order..index,
        tag = tipProps[2],
        is_title = index == 1,
        indent = index == 1 and 0 or 1,
        starting_status = "suggested"
    }})
end
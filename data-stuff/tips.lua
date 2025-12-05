local utils = require("common.utils")

for index, name in ipairs({
    "test-category-1",
    "test-category-2"
}) do -- !!! May need to watch out for duplicates
    local category = {
        type = "tips-and-tricks-item-category",
        name = utils.prefix..name,
        order = index
    }
    data:extend(category)
end

data.raw["tips-and-tricks-item"] = {} -- Delete all existing tips (Most are broken)
local newTips = {
    { "test-category-1", "test-tip" },
    { "test-category-1", "test-subtip-1" },
    { "test-category-2", "test-tip-2" },
    { "test-category-2", "test-subtip-2" }
}
for index, tipProps in ipairs(newTips) do
    local previous = newTips[index-1] or {}
    local tip = {
        type = "tips-and-tricks-item",
        name = utils.prefix..tipProps[2],
        category = utils.prefix..tipProps[1],
        order = index,
        is_title = previous[1] ~= tipProps[1], -- First in category
        starting_status = "suggested" -- !!! Other options are "unlocked" or "completed" to try
        -- !!! icon(s) (Also 'image' available)
    }
    data:extend(tip)
end
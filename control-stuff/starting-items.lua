-- Set starting items for players
script.on_init(function()
    if remote.interfaces["freeplay"] then
        local items = remote.call("freeplay", "get_created_items")
        items["wood"] = nil
        items["burner-mining-drill"] = nil
        items["stone-furnace"] = nil
        items["coal"] = 100
        items["iron-plate"] = 300
        items["copper-plate"] = 100
        items["iron-gear-wheel"] = 50
        items["steel-plate"] = 50
        items["stone-brick"] = 50
        items["electronic-circuit"] = 50
        remote.call("freeplay", "set_created_items", items)
	end
end)
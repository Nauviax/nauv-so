script.on_init(function()
    -- Set starting items for new players
    script.on_event(defines.events.on_player_created, function(event)
        local player = game.players[event.player_index]
        for _, item in pairs({
            {"coal", 200},
            {"iron-plate", 300},
            {"copper-plate", 100},
            {"iron-gear-wheel", 50},
            {"steel-plate", 50},
            {"stone-brick", 50},
            {"electronic-circuit", 50}
        }) do
            player.insert({ name = item[1], count = item[2] })
        end
    end)
end)
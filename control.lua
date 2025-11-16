script.on_init(function()
	-- Some starting material for first player in game
	for _, item in pairs({
		{"coal", 200},
		{"iron-plate", 300},
		{"copper-plate", 100},
		{"iron-gear-wheel", 50},
		{"steel-plate", 50},
		{"stone-brick", 50},
		{"electronic-circuit", 50}
	}) do
		game.players[1].insert({ name = item[1], count = item[2] })
	end
end)
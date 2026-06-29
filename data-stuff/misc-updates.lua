-- Fix spoilage recycling recipe from data stage, which seems to be using gel as reference.
data.raw["recipe"]["spoilage-recycling"].energy_required = 0.03125
data.raw["recipe"]["spoilage-recycling"].results = {
	{ type = "item", name = "spoilage", amount = 0, extra_count_fraction = 0.25, ignored_by_stats = 1 },
}
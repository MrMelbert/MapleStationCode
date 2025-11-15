/datum/techweb_node/mana_base
	id = "mana_base"
	starting_node = TRUE
	display_name = "Early Magical Tech"
	description = "The first bits of technology surronding magic."
	design_ids = list(
		"mana_lens",
		"techie_magic_wand",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)

/datum/techweb_node/artificial_volite
	id = "artificial_volite"
	starting_node = TRUE
	display_name = "Artificial Volite Synthesis"
	description = "Produce volite gemstones through an admittedly inefficient process."
	prereq_ids = list(TECHWEB_NODE_BLUESPACE_THEORY, "mana_base")
	design_ids = list(
		"artificial_volite_large",
		"artificial_volite_small",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)

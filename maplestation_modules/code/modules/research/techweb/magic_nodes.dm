/datum/techweb_node/mana_base_node
	id = TECHWEB_NODE_MANA_BASE
	display_name = "Early Magical Tech"
	description = "The first bits of technology surronding magic."
	prereq_ids = list(TECHWEB_NODE_FUNDIMENTAL_SCI)
	design_ids = list(
		"mana_lens",
		"techie_magic_wand",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/artificial_volite
	id = TECHWEB_NODE_ARTIFICIAL_VOLITE
	display_name = "Artificial Volite Synthesis"
	description = "Produce volite gemstones through an admittedly inefficient process."
	prereq_ids = list(TECHWEB_NODE_MANA_BASE, TECHWEB_NODE_BLUESPACE_THEORY)
	design_ids = list(
		"artificial_volite_large",
		"artificial_volite_small",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)

/datum/techweb_node/stellar_oculory
	id = TECHWEB_NODE_STELLAR_OCULORY
	display_name = "Starlight-Mana Conversion"
	description = "Convert trace arcane essence from nearby starlight into usable mana."
	prereq_ids = list(TECHWEB_NODE_MANA_BASE, TECHWEB_NODE_PARTS_ADV)
	design_ids = list(
		"stellar_oculory",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)

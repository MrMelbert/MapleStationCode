
////  Code to modularly edit techweb nodes in multiple ways without needing to completely overwrite said node.

/datum/techweb_node
	/// Additions to the ids that are unlocked from a node
	var/id_additions = list()
	/// Removals to the ids that are unlocked from a node
	var/id_removals = list()
	/// Additions to ids that are required to have been researched in order to research a node
	var/prereq_id_add = list()
	/// Removals to ids that are required to have been researched in order to research a node
	var/prereq_id_del = list()
	/// Additional experiments that can be done to reduce research costs
	var/discounts_add = list()
	/// Additional experiments that are required in order to complete a node
	var/experiment_add = list()


/datum/techweb_node/New()
	. = ..()
	design_ids += id_additions
	design_ids -= id_removals
	prereq_ids += prereq_id_add
	prereq_ids -= prereq_id_del
	discount_experiments += discounts_add
	required_experiments += experiment_add


////  Code to modularly edit techweb nodes in multiple ways without needing to completely overwrite said node.

/datum/techweb_node
	/// Additions to the ids that are unlocked from a node
	var/list/id_additions
	/// Removals to the ids that are unlocked from a node
	var/list/id_removals
	/// Additions to ids that are required to have been researched in order to research a node
	var/list/prereq_id_add
	/// Removals to ids that are required to have been researched in order to research a node
	var/list/prereq_id_del
	/// Additional experiments that can be done to reduce research costs
	var/list/discounts_add
	/// Additional experiments that are required in order to complete a node
	var/list/experiment_add


/datum/techweb_node/New()
	. = ..()
	if(LAZYLEN(id_additions))
		design_ids += id_additions
	if(LAZYLEN(id_removals))
		design_ids -= id_removals
	if(LAZYLEN(prereq_id_add))
		prereq_ids += prereq_id_add
	if(LAZYLEN(prereq_id_del))
		prereq_ids -= prereq_id_del
	if(LAZYLEN(discounts_add))
		discount_experiments += discounts_add
	if(LAZYLEN(experiment_add))
		required_experiments += experiment_add

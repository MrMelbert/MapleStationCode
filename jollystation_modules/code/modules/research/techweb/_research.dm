/*
	Code to take a list of IDs and add them to existing tech nodes, instead of completely overwriting nodes.
	Simply input a specific techweb_node and make a list of design ID's in the module_design list.
*/

/datum/techweb_node
	var/module_designs = list()

/datum/techweb_node/New()
	. = ..()
	design_ids += module_designs

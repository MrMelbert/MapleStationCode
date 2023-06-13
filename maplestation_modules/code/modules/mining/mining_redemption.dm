///Adds back in upgrades to the Ore Redemption Machine.
/obj/machinery/mineral/ore_redemption/RefreshParts()
	. = ..()
	var/point_upgrade_temp = 1
	var/ore_multiplier_temp = 1
	for(var/datum/stock_part/matter_bin/bin in component_parts)
		ore_multiplier_temp = 0.65 + (0.35 * bin.rating)
	for(var/datum/stock_part/micro_laser/laser in component_parts)
		point_upgrade_temp = 0.65 + (0.35 * laser.rating)
	point_upgrade = round(point_upgrade_temp, 0.01)
	ore_multiplier = round(ore_multiplier_temp, 0.01)

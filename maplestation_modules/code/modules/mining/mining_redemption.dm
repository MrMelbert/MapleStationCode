///Adds back in upgrades to the Ore Redemption Machine.
/obj/machinery/mineral/ore_redemption/RefreshParts()
	var/point_upgrade_temp = 1
	var/ore_multiplier_temp = 1
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		ore_multiplier_temp = 0.65 + (0.35 * B.rating)
	for(var/obj/item/stock_parts/micro_laser/L in component_parts)
		point_upgrade_temp = 0.65 + (0.35 * L.rating)
	point_upgrade = point_upgrade_temp
	ore_multiplier = round(ore_multiplier_temp, 0.01)

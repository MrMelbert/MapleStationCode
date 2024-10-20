/obj/item/mod/module/storage
	max_combined_w_class = 17
	max_items = 17

/obj/item/mod/module/storage/large_capacity
	max_combined_w_class = 21

/obj/item/mod/module
	/// Clothing slots on which this part is mounted. Module does not work or show up if its not deployed
	var/mount_part = list()

/obj/item/mod/module/proc/module_deployed()
	if (isnull(mod) || isnull(mod.wearer))
		return FALSE
		
	if (!mount_part)
		return TRUE
	
	for (var/slot_flag in mount_part)
		var/obj/item/worn_item = mod.wearer.get_item_by_slot(slot_flag)
		if (mod.boots != worn_item && mod.gauntlets != worn_item && mod.chestplate != worn_item && mod.helmet != worn_item)
			return FALSE
	return TRUE
		
/obj/item/mod/module/add_module_overlay(obj/item/source, list/overlays, mutable_appearance/standing, isinhands, icon_file)
	if (module_deployed())
		overlays += generate_worn_overlay(standing)

/obj/item/mod/module/anomaly_locked/kinesis
	mount_part = list(ITEM_SLOT_GLOVES)

/obj/item/mod/module/visor
	mount_part = list(ITEM_SLOT_HEAD)

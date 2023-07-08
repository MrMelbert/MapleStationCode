// Spawn an autopsy scanner in robotics and the morgue

/obj/item/mmi/Initialize(mapload)
	. = ..()
	var/static/robotics_scanner_spawned = FALSE
	if(mapload && !robotics_scanner_spawned && istype(get_area(src), /area/station/science/robotics))
		new /obj/item/autopsy_scanner(loc)
		robotics_scanner_spawned = TRUE

/obj/item/storage/backpack/duffelbag/med/surgery/PopulateContents()
	. = ..()
	if(istype(get_area(src), /area/station/medical/morgue)) // Can't check for roundstart due to PopulateContents, but this would only really affect admin spawns anyway
		new /obj/item/autopsy_scanner(src)

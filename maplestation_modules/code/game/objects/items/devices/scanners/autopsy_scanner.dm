// Spawn an autopsy scanner in robotics and the morgue

/obj/item/mmi/Initialize(mapload)
	. = ..()
	var/static/robotics_scanner_spawned = FALSE
	if(mapload && !robotics_scanner_spawned && istype(get_area(src), /area/station/science/robotics))
		new /obj/item/autopsy_scanner(loc)
		robotics_scanner_spawned = TRUE

/obj/item/surgery_tray/full/morgue/populate_contents()
	. = ..()
	new /obj/item/autopsy_scanner(src)

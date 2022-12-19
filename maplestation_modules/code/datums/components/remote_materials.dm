//Modular file to override remote_materials.dm

//Overrides the z-level check. This is used to unlink anything that moves between z-levels normally
/datum/component/remote_materials/check_z_level(datum/source, turf/old_turf, turf/new_turf)
	return

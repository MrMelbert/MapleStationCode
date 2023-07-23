PROCESSING_SUBSYSTEM_DEF(magic)
	name = "Magic"
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING

	wait = MAGIC_SUBSYSTEM_FIRE_RATE
	priority = FIRE_PRIORITY_MAGIC

/datum/controller/subsystem/processing/magic/Initialize()
	. = ..()

	generate_initial_leylines()

	return SS_INIT_SUCCESS

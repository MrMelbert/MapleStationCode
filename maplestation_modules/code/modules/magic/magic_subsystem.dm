PROCESSING_SUBSYSTEM_DEF(magic)
	name = "Magic"
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING

	wait = MAGIC_SUBSYSTEM_FIRE_RATE
	priority = FIRE_PRIORITY_MAGIC

	/// The intrinsic, underlying lines of transient magic in the universe.
	/// Only a list for future changes. V1 will not have deep leyline simulation, only global variables
	var/list/datum/leyline/leylines = list()

/datum/controller/subsystem/processing/magic/Initialize()
	. = ..()

	var/amount_of_leylines = get_leyline_amount()
	while (amount_of_leylines-- > 0)
		new /datum/leyline()

	return SS_INIT_SUCCESS

/// This proc only exists for if we decide to make leylines better simulated.
/datum/controller/subsystem/processing/magic/proc/get_leyline_amount()
	return 1 //CHANGE THIS IN OTEHR VERSIONS TO BE BETTER

/datum/controller/subsystem/processing/magic/proc/start_processing_leyline(datum/leyline/leyline_to_process)
	if (!istype(leyline_to_process))
		CRASH("[leyline_to_process], type of [leyline_to_process?.type] used as arg in start_processing_leyline!")
	START_PROCESSING(src, leyline_to_process)
	leylines += leyline_to_process

/datum/controller/subsystem/processing/magic/proc/stop_processing_leyline(datum/leyline/leyline_to_process)
	if (!istype(leyline_to_process))
		CRASH("[leyline_to_process], type of [leyline_to_process?.type] used as arg in stop_processing_leyline!")
	STOP_PROCESSING(src, leyline_to_process)
	leylines -= leyline_to_process

/datum/controller/subsystem/processing/magic/proc/get_available_mana()
	var/mana = 0
	for (var/datum/leyline/processing_leyline as anything in leylines)
		mana += processing_leyline.get_stored_mana()

	return mana

/datum/controller/subsystem/processing/magic/proc/adjust_stored_mana(amount)
	var/amount_per_leyline = (amount/leylines.len)

	for (var/datum/leyline/processing_leyline as anything in leylines)
		processing_leyline.adjust_stored_mana(amount_per_leyline) // Doesnt work for multiple leylines

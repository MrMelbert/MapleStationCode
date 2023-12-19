#define LINK_RANGE 2
#define SCAN_EFFECT_DURATION 1 SECONDS

/datum/design/board/vital_floor_scanner
	name = "Vitals Scanning Pad"
	desc = "The circuit board for a vitals scanning pad."
	id = "scanning_pad"
	build_path = /obj/item/circuitboard/machine/vital_floor_scanner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/circuitboard/machine/vital_floor_scanner
	name = "\improper Vitals Scanning Pad"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/vital_floor_scanner
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/datum/stock_part/scanning_module = 1,
	)

/obj/machinery/vital_floor_scanner
	name = "vitals scanning pad"
	desc = "A pad that scans the vitals of anyone who steps on it and displays the results on nearby vitals monitors."
	icon = 'maplestation_modules/icons/obj/floor_scan.dmi'
	icon_state = "scanner"
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	density = FALSE
	obj_flags = CAN_BE_HIT|BLOCKS_CONSTRUCTION
	circuit = /obj/item/circuitboard/machine/vital_floor_scanner
	/// Cooldown between successful "scans"
	COOLDOWN_DECLARE(scan_cooldown)

/obj/machinery/vital_floor_scanner/Destroy()
	set_occupant(null)
	return ..()

/obj/machinery/vital_floor_scanner/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON = PROC_REF(on_entered),
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_exited),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/vital_floor_scanner/proc/on_entered(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER
	if(!is_operational)
		return
	if(!isnull(occupant))
		return
	if(!COOLDOWN_FINISHED(src, scan_cooldown))
		return
	if(!isliving(arrived) || !can_scan(arrived))
		return

	COOLDOWN_START(src, scan_cooldown, 5 SECONDS)
	set_occupant(arrived)

/obj/machinery/vital_floor_scanner/proc/on_exited(datum/source, atom/movable/departed)
	SIGNAL_HANDLER
	if(occupant != departed)
		return
	set_occupant(null)

/obj/machinery/vital_floor_scanner/proc/enable_vitals_nearby()
	if(!is_operational || QDELETED(occupant))
		return

	for(var/obj/machinery/computer/vitals_reader/reader in range(LINK_RANGE, src))
		if(!reader.is_operational)
			continue

		if(!reader.active)
			reader.toggle_active()
			return

		if(isnull(reader.patient))
			reader.set_patient(occupant)
			return

/obj/machinery/vital_floor_scanner/proc/disable_vitals_nearby()
	for(var/obj/machinery/computer/vitals_reader/reader in range(LINK_RANGE, src))
		if(reader.active && isnull(reader.patient))
			reader.toggle_active()
			return

/obj/machinery/vital_floor_scanner/proc/can_scan(mob/living/who)
	if(!(who.mob_biotypes & MOB_ORGANIC))
		return FALSE
	if(who.body_position != STANDING_UP)
		return FALSE
	return TRUE

/obj/machinery/vital_floor_scanner/on_set_is_operational(old_value)
	if(!is_operational)
		set_occupant(null)
		return

	for(var/mob/living/new_mob in loc)
		if(!can_scan(new_mob))
			continue
		set_occupant(new_mob)
		return

/obj/machinery/vital_floor_scanner/set_occupant(atom/movable/new_occupant)
	var/mob/living/old_occupant = occupant
	. = ..()
	if(QDELING(src))
		return
	if(!isnull(occupant))
		addtimer(CALLBACK(src, PROC_REF(enable_vitals_nearby)), SCAN_EFFECT_DURATION, TIMER_UNIQUE)
		scan_effect()

	else if(!isnull(old_occupant))
		addtimer(CALLBACK(src, PROC_REF(disable_vitals_nearby)), 1 SECONDS, TIMER_UNIQUE)

/obj/machinery/vital_floor_scanner/proc/scan_effect()
	var/image/scan_effect = image(
		icon = 'maplestation_modules/icons/obj/floor_scan.dmi',
		loc = occupant,
		icon_state = "scan_effect",
		layer = ABOVE_ALL_MOB_LAYER,
	)
	scan_effect.alpha = 200
	animate(scan_effect, alpha = 100, time = SCAN_EFFECT_DURATION * 0.25)
	animate(scan_effect, alpha = 200, time = SCAN_EFFECT_DURATION * 0.25, loop = -1)
	SET_PLANE_EXPLICIT(scan_effect, occupant.plane, occupant)
	occupant.flick_overlay_view(scan_effect, SCAN_EFFECT_DURATION)

#undef LINK_RANGE
#undef SCAN_EFFECT_DURATION

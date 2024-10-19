/obj/item/guest_pass
	name = "holographic guest pass"
	desc = "A small hard-light slip which you can attach to your ID card to gain temporary access to a department."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "corppaperslip_words"
	inhand_icon_state = "silver_id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	drop_sound = 'sound/items/handling/disk_drop.ogg'
	pickup_sound = 'sound/items/handling/disk_pickup.ogg'
	throwforce = 0
	force = 0
	w_class = WEIGHT_CLASS_TINY
	vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_ID
	verb_say = "buzzes"
	var/list/granted_access
	var/list/existing_access
	var/expire_time

/obj/item/guest_pass/Initialize(mapload, list/new_access = list())
	. = ..()
	transform = transform.Turn(225)
	makeHologram(0.9)
	granted_access = new_access.Copy()
	existing_access = list()

/obj/item/guest_pass/proc/start_expire_timer(duration)
	expire_time = addtimer(CALLBACK(src, PROC_REF(expire)), duration, TIMER_DELETE_ME|TIMER_STOPPABLE)

/obj/item/guest_pass/proc/expire()
	if(istype(loc, /obj/item/card/id))
		var/mob/living/user = get(src, /mob/living)
		if(user)
			to_chat(user, span_notice("[src] fades away."))
		moveToNullspace()
	else
		visible_message(span_notice("[src] fades away."))
	animate(src, alpha = 0, time = 4 SECONDS)
	QDEL_IN(src, 4 SECONDS)

/obj/item/guest_pass/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(istype(old_loc, /obj/item/card/id))
		var/obj/item/card/id/id = old_loc
		id.access -= (granted_access - existing_access)
		REMOVE_KEEP_TOGETHER(id, REF(src))

/obj/item/guest_pass/interact_with_atom(atom/interacting_with, mob/living/user)
	if(!istype(interacting_with, /obj/item/card/id))
		return NONE

	var/obj/item/card/id/id = interacting_with
	var/num_passes = 0
	for(var/obj/item/guest_pass/pass in id)
		num_passes++
	if(num_passes >= 2)
		to_chat(user, span_warning("[src] flashes red: You can only have 2 guest passes on an ID card at a time."))
		var/curr_color = color
		animate(src, color = COLOR_RED, time = 0.2 SECONDS, easing = CUBIC_EASING|EASE_OUT)
		animate(color = curr_color, time = 0.4 SECONDS, easing = CUBIC_EASING|EASE_IN)
		return ITEM_INTERACT_BLOCKING

	if(!user.transferItemToLoc(src, interacting_with))
		return ITEM_INTERACT_BLOCKING

	layer = id.layer + 0.1
	pixel_x = 7
	RegisterSignal(id, COMSIG_ATOM_EXAMINE, PROC_REF(id_examined))

	existing_access = id.access & granted_access
	id.access |= granted_access
	id.vis_contents += src
	ADD_KEEP_TOGETHER(id, REF(src))

	to_chat(user, span_notice("You attach [src] to your [id.name]."))
	return ITEM_INTERACT_SUCCESS

/obj/item/guest_pass/proc/id_examined(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/list/grant_readable = list()
	for(var/access in granted_access)
		grant_readable += SSid_access.get_access_desc(access)

	examine_list += span_notice("It has \a [src] attached, granting access to [english_list(grant_readable)].")
	examine_list += span_green("This access will expire in [DisplayTimeText(timeleft(expire_time), 1)].")

/obj/item/guest_pass/examine(mob/user)
	. = ..()
	var/list/grant_readable = list()
	for(var/access in granted_access)
		grant_readable += SSid_access.get_access_desc(access)
	. += span_notice("Grants any attached ID card access to [english_list(grant_readable)].")
	. += span_green("It will expire in [DisplayTimeText(timeleft(expire_time), 1)].")

/obj/machinery/guest_pass
	name = "guest pass kiosk"
	desc = "A kiosk allowing members of a department to grant access to their department temporarily."
	icon = 'maplestation_modules/icons/obj/machines/bureaucracy.dmi'
	icon_state = "guest_pass_machine_off"
	base_icon_state = "guest_pass_machine"
	anchored = TRUE
	density = FALSE
	layer = HIGH_OBJ_LAYER
	verb_say = "beeps"

	/// Duration of any printed guest passes
	var/set_time = 10 // minutes
	/// Longest duration a guest pass can be set to
	var/max_time = 20 // minutes
	/// Shortest duration a guest pass can be set to
	var/min_time = 2.5 // minutes
	/// Used in init to format the name
	var/dept_name = "some"

	/// Maximum amount of accesses that can be given on one pass
	var/max_given_accesses = 6
	/// List of accesses the user has selected to give
	VAR_PRIVATE/list/given_access = list()
	/// List of all possible accesses that can be given
	var/list/all_possible_given_access = list()

	/// Name of the person who swiped their ID last
	VAR_PRIVATE/swiped_id_name
	/// Job of the person who swiped their ID last
	VAR_PRIVATE/swiped_id_job
	/// Accesses of the person who swiped their ID last
	VAR_PRIVATE/list/swiped_id_access

	/// History of all passes printed
	VAR_PRIVATE/list/pass_history

/obj/machinery/guest_pass/Initialize(mapload)
	. = ..()
	name = "[dept_name] [name]"
	update_appearance()

/obj/machinery/guest_pass/update_icon_state()
	. = ..()
	icon_state = base_icon_state
	if(!is_operational)
		icon_state += "_off"

/obj/machinery/guest_pass/update_overlays()
	. = ..()
	if(is_operational)
		. += emissive_appearance(icon, "[base_icon_state]_emissive", src, alpha = src.alpha)

/obj/machinery/guest_pass/on_set_is_operational()
	. = ..()
	update_icon_state()

/obj/machinery/guest_pass/item_interaction(mob/living/user, obj/item/tool, list/modifiers, is_right_clicking)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return
	if(!istype(tool, /obj/item/card/id))
		return

	swipe_id(tool, user)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/guest_pass/proc/swipe_id(obj/item/card/id/id, mob/living/user)
	swiped_id_name = id.registered_name
	swiped_id_job = id.assignment
	swiped_id_access = id.access.Copy()
	for(var/obj/item/guest_pass/pass in id)
		swiped_id_access -= (pass.granted_access - pass.existing_access)

	playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
	user?.visible_message(
		span_notice("[user] swipes [user.p_their()] [id.name] through [src]."),
		span_notice("You swipe your [id.name] through [src]."),
	)

/obj/machinery/guest_pass/proc/print_guest_pass(mob/living/printer)
	if(!length(swiped_id_access))
		say("Please swipe ID.")
		return FALSE
	if(!length(given_access))
		say("No access selected.")
		return FALSE
	if(length(given_access & swiped_id_access) != length(given_access))
		say("ID does not have all required access.")
		return FALSE

	var/obj/item/guest_pass/pass = new(drop_location(), given_access)
	pass.start_expire_timer(set_time * 1 MINUTES)
	printer.put_in_hands(pass)

	LAZYADD(pass_history, list(list(
		"granter" = swiped_id_name,
		"granter_job" = swiped_id_job,
		"granted" = given_access.Copy(),
		"duration" = set_time,
		"station_time" = station_time_timestamp(),
		"shift_time" = gameTimestamp(),
	)))

	swiped_id_name = null
	swiped_id_job = null
	swiped_id_access = null
	given_access.Cut()

	return TRUE

/obj/machinery/guest_pass/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	playsound(src, SFX_SPARKS, 50, FALSE, SILENCED_SOUND_EXTRARANGE)
	pass_history = null
	if(user)
		balloon_alert(user, "history wiped")
	return TRUE

/obj/machinery/guest_pass/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	var/error_prob = severity == EMP_HEAVY ? 33 : 10
	for(var/list/history as anything in pass_history)
		for(var/entry in history)
			if(prob(error_prob))
				history[entry] = null

/obj/machinery/guest_pass/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_GuestPass")
		ui.open()

/obj/machinery/guest_pass/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(isliving(usr))
		playsound(src, SFX_TERMINAL_TYPE, 50, FALSE)
	switch(action)
		if("change_time")
			set_time = clamp(round(text2num(params["new_time"]), 0.5), min_time, max_time)
			return TRUE
		if("toggle_access")
			var/toggling = params["changed_access"]
			if(toggling in given_access)
				given_access -= toggling
				return TRUE
			if(length(given_access) > max_given_accesses)
				return TRUE
			var/to_give = params["changed_access"]
			for(var/cat in all_possible_given_access)
				if(to_give in all_possible_given_access[cat])
					given_access += to_give
					break
			return TRUE
		if("clear_access")
			given_access.Cut()
			return TRUE
		if("print_pass")
			if(print_guest_pass(usr))
				playsound(src, 'sound/machines/ping.ogg', 33, FALSE)
			else
				playsound(src, 'sound/machines/buzz-two.ogg', 33, FALSE)
			return TRUE
		if("clear_id")
			swiped_id_name = null
			swiped_id_job = null
			swiped_id_access = null
			return TRUE
		if("swipe_id")
			var/obj/item/card/id/id = usr.get_active_held_item()
			if(istype(id))
				swipe_id(id, usr)
			else
				balloon_alert(usr, "no id in hand!")
				playsound(src, 'sound/machines/buzz-sigh.ogg', 33, FALSE)
			return TRUE

/obj/machinery/guest_pass/ui_data(mob/user)
	var/list/data = list()
	data["selected_access"] = given_access
	data["set_time"] = set_time
	data["access_history"] = pass_history
	data["swiped_id_name"] = swiped_id_name
	data["swiped_id_job"] = swiped_id_job
	data["swiped_id_access"] = swiped_id_access
	return data

/obj/machinery/guest_pass/ui_static_data(mob/user)
	var/list/data = list()
	data["all_accesses"] = all_possible_given_access
	data["access_readable"] = SSid_access.desc_by_access
	data["min_time"] = min_time
	data["max_time"] = max_time
	data["max_given_accesses"] = max_given_accesses
	return data

/obj/machinery/guest_pass/medbay
	dept_name = "medical"
	all_possible_given_access = list(
		"General" = list(
			ACCESS_MEDICAL,
			ACCESS_MORGUE,
		),
		"Specialized" = list(
			ACCESS_PHARMACY,
			ACCESS_PSYCHOLOGY,
			ACCESS_SURGERY,
		),
		"Secure" = list(
			ACCESS_MORGUE_SECURE,
			ACCESS_PLUMBING,
			ACCESS_VIROLOGY,
		),
	)

/obj/machinery/guest_pass/science
	dept_name = "science"
	all_possible_given_access = list(
		"General" = list(
			ACCESS_SCIENCE,
		),
		"Specialized" = list(
			ACCESS_GENETICS,
			ACCESS_ORDNANCE,
			ACCESS_ORDNANCE_STORAGE,
			ACCESS_RESEARCH,
			ACCESS_ROBOTICS,
			ACCESS_XENOBIOLOGY,
		),
	)

/obj/machinery/guest_pass/botany
	dept_name = "hydroponics"
	all_possible_given_access = list(
		"General" = list(
			ACCESS_HYDROPONICS,
		),
	)

/obj/machinery/guest_pass/kitchen
	dept_name = "kitchen"
	all_possible_given_access = list(
		"General" = list(
			ACCESS_KITCHEN,
		),
	)

/obj/machinery/guest_pass/sec
	dept_name = "security"
	all_possible_given_access = list(
		"General" = list(
			ACCESS_BRIG_ENTRANCE,
		),
		"Specialized" = list(
			ACCESS_COURT,
			ACCESS_DETECTIVE,
		),
		"Secure" = list(
			ACCESS_BRIG,
			ACCESS_SECURITY,
		),
	)

/obj/machinery/guest_pass/engi
	dept_name = "engineering"
	all_possible_given_access = list(
		"General" = list(
			ACCESS_ENGINEERING,
			ACCESS_CONSTRUCTION,
		),
		"Specialized" = list(
			ACCESS_ATMOSPHERICS,
			ACCESS_AUX_BASE,
			ACCESS_TECH_STORAGE,
		),
	)

/obj/machinery/guest_pass/cargo
	dept_name = "cargo"
	all_possible_given_access = list(
		"General" = list(
			ACCESS_CARGO,
			ACCESS_SHIPPING,
		),
		"Mining" = list(
			ACCESS_BIT_DEN,
			ACCESS_MINERAL_STOREROOM,
			ACCESS_MINING,
			ACCESS_MINING_STATION,
		),
	)

// One with all access for the HoP / debugging / events
/obj/machinery/guest_pass/universal
	dept_name = "station"
	desc = "A special kiosk allowing anyone to give anyone else access to anywhere they want... temporarily."

/obj/machinery/guest_pass/universal/Initialize(mapload)
	. = ..()
	all_possible_given_access["Cargo"] = REGION_ACCESS_SECURITY
	all_possible_given_access["Command"] = REGION_ACCESS_COMMAND
	all_possible_given_access["Engineering"] = REGION_ACCESS_ENGINEERING
	all_possible_given_access["Medical"] = REGION_ACCESS_MEDBAY
	all_possible_given_access["Science"] = REGION_ACCESS_RESEARCH
	all_possible_given_access["Security"] = REGION_ACCESS_SECURITY
	all_possible_given_access["Service"] = REGION_ACCESS_GENERAL

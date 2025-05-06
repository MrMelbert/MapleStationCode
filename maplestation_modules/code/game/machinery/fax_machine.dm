/// --- Fax Machines. ---
// Sprite ported from oldbases with fax machines (Paradise, baystaion, vgstation).

/// GLOB list of all fax machines.
GLOBAL_LIST_EMPTY(fax_machines)

/// Cooldown for fax time between faxes.
#define FAX_COOLDOWN_TIME 3 MINUTES

/// The time between alerts that the machine contains an unread message.
#define FAX_UNREAD_ALERT_TIME 3 MINUTES

/// The max amount of chars displayed in a fax message in the UI
#define MAX_DISPLAYED_PAPER_CHARS 475

/// Fax machine design, for techwebs.
/datum/design/board/fax/deluxe
	name = "Machine Design (Deluxe Fax Machine Board)"
	desc = "The circuit board for a Deluxe Fax Machine. \
		Unlike normal fax machines, this one can receive paperwork to process."
	id = "fax_machine_deluxe"
	build_path = /obj/item/circuitboard/machine/fax/deluxe

/// Fax machine circuit.
/obj/item/circuitboard/machine/fax/deluxe
	name = "Deluxe Fax Machine (Machine Board)"
	build_path = /obj/machinery/fax/deluxe

/obj/item/circuitboard/machine/fax/deluxe/Initialize(mapload)
	. = ..()
	req_components[/obj/item/stack/sheet/mineral/silver] = 2
	req_components[/obj/item/stack/sheet/glass] = 1

/// Fax machine. Sends messages, receives messages, sends paperwork, receives paperwork.
/obj/machinery/fax
	name = "fax machine"
	desc = "A machine made to send copies of papers to other departments, Central Command, or the Aristocracy of Mu. Bureaucratic."
	icon = 'icons/obj/machines/fax.dmi'
	base_icon_state = "fax"
	icon_state = "fax"
	anchored_tabletop_offset = 6
	max_integrity = 100
	pass_flags = PASSTABLE
	speech_span = SPAN_ROBOT
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.1
	req_one_access = list(ACCESS_COMMAND, ACCESS_LAWYER) // for unlocking the panel
	circuit = /obj/item/circuitboard/machine/fax

	// Inherited from /tg/ fax code
	var/fax_name
	var/list/fax_history = list()

	// Original fax code
	/// Whether this machine can send faxes
	var/sending_enabled = TRUE
	/// Whether this machine can receive faxes
	var/receiving_enabled = TRUE
	/// Whether this fax machine is locked.
	var/locked = TRUE
	/// Whether this fax machine can receive paperwork to process on SSeconomy ticks.
	var/can_receive_paperwork = FALSE
	/// Whether this fax can toggle paperwork on or off
	var/is_allowed_to_toggle_paperwork = FALSE
	/// Whether we have an unread message
	VAR_FINAL/unread_message = FALSE
	/// The area string this fax machine is set to.
	VAR_FINAL/room_tag
	/// The paper stored that we can send to admins. Reference to something in our contents.
	VAR_FINAL/obj/item/paper/stored_paper
	/// The paper received that was sent FROM admins. Reference to something in our contents.
	VAR_FINAL/obj/item/paper/received_paper
	/// Lazylist of all paperwork we have in this fax machine. List of references to things in our contents.
	VAR_FINAL/list/obj/item/paper/processed/received_paperwork
	/// Max amount of paperwork we can hold. Any more and the UI gets less readable.
	var/max_paperwork = 8
	/// Cooldown between sending faxes
	COOLDOWN_DECLARE(fax_cooldown)

	var/visible_to_network = TRUE

/obj/machinery/fax/Initialize(mapload)
	. = ..()
	GLOB.fax_machines += src
	set_room_tag(TRUE, !mapload)
	wires = new /datum/wires/fax(src)

/obj/machinery/fax/Destroy()
	QDEL_NULL(stored_paper)
	QDEL_NULL(received_paper)
	QDEL_LAZYLIST(received_paperwork)
	GLOB.fax_machines -= src
	return ..()

/obj/machinery/fax/on_deconstruction()
	var/atom/droploc = drop_location()
	stored_paper.forceMove(droploc)
	received_paper.forceMove(droploc)
	eject_all_paperwork()
	return ..()

/obj/machinery/fax/deluxe
	name = "deluxe fax machine"
	desc = "A deluxe fax machine, designed not only to send and receive faxes, but to process an unending stream of paperwork. \
		You unbelievably boring person."
	is_allowed_to_toggle_paperwork = TRUE
	circuit = /obj/item/circuitboard/machine/fax/deluxe

/obj/machinery/fax/deluxe/starts_enabled
	can_receive_paperwork = TRUE

/obj/machinery/fax/deluxe/full
	can_receive_paperwork = TRUE

/obj/machinery/fax/deluxe/full/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_paperwork)
		LAZYADD(received_paperwork, generate_paperwork(src))

/obj/machinery/fax/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_FaxMachine", name)
		ui.open()

/obj/machinery/fax/ui_state(mob/user)
	if(!anchored)
		return UI_DISABLED
	if(panel_open)
		return UI_UPDATE
	return GLOB.physical_state

/obj/machinery/fax/ui_data(mob/user)
	var/list/data = list()

	var/emagged = obj_flags & EMAGGED

	data["received_paperwork"] = list()
	var/iterator = 1
	for(var/obj/item/paper/processed/paper as anything in received_paperwork)
		var/list/found_paper_data = list()
		found_paper_data["title"] = paper.name
		found_paper_data["contents"] = raw_paper_text_to_ui_text(paper)
		found_paper_data["required_answer"] = paper.required_question
		found_paper_data["ref"] = REF(paper)
		found_paper_data["num"] = iterator++
		UNTYPED_LIST_ADD(data["received_paperwork"], found_paper_data)

	if(stored_paper)
		data["stored_paper"] = list(
			"title" = stored_paper.name,
			"contents" = raw_paper_text_to_ui_text(stored_paper),
			"ref" = REF(stored_paper),
		)

	if(received_paper)
		data["received_paper"] = list(
			"title" = received_paper.name,
			"contents" = raw_paper_text_to_ui_text(received_paper),
			"source" = received_paper.was_faxed_from,
			"ref" = REF(received_paper),
		)

	data["display_name"] = "\[REDACTED\]"
	if(emagged)
		var/emagged_text = ""
		for(var/i in 1 to rand(4, 7))
			emagged_text += pick("!","@","#","$","%","^","&")
		data["display_name"] = emagged_text

	else if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/obj/item/card/id/our_id = human_user.get_idcard()
		if(our_id?.registered_name)
			data["display_name"] = our_id?.registered_name

	else if(issilicon(user))
		data["display_name"] = user.real_name

	data["history"] = fax_history
	data["can_send"] = COOLDOWN_FINISHED(src, fax_cooldown)
	data["can_receive"] = can_receive_paperwork
	data["can_toggle_can_receive"] = is_allowed_to_toggle_paperwork
	data["emagged"] = emagged
	data["unread_message"] = unread_message

	return data

/obj/machinery/fax/ui_static_data(mob/user)
	var/list/data = list()

	var/admin_destination = (obj_flags & EMAGGED) ? SYNDICATE_FAX_MACHINE : CENTCOM_FAX_MACHINE
	var/list/possible_destinations = list()
	possible_destinations += admin_destination
	possible_destinations += MU_FAX_MACHINE
	for(var/obj/machinery/fax/machine as anything in GLOB.fax_machines)
		if(machine == src)
			continue
		if(!machine.room_tag || !machine.visible_to_network)
			continue
		if(machine.room_tag in possible_destinations)
			continue
		possible_destinations += machine.room_tag
	data["destination_options"] = possible_destinations
	data["default_destination"] = admin_destination

	return data

/obj/machinery/fax/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("un_emag_machine")
			balloon_alert(usr, "routing information restored")
			obj_flags &= ~EMAGGED
			update_static_data_for_all_viewers()

		if("toggle_recieving")
			if(is_allowed_to_toggle_paperwork)
				can_receive_paperwork = !can_receive_paperwork

		if("read_last_received")
			unread_message = FALSE

		if("send_stored_paper")
			send_stored_paper(usr, params["destination_machine"])

		if("print_received_paper")
			flick("[base_icon_state]_receive", src)
			flick_overlay_view(find_overlay_state(received_paper, "receive"), 2 SECONDS)
			balloon_alert(usr, "removed paper")
			playsound(src, 'sound/machines/printer.ogg', 50, TRUE)
			if(usr.CanReach(src))
				usr.put_in_hands(received_paper)
			else
				received_paper.forceMove(drop_location())

		if("print_all_paperwork")
			eject_all_paperwork_with_delay(usr)

		if("print_select_paperwork")
			var/obj/item/paper/processed/paper = locate(params["ref"]) in received_paperwork
			eject_select_paperwork(usr, paper, FALSE)

		if("delete_select_paperwork")
			var/obj/item/paper/processed/paper = locate(params["ref"]) in received_paperwork
			qdel(paper)
			use_energy(active_power_usage)

		if("check_paper")
			var/obj/item/paper/processed/paper = locate(params["ref"]) in received_paperwork
			check_paperwork(paper, usr)

	return TRUE

/obj/machinery/fax/update_overlays()
	. = ..()
	if (panel_open)
		. += "fax_panel"
	if (stored_paper)
		. += mutable_appearance(icon, find_overlay_state(stored_paper, "contain"))

/obj/machinery/fax/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/screwdriver)
	if(locked && !panel_open)
		if(issilicon(user))
			balloon_alert(user, "panel lock bypassed")
			return ..()

		balloon_alert(user, "panel locked!")
		return FALSE

	return ..()

/obj/machinery/fax/can_be_unfasten_wrench(mob/user, silent)
	if(!panel_open)
		if(!silent)
			balloon_alert(user, "open the panel first!")
		return FAILED_UNFASTEN // "failed" instead of "cant", because failed stops afterattacks
	return ..()

/obj/machinery/fax/default_unfasten_wrench(mob/user, obj/item/wrench, time = 20)
	. = ..()
	if(. != SUCCESSFUL_UNFASTEN)
		return .

	set_room_tag(anchored, TRUE) // Sets the room tag to NULL if unanchored, or the area name if anchored
	return .

/obj/machinery/fax/screwdriver_act(mob/living/user, obj/item/screwdriver)
	if(default_deconstruction_screwdriver(user, base_icon_state, base_icon_state, screwdriver))
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/machinery/fax/wrench_act(mob/living/user, obj/item/tool)
	switch(default_unfasten_wrench(user, tool))
		if(CANT_UNFASTEN)
			return NONE
		if(FAILED_UNFASTEN)
			return ITEM_INTERACT_BLOCKING
		if(SUCCESSFUL_UNFASTEN)
			return ITEM_INTERACT_SUCCESS
	return NONE

/obj/machinery/fax/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(tool) ? ITEM_INTERACT_SUCCESS : NONE

/obj/machinery/fax/attackby(obj/item/weapon, mob/user, params)
	// This is to catch assemblies
	if(panel_open && is_wire_tool(weapon))
		wires.interact(user)
		return TRUE

	if(istype(weapon, /obj/item/paper/processed))
		insert_processed_paper(weapon, user)
		return TRUE

	if(istype(weapon, /obj/item/paper))
		var/obj/item/paper/inserted_paper = weapon
		if(inserted_paper.was_faxed_from in GLOB.admin_fax_destinations)
			balloon_alert(user, "cannot re-fax!")
			return TRUE
		insert_paper(inserted_paper, user)
		return TRUE

	if(check_access(weapon.GetID()) && !panel_open)
		locked = !locked
		playsound(src, 'sound/machines/terminal_eject.ogg', 30, FALSE)
		balloon_alert(user, "panel [locked ? "locked" : "unlocked"]")
		return TRUE

	return ..()

/obj/machinery/fax/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .
	if(isnull(stored_paper))
		return SECONDARY_ATTACK_CALL_NORMAL

	balloon_alert(user, "removed paper")
	if(user.CanReach(src))
		user.put_in_hands(stored_paper)
	else
		stored_paper.forceMove(drop_location())

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/fax/examine(mob/user)
	. = ..()
	. += span_notice("Its maintenance panel is [locked ? "locked" : "unlocked"][panel_open ? ", and open" : ""].")
	if(stored_paper)
		. += span_notice("It has a paper in its tray, ready to send somewhere.")
	if(received_paper)
		. += span_notice("Looks like it's received a fax.")

/**
 * Set this fax machine's [room_tag] to the current room or null.
 *
 * if to_curr_room is TRUE, sets the room_tag to the current area's name.
 * otherwise, sets it to null.
 *
 * if update_all_faxes is TRUE, updates all fax machines in the world.
 */
/obj/machinery/fax/proc/set_room_tag(to_curr_room = TRUE, update_all_faxes = FALSE)
	if(to_curr_room)
		room_tag = get_area_name(src, TRUE) // no proper or improper tags on this
		if(name == initial(name))
			name = "[fax_name || get_area_name(src, FALSE)] [name]"
	else
		room_tag = null
		name = initial(name)

	if(update_all_faxes)
		for(var/obj/machinery/fax/other_fax as anything in GLOB.fax_machines)
			other_fax.update_static_data_for_all_viewers()

/**
 * Send [stored_paper] from [user] to [destinatoin].
 * if [destination] is an admin fax machine, send it to admins.
 * Otherwise, send it to the corresponding fax machine in the world, looking for (room_tag == [destination])
 *
 * returns TRUE if the fax was sent.
 */
/obj/machinery/fax/proc/send_stored_paper(mob/living/user, destination)
	if((machine_stat & (NOPOWER|BROKEN)) && !(interaction_flags_machine & INTERACT_MACHINE_OFFLINE))
		return FALSE

	if(!sending_enabled)
		balloon_alert(user, "can't send faxes!")
		playsound(src, 'sound/machines/terminal_error.ogg', 50, FALSE)
		return FALSE

	if(!length(stored_paper?.get_raw_text()) || !COOLDOWN_FINISHED(src, fax_cooldown))
		balloon_alert(user, "fax failed to send!")
		playsound(src, 'sound/machines/terminal_error.ogg', 50, FALSE)
		return FALSE

	var/message = "INCOMING FAX: FROM \[[station_name()]\], AUTHOR \[[user]\]: "
	message += remove_all_tags(stored_paper.get_raw_text())
	message += LAZYLEN(stored_paper.stamp_cache) ? " --- The message is stamped." : ""
	if(destination in GLOB.admin_fax_destinations)
		message_admins("[ADMIN_LOOKUPFLW(user)] sent a fax to [destination].")
		send_fax_to_admins(user, message, ((obj_flags & EMAGGED) ? "crimson" : "orange"), destination)
	else
		var/found_a_machine = FALSE
		for(var/obj/machinery/fax/machine as anything in GLOB.fax_machines)
			if(machine == src || machine.room_tag == room_tag)
				continue
			if(!machine.room_tag)
				continue
			if(machine.room_tag == destination && machine.receive_paper(stored_paper.copy(), room_tag))
				message_admins("[ADMIN_LOOKUPFLW(user)] sent a fax to [ADMIN_VERBOSEJMP(machine)].")
				found_a_machine = TRUE
				break
		if(!found_a_machine)
			balloon_alert(user, "destination not found")
			playsound(src, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return FALSE

	var/send_overlay = find_overlay_state(stored_paper, "send")

	balloon_alert(user, "fax sent")
	addtimer(CALLBACK(src, PROC_REF(send_paper_print_copy), user, stored_paper), 2 SECONDS)
	stored_paper = null // Done here so they can't yoink it out before the callback
	update_appearance(UPDATE_OVERLAYS)

	flick("[base_icon_state]_send", src)
	flick_overlay_view(send_overlay, 2 SECONDS)

	history_add("Send", destination)
	playsound(src, 'sound/machines/terminal_processing.ogg', 35, FALSE)
	COOLDOWN_START(src, fax_cooldown, FAX_COOLDOWN_TIME)
	use_energy(active_power_usage)

/obj/machinery/fax/proc/send_paper_print_copy(mob/user, obj/item/paper/copy)
	if(QDELETED(copy))
		return

	if(!QDELETED(user))
		balloon_alert(user, "copy dispensed")

	copy.forceMove(drop_location())
	update_appearance(UPDATE_OVERLAYS)

/**
 * Send the content of admin faxes to admins directly.
 * [sender] - the mob who sent the fax
 * [fax_contents] - the contents of the fax
 * [destination_color] - the color of the span that encompasses [destination_string]
 * [destination_string] - the string that says where this fax was sent (syndiate or centcom)
 */
/obj/machinery/fax/proc/send_fax_to_admins(mob/sender, fax_contents, destination_color, destination_string)
	var/message = copytext_char(sanitize(fax_contents), 1, MAX_MESSAGE_LEN)
	deadchat_broadcast(" has sent a fax to: [destination_string], with the message: \"[message]\" at [span_name("[get_area_name(sender, TRUE)]")].", span_name("[sender.real_name]"), sender, message_type = DEADCHAT_ANNOUNCEMENT)
	to_chat(GLOB.admins, span_adminnotice("<b><font color=[destination_color]>FAX TO [destination_string]: </font>[ADMIN_FULLMONTY(sender)] [ADMIN_FAX_REPLY(src)]:</b> [message]"), confidential = TRUE)

/obj/machinery/fax/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone in received_paperwork)
		LAZYREMOVE(received_paperwork, gone)
	if(gone == stored_paper)
		stored_paper = null
		update_appearance(UPDATE_OVERLAYS)
	if(gone == received_paper)
		received_paper = null

/obj/machinery/fax/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(arrived == stored_paper)
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/fax/proc/raw_paper_text_to_ui_text(obj/item/paper/paper)
	var/paper_contents = ""
	for(var/datum/paper_input/line as anything in paper.raw_text_inputs)
		if(paper_contents)
			paper_contents += " \[FULL STOP\] "
		paper_contents += line.raw_text

	if(paper_contents)
		paper_contents += " \[END\]"
		paper_contents = remove_all_tags(paper_contents) // remove html stuff
		paper_contents = TextPreview(paper_contents, MAX_DISPLAYED_PAPER_CHARS) // trims it down to a reasonable length

	return paper_contents

/**
 * receive [new_paper] as a fax from [source].
 * Ejects any [received_paper] we may have, and sets [received_paper] to [new_paper].
 * If [source] is null or empty, we go with a preset name.
 *
 * [new_paper] is a reference to an instantiated, written paper.
 * [source] is a string of the location or company sending the fax.
 * [forced] will always send the fax if TRUE even if the machine is broken, unpowered, or disabled.
 *
 * returns TRUE if the fax was received.
 */
/obj/machinery/fax/proc/receive_paper(obj/item/paper/new_paper, source, forced = FALSE)
	if(!new_paper)
		return FALSE

	if(!forced)
		if((machine_stat & (NOPOWER|BROKEN)) && !(interaction_flags_machine & INTERACT_MACHINE_OFFLINE))
			return FALSE

		if(!receiving_enabled)
			return FALSE

	if(!length(source))
		source = (obj_flags & EMAGGED) ? "employer" : CENTCOM_FAX_MACHINE
	received_paper?.forceMove(drop_location())

	new_paper.name = "fax - [new_paper.name]"
	new_paper.was_faxed_from = source
	received_paper = new_paper
	received_paper.forceMove(src)
	unread_message = TRUE
	alert_received_paper(source)
	history_add("Receive", source)

	return TRUE

/**
 * Display an alert that [src] received a message from [source].
 * [source] is a string of a location or company.
 */
/obj/machinery/fax/proc/alert_received_paper(source)
	if((machine_stat & (NOPOWER|BROKEN)) && !(interaction_flags_machine & INTERACT_MACHINE_OFFLINE))
		return FALSE

	if(!unread_message)
		return FALSE

	say("Fax received from [source]!")
	playsound(src, 'sound/machines/terminal_processing.ogg', 50, FALSE)
	addtimer(CALLBACK(src, PROC_REF(alert_received_paper), source), FAX_UNREAD_ALERT_TIME)

/**
 * Check if [checked_paper] has had its paperwork fulfilled successfully.
 * [checked_paper] is an instantiated paper.
 * [user] is the mob who triggered the check.
 *
 * returns TRUE if the paperwork was correct, FALSE otherwise.
 */
/obj/machinery/fax/proc/check_paperwork(obj/item/paper/processed/checked_paper, mob/living/user)
	var/paper_check = checked_paper.check_requirements()
	var/message = ""
	switch(paper_check)
		if(FAIL_NO_STAMP)
			message = "Protocal violated. Paperwork not stamped by official."
		if(FAIL_NOT_DENIED)
			message = "Protocal violated. Discrepancies detected in submitted paperwork."
		if(FAIL_INCORRECTLY_DENIED)
			message = "Protocal violated. No discrepancies detected in submitted paperwork, yet paperwork was denied."
		if(FAIL_NO_ANSWER)
			message = "Protocal violated. Paperwork unprocessed."
		if(FAIL_QUESTION_WRONG)
			message = "Protocal violated. Paperwork not processed correctly."
		if(PAPERWORK_SUCCESS)
			message = "Paperwork successfuly processed. Dispensing payment."
		else
			stack_trace("Invalid value returned from paperwork check_requirements(): [paper_check]")
			message = "Paperwork failed to transmit. Contact your local Central Command correspondent."

	say(message)
	if(paper_check == PAPERWORK_SUCCESS)
		new /obj/item/holochip(drop_location(), rand(15, 25))
		playsound(src, 'sound/machines/ping.ogg', 60)
		. = TRUE
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		. = FALSE

	qdel(checked_paper)
	use_energy(active_power_usage)
	return .

/**
 * Insert [inserted_paper] into the fax machine, adding it to the list of [received_paperwork] if possible.
 * [inserted_paper] is an instantiated paper.
 * [user] is the mob placing the paper into the machine.
 */
/obj/machinery/fax/proc/insert_processed_paper(obj/item/paper/processed/inserted_paper, mob/living/user)
	if(LAZYLEN(received_paperwork) >= max_paperwork)
		balloon_alert(user, "it's full!")
		return

	inserted_paper.forceMove(src)
	LAZYADD(received_paperwork, inserted_paper)
	balloon_alert(user, "paperwork inserted")

/**
 * Insert [inserted_paper] into the fax machine, setting [stored_paper] to [inserted_paper].
 * [inserted_paper] is an instantiated paper.
 * [user] is the mob placing the paper into the machine.
 */
/obj/machinery/fax/proc/insert_paper(obj/item/paper/inserted_paper, mob/living/user)
	var/existing = FALSE
	if(stored_paper)
		stored_paper.forceMove(drop_location())
		existing = TRUE

	balloon_alert(user, "paper [existing ? "replaced" : "inserted"]")
	stored_paper = inserted_paper
	inserted_paper.forceMove(src)

/**
 * Call [proc/eject_select_paperwork] on all papers in [received_paperwork].
 * if [user] is specified, pass it into [proc/eject_select_paperwork],
 * dispensing as much paper into their hands as possible.
 *
 * Then, null the list after all is done.
 */
/obj/machinery/fax/proc/eject_all_paperwork(mob/living/user)
	for(var/obj/item/paper/processed/paper as anything in received_paperwork)
		eject_select_paperwork(user, paper)
	received_paperwork = null

/**
 * Recursively call [proc/eject_select_paperwork] on the first index
 * of [received_paperwork], applying a delay in between each call.
 *
 * If [user] is specified, pass [user] into the [proc/eject_select_paperwork] call,
 * dispensing as much paper into their hands as possible.
 */
/obj/machinery/fax/proc/eject_all_paperwork_with_delay(mob/living/user)
	if(!LAZYLEN(received_paperwork))
		return

	if(received_paperwork[1])
		eject_select_paperwork(user, received_paperwork[1], FALSE)
		playsound(src, 'sound/machines/printer.ogg', 50, TRUE)
		addtimer(CALLBACK(src, PROC_REF(eject_all_paperwork_with_delay), user), 2 SECONDS)

/**
 * Remove [paper] from the list of [received_paperwork] and
 * dispense it into [user]'s hands, if user is supplied.
 *
 * [paper] must be an instantiated paper already in [list/received_paperwork].
 * if [silent] is FALSE, give feedback and play a sound.
 */
/obj/machinery/fax/proc/eject_select_paperwork(mob/living/user, obj/item/paper/processed/paper, silent = TRUE)
	if(!paper)
		return
	if(user?.CanReach(src))
		user.put_in_hands(paper)
	else
		paper.forceMove(drop_location())
	if(silent)
		return

	flick("[base_icon_state]_receive", src)
	flick_overlay_view(find_overlay_state(paper, "receive"), 2 SECONDS)
	playsound(src, 'sound/machines/ding.ogg', 50, FALSE)
	use_energy(active_power_usage)

/// Sends messages to the syndicate when emagged.
/obj/machinery/fax/emag_act(mob/user)
	if(!panel_open)
		if(locked)
			balloon_alert(user, "panel hacked")
			playsound(src, 'sound/machines/terminal_eject.ogg', 30, FALSE)
		else
			balloon_alert(user, "open the panel first!")
		return

	if(obj_flags & EMAGGED)
		return

	balloon_alert(user, "routing address overridden")
	playsound(src, 'sound/machines/terminal_alert.ogg', 25, FALSE)
	obj_flags |= EMAGGED

/obj/machinery/fax/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_RMB] = "Remove paper"
		return CONTEXTUAL_SCREENTIP_SET

	switch(held_item.tool_behaviour)
		if(TOOL_SCREWDRIVER)
			context[SCREENTIP_CONTEXT_LMB] = "[panel_open ? "Close" : "Open"] maintenance panel"
			return CONTEXTUAL_SCREENTIP_SET

		if(TOOL_WRENCH)
			if(panel_open)
				context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Unsecure" : "Secure"] maintenance panel"
				return CONTEXTUAL_SCREENTIP_SET

		if(TOOL_MULTITOOL, TOOL_WIRECUTTER)
			if(panel_open)
				context[SCREENTIP_CONTEXT_LMB] = "Access wires"
				return CONTEXTUAL_SCREENTIP_SET

		if(TOOL_CROWBAR)
			if(panel_open)
				context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
				return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/card/emag))
		context[SCREENTIP_CONTEXT_LMB] = panel_open ? "Override routing address" : "Hack panel"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/paper))
		context[SCREENTIP_CONTEXT_LMB] = "Insert"
		return CONTEXTUAL_SCREENTIP_SET

	if(!isnull(held_item.GetID()))
		context[SCREENTIP_CONTEXT_LMB] = "[locked ? "Unlock" : "Lock"] panel"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

// ----- Paper definitions and subtypes for interactions with the fax machine. -----
/obj/item/paper
	/// If this paper was sent via fax, where it came from.
	var/was_faxed_from

/obj/item/paper/processed
	name = "\proper classified paperwork"
	desc = "Some classified paperwork sent by the big men themselves."
	/// Assoc list of data related to our paper.
	var/list/paper_data
	/// Question required to be answered for this paper to be marked as correct.
	var/required_question
	/// Answer requires for this paper to be marked as correct.
	var/needed_answer
	/// The last answer supplied by a user.
	var/last_answer

/obj/item/paper/processed/attackby(obj/item/weapon, mob/living/user, params)
	if(istype(weapon, /obj/item/pen) || istype(weapon, /obj/item/toy/crayon))
		INVOKE_ASYNC(src, PROC_REF(answer_question), user)
		return TRUE

	return ..()

/**
 * Called async - Opens up an input for the user to answer the required question.
 */
/obj/item/paper/processed/proc/answer_question(mob/living/user)
	if(!required_question)
		return

	last_answer = tgui_input_text(user, required_question, "Paperwork")

/**
 * Generate a random question based on our paper's data.
 * This question must be answered by a user for the paper to be marked as correct.
 */
/obj/item/paper/processed/proc/generate_requirements()
	var/list/shuffled_data = shuffle(paper_data)
	for(var/data in shuffled_data)
		if(!shuffled_data[data])
			continue

		needed_answer = shuffled_data[data]
		switch(data)
			if("subject_one")
				required_question = "Which corporation was the first mentioned in the document?"
			if("subject_two")
				required_question = "Which corporation was the second mentioned in the document?"
			if("station")
				required_question = "Which space station was mentioned in the document?"
			if("time_period")
				required_question = "What date was this document created?"
			if("occasion")
				required_question = "What type of document is this paperwork for?"
			if("victim")
				required_question = "What was the name of the victim in the document?"
			if("victim_species")
				required_question = "What was the species of the victim in the document?"
			if("errors_present", "redacts_present")
				continue
			else
				required_question = "This paperwork is incompletable. Who made this garbage?"

		if(required_question)
			return

/**
 * Check if our paper's been  processed correctly.
 *
 * Returns a failure state if it was not (a truthy value, 1+) or a success state if it was (falsy, 0)
 */
/obj/item/paper/processed/proc/check_requirements()
	if(isnull(last_answer))
		return FAIL_NO_ANSWER
	if(!LAZYLEN(stamp_cache))
		return FAIL_NO_STAMP
	if(paper_data["redacts_present"])
		return PAPERWORK_SUCCESS

	if(paper_data["errors_present"])
		if(!("stamp-deny" in stamp_cache))
			return FAIL_NOT_DENIED
	else
		if("stamp-deny" in stamp_cache)
			return FAIL_INCORRECTLY_DENIED
		if(!findtext(last_answer, needed_answer))
			return FAIL_QUESTION_WRONG

	return PAPERWORK_SUCCESS


// Wire IDs for the fax machine
#define WIRE_SEND_FAXES "Send wire"
#define WIRE_RECEIVE_FAXES "Receive wire"
#define WIRE_PAPERWORK "Paperwork wire"

/// Wires for the fax machine
/datum/wires/fax
	holder_type = /obj/machinery/fax
	proper_name = "Fax Machine"

/datum/wires/fax/New(atom/holder)
	wires = list(
		WIRE_SEND_FAXES,
		WIRE_RECEIVE_FAXES,
		WIRE_PAPERWORK,
	)
	add_duds(1)
	return ..()

/datum/wires/fax/get_status()
	var/obj/machinery/fax/machine = holder
	var/list/status = list()
	var/service_light_intensity
	switch((machine.sending_enabled + machine.receiving_enabled))
		if(0)
			service_light_intensity = "off"
		if(1)
			service_light_intensity = "blinking"
		if(2)
			service_light_intensity = "on"
	status += "The service light is [service_light_intensity]."
	status += "The bluespace transceiver is glowing [machine.can_receive_paperwork ? "blue" : "red"]."
	return status

/datum/wires/fax/on_pulse(wire, user)
	var/obj/machinery/fax/machine = holder
	switch(wire)
		if(WIRE_SEND_FAXES)
			machine.send_stored_paper(user)
		if(WIRE_PAPERWORK)
			if(machine.is_allowed_to_toggle_paperwork)
				machine.can_receive_paperwork = !machine.can_receive_paperwork
		if(WIRE_RECEIVE_FAXES)
			if(machine.receiving_enabled)
				machine.receiving_enabled = FALSE
				addtimer(VARSET_CALLBACK(machine, receiving_enabled, TRUE), 30 SECONDS)

/datum/wires/fax/on_cut(wire, mend, source)
	var/obj/machinery/fax/machine = holder
	switch(wire)
		if(WIRE_SEND_FAXES)
			machine.sending_enabled = mend
		if(WIRE_RECEIVE_FAXES)
			machine.receiving_enabled = mend

#undef WIRE_SEND_FAXES
#undef WIRE_RECEIVE_FAXES
#undef WIRE_PAPERWORK

#undef FAX_COOLDOWN_TIME
#undef FAX_UNREAD_ALERT_TIME
#undef MAX_DISPLAYED_PAPER_CHARS

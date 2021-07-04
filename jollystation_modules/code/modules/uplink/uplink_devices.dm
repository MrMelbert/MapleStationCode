// -- Modular minor gadgets/devices that go in the uplink. --
/// A small beacon / controller that can be used to send centcom reports IC.
/obj/item/item_announcer
	name = "FK-\"Deception\" Falty Announcement Device"
	desc = "Designed by MI13, the FK-Deception Falty Announcement Device allows an \
		enterprising syndicate agent attempting to maintain their cover a \
		one-time faked message (announced or classified) from a certain source."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	w_class = WEIGHT_CLASS_SMALL
	/// The syndicate who purchased this beacon - only they can use this item. No sharing.
	var/mob/owner = null
	/// The amount of reports we can send before breaking.
	var/uses = 1

/obj/item/item_announcer/examine(mob/user)
	. = ..()
	. += span_notice("It has [uses] uses left.")

/// Deletes the item when it's used up.
/obj/item/item_announcer/proc/break_item(mob/user)
	to_chat(user, span_notice("The [src] breaks down into unrecognizable scrap and ash after being used."))
	var/obj/effect/decal/cleanable/ash/spawned_ash = new(drop_location())
	spawned_ash.desc = "Ashes to ashes, dust to dust. There's a few pieces of scrap in this pile."
	qdel(src)

/// User sends a preset false alarm.
/obj/item/item_announcer/preset
	/// The name of the fake event, so we don't have to init it.
	var/fake_event_name = ""
	/// What false alarm this item triggers.
	var/fake_event = null

/obj/item/item_announcer/preset/Initialize()
	. = ..()
	if(fake_event)
		for(var/datum/round_event_control/init_event in SSevents.control)
			if(ispath(fake_event, init_event.type))
				fake_event = init_event
				break

/obj/item/item_announcer/preset/examine(mob/user)
	. = ..()
	. += span_notice("It causes a fake \"[fake_event_name]\" when used.")

/obj/item/item_announcer/preset/attack_self(mob/user)
	. = ..()
	if(owner && owner != user)
		to_chat(user, span_warning("Identity check failed."))
	else
		if(trigger_announcement(user) && uses <= 0)
			break_item(user)

/obj/item/item_announcer/preset/proc/trigger_announcement(mob/user)
	var/datum/round_event_control/falsealarm/triggered_event = new()
	if(!fake_event)
		return FALSE
	triggered_event.forced_type = fake_event
	triggered_event.runEvent(FALSE)
	to_chat(user, span_notice("You press the [src], triggering a false alarm for [fake_event_name]."))
	deadchat_broadcast(span_bold("[user] has triggered a false alarm using a syndicate device!"), follow_target = user)
	message_admins("[ADMIN_LOOKUPFLW(user)] has triggered a false alarm using a syndicate device: \"[fake_event_name]\".")
	log_game("[key_name(user)] has triggered a false alarm using a syndicate device: \"[fake_event_name]\".")
	uses--

	return TRUE

/obj/item/item_announcer/preset/ion
	fake_event_name = "Ion Storm"
	fake_event = /datum/round_event_control/ion_storm

/obj/item/item_announcer/preset/rad
	fake_event_name = "Radiation Storm"
	fake_event = /datum/round_event_control/radiation_storm

/// Allows users to input a custom announcement message.
/obj/item/item_announcer/input
	/// The name of central command that will accompany our fake report.
	var/fake_command_name = "???"
	/// The actual contents of the report we're going to send.
	var/command_report_content
	/// Whether the report is an announced report or a classified report.
	var/announce_contents = TRUE

/obj/item/item_announcer/input/attack_self(mob/user)
	if(owner && owner != user)
		to_chat(user, span_warning("Identity check failed."))
		return TRUE
	. = ..()

/obj/item/item_announcer/input/examine(mob/user)
	. = ..()
	. += span_notice("It sends messages from \"[fake_command_name]\".")

/obj/item/item_announcer/input/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/item_announcer/input/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_FakeCommandReport")
		ui.open()

/obj/item/item_announcer/input/ui_data(mob/user)
	var/list/data = list()
	data["command_name"] = fake_command_name
	data["command_report_content"] = command_report_content
	data["announce_contents"] = announce_contents

	return data

/obj/item/item_announcer/input/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("update_report_contents")
			command_report_content = params["updated_contents"]
		if("toggle_announce")
			announce_contents = !announce_contents
		if("submit_report")
			if(!command_report_content)
				to_chat(usr, span_danger("You can't send a report with no contents."))
				return
			if(owner && usr != owner)
				to_chat(usr, span_warning("Identity check failed."))
				return
			if(send_announcement(usr) && uses <= 0)
				break_item(usr)
				return

	return TRUE

/// Send our announcement from [user] and decrease the amount of uses.
/obj/item/item_announcer/input/proc/send_announcement(mob/user)
	/// Our current command name to swap back to after sending the report.
	var/original_command_name = command_name()
	change_command_name(fake_command_name)

	if(announce_contents)
		priority_announce(command_report_content, null, SSstation.announcer.get_rand_report_sound(), has_important_message = TRUE)
	print_command_report(command_report_content, "[announce_contents ? "" : "Classified "][fake_command_name] Update", !announce_contents)

	change_command_name(original_command_name)

	to_chat(user, span_notice("You tap on the [src], sending a [announce_contents ? "" : "classified "]report from [fake_command_name]."))
	deadchat_broadcast(span_bold("[user] has triggered an announcement using a syndicate device!"), follow_target = user)
	message_admins("[ADMIN_LOOKUPFLW(user)] has sent a fake command report using a syndicate device: \"[command_report_content]\".")
	log_game("[key_name(user)] has sent a fake command report using a syndicate device: \"[command_report_content]\", sent from \"[fake_command_name]\".")
	uses--

	return TRUE

/obj/item/item_announcer/input/centcom
	fake_command_name = "Central Command"

/obj/item/item_announcer/input/syndicate
	fake_command_name = "The Syndicate"
	uses = 2

/obj/item/megaphone/synd
	name = "syndicate megaphone"
	icon_state = "megaphone-sec"
	inhand_icon_state = "megaphone-sec"

/// The time it takes per hacking charge to open a door.
#define DOORHACKER_HACK_TIME 2.5 SECONDS
/// The time it takes for the door to close.
#define DOORHACKER_AUTOCLOSE_TIME 45 SECONDS
/// The time it takes for the hacking charges to decrease.
#define DOORHACKER_HACK_COOLDOWN 1 MINUTES
/// The min amount of hacking charges
#define DOORHACKER_MIN_HACKS 0
/// The max amount of hacking charges
#define DOORHACKER_MAX_HACKS 20
/// Interaction key for the doorhacker, only one door can be hacked at a time.
#define DOAFTER_SOURCE_DOORHACKER "doafter_doorhacker"

/// Doorhacker - a doormag, but without charges and it doesn't bolt open the door.
/obj/item/card/doorhacker
	name = "automatic door bypassing card"
	desc = "It's an average ID card, modified with a magnetic strip and wired multitool attached to some circuitry."
	icon_state = "doorjack"
	worn_icon_state = "doorjack"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	item_flags = NO_MAT_REDEMPTION | NOBLUDGEON
	slot_flags = ITEM_SLOT_ID
	worn_icon_state = "emag"
	/// Recent hack charges - hacking time increases based on hacking charges
	var/recent_hacks = 0

/obj/item/card/doorhacker/attack_self(mob/user)
	if(Adjacent(user))
		user.visible_message(span_notice("[user] shows you: [icon2html(src, viewers(user))] [name]."), span_notice("You show [src]."))
	add_fingerprint(user)

/obj/item/card/doorhacker/examine(mob/user)
	. = ..()
	. += span_notice("Hacking the next door will take [(DOORHACKER_HACK_TIME/10) * (1 + recent_hacks)] seconds.")

/obj/item/card/doorhacker/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(DOING_INTERACTION(user, DOAFTER_SOURCE_DOORHACKER))
		return
	if(!istype(A, /obj/machinery/door/airlock) && !istype(A, /obj/machinery/door/window))
		return
	var/obj/machinery/door/hacked_door = A
	if(hacked_door.operating || !hacked_door.density)
		return

	INVOKE_ASYNC(src, .proc/start_hacking, hacked_door, user)
	return TRUE

/* Begin a do-after to see if we can open the door.
 *
 * hacked_door - the door we're starting to open.
 * user - the one hacking the door.
 */
/obj/item/card/doorhacker/proc/start_hacking(obj/machinery/door/hacked_door, mob/living/user)
	to_chat(user, span_notice("You start bypassing the access requirements of \the [hacked_door]..."))
	if(do_after(user, (DOORHACKER_HACK_TIME * (1 + recent_hacks)), hacked_door, interaction_key = DOAFTER_SOURCE_DOORHACKER))
		hack_door(hacked_door, user)

/* Actually go through and try to open the door.
 *
 * hacked_door - the door we're trying to open.
 * user - the one opening the door.
 */
/obj/item/card/doorhacker/proc/hack_door(obj/machinery/door/hacked_door, mob/living/user)
	if(hacked_door.can_open_async() && hacked_door.hasPower())
		INVOKE_ASYNC(hacked_door, /obj/machinery/door/.proc/open)
		to_chat(user, span_notice("You nullify the access requirements of \the [hacked_door], opening it temporarily."))
		playsound(drop_location(), 'sound/machines/ding.ogg', 50, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
		if(hacked_door.autoclose)
			hacked_door.autoclose = FALSE
			addtimer(VARSET_CALLBACK(hacked_door, autoclose, TRUE), (DOORHACKER_AUTOCLOSE_TIME - 5 SECONDS))
		if(istype(hacked_door, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/hacked_airlock = hacked_door
			hacked_airlock.aiDisabledIdScanner = TRUE
			addtimer(VARSET_CALLBACK(hacked_airlock, aiDisabledIdScanner, FALSE), (DOORHACKER_AUTOCLOSE_TIME - 5 SECONDS))
		addtimer(CALLBACK(hacked_door, /obj/machinery/door/.proc/close), DOORHACKER_AUTOCLOSE_TIME)
	else
		to_chat(user, span_warning("You nullify the access requirements of \the [hacked_door], but it fails to open."))
		playsound(drop_location(), 'sound/machines/buzz-sigh.ogg', 20, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)

	recent_hacks = min(DOORHACKER_MAX_HACKS, recent_hacks + 1)
	addtimer(CALLBACK(src, .proc/lower_hacks), DOORHACKER_HACK_COOLDOWN)

/// Lowers the recent hack charges.
/obj/item/card/doorhacker/proc/lower_hacks()
	recent_hacks = max(DOORHACKER_MIN_HACKS, recent_hacks - 1)

/// Checks if we can open a door without the sleeps that come with open().
/obj/machinery/door/proc/can_open_async()
	if(operating || welded || locked)
		return FALSE
	if(hasPower() && wires?.is_cut(WIRE_OPEN))
		return FALSE
	if(obj_flags & EMAGGED)
		return FALSE
	return TRUE

/obj/machinery/door/airlock/can_open_async()
	return ..() && !seal

#undef DOORHACKER_HACK_TIME
#undef DOORHACKER_AUTOCLOSE_TIME
#undef DOORHACKER_HACK_COOLDOWN
#undef DOORHACKER_MIN_HACKS
#undef DOORHACKER_MAX_HACKS
#undef DOAFTER_SOURCE_DOORHACKER

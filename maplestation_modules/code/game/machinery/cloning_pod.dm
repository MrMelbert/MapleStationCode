/obj/machinery/clonepod
	name = "cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue."
	density = TRUE
	icon = 'maplestation_modules/icons/obj/machines/cloning.dmi'
	icon_state = "pod_0"
	base_icon_state = "pod"
	verb_say = "states"
	// circuit = /obj/item/circuitboard/machine/clonepod
	obj_flags = NO_DEBRIS_AFTER_DECONSTRUCTION
	resistance_flags = INDESTRUCTIBLE

	var/obj/item/radio/radio
	var/initial_damage = 180
	var/list/things_to_attach = list()
	var/num_things = 0

/obj/machinery/clonepod/Initialize(mapload)
	. = ..()
	radio = new /obj/item/radio/headset/headset_cent()

/obj/machinery/clonepod/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/machinery/clonepod/dump_inventory_contents(list/subset)
	QDEL_LIST(things_to_attach)
	return ..()

/obj/machinery/clonepod/attack_ghost(mob/user)
	. = ..()
	if(!user.client?.holder)
		return
	pick_subject(user)

/obj/machinery/clonepod/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!user.client?.holder)
		return
	pick_subject(user)
	return TRUE

/obj/machinery/clonepod/examine(mob/user)
	. = ..()
	if(is_operational && isliving(occupant))
		. += span_green("Current clone cycle is [get_completion()]% complete.")

/obj/machinery/clonepod/proc/get_completion()
	var/mob/living/mob_occupant = occupant
	if(istype(mob_occupant))
		var/datum/status_effect/genetic_damage/damage = mob_occupant.has_status_effect(/datum/status_effect/genetic_damage)
		return round(100 * ((initial_damage - damage?.total_damage) / initial_damage), 0.01)
	return 0

/obj/machinery/clonepod/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[occupant ? 1 : 0]"

/obj/machinery/clonepod/return_air()
	// We want to simulate the clone not being in contact with
	// the atmosphere, so we'll put them in a constant pressure
	// nitrogen. They don't need to breathe while cloning anyway.
	var/static/datum/gas_mixture/immutable/cloner/im_mix
	if(!im_mix)
		im_mix = new
	return im_mix

/obj/machinery/clonepod/proc/pick_subject(mob/user)
	if(occupant)
		var/eject = tgui_alert(user, "Someone's already being cloned. \
			Early eject?", "Clone", list("Yes (Partial clone)", "Yes (Healthy clone)", "Cancel"))
		if(eject == "Yes (Healthy clone)")
			if(isliving(occupant))
				var/mob/living/mob_occupant = occupant
				for(var/obj/item/thing as anything in things_to_attach)
					readd_thing(mob_occupant, thing)
				mob_occupant.remove_status_effect(/datum/status_effect/genetic_damage)
			open_machine()
		else if(eject == "Yes (Partial clone)")
			open_machine()
		return
	var/client/picked = tgui_input_list(user, "Pick someone to clone", "Clone", list("Cancel") + GLOB.clients)
	if(occupant || picked == "Cancel" || QDELETED(picked) || QDELETED(src))
		return
	var/brainless = tgui_alert(user, "Make a brainless clone? \
		(IE, just make a cadaver to send to the station)", "Clone", list("Yes", "No", "Cancel"))
	if(occupant || brainless == "Cancel" || !brainless || QDELETED(picked) || QDELETED(src))
		return

	var/datum/mind/found_mind
	if(brainless != "Yes")
		found_mind = picked?.mob?.mind
		if(!found_mind)
			var/datum/record/locked/record = find_record(picked.prefs.read_preference(/datum/preference/name/real_name), TRUE)
			found_mind = record?.mind_ref?.resolve()

		if(!found_mind)
			var/welp = tgui_alert(user, "We couldn't find this person's mind, do you want to continue? \
				We'll just shove their client in the clone (which'll make a NEW mind datum)", "Clone", list("Yes", "Cancel"))
			if(welp != "Yes")
				return

		else if(isliving(found_mind.current) && (found_mind.current.stat != DEAD))
			var/r_u_sure = tgui_alert(user, "You're cloning someone who is alive and kicking, \
				are you sure? We'll drag them out of their existing body (keeping the mind the same).", "Clone", list("Yes", "Cancel"))
			if(r_u_sure != "Yes")
				return

		if(occupant || QDELETED(picked) || QDELETED(src))
			return

	grow_clone(picked, found_mind, brainless == "Yes")

//Start growing a human clone in the pod!
/obj/machinery/clonepod/proc/grow_clone(client/cloning, datum/mind/cloning_mind, brainless = FALSE)
	var/datum/preferences/from_prefs = cloning?.prefs
	if(!from_prefs)
		return
	if(occupant)
		return

	var/mob/living/carbon/human/clone = new(src)
	close_machine(clone)

	from_prefs.apply_prefs_to(clone)
	SSquirks.AssignQuirks(clone, cloning)
	clone.set_cloned_appearance()

	if(brainless)
		var/obj/item/organ/brainy = clone.get_organ_by_type(/obj/item/organ/internal/brain)
		brainy.Remove(clone)
		qdel(brainy)

	maim_clone(clone)

	if(!brainless)
		clone.apply_status_effect(/datum/status_effect/fresh_clone)
		if(cloning_mind)
			cloning_mind.transfer_to(clone)
			clone.notify_revival("You are being cloned by Central Command!", source = src)
		else
			window_flash(cloning)
			SEND_SOUND(cloning, sound('sound/effects/genetics.ogg'))
			to_chat(cloning, span_ghostalert("You are being cloned by Central Command!"))
			clone.key = cloning?.key

	say("Cloning cycle of [clone] initiated.")
	radio.talk_into(src, "Cloning cycle of [clone] initiated.", RADIO_CHANNEL_CENTCOM)

/obj/machinery/clonepod/process()
	if(!isliving(occupant))
		return
	var/mob/living/mob_occupant = occupant
	var/datum/status_effect/genetic_damage/damage = mob_occupant.has_status_effect(/datum/status_effect/genetic_damage)
	if(!damage)
		if(length(things_to_attach))
			readd_thing(mob_occupant, pick_n_take(things_to_attach))
			return

		if(mob_occupant.client)
			mob_occupant.flash_act(intensity = INFINITY, override_blindness_check = TRUE, visual = TRUE)
			to_chat(mob_occupant, span_boldnotice("You are ejected from [src] in a bright flash."))
			to_chat(mob_occupant, span_smallnoticeital("You feel like a new person."))
		open_machine()
		say("Cloning process complete.")
		radio.talk_into(src, "Cloning process complete.", RADIO_CHANNEL_CENTCOM)
		return

	var/progress = initial_damage - damage.total_damage
	var/milestone = initial_damage / num_things
	var/installed = num_things - length(things_to_attach)

	if((progress / milestone) >= installed)
		readd_thing(occupant, pick_n_take(things_to_attach))

/obj/machinery/clonepod/set_occupant(atom/movable/new_occupant)
	var/mob/living/old_occupant_mob = occupant
	. = ..()
	if(isliving(old_occupant_mob))
		old_occupant_mob.remove_traits(list(
			TRAIT_DEAF,
			TRAIT_EMOTEMUTE,
			TRAIT_KNOCKEDOUT,
			TRAIT_MUTE,
			TRAIT_NOBREATH,
			TRAIT_NOCRITDAMAGE,
			TRAIT_STABLEHEART,
			TRAIT_STABLELIVER,
		), REF(src))
		num_things = 0
		old_occupant_mob.remove_status_effect(/datum/status_effect/fresh_clone)
		old_occupant_mob.unset_pain_mod("cloning")
		old_occupant_mob.Unconscious(8 SECONDS)
		if(!old_occupant_mob.client && old_occupant_mob.stat != DEAD)
			old_occupant_mob.notify_revival("You have been cloned by Central Command!", source = src)

	if(isliving(new_occupant))
		var/mob/living/new_occupant_mob = new_occupant
		new_occupant_mob.add_traits(list(
			TRAIT_DEAF,
			TRAIT_EMOTEMUTE,
			TRAIT_KNOCKEDOUT,
			TRAIT_MUTE,
			TRAIT_NOBREATH,
			TRAIT_NOCRITDAMAGE,
			TRAIT_STABLEHEART,
			TRAIT_STABLELIVER,
		), REF(src))
		new_occupant_mob.set_pain_mod("cloning", 0)
	update_appearance()

/obj/machinery/clonepod/relaymove(mob/user)
	container_resist_act(user)

/obj/machinery/clonepod/container_resist_act(mob/living/user)
	if(user.stat == CONSCIOUS)
		open_machine()

/obj/machinery/clonepod/proc/maim_clone(mob/living/carbon/human/clone)
	for(var/atom/existing as anything in things_to_attach)
		qdel(existing)
	things_to_attach.Cut()
	clone.apply_status_effect(/datum/status_effect/genetic_damage/cloning, initial_damage)

	// remove organs before removing limbs and taking things with them
	for(var/obj/item/organ/internal/organ in clone.organs)
		if(organ.organ_flags & (ORGAN_VITAL|ORGAN_UNREMOVABLE))
			continue
		organ.organ_flags |= ORGAN_FROZEN
		organ.Remove(clone, special = FALSE) // not special so we apply stuff like heart attacks and blindness
		organ.forceMove(src)
		things_to_attach += organ

	if(!HAS_TRAIT(clone, TRAIT_NODISMEMBER))
		for(var/obj/item/bodypart/part as anything in clone.bodyparts)
			if(part.body_zone == BODY_ZONE_CHEST || part.body_zone == BODY_ZONE_HEAD)
				continue
			part.drop_limb()
			part.forceMove(src)
			things_to_attach += part

	num_things = length(things_to_attach)

/obj/machinery/clonepod/proc/readd_thing(mob/living/carbon/human/clone, obj/item/thing)
	things_to_attach -= thing
	if(isorgan(thing))
		var/obj/item/organ/internal/organ = thing
		organ.organ_flags &= ~ORGAN_FROZEN
		organ.Insert(clone)
		if(istype(thing, /obj/item/organ/internal/heart))
			to_chat(clone, span_smallnoticeital("You hear a faint thumping..."))
			var/obj/item/organ/internal/heart/heart = organ
			heart.Restart()
			SEND_SOUND(clone, sound('sound/health/slowbeat.ogg', channel = CHANNEL_HEARTBEAT, volume = 33))
			addtimer(CALLBACK(clone, TYPE_PROC_REF(/mob, stop_sound_channel), CHANNEL_HEARTBEAT), 4.75 SECONDS)
		if(istype(thing, /obj/item/organ/internal/lungs))
			to_chat(clone, span_smallnoticeital("You feel a sudden urge to breathe..."))
		if(istype(thing, /obj/item/organ/internal/ears))
			to_chat(clone, span_smallnoticeital("You hear a faint buzzing..."))
		if(istype(thing, /obj/item/organ/internal/eyes))
			to_chat(clone, span_smallnoticeital("You see a faint light..."))
		return

	if(isbodypart(thing))
		var/obj/item/bodypart/part = thing
		part.try_attach_limb(clone)
		if(istype(part, /obj/item/bodypart/arm/left))
			to_chat(clone, span_smallnoticeital("You instinctively flex your fingers..."))
		if(istype(part, /obj/item/bodypart/arm/right))
			to_chat(clone, span_smallnoticeital("You reach out to touch something..."))
		if(istype(part, /obj/item/bodypart/leg/left))
			to_chat(clone, span_smallnoticeital("You stretch your leg[clone.num_legs >= 2 ? "s" : ""]..."))
		if(istype(part, /obj/item/bodypart/leg/right))
			to_chat(clone, span_smallnoticeital("You kick your leg[clone.num_legs >= 2 ? "s" : ""] out..."))
		return

// Cloning pod gas mix
/datum/gas_mixture/immutable/cloner
	initial_temperature = T20C

/datum/gas_mixture/immutable/cloner/garbage_collect()
	. = ..()
	ASSERT_GAS(/datum/gas/nitrogen, src)
	gases[/datum/gas/nitrogen][MOLES] = MOLES_O2STANDARD + MOLES_N2STANDARD

/datum/gas_mixture/immutable/cloner/heat_capacity()
	return (MOLES_O2STANDARD + MOLES_N2STANDARD) * 20 //specific heat of nitrogen is 20

// Cloning damage (RIP clone damage)
/datum/status_effect/genetic_damage/cloning
	remove_per_second = 1

// Used to give people a message when they enter their clone
/datum/status_effect/fresh_clone
	id = "fresh_clone"
	alert_type = null
	duration = -1
	tick_interval = -1

/datum/status_effect/fresh_clone/on_apply()
	RegisterSignal(owner, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login))
	return TRUE

/datum/status_effect/fresh_clone/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_CLIENT_LOGIN)

/datum/status_effect/fresh_clone/proc/on_login(datum/source, client/incoming)
	SIGNAL_HANDLER
	if(istype(owner.loc, /obj/machinery/clonepod))
		to_chat(incoming, span_boldnotice("Consciousness slowly creeps over you as your body regenerates."))
		to_chat(incoming, span_smallnoticeital("So this is what cloning feels like?"))
	qdel(src)

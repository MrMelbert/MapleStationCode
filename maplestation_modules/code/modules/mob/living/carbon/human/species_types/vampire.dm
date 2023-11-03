// Vampire Business

// Heart gives you Bat Form, but with a downside
/obj/item/organ/internal/heart/vampire
	actions_types = list(/datum/action/cooldown/spell/shapeshift/vampire)

/obj/item/organ/internal/heart/vampire/on_insert(mob/living/carbon/receiver)
	. = ..()
	receiver.AddComponent(/datum/component/verbal_confirmation)

/obj/item/organ/internal/heart/vampire/on_remove(mob/living/carbon/receiver)
	. = ..()
	qdel(receiver.GetComponent(/datum/component/verbal_confirmation))

// Bat Form transformation my beloved
/datum/action/cooldown/spell/shapeshift/vampire
	name = "Bat Form"
	desc = "Take on the shape a space bat."
	invocation = "Squeak!"
	cooldown_time = 5 SECONDS
	possible_shapes = list(/mob/living/basic/bat)
	button_icon = 'icons/mob/simple/animal.dmi'
	button_icon_state = "bat"
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/// Component which disallows the mob from entering areas they do not have access to,
/// without getting permission from someone who does
/datum/component/verbal_confirmation
	can_transfer = TRUE

	/// Tracks if we've recently asked someone to allow us in
	var/recently_asked = FALSE
	/// Assoc List of all mobs which have given access (key to department bitflag)
	var/list/prior_allowance = list()
	/// Regexes for matching asking to be allowed in
	var/static/regex/asking_regex
	/// Regexes for responses indicating we're allowed in
	var/static/regex/allowed_regex
	/// Regexes for responses indicating we're explicitly not allowed in
	var/static/regex/begone_regex

/datum/component/verbal_confirmation/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	if(!asking_regex)
		asking_regex = regex(@"((may|come|let|can|enter)[a-zA-z\s]*)", "i")
	if(!allowed_regex)
		allowed_regex = regex(@"(sure|okay|ye[sea]*|yes|ok[ay]*|fine|come.+in[a-zA-z\s]*)", "i")
	if(!begone_regex)
		begone_regex = regex(@"(no[ope]*|begone|go away|shoo|fuck off)", "i")

/datum/component/verbal_confirmation/RegisterWithParent()
	RegisterSignals(parent, list(COMSIG_LIVING_SHAPESHIFTED, COMSIG_LIVING_UNSHAPESHIFTED), PROC_REF(shapechanged))
	RegisterSignal(parent, COMSIG_MOB_SAY, PROC_REF(check_asking))
	RegisterSignal(parent, COMSIG_MOVABLE_HEAR, PROC_REF(check_allowed))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(entering_room))

/datum/component/verbal_confirmation/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_SHAPESHIFTED, COMSIG_LIVING_UNSHAPESHIFTED))
	UnregisterSignal(parent, COMSIG_MOB_SAY)
	UnregisterSignal(parent, COMSIG_MOVABLE_HEAR)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/verbal_confirmation/PostTransfer()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/verbal_confirmation/proc/shapechanged(mob/living/source, mob/living/new_mob)
	SIGNAL_HANDLER
	new_mob.TakeComponent(src)

/datum/component/verbal_confirmation/proc/get_bitflag_from_mob(mob/living/who)
	var/obj/item/card/id/their_id = who.get_idcard()
	if(!istype(their_id) || !istype(their_id.trim, /datum/id_trim/job))
		return NONE

	var/datum/id_trim/job/their_trim = their_id.trim
	return their_trim.job.departments_bitflags

/datum/component/verbal_confirmation/proc/is_allowed(mob/living/vampire, area/station/old_area, area/station/checked_area)
	// Non-station areas are always allowed
	if(!istype(checked_area) || isnull(checked_area.associated_department))
		return TRUE
	// Comparing the same area is fine
	if(old_area == checked_area)
		return TRUE
	// If we're going from station to station and it's the same department we can skip some checks
	if(istype(old_area) && old_area.associated_department == checked_area.associated_department)
		return TRUE
	// Medbay is always a free space
	if(vampire.stat != CONSCIOUS && (checked_area.associated_department_flags & DEPARTMENT_BITFLAG_MEDICAL))
		return TRUE

	var/all_allowed = get_bitflag_from_mob(vampire)
	for(var/ref in prior_allowance)
		all_allowed |= prior_allowance[ref]

	if(all_allowed & DEPARTMENT_BITFLAG_CAPTAIN)
		return TRUE // Straight from the big dog
	if(all_allowed & checked_area.associated_department_flags)
		return TRUE
	if(istype(checked_area, /area/station/service/chapel))
		return TRUE // Go ahead, try waltzing into the chapel

	return FALSE

/datum/component/verbal_confirmation/proc/check_asking(mob/living/source, list/say_args)
	SIGNAL_HANDLER

	var/spoken_message = say_args[SPEECH_MESSAGE]
	if(!spoken_message || !asking_regex.Find(spoken_message))
		return

	recently_asked = TRUE
	addtimer(VARSET_CALLBACK(src, recently_asked, FALSE), 20 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
	say_args[SPEECH_MESSAGE] = asking_regex.Replace(spoken_message, "[span_hierophant("$1")]")

/datum/component/verbal_confirmation/proc/check_allowed(mob/living/source, list/hear_args)
	SIGNAL_HANDLER

	if(!recently_asked && !hear_args[RADIO_EXTENSION])
		return

	var/mob/speaker = hear_args[HEARING_SPEAKER]
	if(!ismob(speaker) || speaker == parent)
		return

	var/spoken_message = hear_args[HEARING_RAW_MESSAGE]
	if(!spoken_message)
		return

	if(begone_regex.Find(spoken_message))
		hear_args[HEARING_RAW_MESSAGE] = begone_regex.Replace(spoken_message, "[span_red("$1")]")
		recently_asked = FALSE
		return

	if(allowed_regex.Find(spoken_message))
		var/speaker_key = REF(speaker)
		prior_allowance[speaker_key] = get_bitflag_from_mob(speaker)
		hear_args[HEARING_RAW_MESSAGE] = allowed_regex.Replace(spoken_message, "[span_green("$1")]")
		addtimer(CALLBACK(src, PROC_REF(clear_allowed), speaker_key), 5 MINUTES, TIMER_UNIQUE|TIMER_OVERRIDE)
		// Only give you a notice if you asked
		if(recently_asked)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), source, span_notice("[speaker] allows you into [speaker.p_their()] department. Joyous day.")), 0.2 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
		recently_asked = FALSE
		return

/datum/component/verbal_confirmation/proc/clear_allowed(speaker_key)
	prior_allowance -= speaker_key

/datum/component/verbal_confirmation/proc/entering_room(mob/living/source, turf/old_loc, movement_dir, forced)
	SIGNAL_HANDLER

	if(isnull(old_loc) || forced)
		return
	if(source.pulledby || source.throwing || (source.buckled?.pulledby && source.buckled.pulledby != source))
		return

	var/area/station/old_area = get_area(old_loc)
	var/area/station/checked_area = get_area(source)
	if(is_allowed(source, old_area, checked_area))
		return

	to_chat(source, span_warning("You don't have permission to enter [checked_area]."))
	source.Paralyze(1 SECONDS, ignore_canstun = TRUE)
	source.throw_at(
		target = get_edge_target_turf(source.loc, REVERSE_DIR(movement_dir)),
		range = 3,
		speed = 4,
		gentle = TRUE,
	)

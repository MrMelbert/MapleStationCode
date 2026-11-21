#define BLOOD_SCRIBE_RUNE "Rune"
#define BLOOD_SCRIBE_MESSAGE "Message"
#define BLOOD_SCRIBE_CANCEL "Cancel"
#define BLOOD_SCRIBE_GROUND "Below you"
#define BLOOD_SCRIBE_WALL "In front of you"

#define BLOOD_SCRIBE_HANDS 1
#define BLOOD_SCRIBE_GLOVES 2
#define BLOOD_SCRIBE_OWN 3

/mob/living/carbon/human/verb/blood_scribe()
	set name = "Scribe in Blood"
	set category = "IC"
	set desc = "Write in blood from your hands. Or if you're bleeding, from your body."

	if(!blood_scribe_check())
		return

	var/list/whatoptions = list(BLOOD_SCRIBE_RUNE, BLOOD_SCRIBE_MESSAGE, BLOOD_SCRIBE_CANCEL)
	var/whatpick = tgui_input_list(src, "What do you want to scribe?", "Scribe in Blood", whatoptions, timeout = 30 SECONDS)
	if(!whatpick || whatpick == BLOOD_SCRIBE_CANCEL || QDELETED(src))
		return
	if(!blood_scribe_check())
		return

	var/list/whereoptions = list(BLOOD_SCRIBE_GROUND, BLOOD_SCRIBE_WALL, BLOOD_SCRIBE_CANCEL)
	var/wherepick = tgui_input_list(src, "Where do you want to write?", "Scribe in Blood", whereoptions, timeout = 30 SECONDS)
	if(!wherepick || wherepick == BLOOD_SCRIBE_CANCEL || QDELETED(src))
		return

	var/drawing_with = blood_scribe_check()
	if(!drawing_with)
		return

	do_blood_scribe(wherepick, whatpick, drawing_with)

/mob/living/carbon/human/proc/do_blood_scribe(where_category, what_category, with_category)
	var/turf/where
	switch(where_category)
		if(BLOOD_SCRIBE_GROUND)
			where = src.loc
		if(BLOOD_SCRIBE_WALL)
			where = get_step(src, dir)

	var/obj/spawn_type
	var/list/spawn_args = list(where, get_static_viruses(), get_blood_dna_list())
	switch(what_category)
		if(BLOOD_SCRIBE_RUNE)
			spawn_type = /obj/effect/decal/cleanable/blood/blood_rune

			var/design = tgui_input_number(src, "Choose a design variant:", "Scribe in Blood", min_value = 1, max_value = 7, timeout = 30 SECONDS)
			if(!design || QDELETED(src))
				return
			spawn_args += design

		if(BLOOD_SCRIBE_MESSAGE)
			spawn_type = /obj/effect/decal/cleanable/blood/writing

			var/message = strip_html_full(tgui_input_text(src, "Enter the message to scribe (it will be written in your active language!):", "Scribe in Blood", max_length = MAX_LABEL_LEN, timeout = 1 MINUTES))
			if(!message || QDELETED(src))
				return
			var/list/filter_result = CAN_BYPASS_FILTER(src) ? null : is_ic_filtered(message)
			if(filter_result)
				REPORT_CHAT_FILTER_TO_USER(src, filter_result)
				return

			var/list/soft_filter_result = CAN_BYPASS_FILTER(src) ? null : is_soft_ic_filtered(message)
			if(soft_filter_result)
				var/confirm = tgui_alert(src, "That message contains \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\", Are you sure you want to write it?", "Soft Blocked Word", list("Yes", "No"), timeout = 10 SECONDS)
				if(confirm != "Yes" || QDELETED(src))
					return
				message_admins("[ADMIN_LOOKUPFLW(src)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[message]\"")
				log_admin_private("[key_name(src)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[message]\"")

			spawn_args += message
			spawn_args += get_selected_language()

	if((!isfloorturf(where) && !iswallturf(where)) || !CanReach(where))
		to_chat(src, span_warning("You can't write on that surface."))
		return
	if(usable_hands <= 0)
		to_chat(src, span_warning("You have no usable hands to write with."))
		return

	visible_message(
		span_warning("[src] begins to [what_category == BLOOD_SCRIBE_RUNE ? "draw" : "write"] on [where] in [with_category == BLOOD_SCRIBE_OWN ? "[p_their()] own blood" : "blood"]!"),
		span_warning("You begin [what_category == BLOOD_SCRIBE_RUNE ? "drawing" : "writing"] on [where] with [with_category == BLOOD_SCRIBE_OWN ? "your own blood" : "blood"]..."),
		vision_distance = EYE_CONTACT_RANGE, // 'wtf are you doin.'
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)

	if(!do_after(src, 2.5 SECONDS, where))
		return
	if((!isfloorturf(where) && !iswallturf(where)) || !CanReach(where))
		return
	if(usable_hands <= 0)
		return

	var/obj/effect/decal/cleanable/blood/spawned = new spawn_type(arglist(spawn_args))
	if(QDELETED(spawned))
		to_chat(src, span_warning("You failed to write on that surface."))
		return

	spawned.add_fingerprint(src)
	where.add_fingerprint(src)
	if(IS_CULTIST(src)) // eyes emoji
		spawned.can_dry = FALSE

	visible_message(
		span_warning("[src] finishes [what_category == BLOOD_SCRIBE_RUNE ? "drawing" : "writing"] on [where] in [with_category == BLOOD_SCRIBE_OWN ? "[p_their()] own blood" : "blood"]!"),
		span_warning("You finish [what_category == BLOOD_SCRIBE_RUNE ? "drawing" : "writing"] on [where] with [with_category == BLOOD_SCRIBE_OWN ? "your own blood" : "blood"]."),
		vision_distance = EYE_CONTACT_RANGE, // 'nothin, why do you ask?'
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)

	switch(with_category)
		if(BLOOD_SCRIBE_OWN)
			bleed(10, leave_pool = FALSE)

		if(BLOOD_SCRIBE_GLOVES)
			var/obj/item/clothing/gloves/cover = get_item_by_slot(ITEM_SLOT_GLOVES)
			if(istype(cover))
				cover.transfer_blood = max(0, cover.transfer_blood - 1)
				update_worn_gloves()

		if(BLOOD_SCRIBE_HANDS)
			blood_in_hands = max(0, blood_in_hands - 1)
			update_worn_gloves()

/obj/effect/decal/cleanable/blood/blood_rune
	name = /obj/effect/rune::name
	desc = /obj/effect/rune::desc
	icon = 'icons/obj/antags/cult/rune.dmi'
	icon_state = "1"
	random_icon_states = null
	base_name = "rune of"

/obj/effect/decal/cleanable/blood/blood_rune/Initialize(mapload, list/datum/disease/diseases, list/starting_dna, variant = rand(1, 7))
	. = ..()
	icon_state = "[variant]"
	if(isclosedturf(loc))
		SET_PLANE_IMPLICIT(src, WALL_PLANE)
		layer = BELOW_OBJ_LAYER
	add_filter("bloodblur", 1, gauss_blur_filter(size = 0.5))

/obj/effect/decal/cleanable/blood/blood_rune/NeverShouldHaveComeHere(turf/here_turf)
	return isgroundlessturf(here_turf)

/obj/effect/decal/cleanable/blood/writing
	name = "bloody text"
	desc = "A message written in blood."
	icon = 'maplestation_modules/icons/effects/blood.dmi'
	icon_state = "writing1"
	mergeable_decal = FALSE
	random_icon_states = list("writing1", "writing2", "writing3", "writing4", "writing5")
	base_name = "writing in"
	gender = PLURAL
	var/message
	var/datum/language/language

/obj/effect/decal/cleanable/blood/writing/Initialize(mapload, list/datum/disease/diseases, list/starting_dna, message = "???", language = /datum/language/common)
	for(var/obj/effect/decal/cleanable/blood/writing/other_writing in loc)
		random_icon_states -= other_writing.icon_state

	. = ..()
	if(!length(random_icon_states))
		return INITIALIZE_HINT_QDEL
	if(isclosedturf(loc))
		SET_PLANE_IMPLICIT(src, WALL_PLANE)
		layer = BELOW_OBJ_LAYER

	src.message ||= message
	src.language = language

/obj/effect/decal/cleanable/blood/writing/NeverShouldHaveComeHere(turf/here_turf)
	return isgroundlessturf(here_turf)

/obj/effect/decal/cleanable/blood/writing/examine(mob/user)
	. = ..()

	var/formatted_text = span_danger(user.translate_language(src, language, message))
	var/postfix = ( user.has_language(language) || (language in user.get_mutually_understood_languages()) ) ? " in <i>[span_notice(language::name)]</i>" : ""

	. += span_info("It reads: \"[formatted_text]\"[postfix].")

/mob/living/carbon/human/proc/blood_scribe_check()
	if(usable_hands <= 0)
		return FALSE

	if(astype(get_item_by_slot(ITEM_SLOT_GLOVES), /obj/item/clothing/gloves)?.transfer_blood > 0)
		return BLOOD_SCRIBE_GLOVES

	var/hands_are_stained = blood_in_hands > 0
	var/hands_are_stained_but_covered = FALSE

	if(hands_are_stained)
		for(var/obj/item/thing as anything in get_equipped_items())
			if(!(thing.body_parts_covered & HANDS))
				continue
			// something's covering it...
			hands_are_stained_but_covered = TRUE
			// ...that something covering it is also covered in blood
			// this counts, so ensure the var is kept as true and then break out
			if(GET_ATOM_BLOOD_DNA_LENGTH(thing))
				hands_are_stained = TRUE
				break
			// ...that something covering it is clean
			// this doesn't count - so clear the var, but continue to check for other coverings
			hands_are_stained = FALSE

	if(hands_are_stained)
		return BLOOD_SCRIBE_HANDS

	if(get_bleed_rate() > 0.5)
		return BLOOD_SCRIBE_OWN

	if(hands_are_stained_but_covered)
		to_chat(src, span_warning("While your hand<i>[usable_hands == 1 ? " is" : "s  are"] </i>covered in blood, [usable_hands == 1 ? "it is" : "they are"] currently covered."))
	else
		to_chat(src, span_warning("You have no blood on your hands or gloves to write with."))
	return FALSE

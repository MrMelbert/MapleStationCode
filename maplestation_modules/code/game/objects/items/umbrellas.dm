/*
 * # Umbrellas!
 * This file has code for umbrellas!
 * Umbrellas you can hold, and open and close.
 * Currently not coding for protecting against rain as ???I dont think??? rain exists.
 * The rest don't and it just for looks.
 */
/obj/item/umbrella/
	name = "umbrella"
	desc = "An umbrella."
	icon = 'maplestation_modules/icons/obj/weapons/umbrellas.dmi'
	icon_state = "umbrella_volkan"
	inhand_icon_state = "umbrella_volkan_closed"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/umbrellas_inhand_lh.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/umbrellas_inhand_rh.dmi'
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 0.5)
	attack_verb_continuous = list("bludgeons", "whacks", "disciplines", "pummels")
	attack_verb_simple = list("bludgeon", "whack", "discipline", "pummel")
	drop_sound = 'maplestation_modules/sound/items/drop/wooden.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/wooden.ogg'
	hitsound = 'sound/weapons/genhit1.ogg'

	//open umbrella offsets for the inhands
	var/open_x_offset = 2
	var/open_y_offset = 3

	//Whether it's open or not
	var/open = FALSE

	/// The sound effect played when our umbrella is opened
	var/on_sound = 'sound/weapons/batonextend.ogg'
	/// The inhand icon state used when our umbrella is opened.
	var/on_inhand_icon_state = "umbrella_volkan_open"

/obj/item/umbrella/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = 7, \
		hitsound_on = "sound/weapons/fwoosh.ogg", \
		w_class_on = WEIGHT_CLASS_BULKY, \
		clumsy_check = FALSE, \
		attack_verb_continuous_on = list("swooshes", "whacks", "fwumps"), \
		attack_verb_simple_on = list("swoosh", "whack", "fwump"), \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/umbrella/worn_overlays(mutable_appearance/standing, isinhands)
	. = ..()
	if(!isinhands)
		return
	//if(isinhands & open)
	//	. += mutable_appearance(lefthand_file, inhand_icon_state + "_BACK", -BODY_BEHIND_LAYER) //not sure why the layer has to be - to work, but it does

/obj/item/umbrella/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER
	inhand_icon_state = active ? on_inhand_icon_state : inhand_icon_state
	open = active
	if(user)
		balloon_alert(user, active ? "opened" : "closed")
	playsound(src, on_sound, 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/umbrella/pickup(mob/user)
	. = ..()
	RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))

/obj/item/umbrella/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)

/obj/item/umbrella/proc/on_dir_change(mob/living/carbon/owner, olddir, newdir)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	build_worn_icon(isinhands = TRUE)
	src.update_icon()
	owner.update_held_items()
	owner.update_appearance()

/obj/item/umbrella/get_worn_offsets(isinhands)
	. = ..()
	if(!isinhands)
		return
	var/mob/holder = loc
	if(open)
		.[2] += open_y_offset
		switch(loc.dir)
			if(NORTH)
				.[1] += ISODD(holder.get_held_index_of_item(src)) ? -open_x_offset : open_x_offset
			if(SOUTH)
				.[1] += ISODD(holder.get_held_index_of_item(src)) ? open_x_offset : -open_x_offset
			if(EAST)
				.[1] -= open_x_offset
			if(WEST)
				.[1] += open_x_offset

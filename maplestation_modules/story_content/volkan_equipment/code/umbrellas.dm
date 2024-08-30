/*
 * # Umbrellas!
 * This file has code for umbrellas!
 * Umbrellas you can hold, and open and close.
 * Currently not coding for protecting against rain as ???I dont think??? rain exists.
 * The rest don't and it just for looks.
 */
/obj/item/umbrella
	name = "umbrella"
	desc = "An umbrella."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/umbrellas.dmi'
	icon_state = "umbrella_volkan"
	inhand_icon_state = "umbrella_volkan_closed"
	lefthand_file = 'maplestation_modules/story_content/volkan_equipment/icons/umbrellas_inhand_lh.dmi'
	righthand_file = 'maplestation_modules/story_content/volkan_equipment/icons/umbrellas_inhand_rh.dmi'
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 0.5)
	attack_verb_continuous = list("bludgeons", "whacks", "disciplines", "thrashes") //copied from cane
	attack_verb_simple = list("bludgeon", "whack", "discipline", "thrash") //copied from cane
	drop_sound = 'maplestation_modules/sound/items/drop/wooden.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/wooden.ogg'

	/// The sound effect played when our umbrella is opened
	var/on_sound = 'sound/weapons/batonextend.ogg'
	/// The inhand iconstate used when our umbrella is opened.
	var/on_inhand_icon_state = "umbrella_volkan_open"

/obj/item/umbrella/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = 7, \
		hitsound_on = "sound/weapons/genhit.ogg", \
		w_class_on = WEIGHT_CLASS_BULKY, \
		clumsy_check = FALSE, \
		attack_verb_continuous_on = list("smacks", "strikes", "cracks", "beats"), \
		attack_verb_simple_on = list("smack", "strike", "crack", "beat"), \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/umbrella/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(user)
		balloon_alert(user, active ? "opened" : "closed")
	playsound(src, on_sound, 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

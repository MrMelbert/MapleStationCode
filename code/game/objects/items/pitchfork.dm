/**
 * Pitchfork item
 *
 * Essentially spears with different stats and sprites.
 * Also fireproof for some reason.
 */
/obj/item/pitchfork
	icon = 'icons/obj/weapons/spear.dmi'
	icon_state = "pitchfork0"
	base_icon_state = "pitchfork"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "pitchfork"
	desc = "A simple tool used for moving hay."
	force = 12
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("attacks", "impales", "pierces")
	attack_verb_simple = list("attack", "impale", "pierce")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor_type = /datum/armor/item_pitchfork
	resistance_flags = FIRE_PROOF

/datum/armor/item_pitchfork
	fire = 100
	acid = 30

/obj/item/pitchfork/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/jousting)
	AddComponent(/datum/component/two_handed, force_unwielded=12, force_wielded=20, icon_wielded="[base_icon_state]1")

/obj/item/pitchfork/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

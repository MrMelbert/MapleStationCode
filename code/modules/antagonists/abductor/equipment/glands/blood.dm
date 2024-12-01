/obj/item/organ/internal/heart/gland/blood
	abductor_hint = "pseudonuclear hemo-destabilizer. Periodically randomizes the abductee's bloodtype into a random reagent."
	cooldown_low = 1200
	cooldown_high = 1800
	uses = -1
	icon_state = "egg"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	mind_control_uses = 3
	mind_control_duration = 1500
	var/new_bloodtype = null

/obj/item/organ/internal/heart/gland/blood/ownerCheck()
	return ..() && !HAS_TRAIT(owner, TRAIT_NOBLOOD) && !!owner.dna?.species

/obj/item/organ/internal/heart/gland/blood/activate()
	to_chat(owner, span_warning("You feel your blood heat up for a moment."))
	new_bloodtype = get_random_reagent_id()
	owner.dna.species.exotic_bloodtype = new_bloodtype

/obj/item/organ/internal/heart/gland/blood/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	organ_owner.dna?.species?.exotic_bloodtype = initial(owner.dna.species.exotic_bloodtype)

/obj/item/organ/internal/heart/gland/blood/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(new_bloodtype)
		organ_owner.dna?.species?.exotic_bloodtype = new_bloodtype

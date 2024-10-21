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

/obj/item/organ/internal/heart/gland/blood/activate()
	if(!ishuman(owner) || !owner.dna.species)
		return
	var/mob/living/carbon/human/H = owner
	to_chat(H, span_warning("You feel your blood heat up for a moment."))
	H.dna.species.exotic_bloodtype = prob(50) ? random_usable_blood_type() : get_random_reagent_id()

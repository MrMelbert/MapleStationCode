///A lizards spines (those things on their back), but also including tail spines (gasp)
/obj/item/organ/spines
	name = "lizard spines"
	desc = "Not an actual spine, obviously."
	icon_state = "spines"
	gender = PLURAL

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_SPINES

	preference = "feature_lizard_spines"

	dna_block = DNA_SPINES_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_FLESH

	bodypart_overlay = /datum/bodypart_overlay/mutant/spines

	organ_flags = parent_type::organ_flags | ORGAN_EXTERNAL

/obj/item/organ/spines/on_mob_insert(mob/living/carbon/receiver, special, movement_flags)
	// If we have a tail, attempt to add a tail spines overlay
	var/obj/item/organ/tail/our_tail = receiver.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	our_tail?.try_insert_tail_spines(our_tail.bodypart_owner)
	return ..()

/obj/item/organ/spines/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	// If we have a tail, remove any tail spines overlay
	var/obj/item/organ/tail/our_tail = organ_owner.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	our_tail?.remove_tail_spines(our_tail.bodypart_owner)
	return ..()

///Bodypart overlay for spines
/datum/bodypart_overlay/mutant/spines
	layers = EXTERNAL_ADJACENT|EXTERNAL_BEHIND
	feature_key = "spines"
	dyable = TRUE
	color_source = ORGAN_COLOR_OVERRIDE // NON-MODULE CHANGE

// BEGIN NON-MODULE CHANGE
/datum/bodypart_overlay/mutant/spines/override_color(obj/item/bodypart/bodypart_owner)

	// by default, use body color if we should be mutant colored
	if(isnull(bodypart_owner.owner) || HAS_TRAIT(bodypart_owner.owner, TRAIT_MUTANT_COLORS) || HAS_TRAIT(bodypart_owner, TRAIT_MUTANT_COLORS))
		return bodypart_owner.draw_color
	// then use forced color - for non-mutant-colored species, like reptilids
	if(bodypart_owner?.owner?.dna?.features["forced_mut_color"])
		return bodypart_owner.owner.dna.features["forced_mut_color"]
	// then default to body color - though this will probably be skin color, some forced color, or pure white
	return bodypart_owner.draw_color

// END NON-MODULE CHANGE

/datum/bodypart_overlay/mutant/spines/get_global_feature_list()
	return SSaccessories.spines_list

/datum/bodypart_overlay/mutant/spines/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return !(bodypart_owner.owner?.obscured_slots & HIDEJUMPSUIT)

/datum/bodypart_overlay/mutant/spines/set_dye_color(new_color, obj/item/organ/tail/organ)
	var/obj/item/organ/tail/tail = organ?.owner.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	tail?.tail_spines_overlay?.set_dye_color(new_color, organ)
	return ..()

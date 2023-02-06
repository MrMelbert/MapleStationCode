GLOBAL_LIST_INIT(story_magic_costs, typecacheof(/datum/story_magic_cost))

/datum/story_magic_cost
	var/name = "Base type, do not use"
	var/description = "Description unset"

/datum/story_magic_cost/proc/can_be_applied_to(mob/living/target, var/score)
	return TRUE

/// Protects apply_effect from having to check can_be_applied_to by acting as a buffer.
/datum/story_magic_cost/proc/apply(mob/living/target, var/score)
	if (can_be_applied_to(target, score)) return FALSE
	return apply_effect(target, score)

/// Never call directly, call apply instead.
/datum/story_magic_cost/proc/apply_effect(mob/living/target, var/score)
	PROTECTED_PROC(TRUE) //should be buffered behind apply
	return FALSE

/datum/story_magic_cost/stamina
	name = "Stamina"
	description = "Transmute the energy in your muscles into magic"

/datum/story_magic_cost/stamina/can_be_applied_to(mob/living/target, var/score)
	if (!iscarbon(target)) return FALSE
	return ..()

/datum/story_magic_cost/stamina/apply_effect(mob/living/carbon/target, var/score)
	target.adjustStaminaLoss(score)
	to_chat(target, span_warning("You feel your muscles ache as the chemical energy stored within them seemingly vanishes."))
	. = ..()

/datum/story_magic_cost/nutrition
	name = "Nutrition"
	description = "Transmute the raw celluar ATP in your body into magic"

/datum/story_magic_cost/nutrition/can_be_applied_to(mob/living/target, var/score)
	if (!iscarbon(target)) return FALSE
	return ..()

/datum/story_magic_cost/nutrition/apply_effect(mob/living/carbon/target, var/score)
	target.adjust_nutrition(score)
	to_chat(target, span_warning("You feel more sluggish, your energy to move seemingly vanishing."))
	. = ..()

/datum/story_magic_cost/blood
	name = "Blood"
	description = "Transmute your own plasma into the lifeblood of the universe"

/datum/story_magic_cost/blood/can_be_applied_to(mob/living/target, var/score)
	if (!iscarbon(target)) return FALSE
	return ..()

/datum/story_magic_cost/blood/apply_effect(mob/living/carbon/target, var/score)
	target.blood_volume = max(0, target.blood_volume - score)
	. = ..()

/// Doesn't have a tangible cost-EXCEPT for informing admins that you used it.
/datum/story_magic_cost/leyline
	name = "The intrinsic power of leylines"
	description = "Gather raw mana from the latent magical leylines underlying spacetime"

/datum/story_magic_cost/leyline/apply_effect(mob/living/target, var/score)
	to_chat(target, span_warning("You gather magical power from the magical leylines underlying all of spacetime. They thrum like violin strings..."))
	message_admins("[target] used leylines to fuel magic, with a cost \"Score\" of [score]. [ADMIN_JMP(target)], [ADMIN_VV(target)], [ADMIN_SMITE(target)]")
	. = ..()

/datum/story_magic_cost/flesh
	name = "Flesh"
	description = "Transmute your own flesh into magic"

/datum/story_magic_cost/flesh/apply_effect(mob/living/target, var/score)
	target.apply_damage(score, BRUTE, sharpness = SHARP_EDGED, forced = TRUE) // b l e e d .
	. = ..()

/// Basetype for any spell that requires a held item.
/datum/story_magic_cost/catalyst

/datum/story_magic_cost/catalyst/can_be_applied_to(mob/living/target, score)
	. = ..()
	if (!iscarbon(target)) return FALSE

	var/mob/living/carbon/carbon_target = target
	var/obj/item = carbon_target.get_active_held_item()
	if (item == null) return FALSE

	return TRUE

/datum/story_magic_cost/catalyst/consume
	name = "Your held item"
	description = "Transmute your held item into magic"

/datum/story_magic_cost/catalyst/consume/can_be_applied_to(mob/living/target, score)
	. = ..()
	if (. == FALSE) return
	var/mob/living/carbon/carbon_target = target
	var/obj/item = carbon_target.get_active_held_item()

	if (item.resistance_flags & INDESTRUCTIBLE)
		to_chat(target, span_warning("[item] neither shifts nor bends - you cannot seem to transmute it!"))
		return FALSE

	var/item_score = get_item_score(item)
	if (item_score < score)
		to_chat(target, span_warning("[item] remains still. Maybe if you used something with more mass/material value?"))
		return FALSE

/datum/story_magic_cost/catalyst/consume/proc/get_item_score(/obj/item)
	var/score = STORY_MAGIC_BASE_CONSUME_SCORE
	var/list/composition = item.get_material_composition(BREAKDOWN_INCLUDE_ALCHEMY)
	for (var/datum/material/material_composition in composition)
		score += (composition[material_composition] * material_composition.value_per_unit)
	return score /// THIS WILL NOT WORK LMFAO I DONT GET HOW THE PROC WORKS


/datum/story_magic_cost/catalyst/consume/apply_effect(mob/living/carbon/target, score)
	. = ..()

	var/obj/item = target.get_active_held_item()
	if (item == null) return FALSE

	item.visible_message(span_warning("[item] vanishes!"))

	qdel(item)

/// Limping from extreme pain in the legs.
/datum/status_effect/limp/pain
	id = "limp_pain"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	remove_on_fullheal = TRUE
	heal_flag_necessary = HEAL_ADMIN|HEAL_WOUNDS|HEAL_STATUS

/datum/status_effect/limp/pain/on_creation(mob/living/new_owner, obj/item/bodypart/next_leg)
	src.next_leg = next_leg
	return ..()

/datum/status_effect/limp/pain/on_apply()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/owner_human = owner
	if(!istype(owner_human) || isnull(owner_human.pain_controller))
		return FALSE

	RegisterSignals(owner, list(COMSIG_CARBON_PAIN_GAINED, COMSIG_CARBON_PAIN_LOST), PROC_REF(update_limp))
	owner.pain_message(
		span_danger("Your [next_leg?.plaintext_zone || "leg"] hurts to walk on!"),
		span_danger("You struggle to walk on your [next_leg?.plaintext_zone || "leg"]!"),
	)

/datum/status_effect/limp/pain/get_examine_text()
	if(limp_chance_left > 0 && limp_chance_right > 0)
		return span_warning("[owner.p_Theyre()] occasionally limping on both legs.")
	else if(limp_chance_left > 0)
		return span_warning("[owner.p_Theyre()] occasionally limping on [owner.p_their()] [left.plaintext_zone].")
	else if(limp_chance_right > 0)
		return span_warning("[owner.p_Theyre()] occasionally limping on [owner.p_their()] [right.plaintext_zone].")

/datum/status_effect/limp/pain/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_CARBON_PAIN_GAINED, COMSIG_CARBON_PAIN_LOST))
	if(!QDELING(owner) && owner.stat <= SOFT_CRIT)
		owner.pain_message(
			span_green("Your pained limp stops!"),
			span_green("It becomes easier to walk again."),
		)

/datum/status_effect/limp/pain/update_limp()
	var/mob/living/carbon/human/limping_human = owner

	left = limping_human.get_bodypart(BODY_ZONE_L_LEG)
	right = limping_human.get_bodypart(BODY_ZONE_R_LEG)

	if(!left && !right)
		qdel(src)
		return

	slowdown_left = 0
	slowdown_right = 0

	if(left?.get_modified_pain() >= 30)
		slowdown_left = left.get_modified_pain() / 10

	if(right?.get_modified_pain() >= 30)
		slowdown_right = right.get_modified_pain() / 10

	// this handles losing your leg with the limp and the other one being in good shape as well
	if(slowdown_left < 3 && slowdown_right < 3)
		qdel(src)
		return

/obj/item/clothing/glasses/blindness_visor
	name = "spectrum amplification visor"
	desc = "A high-tech visor that somehow grants vision to those who have been rendered permanently blind \
		from birth, due to brain injury, or via genetic mutation. It has been reported that sighted individuals wearing \
		it experience heightened sensitivity to light."
	icon_state = "leforge"
	worn_icon_state = "laforge"
	gender = NEUTER
	tint = 1
	custom_materials = list(
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.2,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 0.8,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.2,
	)
	resistance_flags = ACID_PROOF | FIRE_PROOF
	glass_colour_type = /datum/client_colour/glass_colour/barelyyellow
	clothing_traits = list(TRAIT_NIGHT_VISION, TRAIT_MADNESS_IMMUNE)
	flash_protect = FLASH_PROTECTION_SENSITIVE // yay i can see! oh no i can see!
	flags_cover = GLASSESCOVERSEYES
	forced_glass_color = TRUE
	var/was_worn = FALSE
	var/emped = NONE

/obj/item/clothing/glasses/blindness_visor/equipped(mob/living/user, slot, initial)
	. = ..()
	if(!(slot & ITEM_SLOT_EYES) || !iscarbon(user) || isdummy(user))
		return

	if(user.is_blind())
		if(!initial)
			to_chat(user, span_green("As you put on the visor, the entire world fades into view!"))
	else
		if(!initial)
			to_chat(user, span_warning("These things kind of hurt your eyes."))
		user.become_nearsighted(REF(src))
		flash_protect = FLASH_PROTECTION_HYPER_SENSITIVE

	user.cure_blind(QUIRK_TRAIT)
	user.cure_blind(TRAUMA_TRAIT)
	user.cure_blind(GENETIC_MUTATION)
	user.update_sight()
	RegisterSignal(user, COMSIG_CARBON_GAIN_MUTATION, PROC_REF(now_blind_from_mutation))
	RegisterSignal(user, COMSIG_CARBON_GAIN_TRAUMA, PROC_REF(now_blind_from_trauma))
	RegisterSignal(user, COMSIG_CARBON_LOSE_MUTATION, PROC_REF(lost_blind_from_mutation))
	RegisterSignal(user, COMSIG_CARBON_LOSE_TRAUMA, PROC_REF(lost_blind_from_trauma))
	// no check for quirk because it doesn't get added mid gameplay
	was_worn = TRUE

/obj/item/clothing/glasses/blindness_visor/dropped(mob/living/carbon/user)
	. = ..()
	if(!iscarbon(user) || isdummy(user) || QDELING(user) || !was_worn)
		return

	if(user.has_quirk(/datum/quirk/item_quirk/blindness))
		user.become_blind(QUIRK_TRAIT)
	if(user.has_trauma_type(/datum/brain_trauma/severe/blindness))
		user.become_blind(TRAUMA_TRAIT)
	if(user.dna.check_mutation(/datum/mutation/human/blind))
		user.become_blind(GENETIC_MUTATION)

	user.cure_nearsighted(REF(src))
	user.update_sight()
	flash_protect = initial(flash_protect)
	UnregisterSignal(user, COMSIG_CARBON_GAIN_MUTATION)
	UnregisterSignal(user, COMSIG_CARBON_GAIN_TRAUMA)
	UnregisterSignal(user, COMSIG_CARBON_LOSE_MUTATION)
	UnregisterSignal(user, COMSIG_CARBON_LOSE_TRAUMA)
	was_worn = FALSE

/obj/item/clothing/glasses/blindness_visor/proc/now_blind_from_mutation(mob/living/carbon/user, mutation_type, class)
	SIGNAL_HANDLER

	if(!ispath(mutation_type, /datum/mutation/human/blind))
		return

	addtimer(CALLBACK(src, PROC_REF(delayed_unblind), user, GENETIC_MUTATION), 1 SECONDS, TIMER_UNIQUE)

/obj/item/clothing/glasses/blindness_visor/proc/now_blind_from_trauma(mob/living/carbon/user, datum/brain_trauma/trauma_type, resilience)
	SIGNAL_HANDLER

	if(!istype(trauma_type, /datum/brain_trauma/severe/blindness))
		return

	addtimer(CALLBACK(src, PROC_REF(delayed_unblind), user, TRAUMA_TRAIT), 1 SECONDS, TIMER_UNIQUE)

/obj/item/clothing/glasses/blindness_visor/proc/delayed_unblind(mob/living/carbon/user, trait_type)
	if(!was_worn)
		return
	user.cure_blind(trait_type)
	user.cure_nearsighted(REF(src))
	flash_protect = initial(flash_protect)

/obj/item/clothing/glasses/blindness_visor/proc/lost_blind_from_mutation(mob/living/carbon/user, mutation_type, class)
	SIGNAL_HANDLER

	if(!ispath(mutation_type, /datum/mutation/human/blind))
		return

	addtimer(CALLBACK(src, PROC_REF(delayed_nearsighted), user), 1 SECONDS, TIMER_UNIQUE)

/obj/item/clothing/glasses/blindness_visor/proc/lost_blind_from_trauma(mob/living/carbon/user, datum/brain_trauma/trauma_type, resilience)
	SIGNAL_HANDLER

	if(!istype(trauma_type, /datum/brain_trauma/severe/blindness))
		return

	addtimer(CALLBACK(src, PROC_REF(delayed_nearsighted), user), 1 SECONDS, TIMER_UNIQUE)

/obj/item/clothing/glasses/blindness_visor/proc/delayed_nearsighted(mob/living/carbon/user)
	if(!was_worn)
		return
	if(user.has_quirk(/datum/quirk/item_quirk/blindness))
		return
	if(user.has_trauma_type(/datum/brain_trauma/severe/blindness))
		return
	if(user.dna.check_mutation(/datum/mutation/human/blind))
		return
	user.become_nearsighted(REF(src))
	flash_protect = FLASH_PROTECTION_SENSITIVE

/obj/item/clothing/glasses/blindness_visor/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	// There is a 30 second cooldown  between emps causing damage
	// However if a light emp hits us followed by a heavy emp we still want to do heavy emp damage
	// So we proceed if emped is different from severity and not already at heavy
	if(!isliving(loc) || emped == severity || emped == EMP_HEAVY)
		return

	// Translate light emp -> 0.5x and heavy emp -> 1x
	var/multiplier = 1 / severity
	// If we were already emped it implies we were hit by a light emp (0.5x)
	// It also implies this is a heavy emp (1x) so reduce it to 0.5x for a full 1x
	if(emped)
		multiplier = 0.5

	emped = severity
	addtimer(VARSET_CALLBACK(src, emped, NONE), 30 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

	var/mob/living/wearer = loc
	wearer.adjustOrganLoss(ORGAN_SLOT_EYES, 25 * multiplier, REF(src))
	wearer.adjust_eye_blur(40 SECONDS * multiplier)
	wearer.sharp_pain(BODY_ZONE_HEAD, 20 * multiplier, BURN, 1 MINUTES * multiplier)
	to_chat(wearer, span_warning("Your head aches as [src] malfunctions!"))

// very very light yellow tint
/datum/client_colour/glass_colour/barelyyellow
	colour = "#ffffee"

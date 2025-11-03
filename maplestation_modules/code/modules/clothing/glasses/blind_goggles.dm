/obj/item/clothing/glasses/blindness_visor
	name = "spectrum amplification visor"
	desc = "A high-tech visor that somehow grants vision to those who have been rendered permanently blind \
		from birth, due to brain injury, or via genetic mutation. It has been reported that sighted individuals wearing \
		it experience heightened sensitivity to light."
	icon_state = "leforge"
	worn_icon_state = "laforge"
	gender = NEUTER
	tint = 1

	var/was_worn = FALSE

/obj/item/clothing/glasses/blindness_visor/equipped(mob/living/user, slot, initial)
	. = ..()
	if(!(slot & ITEM_SLOT_EYES) || !iscarbon(user))
		return

	if(user.is_blind())
		if(!initial)
			to_chat(user, span_green("As you put on the visor, the entire world fades into view!"))
	else
		if(!initial)
			to_chat(user, span_warning("These things kind of hurt your eyes."))
		user.become_nearsighted(REF(src))
		flash_protect = FLASH_PROTECTION_SENSITIVE

	user.cure_blind(QUIRK_TRAIT)
	user.cure_blind(TRAUMA_TRAIT)
	user.cure_blind(GENETIC_MUTATION)
	RegisterSignal(user, COMSIG_CARBON_GAIN_MUTATION, PROC_REF(now_blind_from_mutation))
	RegisterSignal(user, COMSIG_CARBON_GAIN_TRAUMA, PROC_REF(now_blind_from_trauma))
	RegisterSignal(user, COMSIG_CARBON_LOSE_MUTATION, PROC_REF(lost_blind_from_mutation))
	RegisterSignal(user, COMSIG_CARBON_LOSE_TRAUMA, PROC_REF(lost_blind_from_trauma))
	// no check for quirk because it doesn't get added mid gameplay
	was_worn = TRUE

/obj/item/clothing/glasses/blindness_visor/dropped(mob/living/carbon/user)
	. = ..()
	if(!iscarbon(user) || QDELING(user) || !was_worn)
		return

	if(user.has_quirk(/datum/quirk/item_quirk/blindness))
		user.become_blind(QUIRK_TRAIT)
	if(user.has_trauma_type(/datum/brain_trauma/severe/blindness))
		user.become_blind(TRAUMA_TRAIT)
	if(user.dna.check_mutation(/datum/mutation/human/blind))
		user.become_blind(GENETIC_MUTATION)

	user.cure_nearsighted(REF(src))
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

	addtimer(CALLBACK(src, PROC_REF(delayed_trauma_unblind), user, TRAUMA_TRAIT), 1 SECONDS, TIMER_UNIQUE)

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


// techweb design
/datum/design/sight_visor
	name = "Spectrum Amplification Visor"
	id = "antiblindnessvisor"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.2,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 0.8,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.2,
	)
	build_path = /obj/item/clothing/glasses/blindness_visor
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/skillchip/entrails_reader
	complexity = 0 // who cares?

/// Teaches you how to perform CPR without harming the patient
/obj/item/skillchip/job/cpr
	name = "CPR-Aid"
	skill_name = "CPR Training"
	skill_description = "Provides the user with the knowledge of how to safely perform CPR on a patient."
	skill_icon = FA_ICON_HEARTBEAT
	activate_message = span_notice("You feel more confident in your ability to perform CPR.")
	deactivate_message = span_notice("You suddenly feel less confident in your ability to perform CPR.")
	auto_traits = list(TRAIT_CPR_CERTIFIED)
	complexity = 0 // it's pretty minor, all things considered

/obj/item/storage/box/skillchips/medbay
	name = "box of medbay skillchips"
	desc = "Contains spares of every medical job skillchip."

/obj/item/storage/box/skillchips/medbay/PopulateContents()
	// new /obj/item/skillchip/job/cpr(src)
	// new /obj/item/skillchip/job/cpr(src)
	// new /obj/item/skillchip/job/cpr(src)
	// new /obj/item/skillchip/job/cpr(src)
// 	new /obj/item/skillchip/entrails_reader(src)
	new /obj/item/skillchip/job/skills(src, null, /datum/job/chemist)
	new /obj/item/skillchip/job/skills(src, null, /datum/job/chemist)
	new /obj/item/skillchip/job/skills(src, null, /datum/job/coroner)
	new /obj/item/skillchip/job/skills(src, null, /datum/job/doctor)
	new /obj/item/skillchip/job/skills(src, null, /datum/job/doctor)
	new /obj/item/skillchip/job/skills(src, null, /datum/job/paramedic)
	new /obj/item/skillchip/job/skills(src, null, /datum/job/virologist)

/obj/structure/closet/secure_closet/chief_medical/PopulateContents()
	. = ..()
	new /obj/item/storage/box/skillchips/medbay(src)

/// Book that grants the same trait as a skillchip, since reasonably there's no need for it to be chip locked
/obj/item/book/granter/cpr
	name = "CPR Training Manual"
	desc = "A book that teaches you how to perform CPR properly and safely."
	icon_state = "book7"
	remarks = list(
		"Assess the situation for danger... But it's always dangerous on the station!",
		"Make sure to check for a pulse and call for help before starting...",
		"Thirty compressions followed by two breaths...",
		"Match compressions to the beat of 'Staying Alive'... What?",
		"Proper hand placement is crucial. Wait, are lizardperson hearts in the same location as humans?",
		"Tilt the head back and pinch the nose before delivering breaths.",
		"Let the chest return to its normal position after each compression.",
		"Follow up with an AED if available.",
	)
	pages_to_mastery = 6
	reading_time = 2 SECONDS
	uses = INFINITY

/obj/item/book/granter/cpr/can_learn(mob/living/user)
	return !HAS_TRAIT_FROM(user, TRAIT_CPR_CERTIFIED, name)

/obj/item/book/granter/cpr/on_reading_start(mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CPR_CERTIFIED))
		to_chat(user, span_notice("You already know how to perform CPR, but it can't hurt to brush up."))

/obj/item/book/granter/cpr/on_reading_finished(mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CPR_CERTIFIED))
		to_chat(user, span_green("You remind yourself of the proper way to perform CPR safely."))
	else
		to_chat(user, span_green("You feel confident in your ability to perform CPR safely."))

	ADD_TRAIT(user, TRAIT_CPR_CERTIFIED, name)

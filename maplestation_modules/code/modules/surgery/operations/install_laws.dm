/datum/surgery_operation/organ/install_laws
	name = "install laws"
	desc = "Replace the laws installed in an android's positronic brain with a new set of laws."
	rnd_name = "Positronic Brain Reprogramming"
	implements = list(
		/obj/item/ai_module = 2,
	)
	time = 12 SECONDS
	preop_sound = 'sound/items/taperecorder/tape_flip.ogg'
	success_sound = 'sound/items/taperecorder/taperecorder_close.ogg'
	operation_flags = OPERATION_NOTABLE | OPERATION_STANDING_ALLOWED | OPERATION_MECHANIC
	target_type = /obj/item/organ/brain
	required_organ_flag = NONE
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_ORGANS_CUT|SURGERY_BONE_SAWED

/datum/surgery_operation/organ/install_laws/get_default_radial_image()
	return image(/obj/item/ai_module)

/datum/surgery_operation/organ/install_laws/state_check(obj/item/organ/brain/operating_on)
	return istype(operating_on, /obj/item/organ/brain/cybernetic/android)

/datum/surgery_operation/organ/install_laws/all_required_strings()
	return ..() + list("the target must be an advanced positronic brain")

/datum/surgery_operation/organ/install_laws/on_preop(obj/item/organ/brain/cybernetic/android/organ, mob/living/surgeon, obj/item/ai_module/tool, list/operation_args)
	display_results(
		surgeon,
		organ.owner,
		span_notice("You begin to reprogram [organ.owner]..."),
		span_notice("[surgeon] begins to reprogram [organ.owner]'s brain."),
		span_notice("[surgeon] begins to perform surgery on [organ.owner]'s brain."),
	)
	display_pain(
		target = organ.owner,
		affected_locations = organ,
		pain_message = "Your vision begins to fill with static!",
	)
	organ.owner.set_static_vision(30 SECONDS)

/datum/surgery_operation/organ/install_laws/proc/finish_surgery(obj/item/organ/brain/cybernetic/android/organ, mob/living/surgeon)
	display_results(
		surgeon,
		organ.owner,
		span_notice("You finish reprogramming [organ.owner]'s brain."),
		span_notice("[surgeon] finishes reprogramming [organ.owner]'s brain."),
		span_notice("[surgeon] finishes performing surgery on [organ.owner]'s brain."),
	)
	display_pain(
		target = organ.owner,
		affected_locations = organ,
		pain_message = "Your vision begins to clear up, and your perspective of the world seems... different.",
	)
	organ.init_law_datum()

/datum/surgery_operation/organ/install_laws/on_success(obj/item/organ/brain/cybernetic/android/organ, mob/living/surgeon, obj/item/ai_module/tool, list/operation_args)
	finish_surgery(organ, surgeon)
	tool.transmitInstructions(organ.law_datum, surgeon)
	organ.print_laws("Your laws have been changed")

/datum/surgery_operation/organ/install_laws/on_failure(obj/item/organ/brain/cybernetic/android/organ, mob/living/surgeon, obj/item/ai_module/tool, list/operation_args)
	finish_surgery(organ, surgeon)
	organ.on_ion_storm()
	organ.apply_organ_damage(rand(10, 20), 120)

/obj/item/organ/heart/android
	name = "android heart"
	desc = "An electronic device designed to mimic the functions of a human heart. Pumps fuel throughout the body."
	icon_state = /obj/item/organ/heart/cybernetic/tier2::icon_state
	organ_flags = ORGAN_ROBOTIC

/obj/item/organ/heart/android/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	apply_organ_damage(10 / severity)

// /obj/item/organ/heart/android/get_heart_rate()
// 	return 2 // static heart rate

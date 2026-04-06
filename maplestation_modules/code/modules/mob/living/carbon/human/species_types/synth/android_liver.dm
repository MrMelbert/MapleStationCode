/obj/item/organ/liver/android
	name = "toxin filtration system"
	desc = "An electronic device which filters toxins out of a synthetic's cooling, fueling, and power systems. \
		An excess of toxins may cause the filters to clog, resulting in reduced performance until flushed with clean fluids."
	icon_state = /obj/item/organ/liver/cybernetic/tier2::icon_state
	filterToxins = FALSE
	organ_flags = ORGAN_ROBOTIC
	alcohol_tolerance = 0

/obj/item/organ/liver/android/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	apply_organ_damage(10 / severity)

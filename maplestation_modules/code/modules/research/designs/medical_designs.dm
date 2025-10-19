/datum/design/cybernetic_ears/cat
	name = "Cybernetic Cat Ears"
	desc = "A pair of cybernetic cat ears."
	id = "cybernetic_cat_ears"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 4)
	build_path = /obj/item/organ/ears/cat/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

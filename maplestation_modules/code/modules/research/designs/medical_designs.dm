/datum/design/cybernetic_ears/cat
	name = "Cybernetic Cat Ears"
	desc = "A pair of cybernetic cat ears."
	id = "cybernetic_cat_ears"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = 250, /datum/material/glass = 400)
	build_path = /obj/item/organ/internal/ears/cat/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

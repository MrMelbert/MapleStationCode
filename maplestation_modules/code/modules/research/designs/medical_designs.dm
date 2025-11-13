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
